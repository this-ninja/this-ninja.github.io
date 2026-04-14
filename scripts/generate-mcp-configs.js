const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..");
const canonicalConfigPath = path.join(repoRoot, "mcp.config.yaml");
const vscodeConfigPath = path.join(repoRoot, ".vscode", "mcp.json");
const codexConfigPath = path.join(repoRoot, ".codex", "config.toml");

function readCanonicalConfig() {
  const source = fs.readFileSync(canonicalConfigPath, "utf8");
  const parsed = JSON.parse(source);

  if (!parsed || typeof parsed !== "object" || !parsed.servers || typeof parsed.servers !== "object") {
    throw new Error("mcp.config.yaml must define a top-level servers object.");
  }

  return parsed;
}

function transformValue(value, mapper) {
  if (typeof value === "string") {
    return mapper(value);
  }

  if (Array.isArray(value)) {
    return value.map((item) => transformValue(item, mapper));
  }

  if (value && typeof value === "object") {
    const result = {};
    for (const [key, nestedValue] of Object.entries(value)) {
      result[key] = transformValue(nestedValue, mapper);
    }
    return result;
  }

  return value;
}

function mapForVscode(value) {
  if (value === "${workspaceFolder}") {
    return value;
  }

  return value.replace(/\$\{([A-Z0-9_]+)\}/g, "${env:$1}");
}

function mapForCodex(value) {
  return value.replace(/\$\{workspaceFolder\}/g, ".");
}

function buildVscodeConfig(config) {
  const servers = {};

  for (const [name, rawServer] of Object.entries(config.servers)) {
    servers[name] = transformValue(rawServer, mapForVscode);
  }

  return JSON.stringify({ servers }, null, 2) + "\n";
}

function toTomlString(value) {
  return JSON.stringify(value);
}

function toTomlArray(values) {
  return `[${values.map((value) => toTomlString(value)).join(", ")}]`;
}

function buildCodexConfig(config) {
  const lines = [
    "# Generated from mcp.config.yaml. Do not edit directly.",
    "# Update mcp.config.yaml and run: npm run generate:mcp",
    "",
  ];

  for (const [name, rawServer] of Object.entries(config.servers)) {
    const server = transformValue(rawServer, mapForCodex);
    lines.push(`[mcp_servers.${name}]`);
    lines.push(`type = ${toTomlString(server.type)}`);

    if (server.url) {
      lines.push(`url = ${toTomlString(server.url)}`);
    }

    if (server.command) {
      lines.push(`command = ${toTomlString(server.command)}`);
    }

    if (server.args) {
      lines.push(`args = ${toTomlArray(server.args)}`);
    }

    if (server.env && Object.keys(server.env).length > 0) {
      lines.push("");
      lines.push(`[mcp_servers.${name}.env]`);
      for (const [envName, envValue] of Object.entries(server.env)) {
        lines.push(`${envName} = ${toTomlString(envValue)}`);
      }
    }

    lines.push("");
  }

  return lines.join("\n");
}

function writeFile(targetPath, contents) {
  fs.mkdirSync(path.dirname(targetPath), { recursive: true });
  fs.writeFileSync(targetPath, contents, "utf8");
}

function main() {
  const config = readCanonicalConfig();
  writeFile(vscodeConfigPath, buildVscodeConfig(config));
  writeFile(codexConfigPath, buildCodexConfig(config));
}

main();

