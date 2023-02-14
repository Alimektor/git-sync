PowerShell.exe -ExecutionPolicy Bypass -File .\install-default.ps1

$git_sync_repo = git rev-parse --show-toplevel 2>&1
$git_sync_repo_basename = (Get-Item $git_sync_repo).Basename

$taskname = "$git_sync_repo_basename-sync"

Write-Output "Delete a scheduled task for Windows."
Unregister-ScheduledTask -TaskName $taskname -Confirm:$false 2> $null

Write-Output "Create a scheduled task for Windows."
$action = New-ScheduledTaskAction -Execute "$git_sync_repo/.githooks/scripts/update.vbs" -WorkingDirectory "$git_sync_repo"
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(5) -RepetitionInterval (New-TimeSpan -Minutes 30)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskname -AsJob

Write-Output "Sheduled task installation for the $git_sync_repo_basename Git repository is complete!"
