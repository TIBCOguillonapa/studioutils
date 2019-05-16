#!/bin/bash
# Guillermo Narvaez

# !!!!! THESE VARIABLES SHOULD BE PART OF THE ENVIRONMENT (put in ~/.bash_profile or similar) !!!!!

### Script variables - Product installation location
# export PRODUCT_INSTALL_PATH="/Users/$USER/Development/product"
# export INSTALL_PATH="${PRODUCT_INSTALL_PATH}/tibco/sb-cep"
### Script variables - Location for temporary workspaces
# export TEMP_DIR="/Users/$USER/Development/other/Studio Workspaces/temp/workspaces"
### Script variables - Location for *.ini files
# export INI_DIR="/Users/$USER/Development/other/Studio Workspaces/temp/ini"
### Script variables - Product configuration location
# export CONFIG_PATH_PREFIX="/Users/$USER/Library/Application Support/com.streambase.sb.sbstudio/"

# Text formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color
BOLD='\033[1m' # Bold text
INFO="${BLUE}[INFO]${NC}"
WARNING="${ORANGE}[WARN]${NC}"
ERROR="${RED}[ERROR]${NC}"
EXIT="${BLUE}[EXIT]${NC}"

declare -i SUPPRESS_RETURN_CODE=2

function show_help {
cat << EOF
    
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
            monday-morning <version>        A shortcut for the Monday morning routine.
                  --help                    Help menu for 'monday-morning'.
            m2 <dev|studio>                 Toggle, remove (studio) or place (dev) maven settings file.
            ------------------------------------------------------------------------------------------

EOF
}

function file_suffix {
    declare -i var=1
    while [ -d "${TEMP_DIR}/Temporary_Workspace_${var}" ]; do
        var=$((var+1))
    done
    echo "${TEMP_DIR}/Temporary_Workspace_${var}"
}

function insert_temp_ini_file {
    echo -data > "${INI_DIR}/$3/_sbstudio_temp.ini"
    file_suffix >> "${INI_DIR}/$3/_sbstudio_temp.ini"
    cat "${INI_DIR}/$3/_sbstudio_default.ini" >> "${INI_DIR}/$3/_sbstudio_temp.ini"
    rm "${INSTALL_PATH}/$3/StreamBase Studio $3.app/Contents/Eclipse/_sbstudio.ini"
    cp "${INI_DIR}/$3/_sbstudio_temp.ini" "${INSTALL_PATH}/$3/StreamBase Studio $3.app/Contents/Eclipse/_sbstudio.ini"
}

function insert_default_ini_file {
    rm "${INSTALL_PATH}/$2/StreamBase Studio $2.app/Contents/Eclipse/_sbstudio.ini"
    cp "${INI_DIR}/$2/_sbstudio_default.ini" "${INSTALL_PATH}/$2/StreamBase Studio $2.app/Contents/Eclipse/_sbstudio.ini"
}

