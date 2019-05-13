# studioutils

A shell script with utilities for TIBCO StreamBase Studio developers.

``` 
studio_config is a simple utility script to manage StreamBase Studio 
installations and configurations. This script was written for Mac.

The installation directory for Studio needs to be configured manually
in this script. The script also assumes that the configuration area
exists at:
/Users/$USER/Library/Application Support/com.streambase.sb.sbstudio/

        The following are valid command options:

        help, --help, -help, -h         Open the help menu.

        CONFIGURATION AREA ---------------------------------------------------------------------
        ls-conf                         List the existing configuration areas.
        rm-conf <version>               Remove the configuration area for <version>.
        ----------------------------------------------------------------------------------------

        STUDIO UTILITIES -----------------------------------------------------------------------
        ls                              List all Studio installations.
        open [-t] <version>             Open the specified Studio version if installed.
                -t  <version>             Opens a workspace in a temporary directory.
        install <product> [-v <version>] Where product is the same as in "sbx install <product>".
        uninstall <version>             Removes the the specified installed version of Studio.
        install-path                    Shows the directory where StreamBase is being installed.
        clean                           Deletes all workspaces opend with -t flag.
        ----------------------------------------------------------------------------------------
```