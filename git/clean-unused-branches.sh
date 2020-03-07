#!/usr/bin/env bash

set -e 				# stops the script when an error is triggered
#set -o pipetail		# stops the script when an error is triggered on piped commands

#===================================================================================

# load the needed scripts

#===================================================================================
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
helpers_dir="$( cd $current_dir && cd ../helpers && pwd )"

source $helpers_dir/colors.sh
source $helpers_dir/greetings.sh
source $helpers_dir/animations.sh

#===================================================================================

# changelog

#===================================================================================
title="clean-unused-branches.sh"
description="This script will delete all local branches that are already deleted in origin."
author="ZeRodrigues"
date="07/03/2020"
version="0.2.0"

# passed params
CHECK_ORIGIN=1

# global params
ORIGINBRANCH='develop'
OUTDATEDBRANCHES=()
DELETEDBRANCHES=()
STILLONREMOTE=()

function welcome()
{
    clear
    hello
    disclaimer
    changelog "$title" "$description" "$author" "$date" "$version"
}

function disclaimer() {
    yellow_color
    
    echo "Disclaimer: only your local copy of the remote branches will be deleted."
    echo
    
    reset_color
}

function usage() {
    yellow_color
    echo ""
    echo "USAGE"
    echo "======================================="
    echo ""
    echo "Run the script inside the root folder of the project you want to delete your local branches."
    echo ""
    exit 1
}

function repository_info() {
    reset_color
    
    echo "REPOSITORY"
    echo "======================================="
    
    REMOTE=$(git remote show -n origin | grep Fetch | cut -d: -f2-)
    echo -n "Remote:"
    yellow_color
    echo "$REMOTE"
    
    ORIGINBRANCH=$(git branch | grep \* | cut -d ' ' -f2)
    reset_color
    echo -n "Current branch: "
    yellow_color
    echo "$ORIGINBRANCH"
}

function read_options() {
    while [ "$1" != "" ]; do
        case $1 in
            -s | --skip-origin )    CHECK_ORIGIN=0
            ;;
            -h | --help )           usage
                exit
            ;;
            * )                     usage
                exit 1
        esac
        shift
    done
}

function local_merged_branches() {
    reset_color
    
    # deletes all merged brances
    #git branch --merged develop | grep -v develop | xargs git branch -d
    OUTDATEDBRANCHES=($(git branch --merged $ORIGINBRANCH | grep -v $ORIGINBRANCH))
    
    if [[ "${#OUTDATEDBRANCHES[@]}" -eq 0 ]]; then
        echo
        echo "There is no outdated branches."
        reset_color
        exit 0
    fi
    
    echo
    echo "Outaded branches:"
    yellow_color
    for i in "${OUTDATEDBRANCHES[@]}"; do
        echo "$i"
    done
    green_color
    echo
    echo "${#OUTDATEDBRANCHES[@]} deletable branches were found."
}

function how_to_remove_branches() {
    blue_color
    echo ""
    read -p "Remove branches all branches? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        delete_branches "all-at-once"
        return
    fi
    
    reset_color
    echo "Deleting branches one by one..."
    delete_branches "one-by-one"
}

function delete_branches() {
    for i in "${OUTDATEDBRANCHES[@]}"; do
        if [ "$CHECK_ORIGIN" = "1" ]; then
            check_branch_origin_existance $i
        else
            yellow_color
            echo "$i"
        fi
        
        if [ "${1}" == "all-at-once" ]; then
            delete_single_branch $i
        else
            blue_color
            read -p "Do you want to delete it locally? [y/N] " -n 1 -r
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo
                delete_single_branch $i
            else
                green_color
                echo
                echo "Skipped!"
            fi
            echo
        fi
    done
}

function delete_single_branch() {
    red_color
    DELETEDBRANCHES+=(${1})
    git branch -D ${1}
}

function check_branch_origin_existance() {
    reset_color
    echo -n "Checking "
    yellow_color
    echo -n "$i"
    reset_color
    echo -n "..."
    
    reset_color
    HASORIGIN=($(git ls-remote --heads origin ${1}))
    if [ -z "$HASORIGIN" ]; then
        green_color
        echo " branch doesn't exist remotly."
    else
        red_color
        echo " branch exists remotly. Consider deleting it!"
    fi
}

function summary() {
    reset_color
    echo
    echo "Summary"
    echo "======================================="
    
    green_color
    echo "${#DELETEDBRANCHES[@]} local branches deleted!"
}

function goodbye(){
    green_color
    echo
    echo "Script ended. Have a good day!"
    
    reset_color
    exit 0
}

##### Main
welcome
read_options $1
repository_info
local_merged_branches
how_to_remove_branches
summary
goodbye
