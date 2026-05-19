// @ts-check

const fs = require("fs");
const path = require("path");

const stateRelativePath = path.join(".baseline", "module-state.json");
const manifestRelativePath = path.join("manifests", "baseline.yaml");

/**
 * @typedef {{ json: boolean, help: boolean }} CliOptions
 * @typedef {{ name: string, version: string, enabled: boolean }} ManifestModule
 * @typedef {{ source_repo: string | null, version: string | null, modules: ManifestModule[] }} ParsedManifest
 * @typedef {{ name: string, applied_version: string, source: string }} StatusModule
 * @typedef {{
 *   ok: boolean,
 *   target_repo: string,
 *   target_path: string,
 *   state_source: string | null,
 *   module_state_found: boolean,
 *   manifest_found: boolean,
 *   source_repository: string | null,
 *   baseline_version: string | null,
 *   legacy: boolean,
 *   modules: StatusModule[],
 *   notices: string[],
 * }} StatusReport
 */

/**
 * @param {string[]} argv
 * @returns {CliOptions}
 */
function parseArgs(argv) {
  /** @type {CliOptions} */
  const options = {
    json: false,
    help: false,
  };

  for (const arg of argv) {
    if (arg === "--json") {
      options.json = true;
      continue;
    }

    if (arg === "--help" || arg === "-h") {
      options.help = true;
      continue;
    }

    if (arg === "--target") {
      throw new Error("This consumer module:status command is local-only and does not accept --target.");
    }

    throw new Error(`Unknown argument: ${arg}`);
  }

  return options;
}

function printHelp() {
  console.log("Usage: npm run module:status [-- --json]");
  console.log("");
  console.log("Reports repo-foundry module state for the current repository.");
}

/**
 * @param {string} value
 * @returns {string}
 */
