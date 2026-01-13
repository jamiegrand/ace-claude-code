#!/usr/bin/env bash
# Ace Progress Dashboard
# Real-time execution status display

StateFile=".ace/planning/STATE.md"
PlanFile=""
Watch=false
RefreshRate=2

while [[ $# -gt 0 ]]; do
    case "$1" in
        -StateFile)
            StateFile="$2"
            shift 2
            ;;
        -PlanFile)
            PlanFile="$2"
            shift 2
            ;;
        -Watch)
            Watch=true
            shift
            ;;
        -RefreshRate)
            RefreshRate="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

ESC=$'\033'

C_Reset="${ESC}[0m"
C_Bold="${ESC}[1m"
C_Dim="${ESC}[2m"
C_Purple="${ESC}[38;5;135m"
C_Pink="${ESC}[38;5;213m"
C_Green="${ESC}[38;5;114m"
C_Yellow="${ESC}[38;5;221m"
C_Red="${ESC}[38;5;203m"
C_Cyan="${ESC}[38;5;117m"
C_Gray="${ESC}[38;5;245m"
C_White="${ESC}[38;5;255m"
C_BgDark="${ESC}[48;5;236m"

repeat_char() {
    local char="$1"
    local count="$2"
    if (( count <= 0 )); then
        printf ""
        return
    fi
    printf "%*s" "$count" "" | tr ' ' "$char"
}

strip_ansi() {
    printf "%s" "$1" | sed -E $'s/\x1B\[[0-9;]*m//g'
}

