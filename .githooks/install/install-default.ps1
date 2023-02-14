$git_sync_repo = git rev-parse --show-toplevel 2>&1
$git_sync_repo_basename = (Get-Item $git_sync_repo).Basename

Write-Output "Install necessary aliases."
git config --local alias.pullstash "!git fetch --all; git stash; git merge @{u}; git stash pop"
git config --local pull.rebase false
git config --local core.hooksPath .githooks
git config --local alias.xgithook "!chmod +x \`"`$(git rev-parse --show-toplevel)\`"/.githooks/*; chmod +x \`"`$(git rev-parse --show-toplevel)\`"/.githooks/scripts/*"
git config --local core.filemode false
git config --local alias.sync "!git pullstash; git xgithook; git add -A; [[ -z \`"`$(git status --porcelain)\`" ]] || git commit -m \`"[UPDATED]\`"; git stash clear"

Write-Output "Settings installation for the $git_sync_repo_basename Git repository is complete!"
