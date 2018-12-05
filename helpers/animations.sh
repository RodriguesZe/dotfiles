#!/usr/bin/env bash

function loading_dots()
{
    while [[ 1 ]]; do
        echo -ne "."
        sleep 0.1
    done
}

function spin()
{
    declare -a spinner_elements=("${!1}")

    while [[ 1 ]]; do
        for i in "${spinner_elements[@]}"; do
            echo -ne "\r$i"
            sleep 0.4
        done
    done
}

function spinner_basic()
{
    spinner_basic=( '|' '/' '-' '\' )

    spin spinner_basic[@]
}

function animated_shrug()
{
	spinner=( 
		'___(•_•)___'
		'\__(¬‿¬)__/'
		'¯\_(ツ)_/¯'
		'¯¯\(°°)/¯¯' 
		'¯¯\(°°)/¯¯' 
		'¯\_(ツ)_/¯' 
		'\__(¬‿¬)__/'       
		'___(•_•)___'
		)

	spinner1=( 
		'      ¯\_(ツ)_/¯            ' 
		'       ¯\_(ツ)_/¯           ' 
		'        ¯\_(ツ)_/¯          ' 
		'         ¯\_(ツ)_/¯         ' 
		'          ¯\_(ツ)_/¯        ' 
		'           ¯\_(ツ)_/¯       ' 
		'            ¯\_(ツ)_/¯      ' 
		'            ¯\_(ツ)_/¯      '
		'           ¯\_(ツ)_/¯       ' 
		'          ¯\_(ツ)_/¯        ' 
		'         ¯\_(ツ)_/¯         ' 
		'        ¯\_(ツ)_/¯          ' 
		'       ¯\_(ツ)_/¯           '       
		'      ¯\_(ツ)_/¯            '
		)

	spin spinner[@]
}

function kill_spinner()
{
    if [[ $# -eq 0 ]]
    then
        echo "No pid was provided"
        exit 64
    fi

    # -13 prevents the output of warning messages after killing the pid
    kill -13 "$1"
    echo ""
}