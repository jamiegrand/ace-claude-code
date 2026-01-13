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
        printf "\n"
        printf "  Ace Terminal Scripts\n"
        printf "  --------------------\n"
        printf "\n"
        printf "  ace splash     Show animated splash screen\n"
        printf "  ace dashboard  Show project dashboard\n"
        printf "  ace progress   Live progress monitoring\n"
        printf "  ace help       Show this help\n"
        printf "\n"
        ;;
esac
