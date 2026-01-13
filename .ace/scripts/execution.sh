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

repeat_char() {
    local char="$1"
    local count="$2"
    if (( count <= 0 )); then
        printf ""
        return
    fi
    printf "%*s" "$count" "" | tr ' ' "$char"
}

show_header() {
    printf "\n"
    printf "%s\n" "  ${C_Purple}╔══════════════════════════════════════════════════════════════╗${C_Reset}"
    printf "%s\n" "  ${C_Purple}║${C_Reset}           ${C_Pink}${C_Bold}ACE EXECUTE${C_Reset}                                     ${C_Purple}║${C_Reset}"
    printf "%s\n" "  ${C_Purple}╠══════════════════════════════════════════════════════════════╣${C_Reset}"
    local plan_pad=$((35 - ${#PlanName}))
    if (( plan_pad < 0 )); then
        plan_pad=0
    fi
    printf "%s\n" "  ${C_Purple}║${C_Reset}  Phase: ${C_Bold}${Phase}${C_Reset}  │  Plan: ${C_Cyan}${PlanName}${C_Reset}$(repeat_char " " "$plan_pad")${C_Purple}║${C_Reset}"
    printf "%s\n" "  ${C_Purple}╚══════════════════════════════════════════════════════════════╝${C_Reset}"
    printf "\n"
}

show_execution_grid() {
    local alpha_status="$1"
    local beta_status="$2"
    local gamma_status="$3"
    local frame="$4"

    local spin_idx=$((frame % ${#Spinners[@]}))

    printf "%s\n" "  ${C_Bold}TASK DISTRIBUTION:${C_Reset}"
    printf "\n"

    printf "%s\n" "  ${C_Blue}┌──────────────────────┐${C_Reset}  ${C_Green}┌──────────────────────┐${C_Reset}  ${C_Pink}┌──────────────────────┐${C_Reset}"

    local alpha_icon
    if [[ "$alpha_status" == "WORKING" ]]; then
        alpha_icon="${C_Yellow}${Spinners[$spin_idx]}${C_Reset}"
    elif [[ "$alpha_status" == "DONE" ]]; then
        alpha_icon="${C_Green}✓${C_Reset}"
    else
        alpha_icon="${C_Gray}○${C_Reset}"
    fi

    local beta_icon
    if [[ "$beta_status" == "WORKING" ]]; then
        beta_icon="${C_Yellow}${Spinners[$spin_idx]}${C_Reset}"
    elif [[ "$beta_status" == "DONE" ]]; then
        beta_icon="${C_Green}✓${C_Reset}"
    else
        beta_icon="${C_Gray}○${C_Reset}"
    fi

    local gamma_icon
    if [[ "$gamma_status" == "WORKING" ]]; then
        gamma_icon="${C_Yellow}${Spinners[$spin_idx]}${C_Reset}"
    elif [[ "$gamma_status" == "DONE" ]]; then
        gamma_icon="${C_Green}✓${C_Reset}"
    else
        gamma_icon="${C_Gray}○${C_Reset}"
    fi

    printf "%s\n" "  ${C_Blue}│${C_Reset} ${C_Bold}ALPHA${C_Reset}         ${alpha_icon}     ${C_Blue}│${C_Reset}  ${C_Green}│${C_Reset} ${C_Bold}BETA${C_Reset}          ${beta_icon}     ${C_Green}│${C_Reset}  ${C_Pink}│${C_Reset} ${C_Bold}GAMMA${C_Reset}         ${gamma_icon}     ${C_Pink}│${C_Reset}"
    printf "%s\n" "  ${C_Blue}├──────────────────────┤${C_Reset}  ${C_Green}├──────────────────────┤${C_Reset}  ${C_Pink}├──────────────────────┤${C_Reset}"

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

    local at_pad=$((20 - ${#at}))
    local bt_pad=$((20 - ${#bt}))
    local gt_pad=$((20 - ${#gt}))
    if (( at_pad < 0 )); then at_pad=0; fi
    if (( bt_pad < 0 )); then bt_pad=0; fi
    if (( gt_pad < 0 )); then gt_pad=0; fi

    printf "%s\n" "  ${C_Blue}│${C_Reset} ${C_Gray}${at}${C_Reset}$(repeat_char " " "$at_pad")${C_Blue}│${C_Reset}  ${C_Green}│${C_Reset} ${C_Gray}${bt}${C_Reset}$(repeat_char " " "$bt_pad")${C_Green}│${C_Reset}  ${C_Pink}│${C_Reset} ${C_Gray}${gt}${C_Reset}$(repeat_char " " "$gt_pad")${C_Pink}│${C_Reset}"
    printf "%s\n" "  ${C_Blue}└──────────────────────┘${C_Reset}  ${C_Green}└──────────────────────┘${C_Reset}  ${C_Pink}└──────────────────────┘${C_Reset}"
}

show_progress_bar() {
    local done="$1"
    local total="$2"

    local percent=0
    if (( total > 0 )); then
        percent=$(( (done * 100) / total ))
    fi
    local width=50
    local filled=$(( (percent * width) / 100 ))
    local empty=$(( width - filled ))

    local bar="${C_Green}$(repeat_char "█" "$filled")${C_Gray}$(repeat_char "░" "$empty")${C_Reset}"
    printf "\n"
    printf "%s\n" "  Progress: [${bar}] ${done}/${total} (${percent}%)"
}

show_execution_view() {
    local alpha_status="$1"
    local beta_status="$2"
    local gamma_status="$3"
    local frame="$4"

    clear
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
    printf "%s\n" "  ${C_Dim}Execution: PARALLEL${C_Reset}"
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
    printf "%s\n" "  ${C_Green}${C_Bold}EXECUTION COMPLETE${C_Reset}"
    printf "\n"
fi
