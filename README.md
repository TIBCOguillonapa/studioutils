# studioutils

A shell script with utilities for TIBCO StreamBase Studio developers. Follow the instructions below to get started.

## What is it?

* An easy way to manage TIBCO StreamBase Studio installations (install and uninstall).
* An easy way to manage the configuration area for Studio versions.
* A way to open "temporary" workspaces that will not clutter your file system.
* An easy command to remove all your "temporary" workspaces.
* Useful development routines for Studio developers.
* An easy way to install personal builds of StreamBase Studio and manage them.

## Getting Started

### Installation

To install 'studioutils' you can use Homebrew. First, you will need to tap the Homebrew repository.

```
brew tap gunarvae/hb-osx
```

Then, install the package.

```
brew install studioutils
```

### Configuring the Script (Environment Variables)

There is a single variable that is used in the script that you will need to configure manually. **This variable needs to be part of the environment in order for the script to work**. Export it in `~/.bash_profile` or a similar place.

This variable should be called `STUDIOUTILS_HOME`, and it needs to be a path to the directory that `studioutils` will use. The path to the directory needs to be valid, but the directory itself doesn't have to exist already. Include something similar to the following.

```
export STUDIOUTILS_HOME="/Users/$USER/Development/studioutils"
```

This script assumes that the configuration area that TIBCO StreamBase Studio uses is located at `/Users/$USER/Library/Application Support/com.streambase.sb.sbstudio/`.

`STUDIOUTILS_HOME` will be used by the scripts to define `PRODUCT_INSTALL_PATH`, `INSTALL_PATH`, `TEMP_DIR`, `INI_DIR`, and `BUILDS_INSTALL_PATH`.

* `PRODUCT_INSTALL_PATH`: The directory where `sbx` will install new versions of Studio.
* `INSTALL_PATH`: The directory where we can find the actual installations of Studio (10.4, 10.5, etc.).
* `TEMP_DIR`: The directory where temporary directories will be created.
* `INI_DIR`: The directory that will contain *.ini configuration files to start Studio workspaces.
* `BUILDS_INSTALL_PATH`: The directory that will contain personal builds.

**Note:** Nothing within the directory referenced by `STUDIOUTILS_HOME` should be modified manually.

### Configuring the Script (Auto-Completion)

In order for autocomplete to work you need to download and source the `studioutils-completion` script.

First, make sure that you have an `/etc/bash_completion.d/` directory. Create one if you don't already have one. Then, put the `studioutils-completion` script there. Finally, You will need to source the script. Below the export statement for `STUDIOUTILS_HOME`, enter the following.

```
source /etc/bash_completion.d/studioutils-completion
```

## Usage

At this point, you should be able to type `studioutils` from anywhere in your terminal. Doing so should show you the help menu.

``` 
studioutils 1.1.0
Usage: studioutils <command> [<subcommand> ...]

studioutils is a simple utility script to manage StreamBase Studio 
installations and configurations. This script was written for Mac.

In order for this script to work, you will need to export 'STUDIOUTILS_HOME'
as part of your environment. This variable (a path to a directory) will be 
used by this script to manage installations, workspaces, etc. The script also 
assumes that the configuration area exists at:
/Users/$USER/Library/Application Support/com.streambase.sb.sbstudio/

The following are valid command options:
    builds      Group of commands related to Studio builds
    clean       Removes all temporary workspaces
    configs     Group of commands related to the configuration area for Studio
    init        Initializes the directories used by 'studioutils'
    install     Uses 'sbx' to install the specified build for the corresponding version
    installs    Group of commands related to Studio installations
    help        Displays information on specific sets of commands
    m2          Toggle, remove (studio) or place (dev) maven settings file
    mondays     A shortcut for the Monday morning routine

See 'studioutils help <command> ...' for information on a specific chain of commands.
```

