# edwindurham.com

Personal consulting site for Edwin Durham — Sales Strategy & Enterprise Access Advisor.

## Structure

Single-file static site: `index.html` (all CSS and JS inline; Google Fonts loaded from a CDN `<link>`). No build step, no dependencies.

## Local preview

Just open `index.html` directly in a browser.

## Publishing

**Step 1 — push to GitHub.** Run `setup.ps1` (PowerShell) from inside this folder — it initializes git, commits the files, and (if the GitHub CLI `gh` is installed and logged in) creates a public GitHub repo named `edwindurham` and pushes. If `gh` isn't set up, it prints the manual steps instead.

**Step 2 — host on Cloudflare.**

Cloudflare's current "Create an app" flow connects a GitHub repo and deploys it with `npx wrangler deploy`, which requires a `wrangler.jsonc` config file in the repo root. This repo has one:

```jsonc
{
  "name": "edwindurham",
  "compatibility_date": "2026-09-14",
  "assets": { "directory": "." }
}
```

That tells Wrangler to serve everything in the repo root (`index.html` and friends) as static assets — no build step needed.

1. Make sure `wrangler.jsonc` is committed and pushed to GitHub (it needs to be on the branch Cloudflare deploys from — otherwise the deploy command has nothing to work with).
2. In the Cloudflare dashboard, go to **Workers & Pages → Create**, connect to Git, and select the `edwindurham` GitHub repo.
3. Leave the build command empty and leave the deploy command as the prefilled `npx wrangler deploy`.
4. Click **Deploy**. Cloudflare gives you a `*.workers.dev` (or `*.pages.dev`) URL immediately — check that first.
5. In the project settings, go to **Custom domains → Set up a custom domain**, enter `edwindurham.com`, and follow the prompt. Since `edwindurham.com` is already an active Cloudflare zone (nameservers pointed at Cloudflare), this is automatic — Cloudflare adds the DNS record itself.
6. Cloudflare issues and renews the SSL certificate automatically — no separate HTTPS step needed.

The `CNAME` file in this repo is a GitHub Pages convention and is harmless either way — it's ignored by Cloudflare, and kept here in case GitHub Pages is ever used as a fallback instead.

## Editing the "Track record" section

The rotating company grid is data-driven — see the `trackRecord` array near the bottom of `index.html`, inside the `<script>` block. Each entry needs `company`, `industry`, `level`, and either `revenueDisplay`/`revenueValue` or a `scaleNote` (for entities like government agencies where "revenue" doesn't apply).

Any row with `level: "TBD"` is automatically excluded from the live rotation — swap in the real title and it joins the grid automatically. No other code changes are needed as you add more companies.
