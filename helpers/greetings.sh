#!/usr/bin/env bash

function hello() {
    green_color

    echo "                                              "
    echo "      _____         ____                _     "
    echo "     |__  /   ___  |    \    ___     __| |    "
    echo "       / /   / _ \ | | ) |  /   \   /    |    "
    echo "      / /_  |  __/ |  _ <  | ( ) | | ( | |    "
    echo "     /____|  \___| |_| \_\  \___/   \____|    "
    echo "                 @javrodrigues                "   
    echo "                                              "
}

function changelog() {
    reset_color
    echo
    echo "CHANGELOG"
    echo "======================================="
    echo "title:         $1"
    echo "description:   $2"
    echo "author:        $3"
    echo "date:          $4"
    echo "version:       $5"
    echo
}

function proceed_question()
{
    green_color

    read -p "Shall we proceed? (y/N) " -n 1 answer
    echo
    if [[ ${answer} != "y" ]]; then
        red_color
        echo "Sorry to see you leaving so soon... take care!"
        exit 1
    fi

    reset_color
}

function separator() {
    green_color
    echo "#=============================STEP FINISHED=============================#"
    reset_color
}

