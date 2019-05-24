#!/bin/bash
# Guillermo Narvaez

## Script variables - Product installation location
PRODUCT_INSTALL_PATH="${STUDIOUTILS_LOCATION}/product"
INSTALL_PATH="${PRODUCT_INSTALL_PATH}/tibco/sb-cep"
## Script variables - Builds installation location
BUILDS_INSTALL_PATH="${STUDIOUTILS_LOCATION}/builds"
## Script variables - Location for temporary workspaces
TEMP_DIR="${STUDIOUTILS_LOCATION}/temp_workspaces"
## Script variables - Location for *.ini files
INI_DIR="${STUDIOUTILS_LOCATION}/configuration"

function suggest() {
    CURR_LOC=$(pwd)
    if [ "${#COMP_WORDS[@]}" == "2" ]; then
        # Don't allow words that start with '-'
        if [[ "${COMP_WORDS[1]}" != -* ]]; then
            COMPREPLY=($(compgen -W "ls-conf rm-conf ls open install uninstall install-path clean m2 help monday-morning install-build open-build rm-builds ls-builds" "${COMP_WORDS[1]}"))
        fi
    elif [ "${COMP_WORDS[1]}" == "m2" ] && [ "${#COMP_WORDS[@]}" == "3" ]; then
        # Don't allow words that start with '-'
        if [[ "${COMP_WORDS[2]}" != -* ]]; then
            COMPREPLY=($(compgen -W "dev studio" "${COMP_WORDS[2]}"))
        fi
    elif [ "${COMP_WORDS[1]}" == "rm-conf" ] && [ "${#COMP_WORDS[@]}" == "3" ]; then
        # Don't allow words that start with '-'
        if [[ "${COMP_WORDS[2]}" != -* ]]; then
            cd "$STUDIO_CONFIGURATION_AREA"
            COMPREPLY=($(compgen -d "${COMP_WORDS[2]}"))
            cd "$CURR_LOC"
        fi
    elif [ "${COMP_WORDS[1]}" == "open" ]; then
        cd "$INSTALL_PATH"
        if [ "${#COMP_WORDS[@]}" == "3" ]; then
            if [[ "${COMP_WORDS[2]}" == -* ]]; then
                if [[ "${COMP_WORDS[2]}" != "-" ]]; then
                    COMPREPLY="${COMP_WORDS[2]}"
                fi
            else
                COMPREPLY=($(compgen -d "${COMP_WORDS[2]}"))
            fi
        elif [ "${#COMP_WORDS[@]}" == "4" ] && [ "${COMP_WORDS[2]}" == "-t" ]; then
            COMPREPLY=($(compgen -d "${COMP_WORDS[3]}"))
        fi
        cd "$CURR_LOC"
    elif [ "${COMP_WORDS[1]}" == "install" ] && [ "${#COMP_WORDS[@]}" == "3" ]; then
        # Don't allow words that start with '-'
        if [[ "${COMP_WORDS[2]}" != -* ]]; then
            # Could offer more advanced options here... looking at the actual svn tree?
            COMPREPLY=($(compgen -W "trunk sb/main/10.4 sb/main/10.5" "${COMP_WORDS[2]}"))
        fi
    elif [ "${COMP_WORDS[1]}" == "uninstall" ]; then
        # Don't allow words that start with '-'
        if [[ "${COMP_WORDS[2]}" != -* ]]; then
            cd "$INSTALL_PATH"
            COMPREPLY=($(compgen -d "${COMP_WORDS[2]}"))
            cd "$CURR_LOC"
        fi
    elif [ "${COMP_WORDS[1]}" == "open-build" ] && [ "${#COMP_WORDS[@]}" == "3" ]; then
        cd "$BUILDS_INSTALL_PATH"
            COMPREPLY=($(compgen -d "${COMP_WORDS[2]}"))
        cd "$CURR_LOC"
    fi
}

complete -F suggest studioutils