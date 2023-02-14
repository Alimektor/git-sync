#!/usr/bin/env -S bash -e
# Install cron task.

. ../lib/functions

taskcronfile="${HOME}/taskcron"
echo "*/30 * * * * (cd ${git_sync_repo}; git sync) >> ~/.${git_sync_repo_basename}-sync.log 2>&1" >> "${taskcronfile}"
crontab "${taskcronfile}"
rm "${taskcronfile}"

print_okay "Sync cron job installation for the ${warning_color}${git_sync_repo_basename}${success_color} Git repository is complete!"
