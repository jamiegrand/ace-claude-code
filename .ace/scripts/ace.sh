#!/usr/bin/env bash
# Ace Launcher for macOS/Linux
# Usage: ace [splash|dashboard|progress]

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

command="$1"

if [[ -z "$command" ]]; then
    command="splash"
fi

case "$command" in
    splash)
        "${script_dir}/splash.sh"
        ;;
    dashboard)
        "${script_dir}/dashboard.sh"
        ;;
    progress)
        "${script_dir}/dashboard.sh" -Watch
        ;;
    help|*)
        ESC=$'\033'
        Bold="${ESC}[1m"
        Reset="${ESC}[0m"
        Dim="${ESC}[2m"

        printf "\n"
        printf "  ${Bold}Ace Terminal Scripts${Reset}\n"
        printf "  ${Dim}Minimal CLI tools for your Ace workflow${Reset}\n"
        printf "\n"
        printf "  ${Bold}Commands${Reset}\n"
        printf "    ${Bold}ace splash${Reset}     Show animated splash screen\n"
        printf "    ${Bold}ace dashboard${Reset}  Show project dashboard\n"
        printf "    ${Bold}ace progress${Reset}   Live progress monitoring\n"
        printf "    ${Bold}ace help${Reset}       Show this help\n"
        printf "\n"
        ;;
esac
