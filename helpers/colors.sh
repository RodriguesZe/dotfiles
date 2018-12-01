#!/usr/bin/env bash

RESET_COLOR="\033[0m"
RED_COLOR="\033[0;31m"
GREEN_COLOR="\033[0;32m"
BLUE_COLOR="\033[0;96m"
YELLOW_COLOR="\033[0;33m"

function reset_color() {
    echo -e "${RESET_COLOR}\c"
}

function red_color() {
    echo -e "${RED_COLOR}\c"
}

function green_color() {
    echo -e "${GREEN_COLOR}\c"
}

function blue_color() {
    echo -e "${BLUE_COLOR}\c"
}

function yellow_color() {
    echo -e "${YELLOW_COLOR}\c"
}