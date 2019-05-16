# studioutils

A shell script with utilities for TIBCO StreamBase Studio developers. Clone this repository and follow the instructions below to get started.

## What is it?

* An easy way to manage TIBCO StreamBase Studio installations (install and uninstall).
* An easy way to manage the configuration area for Studio versions.
* A way to open "temporary" workspaces that will not clutter your file system.
* An easy command to remove all your "temporary" workspaces.
* Useful development routines for Studio developers.

## Getting Started

### Configuring the Script (Environment Variables)

There are two variables that are used in the script that you will need to configure manually. **These variables need to be part of the environment in order for the script to work**. Export each of these in `~/.bash_profile` or a similar place.

The first variable is the path to the cloned repository `STUDIOUTILS_LOCATION`, i.e.  the directory called `studioutils`.

```
export STUDIOUTILS_LOCATION="/Users/$USER/Development/GitHub/studioutils"
```

The second variable is the path to the configuration area that TIBCO StreamBase Studio uses.

```
export STUDIO_CONFIGURATION_AREA="/Users/$USER/Library/Application Support/com.streambase.sb.sbstudio/"
```

These two environment variables will be used by the scripts to define `PRODUCT_INSTALL_PATH`, `INSTALL_PATH`, `TEMP_DIR`, and `INI_DIR`.

* `PRODUCT_INSTALL_PATH`: The directory where `sbx` will install new versions of Studio.
* `INSTALL_PATH`: The directory where we can find the actual installations of Studio (10.4, 10.5, etc.).
* `TEMP_DIR`: The directory where temporary directories will be created.
* `INI_DIR`: The directory that will contain *.ini configuration files to start Studio workspaces.

**Note:** Nothing within the `studioutils` directory should be modified manually.

### Configuring the Script (Auto-Completion)

In order for autocomplete to work you need to source the `studioutils-completion.sh` script. First, create a symbolic link in a directory that is already part of your path like this:

```
ln -s /<path-to-studioutils>/scripts/studioutils-completion.sh /usr/local/bin/studioutils-completion
```

Then, you will need to include something like the following in your `.bash_profile` file or similar.

```
source studioutils-completion
```

If you decided to not create a symbolic link, you can then source the `studioutils-completion.sh` file using it's absolute path.

### Executing the Script

After you have cloned the repository and followed the steps above, you will need to make the script executable. To do so, run:

```
chmod +x /<path-to-studioutils>/scripts/studioutils.sh
```

After that, you will need to make sure that the script is located in a directory that is part of your path. For this, I suggest creating a symbolic link in a directory that is already part of your path. For example, you can create the link in `/usr/local/bin` or `$HOME/bin` if you have your own directory for scripts. To create the link you need the following.

```
ln -s /<path-to-studioutils>/scripts/studioutils.sh /usr/local/bin/studioutils
```

If you decide to put the symbolic link somewhere else, you will need to include that directory in your path.

```
export PATH=$PATH:/path/to/directory
```

## Usage

At this point, you should be able to type `studioutils` from anywhere in your terminal. Doing so should show you the help menu.

``` 
studio_config is a simple utility script to manage StreamBase Studio 
installations and configurations. This script was written for Mac.

The installation directory for Studio needs to be configured manually
in this script. The script also assumes that the configuration area
exists at:
/Users/$USER/Library/Application Support/com.streambase.sb.sbstudio/

        The following are valid command options:

        help, --help, -help, -h         Open the help menu.

        CONFIGURATION AREA -----------------------------------------------------------------------
        ls-conf                         List the existing configuration areas.
        rm-conf <version>               Remove the configuration area for <version>.
        ------------------------------------------------------------------------------------------

        STUDIO UTILITIES -------------------------------------------------------------------------
        ls                              List all Studio installations.
        open [-t] <version>             Open the specified Studio version if installed.
                -t  <version>           Opens a workspace in a temporary directory.
        install <product> <version>     Where product is the same as in "sbx install <product>".
        uninstall <version>             Removes the the specified installed version of Studio.
        install-path                    Shows the directory where StreamBase is being installed.
        clean                           Deletes all workspaces opend with -t flag.
        ------------------------------------------------------------------------------------------

        STUDIO DEVELOPMENT -----------------------------------------------------------------------
        monday-morning <version>        A shortcut for the Monday morning routine.
                --help                  Help menu for 'monday-morning'.
        m2 <dev|studio>                 Toggle, remove (studio) or place (dev) maven settings file.
        ------------------------------------------------------------------------------------------
```