function do_the_stuff {
    if [ $1 = "monday-morning" ]; then
        if [ $# -ne 2 ]; then
            echo -e "${WARNING} The current version of 'trunk' must be specified. For version 10.5 run..."
            echo -e "${WARNING}     $ studioutils monday-morning 10.5"
            echo -e "${WARNING} For more help enter..."
            echo -e "${WARNING}     $ studioutils monday-morning --help"
            return 1
        elif [ $2 = "--help" ] || [ $2 = "-h" ] || [ $2 = "help" ] || [ $2 = "-help" ]; then
cat << EOF

    'studioutils monday-morning <version>' is a shortcut to the Monday morning routine for
    the SteamBase Studio developer. Running this will uninstall the specified version of
    Studio, remove the configuration area for that installation, and it will install the
    latest trunk build.

    IMPORTANT: The version passed in this command must match the version of the current trunk.

EOF
            return $SUPPRESS_RETURN_CODE
        else
            echo -e "${INFO} Four more days until Friday... Updating StreamBase Studio $2."
            do_the_stuff uninstall $2
            if [ $? -ne 0 ]; then
                echo -e "${WARNING} An error occurred trying to uninstall StreamBase Studio $2."
                return 1
            fi
            do_the_stuff rm-conf $2
            if [ $? -ne 0 ]; then
                echo -e "${WARNING} An error occurred trying to remove the configuration area for StreamBase Studio $2."
                return 1
            fi
            do_the_stuff install trunk -v $2
            if [ $? -ne 0 ]; then
                echo -e "${WARNING} An error occurred trying to install StreamBase Studio $2."
                return 1
            fi
        fi
    elif [ $1 = "ls-conf" ]; then
        if [ $# -ne 1 ]; then
            echo -e "${WARNING} The option 'ls-conf' takes no arguments."
        fi
        ls -l "$CONFIG_PATH_PREFIX"
    elif [ $1 = "rm-conf" ]; then
        if [ $# -ne 2 ]; then
            echo -e "${ERROR} Wrong number of arguments (Expected: 1)."
            return 1
        elif [ -d  "${CONFIG_PATH_PREFIX}$2" ]; then
            rm -rf "${CONFIG_PATH_PREFIX}$2"
            if [ $? -eq 0 ]; then
                echo -e "${INFO} ${CONFIG_PATH_PREFIX}$2 has been removed."
            else
                echo -e "${WARNING} ${CONFIG_PATH_PREFIX}$2 could not be removed."
                return 1
            fi
        else
            echo -e "${WARNING} ${CONFIG_PATH_PREFIX}$2 is not a valid directory."
        fi
    elif [ $1 = "install-path" ]; then
        echo -e "${INFO} Installation path: ${INSTALL_PATH}"
    elif [ $1 = "ls" ]; then
        ls -l "${INSTALL_PATH}"
    elif [ $1 = "clean" ]; then
        echo -e "${INFO} Removing from: ${TEMP_DIR}"
        ls "${TEMP_DIR}" | wc -l | awk -v INFO_STRING="$INFO" '{printf "%s Found %s workspace(s) to remove.\n", INFO_STRING, $1}'
        rm -rf "${TEMP_DIR}"
        mkdir "${TEMP_DIR}"
    elif [ $1 = "open" ]; then
        if [ $# -eq 3 ] && [ $2 = "-t" ]; then
            echo -e "${INFO} Opening workspace in temporary location."
            insert_temp_ini_file $@
            if [ $? -ne 0 ]; then
                echo -e "${WARNING} An error occured while copying .ini files."
                return 1
            fi
            if [ -d "${INSTALL_PATH}/$3" ]; then
                echo -e "${INFO} Opening a temporary workspace."
                open "${INSTALL_PATH}/$3/StreamBase Studio $3.app"
            else
                echo -e "${WARNING} ${INSTALL_PATH}$3 is not a valid directory"
                return 1
            fi
        elif [ $# -ne 2 ]; then
            echo -e "${WARNING} The arguments given are not valid."
            return 1
        elif [ -d "${INSTALL_PATH}/$2" ]; then
            echo -e "${INFO} Opening a standard workspace."
            insert_default_ini_file $@
            if [ $? -ne 0 ]; then
                echo -e "${WARNING} An error occured while copying .ini files."
                return 1
            fi
            open "${INSTALL_PATH}/$2/StreamBase Studio $2.app"
        else
            echo -e "${WARNING} ${INSTALL_PATH}$2 is not a valid directory"
            return 1
        fi
    elif [ $1 = "install" ]; then
        if [ $# -eq 4 ] && [ $3 = "-v" ]; then
            if ! [ -d "${INI_DIR}/$4" ]; then
                mkdir "${INI_DIR}/$4"
                if [ $? -ne 0 ]; then
                    echo -e "${WARNING} An error occured while creating a temporary directory."
                    return 1
                fi
            fi
            echo -e "${INFO} Preparing to install '$2' (StreamBase Studio $4)..."
            sbx install --no-uninstall --root "${PRODUCT_INSTALL_PATH}" "$2"
            # sudo sbx install --no-uninstall "$3"
            if [ $? -ne 0 ]; then
                echo -e "${WARNING} An error occured while installing StreamBase Studio."
                return 1
            fi
            echo -e "${INFO} Copying _sbstudio.ini file into temp directory."
            cat "${INSTALL_PATH}/$4/StreamBase Studio $4.app/Contents/Eclipse/_sbstudio.ini" > "${INI_DIR}/$4/_sbstudio_default.ini"
            if [ $? -ne 0 ]; then
                echo -e "${WARNING} An error occured while copying .ini files."
                return 1
            fi
        elif [ $# -ne 2 ]; then
            echo -e "${WARNING} The arguments given are not valid."
            return 1
        else
            echo -e "${WARNING} The *.ini files associated with this install will not be copied for use of temporary workspaces."
            echo -e "${INFO} Preparing to install '$2' (Unkwown StreamBase Studio version)..."
            sbx install --no-uninstall --root "${PRODUCT_INSTALL_PATH}" "$2"
            # sudo sbx install --no-uninstall "$3"
            if [ $? -ne 0 ]; then
                echo -e "${WARNING} An error occured while installing StreamBase Studio."
                return 1
            fi
        fi
    elif [ $1 = "uninstall" ]; then
        if [ $# -ne 2 ]; then
            echo -e "${WARNING} Wrong number of arguments (Exptected: 1)."
            return 1
        else
            rm -rf "${INSTALL_PATH}/$2"
            if [ $? -ne 0 ]; then
                echo -e "${WARNING} An error occured while uninstalling StreamBase Studio."
                return 1
            else
                echo -e "${INFO} StreamBase Studio $2 has been removed."
            fi
        fi
    elif [ $1 = "m2" ]; then
        if [ ! -f ~/.m2/settings.bak ]; then
            echo -e "${WARNING} No ~/.m2/settings.bak, aborting."
            return -1
        fi
        if [ $# -eq 2 ]; then
            if [ $2 = "studio" ]; then
                if [ ! -f ~/.m2/settings.xml ]; then
                    echo -e "${WARNING} No settings.xml file exists in ~/.m2/"
                else
                    rm ~/.m2/settings.xml
                    echo -e "${INFO} Maven ~/.m2/settings.xml removed"
                fi
            elif [ $2 = "dev" ]; then
                cp ~/.m2/settings.bak ~/.m2/settings.xml
                echo -e "${INFO} Maven ~/.m2/settings.xml now in place"
            else
                # wrong arguments
                echo -e "${WARNING} Not a valid argument for m2."
                return 1;
            fi
        else
            # whatever we have, toggle it
            if [ -f ~/.m2/settings.xml ];then
                rm ~/.m2/settings.xml
                echo -e "${INFO} Maven ~/.m2/settings.xml removed"
            else
                cp ~/.m2/settings.bak ~/.m2/settings.xml
                echo -e "${INFO} Maven ~/.m2/settings.xml now in place"
            fi
        fi
    else
        echo -e "${WARNING} Not a valid set of arguments."
        echo -e "${INFO} *** Run 'studio_conf.sh --help' to list all valid options."
        return $SUPPRESS_RETURN_CODE
    fi
}

# TODO need a script to initialize the preferences for this script
# TODO ask user if they want to copy to ini file
# TODO start new development workspaces (with eclipse preferences)

function main {
    if [ $# -eq 0 ] || [ $1 = "--help" ] || [ $1 = "-help" ] || [ $1 = "-h" ] || [ $1 = "help" ]; then
        show_help
        return $SUPPRESS_RETURN_CODE
    else
        do_the_stuff $@
    fi
}

main $@
declare -i ret=$?
if [ $ret -eq 0 ]; then
    echo -e "${BOLD}${EXIT}${GREEN} SUCCESS.${NC}"
elif [ $ret -eq $SUPPRESS_RETURN_CODE ]; then
    exit # suppress return code
else
    echo -e "${BOLD}${EXIT}${RED} ERROR (Exited with code $ret).${NC}"
fi