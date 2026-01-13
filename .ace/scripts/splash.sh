#!/usr/bin/env bash
# Ace Splash Screen
# Run: ./splash.sh

ESC=$'\033'

# Colors
Reset="${ESC}[0m"
Bold="${ESC}[1m"
Dim="${ESC}[2m"
Purple="${ESC}[38;5;135m"
Pink="${ESC}[38;5;213m"
Green="${ESC}[38;5;114m"
Yellow="${ESC}[38;5;221m"
Cyan="${ESC}[38;5;117m"
Gray="${ESC}[38;5;245m"
White="${ESC}[38;5;255m"

center_text() {
    local text="$1"
    local width
    width=$(tput cols 2>/dev/null || echo 80)
    local plain
    plain=$(printf "%s" "$text" | sed -E $'s/\x1B\[[0-9;]*m//g')
    local pad=$(( (width - ${#plain}) / 2 ))
    if (( pad < 0 )); then
        pad=0
    fi
    printf "%*s%s\n" "$pad" "" "$text"
}

clear

printf "\n"
center_text "${Bold}${Purple}💎 ACE  v4.0${Reset}"
center_text "${Dim}Agent Creates Everything${Reset}"
printf "\n"

printf "%s\n" "${Bold}${Pink}Build Anything${Reset}"
printf "%s\n" "  • ${Green}Apps${Reset} ${Gray}dashboards, landing pages, portals${Reset}"
printf "%s\n" "  • ${Green}APIs${Reset} ${Gray}REST, GraphQL, microservices${Reset}"
printf "%s\n" "  • ${Green}Tools${Reset} ${Gray}CLI, scripts, automations${Reset}"
printf "%s\n" "  • ${Green}Agents${Reset} ${Gray}AI workflows, LLM pipelines${Reset}"
printf "\n"

printf "%s\n" "${Bold}${Cyan}Commands${Reset}"
printf "%s\n" "  → ${Cyan}/ace:new-project${Reset} ${Gray}Start new project${Reset}"
printf "%s\n" "  → ${Cyan}/ace:map-codebase${Reset} ${Gray}Analyze existing code${Reset}"
printf "%s\n" "  → ${Cyan}/ace:progress${Reset} ${Gray}Check status${Reset}"
printf "%s\n" "  → ${Cyan}/ace:help${Reset} ${Gray}All commands${Reset}"
printf "\n"

printf "%s\n" "${Dim}What's the plan?${Reset}"
printf "\n"
