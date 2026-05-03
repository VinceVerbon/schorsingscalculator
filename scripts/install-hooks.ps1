# Activate the in-repo privacy-guard hooks (Windows / PowerShell).
# Run once after cloning the repo.
git config core.hooksPath hooks
Write-Host "OK: core.hooksPath = $(git config core.hooksPath)"
Write-Host "Pre-commit and pre-push privacy guards are active."