function stripInlineComment(value) {
  return value.replace(/\s+#.*$/, "");
}

/**
 * @param {string} value
 * @returns {string | boolean}
 */
function parseScalar(value) {
  const trimmed = value.trim();

  if (trimmed === "true") {
    return true;
  }

  if (trimmed === "false") {
    return false;
  }

  return trimmed.replace(/^["']|["']$/g, "");
}

/**
 * @param {string} line
 * @returns {{ key: string, value: string | boolean | null } | null}
 */
function parseKeyValue(line) {
  const match = line.match(/^([^:]+):(.*)$/);
  if (!match) {
    return null;
  }

  const rawValue = match[2].trim();
  return {
    key: match[1].trim(),
    value: rawValue === "" ? null : parseScalar(rawValue),
  };
}

/**
 * @param {string} targetRoot
 * @returns {ParsedManifest | null}
 */
function readManifest(targetRoot) {
  const manifestPath = path.join(targetRoot, manifestRelativePath);
  if (!fs.existsSync(manifestPath)) {
    return null;
  }

  const lines = fs.readFileSync(manifestPath, "utf8").split(/\r?\n/);
  /** @type {ParsedManifest} */
  const manifest = {
    source_repo: null,
    version: null,
    modules: [],
  };
  let inBaseline = false;
  let modulesIndent = null;
  /** @type {ManifestModule | null} */
  let currentModule = null;

  for (const rawLine of lines) {
    const withoutComment = stripInlineComment(rawLine);
    if (!withoutComment.trim()) {
      continue;
    }

    const indent = withoutComment.match(/^ */)[0].length;
    const trimmed = withoutComment.trim();

    if (indent === 0) {
      inBaseline = trimmed === "baseline:";
      modulesIndent = null;
      currentModule = null;
      continue;
    }

    if (!inBaseline) {
      continue;
    }

    if (modulesIndent !== null && indent <= modulesIndent) {
      modulesIndent = null;
      currentModule = null;
    }

    if (indent === 2) {
      const pair = parseKeyValue(trimmed);

      if (trimmed === "modules:") {
        modulesIndent = indent;
        continue;
      }

      if (!pair) {
        continue;
      }

      if (pair.key === "source_repo" && typeof pair.value === "string") {
        manifest.source_repo = pair.value;
      }

      if (pair.key === "version" && typeof pair.value === "string") {
        manifest.version = pair.value;
      }

      continue;
    }

    if (modulesIndent === null) {
      continue;
    }

    if (indent === modulesIndent + 2 && trimmed.startsWith("- ")) {
      const itemText = trimmed.slice(2).trim();
      currentModule = {
        name: "",
        version: "unversioned",
        enabled: true,
      };
      manifest.modules.push(currentModule);

      const pair = parseKeyValue(itemText);
      if (pair && pair.key === "name" && typeof pair.value === "string") {
        currentModule.name = pair.value;
      } else if (!pair && itemText) {
        currentModule.name = itemText;
      }

      continue;
    }

    if (!currentModule || indent !== modulesIndent + 4) {
      continue;
    }

    const pair = parseKeyValue(trimmed);
    if (!pair) {
      continue;
    }

    if (pair.key === "name" && typeof pair.value === "string") {
      currentModule.name = pair.value;
    }

    if (pair.key === "version" && typeof pair.value === "string" && pair.value) {
      currentModule.version = pair.value;
    }

    if (pair.key === "enabled" && typeof pair.value === "boolean") {
      currentModule.enabled = pair.value;
    }
  }

  manifest.modules = manifest.modules.filter((module) => module.name && module.enabled !== false);
  return manifest;
}

/**
 * @param {string} targetRoot
 * @returns {Record<string, unknown> | null}
 */
function readModuleState(targetRoot) {
  const statePath = path.join(targetRoot, stateRelativePath);
  if (!fs.existsSync(statePath)) {
    return null;
  }

  try {
    return JSON.parse(fs.readFileSync(statePath, "utf8"));
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    throw new Error(`Module state exists but is not valid JSON: ${stateRelativePath}: ${message}`);
  }
}

/**
 * @param {ParsedManifest | null} manifest
 * @returns {Map<string, string>}
 */
function buildManifestVersionMap(manifest) {
  const versions = new Map();

  for (const module of manifest ? manifest.modules : []) {
    versions.set(module.name, module.version || "unversioned");
  }

  return versions;
}

/**
 * @param {unknown} value
 * @returns {value is Record<string, string>}
 */
function isStringRecord(value) {
  return Boolean(value && typeof value === "object" && !Array.isArray(value));
}

/**
 * @param {string} targetRoot
 * @returns {StatusReport}
 */
function buildStatusReport(targetRoot) {
  const manifest = readManifest(targetRoot);
  const moduleState = readModuleState(targetRoot);
  const manifestVersions = buildManifestVersionMap(manifest);
  /** @type {string[]} */
  const notices = [];

  if (!moduleState && !manifest) {
    throw new Error(`No repo-foundry module state or manifest found. Expected ${stateRelativePath} or ${manifestRelativePath}.`);
  }

  if (moduleState && Array.isArray(moduleState.applied_modules)) {
    const stateVersions = isStringRecord(moduleState.module_versions)
      ? moduleState.module_versions
      : {};
    const hasStateVersions = Object.keys(stateVersions).length > 0;
    const hasManifestVersions = Array.from(manifestVersions.values()).some((version) => version !== "unversioned");
    const modules = moduleState.applied_modules
      .filter((name) => typeof name === "string" && name)
      .map((name) => ({
        name,
        applied_version: stateVersions[name] || manifestVersions.get(name) || "unversioned",
        source: stateVersions[name] ? stateRelativePath : manifestVersions.has(name) ? manifestRelativePath : "module-state",
      }))
      .sort((left, right) => left.name.localeCompare(right.name));

    const legacy = !(hasStateVersions || hasManifestVersions)
      || modules.some((module) => module.applied_version === "unversioned");

    if (legacy) {
      notices.push("Legacy or unversioned module data detected. Versions shown as unversioned need state adoption before versioned updates can be planned safely.");
    }

    return {
      ok: true,
      target_repo: path.basename(targetRoot),
      target_path: targetRoot,
      state_source: stateRelativePath,
      module_state_found: true,
      manifest_found: Boolean(manifest),
      source_repository: typeof moduleState.source_repository === "string"
        ? moduleState.source_repository
        : typeof moduleState.source_repo === "string"
          ? moduleState.source_repo
          : manifest && manifest.source_repo,
      baseline_version: typeof moduleState.baseline_version === "string"
        ? moduleState.baseline_version
        : manifest && manifest.version,
      legacy,
      modules,
      notices,
    };
  }

  if (moduleState) {
    notices.push("Module state is present but does not list applied_modules; using the baseline manifest fallback.");
  } else {
    notices.push("Module state is missing; using the baseline manifest fallback.");
  }

  const modules = (manifest ? manifest.modules : [])
    .map((module) => ({
      name: module.name,
      applied_version: module.version || "unversioned",
      source: manifestRelativePath,
    }))
    .sort((left, right) => left.name.localeCompare(right.name));
  const legacy = modules.some((module) => module.applied_version === "unversioned");

  if (legacy) {
    notices.push("Legacy or unversioned module data detected. Versions shown as unversioned need state adoption before versioned updates can be planned safely.");
  }

  return {
    ok: true,
    target_repo: path.basename(targetRoot),
    target_path: targetRoot,
    state_source: manifest ? manifestRelativePath : null,
    module_state_found: false,
    manifest_found: Boolean(manifest),
    source_repository: manifest && manifest.source_repo,
    baseline_version: manifest && manifest.version,
    legacy,
    modules,
    notices,
  };
}

/**
 * @param {unknown} value
 * @param {number} width
 * @returns {string}
 */
function pad(value, width) {
  const text = String(value || "");
  return text + " ".repeat(Math.max(width - text.length, 0));
}

/**
 * @param {StatusReport} report
 */
function printHumanStatus(report) {
  console.log("Repo-foundry module status");
  console.log("");
  console.log(`Repository       : ${report.target_repo || "unknown"}`);
  console.log(`State source     : ${report.state_source || "not found"}`);
  console.log(`Module state     : ${report.module_state_found ? "found" : "missing"}`);
  console.log(`Manifest         : ${report.manifest_found ? "found" : "missing"}`);
  console.log(`Source repository: ${report.source_repository || "unknown"}`);
  console.log(`Baseline version : ${report.baseline_version || "unknown"}`);
  console.log(`Legacy data      : ${report.legacy ? "yes" : "no"}`);
  console.log("");

  if (report.modules.length === 0) {
    console.log("No repo-foundry modules detected.");
  } else {
    console.log(`${pad("Module", 18)}Version`);
    console.log(`${pad("------", 18)}-------`);
    for (const module of report.modules) {
      console.log(`${pad(module.name, 18)}${module.applied_version}`);
    }
  }

  if (report.notices.length > 0) {
    console.log("");
    for (const notice of report.notices) {
      console.log(notice);
    }
  }
}

function main() {
  const wantsJson = process.argv.slice(2).includes("--json");

  try {
    const options = parseArgs(process.argv.slice(2));

    if (options.help) {
      printHelp();
      return;
    }

    const report = buildStatusReport(process.cwd());

    if (options.json) {
      console.log(JSON.stringify(report, null, 2));
      return;
    }

    printHumanStatus(report);
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);

    if (wantsJson) {
      console.log(JSON.stringify({
        ok: false,
        error: message,
      }, null, 2));
    } else {
      console.error(message);
    }

    process.exitCode = 1;
  }
}

main();
