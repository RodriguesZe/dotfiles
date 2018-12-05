#!/usr/bin/env bash

set -e 				# stops the script when an error is triggered

#===================================================================================

# load the needed scripts

#===================================================================================
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
helpers_dir="$( cd $current_dir && cd helpers && pwd )"

source $helpers_dir/colors.sh
source $helpers_dir/greetings.sh
source $helpers_dir/animations.sh


skipQuestions=false

#===================================================================================

# changelog

#===================================================================================
title="install.sh"
description="This script will install all system configurations from scratch (including all the needed apps)."
author="ZeRodrigues"
date="5/11/2018"
version="0.1.0"


function init() {
    clear
    hello
    changelog "$title" "$description" "$author" "$date" "$version"

    if ! $skipQuestions; then
        disclaimer

        yellow_color
        echo "I just need your password once... "
        sudo -v #ask password beforehand
    fi
}

function disclaimer() {
    yellow_color
    echo "Disclaimer: this script will not install anything without your consent!"
    echo

    green_color
    read -p "Do you want to proceed with installation? (y/N) " -n 1 answer
    echo
    if [ ${answer} != "y" ]; then
        red_color
        echo "Sorry to see you leaving so soon... take care!"
        exit 1
    fi
}

function read_variables() {
    if [[ -n ${1+x} ]]; then
        skipQuestions=$1
    fi
}

function install_xcode() {
    reset_color
    echo "Detecting installed Command Line Tools..."

    if ! [ $(xcode-select -p) ]; then
        yellow_color
        echo "You don't have xcode installed"
        echo "They are required to proceed with installation"

        if ! $skipQuestions; then
            green_color
            read -p "Do you agree to install Command Line Tools? (y/N) " -n 1 answer
            echo

            if ! $skipQuestions && [ ${answer} != "y" ]; then
                yellow_color
                echo "Skipping the installation..."
                exit 1
            fi
        fi

        blue_color
        echo "Installing xcode..."
        echo "Please, wait until Command Line Tools will be installed, before continue"

        xcode-select --install
    else
        yellow_color
        echo "Xcode is already installed..."
    fi

    reset_color
    separator
    sleep 1
}

function install_homebrew() {
    reset_color
    echo "Detecting if Homebrew is installed..."

    if ! [ $(which brew) ]; then
        yellow_color
        echo "Homebrew is not installed"

        reset_color
        echo "Installing Homebrew..."

        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    green_color
    echo "Homebrew installed!"

    reset_color
    echo "Updating Homebrew..."
    brew update

    green_color
    echo "Homebrew updated!"

    reset_color
    separator
    sleep 1
}

function install_php()
{
    yellow_color
    echo "Installing all PHP related tools..."

    # Install PHP extensions with PECL
    pecl install imagick

    green_color
    echo "PHP installed!"

    reset_color
    separator
    sleep 1
}

function install_composer()
{
    yellow_color
    echo "Installing composer..."

    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer

    green_color
    echo "Composer installed!"

    reset_color
    separator
    sleep 1
}

function install_bat()
{
    blue_color
    echo "Trying to detect if bat is installed..."

    if ! [ $(which bat) ]; then
        yellow_color
        echo "Bat is not installed"

        reset_color
        echo "Installing bat..."

        brew install bat
    fi

    green_color
    echo "Bat installed!"
}

function cleanup(){
    reset_color
    echo "Cleaning old brew installations..."

    brew cleanup
    echo "Clean up done!"
}

function terminal(){
    reset_color
    echo
    echo "Configuring your terminal..."

    #install_xcode
    install_homebrew
    install_php
    install_composer
    install_bat
}

function apps()
{
    yellow_color
    echo "Installing all the required apps..."

    brew tap homebrew/bundle
    brew bundle

    green_color
    echo "Apps installed!"

    separator
}

function macos(){
    reset_color
    echo
    echo "Configuring your macos..."

    proceed_question ""
}

function symlink_files()
{
    reset_color
    echo
    echo "Making the remaining configurations..."
}

function goodbye() {
    green_color
    echo
    echo
    echo "This mac was successfully prepared for your daily use!"
    echo

    blue_color
    echo "A couple of tips before you go:"
    echo "	- run 'work' to open all the needed apps for your work day."
    echo "	- run 'gohome' to close all work related apps."
    echo
    green_color
    echo "It's all for now. Have a great time!"

    reset_color
    exit 0
}

read_variables $1
init
terminal
#symlink_files
goodbye