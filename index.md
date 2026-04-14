---
layout: default
title: Home
permalink: /
---

<div class="home-stack">
  <section class="home-hero">
    <div class="home-hero__scene" aria-hidden="true">
      <div class="studio-rig"></div>
      <div class="studio-lights">
        <div class="studio-light studio-light--red">
          <span class="studio-light__cable"></span>
          <span class="studio-light__fixture"></span>
          <span class="light-projection light-projection--red"></span>
        </div>
        <div class="studio-light studio-light--green">
          <span class="studio-light__cable"></span>
          <span class="studio-light__fixture"></span>
          <span class="light-projection light-projection--green"></span>
        </div>
        <div class="studio-light studio-light--blue">
          <span class="studio-light__cable"></span>
          <span class="studio-light__fixture"></span>
          <span class="light-projection light-projection--blue"></span>
        </div>
      </div>
      <div class="studio-floor-glow"></div>
    </div>

    <div class="home-hero__content">
      <p class="section-label">A connected platform for learning, performance, community, and action</p>
      <div class="home-intro__logo">
        <img src="{{ '/images/thisninja_name.png' | relative_url }}" alt="this.ninja logo" width="225" height="75">
      </div>
      <h1 class="display-title">Focused products. Shared momentum.</h1>
      <p class="home-hero__lede">THIS NINJA brings together a family of tools designed to help people learn with intention, perform with clarity, connect with purpose, and move work forward.</p>
      <div class="home-actions">
        <a class="button button--primary" href="#products">Explore the platform</a>
        <a class="button button--secondary" href="#support">View support links</a>
      </div>
    </div>
  </section>

  <section class="home-section" id="products">
    <div class="home-section__intro">
      <p class="section-label">Product Family</p>
      <h2>Four focused directions, one system underneath.</h2>
      <p class="content-card__intro">Each product carries its own purpose while staying anchored to the same platform language, visual system, and practical sense of momentum.</p>
    </div>

    <div class="product-grid">
      <article class="product-card product-card--spark">
        <p class="section-label">Spark, Learning</p>
        <h3>Spark</h3>
        <p>Learning tools for curiosity, structured practice, and forward motion when new ideas need traction.</p>
      </article>

      <article class="product-card product-card--pulse">
        <p class="section-label">Pulse, Performance</p>
        <h3>Pulse</h3>
        <p>Performance tools that help teams and individuals measure signal, refine rhythm, and keep standards visible.</p>
      </article>

      <article class="product-card product-card--reach">
        <p class="section-label">Reach, Community</p>
        <h3>Reach</h3>
        <p>Community tools for connection, shared context, and communication that feels direct instead of noisy.</p>
      </article>

      <article class="product-card product-card--stride">
        <p class="section-label">Stride, Action</p>
        <h3>Stride</h3>
        <p>Action tools for translating plans into movement with clearer priorities, next steps, and momentum.</p>
      </article>
    </div>
  </section>

  <section class="content-column home-support" id="support">
    <p class="section-label">Support And Policies</p>
    <h2>Support links and public policy pages.</h2>
    <p class="content-card__intro">For questions, contact <a href="mailto:contact@this.ninja">contact@this.ninja</a>. Public SMS policy pages remain available below.</p>
    <ul class="legal-links">
      <li><a href="{{ '/sms-privacy/' | relative_url }}">SMS Privacy Policy</a></li>
      <li><a href="{{ '/sms-terms/' | relative_url }}">SMS Terms and Conditions</a></li>
      <li><a href="{{ '/sms-consent/' | relative_url }}">SMS Consent</a></li>
    </ul>
  </section>
</div>
