#!/usr/bin/env -S bash -e
# Install for repository.

. ../lib/functions

cd "${git_sync_repo}"

print_info "Install necessary aliases."

git config --local alias.pullstash "!git fetch --all; git stash; git merge @{u}; git stash pop"
git config --local pull.rebase false

if [[ "$(get_os)" = "Termux" ]]
then
    git config --local alias.committermux '!bash -e ./.githooks/termux'
    git config --local alias.sync "!git pullstash; git add -A; [ -z \"\$(git status --porcelain)\" ] || git committermux; git stash clear"
    git config --local core.filemode false
else
    git config --local core.hooksPath .githooks
    git config --local alias.xgithook "!chmod +x \"\$(git rev-parse --show-toplevel)\"/.githooks/*; chmod +x \"\$(git rev-parse --show-toplevel)\"/.githooks/scripts/*"
    git config --local alias.sync "!git pullstash; git xgithook; git add -A; [[ -z \"\$(git status --porcelain)\" ]] || git commit -m \"[UPDATED]\"; git stash clear"
fi

print_okay "Settings installation for the ${warning_color}${git_sync_repo_basename}${success_color} Git repository is complete!"
