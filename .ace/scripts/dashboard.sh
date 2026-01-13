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

repeat_char() {
    local char="$1"
    local count="$2"
    if (( count <= 0 )); then
        printf ""
        return
    fi
    printf "%*s" "$count" "" | tr ' ' "$char"
}

draw_progress_bar() {
    local percent="$1"
    local width="$2"
    local filled=$(( (percent * width) / 100 ))
    local empty=$(( width - filled ))

    local bar=""
    if (( filled > 0 )); then
        bar="${C_Green}$(repeat_char "━" $((filled - 1)))╸${C_Reset}"
    fi
    local tail="${C_Gray}$(repeat_char "·" "$empty")${C_Reset}"
    printf "%s%s %s%%" "$bar" "$tail" "$percent"
}

status_dot() {
    local status="$1"
    local dot_color="$C_Gray"

    if [[ "$status" =~ (In[[:space:]]Progress|Running|Working) ]]; then
        dot_color="$C_Yellow"
    elif [[ "$status" =~ (Complete|Done|Success) ]]; then
        dot_color="$C_Green"
    elif [[ "$status" =~ (Error|Failed) ]]; then
        dot_color="$C_Red"
    fi

    printf "%s●%s" "$dot_color" "$C_Reset"
}

team_dot() {
    local status="$1"
    local dot_color="$C_Gray"

    if [[ "$status" == "WORKING" ]]; then dot_color="$C_Yellow"; fi
    if [[ "$status" == "DONE" ]]; then dot_color="$C_Green"; fi
    if [[ "$status" == "ERROR" ]]; then dot_color="$C_Red"; fi

    printf "%s●%s" "$dot_color" "$C_Reset"
}

get_plan_name() {
    local plan_name="Current Plan"
    if [[ -n "$PlanFile" && -f "$PlanFile" ]]; then
        plan_name=$(basename "$PlanFile")
        plan_name="${plan_name%.md}"
    fi
    printf "%s" "$plan_name"
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
    printf "%s\n" "  ${C_Purple}${C_Bold}CLAUDRON${C_Reset} ${C_Dim}Dashboard${C_Reset}"
    printf "\n"

    local state_info
    if state_info=$(get_state_info); then
        IFS='|' read -r phase_current phase_total status last_activity progress <<< "$state_info"

        local plan_name
        plan_name=$(get_plan_name)

        printf "%s\n" "  ${C_Bold}${C_Pink}PHASE ${phase_current}/${phase_total}${C_Reset} ${C_Dim}•${C_Reset} ${C_Bold}PLAN:${C_Reset} ${C_White}${plan_name}${C_Reset}"
        printf "\n"
        printf "%s\n" "  ${C_Bold}Status:${C_Reset} $(status_dot "$status") ${C_White}${status}${C_Reset}"
        printf "%s\n" "  ${C_Bold}Activity:${C_Reset} ${C_Gray}${last_activity}${C_Reset}"
        printf "%s\n" "  ${C_Bold}Progress:${C_Reset} $(draw_progress_bar "$progress" 36)"
        printf "\n"

        printf "%s\n" "  ${C_Bold}Team Leads:${C_Reset} Alpha $(team_dot "IDLE")   Beta $(team_dot "IDLE")   Gamma $(team_dot "IDLE")"
        printf "\n"

        printf "%s\n" "  ${C_Bold}Quick Commands${C_Reset}"
        printf "%s\n" "  → ${C_Cyan}/ace:progress${C_Reset} ${C_Gray}Refresh status${C_Reset}"
        printf "%s\n" "  → ${C_Cyan}/ace:execute-plan${C_Reset} ${C_Gray}Start execution${C_Reset}"
        printf "%s\n" "  → ${C_Cyan}/ace:show-plan${C_Reset} ${C_Gray}View current plan${C_Reset}"
        printf "%s\n" "  → ${C_Cyan}/ace:help${C_Reset} ${C_Gray}All commands${C_Reset}"
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
