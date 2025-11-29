#!/usr/bin/env bash

mode="unique"
selected=()
current=0
option_lines=0

if [[ ! -d "./templates" ]]; then
    echo "Folder ./templates not found"
    exit 1
fi

options=()
files=()

shopt -s nullglob
for f in ./templates/*.md; do
    base="$(basename "$f")"
    name="${base%.md}" 
    options+=("${name^}")
    files+=("$base")    
done
shopt -u nullglob

if [[ ${#options[@]} -eq 0 ]]; then
    echo "No Markdown files found in ./templates"
    exit 1
fi

clear

draw_menu() {
    if [[ $option_lines -gt 0 ]]; then
        tput cuu $option_lines
    else
        echo
        echo "Select the desired template"
        echo "Use ↑ ↓ to move, space to select/deselect, Enter to confirm"
        echo
    fi

    for i in "${!options[@]}"; do
        prefix="   "
        mark=" "
        [[ $i -eq $current ]] && prefix=">  "
        [[ " ${selected[@]} " =~ " ${i} " ]] && mark="x"
        printf "\r%s[%s] %s\n" "$prefix" "$mark" "${options[i]}"
    done

    option_lines=${#options[@]}
}

read_key() {
    IFS= read -rsn1 key
    if [[ $key == $'\x1b' ]]; then
        read -rsn2 -t 0.1 key2
        key+=$key2
    fi
    echo "$key"
}

while true; do
    draw_menu
    key=$(read_key)

    case "$key" in
        $'\x1b[A')
            ((current--))
            [[ $current -lt 0 ]] && current=$((${#options[@]}-1))
            ;;
        $'\x1b[B')
            ((current++))
            [[ $current -ge ${#options[@]} ]] && current=0
            ;;
        ' ')
            if [[ "$mode" == "multiple" ]]; then
                found=false
                new_selected=()
                for i in "${selected[@]}"; do
                    if [[ $i -eq $current ]]; then
                        found=true
                    else
                        new_selected+=("$i")
                    fi
                done
                if $found; then
                    selected=("${new_selected[@]}")
                else
                    selected+=("$current")
                fi
            else
                selected=("$current")
            fi
            ;;
        '')
            [[ "$mode" == "unique" && ${#selected[@]} -eq 0 ]] && selected=("$current")
            break
            ;;
    esac
done

if [[ ${#selected[@]} -gt 0 ]]; then
    exec ./select_contracts.sh "$1" "${files[selected[0]]}"
fi
