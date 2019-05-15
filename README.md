# studioutils

A shell script with utilities for TIBCO StreamBase Studio developers.

## Getting Started

### Configuring the Script

There are some variables that are used in the script that you will need to configure manually. **These variables need to be part of the environment in order for the script to work**. Export each of these in `~/.bash_profile` or a similar place. 

The first two variables are used to install StreamBase Studio. You will need to change `PRODUCT_INSTALL_PATH` to point to a directory where you want Studio to be installed. Installing a new versio of Studio will create `tibco/sb-cep/` if it's not in `PRODUCT_INSTALL_PATH` already.

```
# Script variables - Product installation location
export PRODUCT_INSTALL_PATH="/Users/$USER/Development/product"
export INSTALL_PATH="${PRODUCT_INSTALL_PATH}/tibco/sb-cep"
```

The third variable, `TEMP_DIR`, needs to point to a directory where you will only have temporary workspaces. Using the `clean` option of this script will delete everything in this directory.

```
# Script variables - Location for temporary workspaces
export TEMP_DIR="/Users/$USER/Development/other/Studio Workspaces/temp/workspaces"
```

The fourth variable, `INI_DIR`, needs to point to a directory where you will store *.ini files. This files will be used to update the configuration of Studio itself when trying to open a regular workspace or a temporary one.

```
# Script variables - Location for *.ini files
export INI_DIR="/Users/$USER/Development/other/Studio Workspaces/temp/ini"
```

The fifth and last variable, `CONFIG_PATH_PREFIX`, needs to point at the directory where Studio configuration areas are stored. This is usually `/Users/$USER/Library/Application Support/com.streambase.sb.sbstudio/`.

```
# Script variables - Product configuration location
export CONFIG_PATH_PREFIX="/Users/$USER/Library/Application Support/com.streambase.sb.sbstudio/"
```

**Note:** The directories specified in these variables should not be modified manually.

Finally, in order for autocomplete to work you need to source the `studioutils-completion.sh` script. First, create a symbolic link in a directory that is already part of your path like this:

```
ln -s ~/Scripts/studioutils-completion.sh /usr/local/bin/studioutils-completion
```

Then, you will need to include something like the following in your `.bash_profile` file or similar.

```
source studioutils-completion
```

If you decided to not create a symbolic link, you can then source the `studioutils-completion.sh` file using it's absolute path.

### Executing the Script

After you have downloaded the script into the desired location in your machine, and configured the script's variables, you will need to make the script executable. To do so, run:

```
chmod +x studioutils.sh
```

After that, you will need to make sure that the script is located in a directory that is part of your path. For this, I suggest creating a symbolic link in a directory that is already part of your path. For example, you can create the link in `/usr/local/bin` or `$HOME/bin` if you have your own directory for scripts. To create the link you need the following (assuming you placed the script in a folder named `Scripts`).

```
ln -s ~/Scripts/studioutils.sh /usr/local/bin/studioutils
```

If you decide to put the symbolic link somewhere else, you will need to include that directory in your path.

```
export PATH=$PATH:/path/to/directory
```

## Usage

At this point, you should be able to type `studioutils` from anywhere in your terminal. Doing so should show your the help menu.

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
                -t  <version>             Opens a workspace in a temporary directory.
        install <product> [-v <version>] Where product is the same as in "sbx install <product>".
        uninstall <version>             Removes the the specified installed version of Studio.
        install-path                    Shows the directory where StreamBase is being installed.
        clean                           Deletes all workspaces opend with -t flag.
        ------------------------------------------------------------------------------------------

        STUDIO DEVELOPMENT -----------------------------------------------------------------------
        m2 <dev|studio>                 Toggle, remove (studio) or place (dev) maven settings file.
        ------------------------------------------------------------------------------------------
```

