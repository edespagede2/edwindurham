# edwindurham.com

Personal consulting site for Edwin Durham — Sales Strategy & Enterprise Access Advisor.

## Structure

Single-file static site: `index.html` (all CSS and JS inline; Google Fonts loaded from a CDN `<link>`). No build step, no dependencies.

## Local preview

Just open `index.html` directly in a browser.

## Publishing

**Step 1 — push to GitHub.** Run `setup.ps1` (PowerShell) from inside this folder — it initializes git, commits the files, and (if the GitHub CLI `gh` is installed and logged in) creates a public GitHub repo named `edwindurham` and pushes. If `gh` isn't set up, it prints the manual steps instead.

**Step 2 — host on Cloudflare Pages.**
1. In the Cloudflare dashboard, go to **Workers & Pages → Create → Pages → Connect to Git**, and authorize/select the `edwindurham` GitHub repo.
2. Build settings: no framework preset, no build command, output directory `/` (this is a plain static file, nothing to build).
3. Deploy. Cloudflare gives you a `*.pages.dev` URL immediately — check that first.
4. In the Pages project, go to **Custom domains → Set up a custom domain**, enter `edwindurham.com`, and follow the prompt. If the domain's nameservers are already pointed at Cloudflare, this is automatic (Cloudflare adds the DNS record itself). If the domain isn't on Cloudflare DNS yet, it'll walk you through switching the nameservers at your registrar first.
5. Cloudflare issues and renews the SSL certificate automatically — no separate HTTPS step needed.

The `CNAME` file in this repo is a GitHub Pages convention and is harmless either way — it's ignored by Cloudflare Pages, and kept here in case GitHub Pages is ever used as a fallback instead.

## Editing the "Track record" section

The rotating company grid is data-driven — see the `trackRecord` array near the bottom of `index.html`, inside the `<script>` block. Each entry needs `company`, `industry`, `level`, and either `revenueDisplay`/`revenueValue` or a `scaleNote` (for entities like government agencies where "revenue" doesn't apply).

Any row with `level: "TBD"` is automatically excluded from the live rotation — swap in the real title and it joins the grid automatically. No other code changes are needed as you add more companies.
