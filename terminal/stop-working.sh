#!/usr/bin/env bash

set -e

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
title="stop-working.sh"
description="This script will close all the apps no longer needed, after an awesome work day."
author="ZeRodrigues"
date="24/10/2018"
version="0.1.0"

function welcome()
{
	clear
	hello
	changelog "$title" "$description" "$author" "$date" "$version"
}

function close_apps()
{
	yellow_color
	echo ""
	echo "Closing all your apps..."

	green_color

	apps_coding
	apps_productivity
	apps_entertainment
}

function apps_functions_header()
{
	reset_color
	echo 
	echo "$1:"
	green_color
}

function apps_close_container()
{
	declare -a APPS=("${!1}")

	for APP in "${APPS[@]}"; do
		apps_close_app_full_process "$APP"
	done
}

function apps_close_app_full_process()
{
	echo -n "$1..."
	loading_dots &

	# after opening the app, loading_dots needs to be killed. To that end, we collect its pid to kill it afterwards.
	pid=$!

	#APP_PID=$(pgrep -f "$1")
	if [[ -z $(pgrep -f "$1") ]]
	then
		red_color
		echo -n " app already closed!"
	  	green_color
	else
		kill -9 $(pgrep -f "$1")
		yellow_color
		echo -n " done!"
		green_color
	fi

	kill_spinner "$pid"
}

function apps_coding()
{
	apps_functions_header "Coding apps" 

	APPS=("PhpStorm" "Sequel Pro" "Postman 2" "Sublime Text 2")

	apps_close_container APPS[@]
}

function apps_productivity()
{
	apps_functions_header "Productivity apps" 

	APPS=("Bear" "Slack" "Franz" "Console")

	apps_close_container APPS[@]
}

function apps_entertainment()
{
	apps_functions_header "Entertainment apps"

	APPS=("Spotify")

	apps_close_container APPS[@]
}

function goodbye()
{
	green_color
    echo
    echo "You're ready to go home! Have a pleasant evening."
    exit 0
}

welcome
close_apps
goodbye