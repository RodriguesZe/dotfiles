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
title="start-working.sh"
description="This script will get your mac ready for an awesome work day."
author="ZeRodrigues"
date="24/10/2018"
version="0.1.0"

function welcome()
{
	clear
	hello
	changelog "$title" "$description" "$author" "$date" "$version"
}

function open_apps()
{
	yellow_color
	echo ""
	echo "Opening all your apps..."

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

function apps_open_container()
{
	declare -a APPS=("${!1}")

	for APP in "${APPS[@]}"; do
		apps_open_app_full_process "$APP"
	done
}

function apps_open_app_full_process()
{
	echo -n "$1..."
	loading_dots &

	# after opening the app, loading_dots needs to be killed. To that end, we collect its pid to kill it afterwards.
	pid=$!

	#apps_open_container "$1"
	open -a "/Applications/$1.app"

	yellow_color
	echo -n " done!"
	green_color

	kill_spinner "$pid"
}

function apps_coding()
{
	apps_functions_header "Coding apps" 

	APPS=("PhpStorm" "Sequel Pro" "Postman 2")

	apps_open_container APPS[@]
}

function apps_productivity()
{
	apps_functions_header "Productivity apps" 

	APPS=("Alfred 3" "Spark" "Bear" "Slack" "Franz")

	apps_open_container APPS[@]
}

function apps_entertainment()
{
	apps_functions_header "Entertainment apps"

	APPS=("Spotify")

	apps_open_container APPS[@]
}

function goodbye()
{
	green_color
    echo
    echo "You're ready to go! Have an amazing and productive day."
    yellow_color
    echo "Btw, don't forget to run the stop-working.sh script at the end of the day."
    reset_color
    exit 0
}

welcome
open_apps
goodbye