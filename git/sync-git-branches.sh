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
title="sync-git-branches.sh"
description="This script will sync two branches in the same repository."
author="ZeRodrigues"
date="3/11/2018"
version="0.1.2"

# passed params
ORIGINBRANCH='dev'
TARGETBRANCH='staging'
STASHED=false

function welcome()
{
    clear
    hello
    disclaimer
    changelog "$title" "$description" "$author" "$date" "$version"
}

function disclaimer() {
    yellow_color

    echo "Disclaimer: this script will sync your repository branches."
    echo

    reset_color
}

function usage() {
    yellow_color
    echo ""
    echo "USAGE"
    echo "======================================="
    echo ""
    echo "Run the script inside the root folder of the project you want to sync your branches."
    echo "Be sure that the origin branch is currently in use. The branches you can rebase to will appear as options for you to choose."
    echo ""
    exit 1
}

function repository_info(){
    reset_color

    echo "REPOSITORY"
    echo "======================================="

    yellow_color
    REMOTE=$(git remote show -n origin | grep Fetch | cut -d: -f2-)
    echo "Remote:$REMOTE"

    ORIGINBRANCH=$(git branch | grep \* | cut -d ' ' -f2)
    echo "Current branch: $ORIGINBRANCH"
}

function choose_branch(){
    green_color

    #git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(color:blue)%(authorname) %(color:reset)(%(color:green)%(committerdate:relative)%(color:reset))'
    options=($(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short)'))

    if [[ "${#options[@]}" -eq 0 ]]; then
        echo ""
        echo "All branches are synced"
        reset_color
        exit 0
    fi

    echo ""
    echo "Branches available:"
    reset_color

    PS3='Rebase to: '
    select opt in "${options[@]}"; do

        if [[ -z "$opt" ]]; then
            red_color
            echo "Option not available. Try again!"
            reset_color
        elif (printf '%s\n' "${options[@]}" | grep -xq $opt); then
            TARGETBRANCH=$opt
            break;
        fi

    done

    green_color
    echo ""
    echo "Chosen branch: $TARGETBRANCH"
}

function stash_not_commited_files(){
    reset_color

    # Update the index
    git update-index -q --ignore-submodules --refresh
    err=0

    # Disallow unstaged changes in the working tree
    if ! git diff-files --quiet --ignore-submodules --
    then
        #echo >&2 "cannot $1: you have unstaged changes."
        git diff-files --name-status -r --ignore-submodules -- >&2
        err=1
    fi

    # Disallow uncommitted changes in the index
    if ! git diff-index --cached --quiet HEAD --ignore-submodules --
    then
        #echo >&2 "cannot $1: your index contains uncommitted changes."
        git diff-index --cached --name-status -r --ignore-submodules HEAD -- >&2
        err=1
    fi

    if [ $err = 1 ]
    then
        git stash -q
        STASHED=true

        yellow_color
        echo "Uncommitted files are now stashed! It will go back to the working tree at the end of the sync process."
    fi
}

function sync_branches(){
    yellow_color
    echo ""
    echo "Syncing branches.."
    reset_color
    git checkout $TARGETBRANCH
    git rebase $ORIGINBRANCH

    yellow_color
    echo ""
    echo "Pushing changes..."
    reset_color
    git push origin $TARGETBRANCH

    yellow_color
    echo ""
    echo "Moving back to $ORIGINBRANCH"
    reset_color
    git checkout $ORIGINBRANCH
}

function unstash_not_commited_files(){
    reset_color
    if [ "$STASHED" = true ]
    then
        git stash pop -q

        yellow_color
        echo ""
        echo "Uncommitted files are now back again in the working tree."
    fi
}

function goodbye(){
    green_color
    echo
    echo
    echo "Branches were successfully synced!"

    reset_color
    exit 0
}

welcome
repository_info
choose_branch
stash_not_commited_files
sync_branches
unstash_not_commited_files
goodbye
