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

function suggest() {
    CURR_LOC=$(pwd)
    if [ "${#COMP_WORDS[@]}" == "2" ]; then
        # Don't allow words that start with '-'
        if [[ "${COMP_WORDS[1]}" != -* ]]; then
            COMPREPLY=($(compgen -W "ls-conf rm-conf ls open install uninstall install-path clean m2 help monday-morning" "${COMP_WORDS[1]}"))
        fi
    elif [ "${COMP_WORDS[1]}" == "m2" ] && [ "${#COMP_WORDS[@]}" == "3" ]; then
        # Don't allow words that start with '-'
        if [[ "${COMP_WORDS[2]}" != -* ]]; then
            COMPREPLY=($(compgen -W "dev studio" "${COMP_WORDS[2]}"))
        fi
    elif [ "${COMP_WORDS[1]}" == "rm-conf" ] && [ "${#COMP_WORDS[@]}" == "3" ]; then
        # Don't allow words that start with '-'
        if [[ "${COMP_WORDS[2]}" != -* ]]; then
            cd "$CONFIG_PATH_PREFIX"
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
    fi
}

complete -F suggest studioutils