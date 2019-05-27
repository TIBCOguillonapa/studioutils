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
studio_config is a simple utility script to manage StreamBase Studio 
installations and configurations. This script was written for Mac.

In order for this script to work, you will need to export `STUDIOUTILS_HOME`
as part of your environment. This variable (a path to a directory) will be 
used by this script to manage installations, workspaces, etc. The script also 
assumes that the configuration area exists at:
/Users/$USER/Library/Application Support/com.streambase.sb.sbstudio/

        The following are valid command options:

--->    GETTING STARTED
        help, --help, -help, -h         Display this help.
        init                            Initialize the directories used by 'studioutils'.

--->    CONFIGURATION AREA
        ls-conf                         List the existing configuration areas.
        rm-conf <version>               Remove the configuration area for <version>.

--->    STUDIO UTILITIES
        clean                           Deletes all workspaces opened with -t flag.
        install <product> <version>     Where product is the same as in "sbx install <product>".
        install-path [-q]               Shows the directory where StreamBase is being installed.
                -q                      Prints only the path with no extra decorations.
        ls                              List all Studio installations.
        open [-t] <version>             Open the specified Studio version if installed.
                -t  <version>           Opens a workspace in a temporary directory.
        uninstall <version>             Removes the the specified installed version of Studio.

--->    STUDIO DEVELOPMENT
        install-build <branch> <name>   Installs the build for the branch under ./builds/<name>.
        ls-builds                       Shows a list of all installed builds in ./builds.
        m2 <dev|studio>                 Toggle, remove (studio) or place (dev) maven settings file.
        monday-morning <version>        A shortcut for the Monday morning routine.
                --help                  Help menu for 'monday-morning'.
        open-build <name>               Opens StreamBase Studio for the build in .builds/<name>.
        rm-builds                       Removes all builds from ./builds.
```

