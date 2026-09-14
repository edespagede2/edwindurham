# Setup script for the edwindurham.com site repo.
# Run from inside this folder, e.g.:
#   powershell -ExecutionPolicy Bypass -File .\setup.ps1

$ErrorActionPreference = "Stop"

Write-Host "== edwindurham.com repo setup ==" -ForegroundColor Cyan

# 1. Initialize git if needed
if (-not (Test-Path ".git")) {
    Write-Host "Initializing git repository..."
    git init
    git branch -M main
} else {
    Write-Host "Git repository already initialized."
}

# 2. Stage and commit
git add -A
$hasChanges = git status --porcelain
if ($hasChanges) {
    git commit -m "Initial commit: edwindurham.com site"
    Write-Host "Committed site files." -ForegroundColor Green
} else {
    Write-Host "Nothing to commit (working tree clean)."
}

# 3. Try to create + push to GitHub via the GitHub CLI
$ghAvailable = Get-Command gh -ErrorAction SilentlyContinue
if ($ghAvailable) {
    gh auth status *> $null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "GitHub CLI is authenticated. Creating public repo 'edwindurham' and pushing..." -ForegroundColor Cyan
        gh repo create edwindurham --public --source=. --remote=origin --push
        Write-Host "Done - repo created and pushed." -ForegroundColor Green
    } else {
        Write-Host "GitHub CLI is installed but not logged in." -ForegroundColor Yellow
        Write-Host "Run: gh auth login" -ForegroundColor Yellow
        Write-Host "Then re-run this script." -ForegroundColor Yellow
    }
} else {
    Write-Host "GitHub CLI (gh) not found." -ForegroundColor Yellow
    Write-Host "Easiest fix: install it from https://cli.github.com, run 'gh auth login', then re-run this script." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "-- or, without gh --" -ForegroundColor Yellow
    Write-Host "1. Create a new PUBLIC repo named 'edwindurham' at https://github.com/new (don't initialize it with a README)."
    Write-Host "2. Then run:"
    Write-Host "     git remote add origin https://github.com/<your-username>/edwindurham.git"
    Write-Host "     git push -u origin main"
}

Write-Host ""
Write-Host "== Next: host it on Cloudflare ==" -ForegroundColor Cyan
Write-Host "This repo includes wrangler.jsonc, which Cloudflare's 'npx wrangler deploy'"
Write-Host "command needs in order to serve index.html as a static asset."
Write-Host "1. Make sure wrangler.jsonc is committed and pushed (this script's commit above includes it)."
Write-Host "2. Cloudflare dashboard > Workers and Pages > Create > connect to Git > pick the 'edwindurham' repo."
Write-Host "3. Leave build command empty; leave deploy command as the prefilled 'npx wrangler deploy'."
Write-Host "4. Deploy - you will get a *.workers.dev (or *.pages.dev) URL to check first."
Write-Host "5. In the project: Custom domains > Set up a custom domain > edwindurham.com"
Write-Host "   (edwindurham.com is already an active Cloudflare zone, so this is automatic.)"
Write-Host "See README.md for the full walkthrough."
