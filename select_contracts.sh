#!/usr/bin/env bash

project_path=$1
mode="multiple"
input_file="./templates/$2"

if [ ! -f "$input_file" ]; then
    echo "Errore: File $input_file non trovato."
    exit 1
fi

mapfile -t options < <(grep '^# CONTRACT:' "$input_file" | awk -F ': ' '{print $2}')

mapfile -t MODULE_DESCRIPTIONS < <(grep '^## DESCRIPTION: ' "$input_file" | awk -F ': ' '{print $2}')

current=0
selected=()
option_lines=0

draw_menu() {
    clear
    echo
    echo "Selected template: $template"
    echo "Choose which contracts you want to implement"
    echo "Use ↑ ↓ to move, space to select/deselect, Enter to confirm"
    echo

    for i in "${!options[@]}"; do
        prefix="   "
        mark=" "
        [[ $i -eq $current ]] && prefix=">  "
        [[ " ${selected[@]} " =~ " ${i} " ]] && mark="x"
        printf "%s[%s] %s\n" "$prefix" "$mark" "${options[i]}"
    done

    echo
    echo "Description of ${options[current]}"
    echo ${MODULE_DESCRIPTIONS[current]}
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

if [ ${#selected[@]} -gt 0 ]; then
    mapfile -t selected < <(printf "%s\n" "${selected[@]}" | sort -n)
fi

if [[ ${#selected[@]} -ge 1 ]]; then
  selected_contracts=()
  for i in "${selected[@]}"; do
    selected_contracts+=("${options[i]}")
  done

  exec ./use_template.sh "$project_path" "$2" "${selected_contracts[@]}"
else
  echo "No contracts selected, exiting"
fi
