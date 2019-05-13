#!/bin/bash
# Guillermo Narvaez

PRODUCT_INSTALL_PATH="/Users/gunarvae/Development/product"
TEMP_DIR=/Users"/$USER/Development/other/Studio Workspaces/temp/workspaces"
TEMP_DIR_ESCAPED="/Users/$USER/Development/other/Studio\ Workspaces/temp/workspaces"
INI_DIR="/Users/$USER/Development/other/Studio Workspaces/temp/ini"
CONFIG_PATH_PREFIX="/Users/$USER/Library/Application Support/com.streambase.sb.sbstudio/"
INSTALL_PATH="${PRODUCT_INSTALL_PATH}/tibco/sb-cep"
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
    if [ $1 = "ls-conf" ]; then
        if [ $# -ne 1 ]; then
            echo -e "${WARNING} The option 'ls' takes no arguments."
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
            fi
        fi
    elif [ $1 = "m2" ]; then
        m2.sh
    else
        echo -e "${WARNING} Not a valid set of arguments."
        echo -e "${INFO} *** Run 'studio_conf.sh --help' to list all valid options."
        return $SUPPRESS_RETURN_CODE
    fi
}

# TODO need a script to initialize the preferences for this script
# TODO add m2 utils to this script
# TODO ask user if they want to copy to ini file

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