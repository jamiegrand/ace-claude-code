#!/usr/bin/env bash
# Ace Execution Progress Display
# Shows real-time Team Lead activity during plan execution

PlanName="Current Plan"
Phase="1"
AlphaTask=""
BetaTask=""
GammaTask=""
Mode="Running"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -PlanName)
            PlanName="$2"
            shift 2
            ;;
        -Phase)
            Phase="$2"
            shift 2
            ;;
        -AlphaTask)
            AlphaTask="$2"
            shift 2
            ;;
        -BetaTask)
            BetaTask="$2"
            shift 2
            ;;
        -GammaTask)
            GammaTask="$2"
            shift 2
            ;;
        -Mode)
            Mode="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

ESC=$'\033'
printf "\033]0;Ace - Executing\007"

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
C_Blue="${ESC}[38;5;75m"

Spinners=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
Rendered=false

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

pad_text() {
    local text="$1"
    local width="$2"
    local plain
    plain=$(strip_ansi "$text")
    local pad=$((width - ${#plain}))
    if (( pad < 0 )); then
        pad=0
    fi
    printf "%s%s" "$text" "$(repeat_char " " "$pad")"
}

show_header() {
    printf "\n"
    printf "%s\n" "  ${C_Bold}${C_Pink}ACE EXECUTE${C_Reset}"
    printf "%s\n" "  ${C_Dim}Phase ${Phase} • Plan ${PlanName}${C_Reset}"
    printf "\n"
}

status_icon() {
    local status="$1"
    local frame="$2"
    local spin_idx=$((frame % ${#Spinners[@]}))

    if [[ "$status" == "WORKING" ]]; then
        printf "%s%s%s" "$C_Yellow" "${Spinners[$spin_idx]}" "$C_Reset"
    elif [[ "$status" == "DONE" ]]; then
        printf "%s🟢%s" "$C_Green" "$C_Reset"
    else
        printf "%s⚪️%s" "$C_Gray" "$C_Reset"
    fi
}

show_execution_grid() {
    local alpha_status="$1"
    local beta_status="$2"
    local gamma_status="$3"
    local frame="$4"

    printf "%s\n" "  ${C_Bold}Task Distribution${C_Reset}"
    printf "\n"

    local col_width=20
    local alpha_label="${C_Bold}ALPHA${C_Reset}"
    local beta_label="${C_Bold}BETA${C_Reset}"
    local gamma_label="${C_Bold}GAMMA${C_Reset}"

    printf "  %s  %s  %s\n" "$(pad_text "$alpha_label" "$col_width")" "$(pad_text "$beta_label" "$col_width")" "$(pad_text "$gamma_label" "$col_width")"

    local alpha_status_line="$(status_icon "$alpha_status" "$frame") ${C_Dim}${alpha_status}${C_Reset}"
    local beta_status_line="$(status_icon "$beta_status" "$frame") ${C_Dim}${beta_status}${C_Reset}"
    local gamma_status_line="$(status_icon "$gamma_status" "$frame") ${C_Dim}${gamma_status}${C_Reset}"

    printf "  %s  %s  %s\n" "$(pad_text "$alpha_status_line" "$col_width")" "$(pad_text "$beta_status_line" "$col_width")" "$(pad_text "$gamma_status_line" "$col_width")"

    local at="$AlphaTask"
    local bt="$BetaTask"
    local gt="$GammaTask"
    if (( ${#at} > 18 )); then
        at="${at:0:15}..."
    fi
    if (( ${#bt} > 18 )); then
        bt="${bt:0:15}..."
    fi
    if (( ${#gt} > 18 )); then
        gt="${gt:0:15}..."
    fi

    local at_line="${C_Gray}${at}${C_Reset}"
    local bt_line="${C_Gray}${bt}${C_Reset}"
    local gt_line="${C_Gray}${gt}${C_Reset}"

    printf "  %s  %s  %s\n" "$(pad_text "$at_line" "$col_width")" "$(pad_text "$bt_line" "$col_width")" "$(pad_text "$gt_line" "$col_width")"
}

show_progress_bar() {
    local done="$1"
    local total="$2"

    local percent=0
    if (( total > 0 )); then
        percent=$(( (done * 100) / total ))
    fi
    local width=40
    local filled=$(( (percent * width) / 100 ))
    local empty=$(( width - filled ))

    local bar=""
    if (( filled > 0 )); then
        bar="${C_Green}$(repeat_char "━" $((filled - 1)))╸${C_Reset}"
    fi
    local tail="${C_Gray}$(repeat_char "·" "$empty")${C_Reset}"

    printf "\n"
    printf "%s\n" "  ${C_Bold}Progress:${C_Reset} ${bar}${tail} ${done}/${total} (${percent}%)"
}

show_execution_view() {
    local alpha_status="$1"
    local beta_status="$2"
    local gamma_status="$3"
    local frame="$4"

    if [[ "$Rendered" == true ]]; then
        tput cup 0 0
        tput ed
    else
        clear
        Rendered=true
    fi

    show_header
    show_execution_grid "$alpha_status" "$beta_status" "$gamma_status" "$frame"

    local done=0
    if [[ "$alpha_status" == "DONE" ]]; then
        done=$((done + 1))
    fi
    if [[ "$beta_status" == "DONE" ]]; then
        done=$((done + 1))
    fi
    if [[ "$gamma_status" == "DONE" ]]; then
        done=$((done + 1))
    fi

    show_progress_bar "$done" 3
    printf "\n"
    printf "%s\n" "  ${C_Dim}Execution: Parallel${C_Reset}"
}

if [[ "$Mode" == "Running" ]]; then
    for ((i=0; i<30; i++)); do
        local_alpha="WAITING"
        local_beta="WAITING"
        local_gamma="WAITING"

        if (( i >= 5 && i < 15 )); then
            local_alpha="WORKING"
        elif (( i >= 15 )); then
            local_alpha="DONE"
        fi

        if (( i >= 8 && i < 20 )); then
            local_beta="WORKING"
        elif (( i >= 20 )); then
            local_beta="DONE"
        fi

        if (( i >= 3 && i < 25 )); then
            local_gamma="WORKING"
        elif (( i >= 25 )); then
            local_gamma="DONE"
        fi

        show_execution_view "$local_alpha" "$local_beta" "$local_gamma" "$i"
        sleep 0.2
    done

    show_execution_view "DONE" "DONE" "DONE" 0
    printf "\n"
    printf "%s\n" "  ${C_Green}${C_Bold}Execution Complete${C_Reset}"
    printf "\n"
fi
