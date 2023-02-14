#!/usr/bin/env -S bash -e
# Install script for systemd service and systemd timer.

. ../lib/functions

user_systemd_path="${HOME}/.config/systemd/user/"
user_systemd_service="${git_sync_repo_basename}-sync.service"
user_systemd_timer="${git_sync_repo_basename}-sync.timer"

mkdir -p "${user_systemd_path}"
cat > "${user_systemd_path}/${user_systemd_service}" << EOF
[Unit]
Description=Sync for ${git_sync_repo_basename} Git repository
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/env -S bash -e -c 'cd ${git_sync_repo}; git sync'

[Install]
WantedBy=default.target
EOF

cat > "${user_systemd_path}/${user_systemd_timer}" << EOF
[Unit]
Description=Run git sync for ${git_sync_repo_basename} Git repository every 30 minutes

[Timer]
OnBootSec=2min
OnUnitActiveSec=30min

[Install]
WantedBy=timers.target
EOF

systemctl --user daemon-reload
systemctl --user start "${user_systemd_service}"
systemctl --user enable --now "${user_systemd_timer}"
print_okay "Sync service installation for the ${warning_color}${git_sync_repo_basename}${success_color} Git repository is complete!"