draw_box() {
    local title="$1"
    local width="$2"
    local color="$3"
    shift 3
    local content=("$@")

    local top="${color}╔$(repeat_char "═" $((width - 2)))╗${C_Reset}"
    local title_pad=$((width - 4 - ${#title}))
    if (( title_pad < 0 )); then
        title_pad=0
    fi
    local title_line="${color}║${C_Reset} ${C_Bold}${title}${C_Reset}$(repeat_char " " "$title_pad")${color}║${C_Reset}"
    local sep="${color}╠$(repeat_char "═" $((width - 2)))╣${C_Reset}"
    local bottom="${color}╚$(repeat_char "═" $((width - 2)))╝${C_Reset}"

    printf "%s\n" "$top"
    printf "%s\n" "$title_line"
    printf "%s\n" "$sep"

    local line
    for line in "${content[@]}"; do
        local stripped
        stripped=$(strip_ansi "$line")
        local padding=$((width - 4 - ${#stripped}))
        if (( padding < 0 )); then
            padding=0
        fi
        printf "%s\n" "${color}║${C_Reset} ${line}$(repeat_char " " "$padding") ${color}║${C_Reset}"
    done

    printf "%s\n" "$bottom"
}

draw_progress_bar() {
    local percent="$1"
    local width="$2"
    local color="$3"

    local filled=$(( (percent * width) / 100 ))
    local empty=$(( width - filled ))

    local bar="${color}$(repeat_char "█" "$filled")${C_Gray}$(repeat_char "░" "$empty")${C_Reset}"
    printf "[%s] %s%%" "$bar" "$percent"
}

draw_team_status() {
    local alpha="$1"
    local beta="$2"
    local gamma="$3"

    local alpha_color="$C_Gray"
    local beta_color="$C_Gray"
    local gamma_color="$C_Gray"

    if [[ "$alpha" == "WORKING" ]]; then alpha_color="$C_Yellow"; fi
    if [[ "$alpha" == "DONE" ]]; then alpha_color="$C_Green"; fi
    if [[ "$alpha" == "ERROR" ]]; then alpha_color="$C_Red"; fi

    if [[ "$beta" == "WORKING" ]]; then beta_color="$C_Yellow"; fi
    if [[ "$beta" == "DONE" ]]; then beta_color="$C_Green"; fi
    if [[ "$beta" == "ERROR" ]]; then beta_color="$C_Red"; fi

    if [[ "$gamma" == "WORKING" ]]; then gamma_color="$C_Yellow"; fi
    if [[ "$gamma" == "DONE" ]]; then gamma_color="$C_Green"; fi
    if [[ "$gamma" == "ERROR" ]]; then gamma_color="$C_Red"; fi

    local lines=(
        "${C_Purple}┌────────────┬────────────┬────────────┐${C_Reset}"
        "${C_Purple}│${C_Reset}   ${C_Bold}ALPHA${C_Reset}    ${C_Purple}│${C_Reset}    ${C_Bold}BETA${C_Reset}    ${C_Purple}│${C_Reset}   ${C_Bold}GAMMA${C_Reset}    ${C_Purple}│${C_Reset}"
        "${C_Purple}├────────────┼────────────┼────────────┤${C_Reset}"
        "${C_Purple}│${C_Reset}  ${alpha_color}${alpha}${C_Reset}$(repeat_char " " $((8 - ${#alpha})))${C_Purple}│${C_Reset}  ${beta_color}${beta}${C_Reset}$(repeat_char " " $((8 - ${#beta})))${C_Purple}│${C_Reset}  ${gamma_color}${gamma}${C_Reset}$(repeat_char " " $((8 - ${#gamma})))${C_Purple}│${C_Reset}"
        "${C_Purple}└────────────┴────────────┴────────────┘${C_Reset}"
    )

    local line
    for line in "${lines[@]}"; do
        printf "%s\n" "          ${line}"
    done
}

draw_mini_cauldron() {
    printf "%s\n" "${C_Gray}     .  o  .${C_Reset}"
    printf "%s\n" "${C_Gray}    o  .  o${C_Reset}"
    printf "%s\n" "${C_Purple}  .d88888888b.${C_Reset}"
    printf "%s\n" "${C_Purple} d888888888888b${C_Reset}"
    printf "%s\n" "${C_Pink}888888888888888${C_Reset}"
    printf "%s\n" "${C_Purple} Y8888888888P${C_Reset}"
    printf "%s\n" "${C_Gray}  `Y888888P'${C_Reset}"
    printf "%s\n" "${C_Dim}   _/    \_${C_Reset}"
}

get_state_info() {
    if [[ ! -f "$StateFile" ]]; then
        return 1
    fi

    local content
    content=$(cat "$StateFile")

    local phase_current="?"
    local phase_total="?"
    if [[ $content =~ Phase:[[:space:]]*([0-9]+)[[:space:]]*of[[:space:]]*([0-9]+) ]]; then
        phase_current="${BASH_REMATCH[1]}"
        phase_total="${BASH_REMATCH[2]}"
    fi

    local status="Unknown"
    if [[ $content =~ Status:[[:space:]]*(.+) ]]; then
        status="${BASH_REMATCH[1]}"
        status="${status%%$'\r'}"
    fi

    local last_activity="Unknown"
    if [[ $content =~ Last[[:space:]]activity:[[:space:]]*(.+) ]]; then
        last_activity="${BASH_REMATCH[1]}"
        last_activity="${last_activity%%$'\r'}"
    fi

    local progress=0
    if [[ $content =~ Progress:.*\[[#[:space:]]+\][[:space:]]*([0-9]+)% ]]; then
        progress="${BASH_REMATCH[1]}"
    fi

    printf "%s\n" "$phase_current|$phase_total|$status|$last_activity|$progress"
}

show_dashboard() {
    clear

    printf "\n"
    printf "%s\n" "  ${C_Purple}${C_Bold}╔══════════════════════════════════════════════════════════════╗${C_Reset}"
    printf "%s\n" "  ${C_Purple}${C_Bold}║${C_Reset}              ${C_Pink}${C_Bold}C L A U D R O N${C_Reset}   ${C_Gray}Dashboard${C_Reset}              ${C_Purple}${C_Bold}║${C_Reset}"
    printf "%s\n" "  ${C_Purple}${C_Bold}╚══════════════════════════════════════════════════════════════╝${C_Reset}"
    printf "\n"

    local state_info
    if state_info=$(get_state_info); then
        IFS='|' read -r phase_current phase_total status last_activity progress <<< "$state_info"

        local status_content=(
            "${C_Gray}Phase:${C_Reset}    ${C_Bold}${phase_current}${C_Reset} of ${phase_total}"
            "${C_Gray}Status:${C_Reset}   ${C_Green}${status}${C_Reset}"
            "${C_Gray}Activity:${C_Reset} ${last_activity}"
            ""
            "$(draw_progress_bar "$progress" 45 "$C_Green")"
        )

        draw_box "PROJECT STATUS" 58 "$C_Purple" "${status_content[@]}"
        printf "\n"

        printf "%s\n" "  ${C_Bold}TEAM LEADS${C_Reset}"
        draw_team_status "IDLE" "IDLE" "IDLE"
        printf "\n"

        local cmd_content=(
            "${C_Cyan}/ace:progress${C_Reset}      Refresh status"
            "${C_Cyan}/ace:execute-plan${C_Reset}  Start execution"
            "${C_Cyan}/ace:show-plan${C_Reset}     View current plan"
            "${C_Cyan}/ace:help${C_Reset}          All commands"
        )
        draw_box "QUICK COMMANDS" 58 "$C_Gray" "${cmd_content[@]}"
    else
        printf "%s\n" "  ${C_Yellow}No project state found.${C_Reset}"
        printf "%s\n" "  ${C_Gray}Run ${C_Cyan}/ace:new-project${C_Gray} to start.${C_Reset}"
    fi

    printf "\n"
    if [[ "$Watch" == true ]]; then
        printf "%s\n" "  ${C_Dim}Auto-refreshing every ${RefreshRate} seconds. Press Ctrl+C to exit.${C_Reset}"
    fi
}

if [[ "$Watch" == true ]]; then
    while true; do
        show_dashboard
        sleep "$RefreshRate"
    done
else
    show_dashboard
fi
