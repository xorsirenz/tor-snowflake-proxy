#!/bin/bash
# Madison's Tor Snowflake proxy install script for arch linux
#
# Define colors because colors are pretty, duh! but global..
RED=`tput bold && tput setaf 1`
GREEN=`tput bold && tput setaf 2`
BLUE=`tput bold && tput setaf 4`
MAGENTA=`tput bold && tput setaf 5`
NC=`tput sgr0`

function RED(){
    echo -e "\n${RED}${1}${NC}"
}
function GREEN(){
    echo -e "\n${GREEN}${1}${NC}"
}
function BLUE(){
    echo -e "\n${BLUE}${1}${NC}"
}
function MAGENTA(){
    echo -e "\n${MAGENTA}${1}${NC}"
}

MAGENTA "❄ Archflake - Tor snowflake proxy install script for Arch Linux"
sleep .5

function install_tor()
{   package=tor
    if pacman -Qi $package 2>&1> /dev/null ; then
        RED "Tor is already installed"
        GREEN "Configuring torrc & starting service"
        sudo systemctl start tor
        sudo mv torrc /etc/tor/
        GREEN "Tor successfully installed, torrc updated & service started."
    else
        GREEN "Installing Tor:"
        sudo pacman --noconfirm -S $package 2> /dev/null
        sudo systemctl start tor
        sudo mv torrc /etc/tor/
        GREEN "Tor successfully installed, torrc updated & service started."
    fi
    install_snowflake
}

function install_snowflake()
{   url='https://aur.archlinux.org/cgit/aur.git/snapshot'
    package='snowflake-pt-client-git'
    if pacman -Qi $package 2>&1> /dev/null ; then
        RED "Snowflake client is already installed"
    else
        GREEN "Installing snowflake client:"
        # too lazy to check if/what aur is installed
        curl -L -O "$url/$package.tar.gz"
        tar xvf "$package.tar.gz" 2>&1> /dev/null
        rm "$package.tar.gz" 2> /dev/null 
        cd "$package"
        makepkg --noconfirm -si
        cd ../
        rm -rf $package
        sudo systemctl restart tor
        GREEN "Snowflake client successfully installed!"
    fi
}

function main(){   
    install_tor
}
main
