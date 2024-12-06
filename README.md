# git-sync #

Use [git-synchronize](https://github.com/Alimektor/git-synchronize) for a more user-friendly experience.

> A template with magic aliases, hooks, services for Git repository auto-synchronization between different devices.

## Table of Contents ##

- [git-sync](#git-sync)
  - [Table of Contents](#table-of-contents)
  - [What Is It?](#what-is-it)
  - [Quickstart](#quickstart)
  - [Installation](#installation)
    - [Linux](#linux)
      - [Manual Usage](#manual-usage)
      - [SystemD](#systemd)
      - [Cron](#cron)
    - [Termux](#termux)
      - [Manual Usage](#manual-usage-1)
      - [Cron](#cron-1)
        - [Additional Information](#additional-information)
          - [Shortcut](#shortcut)
    - [Windows](#windows)
      - [Manual Usage](#manual-usage-2)
      - [Task Scheduler](#task-scheduler)
- [How It Works](#how-it-works)
  - [Stash Stage](#stash-stage)
  - [Commit Stage](#commit-stage)
  - [Push Stage](#push-stage)
- [License](#license)

## What Is It? ##

This repository provides a `sync` Git command that automatically commits and sends changes to origin. This can be useful if you maintain a website using [Hugo](https://gohugo.io/) or write any notes in a program such as [Obsidian](https://obsidian.md/). In addition, the repository provides services and a job scheduler for some platforms (Windows, Linux, Termux) which runs every half hour.

## Quickstart ##

1. Copy the `.githooks` directory into your Git repository folder.
   
   ```bash
   cp -r .githooks <your Git repo>
   ```

2. Go to your Git repository:
   
   ```bash
   cd <your Git repo>
   ```
   
3. Go to the `install` directory:
   
   ```bash
   cd .githooks/install
   ```

4. Run the installation script:
   - Linux (Bash):
      
      ```bash
      bash -e ./install-default.sh
      ```

      or

      ```bash
      make install
      ```
    
   - Windows (PowerShell):
      
      ```powershell
      PowerShell.exe -ExecutionPolicy Bypass -File .\install-default.ps1
      ```

5. Run instead `git pull` / `git commit` / `git push`:
   
   ```bash
   git sync
   ```

## Installation ##

Go to the `install` directory:
   
```bash
cd .githooks/install
```

### Linux ###

#### Manual Usage ####

Install using Make:

```bash
$ make install
```

Install using shell:

```bash
$ bash -e ./install-default.sh
```

#### SystemD ####

Install using Make:

```bash
$ make systemd
```

Install using shell:

```bash
$ bash -e ./install-systemd.sh
```

Check the output of the `systemd`-service:

```bash
$ journalctl -e --user-unit <your repo name>-sync.service
```

#### Cron ####

Install using Make:

```bash
$ make cron
```

Install using shell:

```bash
$ bash -e ./install-cron.sh
```

Check the log output in `~/.<your repo name>-sync.log`.

### Termux ###

#### Manual Usage ####

Install using Make:

```bash
$ make install
```

Install using shell:

```bash
$ bash -e ./install-default.sh
```

#### Cron ####

Install using Make:

```bash
$ make cron
```

Install using shell:

```bash
$ bash -e ./install-cron.sh
```

Check the log output in `~/.<your repo name>-sync.log`.

##### Additional Information ####

There were some problems with Termux, which was how to get it to work all the time. You can use [Termux-services](https://wiki.termux.com/wiki/Termux-services) to make synchronization work properly. This application does not have a full-fledged initialization system like GNU/Linux, but this works and allows you to run scripts on the machine.

To run scripts when the app autoruns, you must install the [Termux:Boot addon](https://f-droid.org/ru/packages/com.termux.boot/) and setup a simple [boot-config](https://wiki.termux.com/wiki/Termux:Boot). Use the code below.

1. Install `termux-services` and `cronie`:
   
   ```bash
   $ pkg install -y cronie termux-services
   ```

2. Enable `crond` service:
   ```bash
   $ sv-enable crond
   ```

3. Create an autorun script for `crond`:
   
   ```bash
   $ cat > ~/.termux/boot/start-crond << EOF
   #!/data/data/com.termux/files/usr/bin/sh
   termux-wake-lock
   sv-enable crond
   EOF
   ```

4. Restart Termux.

P.S. Sometimes it doesn't work with some Android devices. In this case, use the [Termux-wake-lock](https://wiki.termux.com/wiki/Termux-wake-lock) function or, as an alternative to Termux:Boot, [Termux:Tasker](https://wiki.termux.com/wiki/Termux:Tasker).

###### Shortcut ######

```bash
pkg install -y cronie termux-services
sv-enable crond
cat > ~/.termux/boot/start-crond << EOF
#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock
sv-enable crond
EOF
```

Restart Termux.

### Windows ###

#### Manual Usage ####

Install using PowerShell:

```powershell
PS> PowerShell.exe -ExecutionPolicy Bypass -File .\install-default.ps1
```

#### Task Scheduler ####

Run this script to create a job for [Task Scheduler](https://learn.microsoft.com/en-us/windows/win32/taskschd/task-scheduler-start-page):

```powershell
PS> PowerShell.exe -ExecutionPolicy Bypass -File .\install-task.ps1
```

# How It Works #

The `git sync` command provides the following scenario:

- Stash Stage.
- Commit Stage.
- Push Stage.

It uses [Git hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks), so you can extend your hooks, for example, by adding your scripts to the `run_health_check` section of the `pre-commit` file.

## Stash Stage ##

Get the changes, hide them in stash, merge them, and bring them back.

```bash
git fetch --all
git stash
git merge @{u}
git stash pop
```

## Commit Stage ##

Add changes, commit, and clear stash.

```bash
git add -A
if [[ -z "$(git status --porcelain)" ]]
then
    git commit -m "UPDATE from <OS name> by <time now>"
fi
git stash clear
```

## Push Stage ##

Push using `post-commit` hook:

```
git push --all origin
```

# License #

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](/LICENSE.md)

