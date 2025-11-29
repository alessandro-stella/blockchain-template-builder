#!/usr/bin/env bash

project_path=$1
mode="multiple"
template=$2
input_file="./templates/$template"

# Aggiungo l'opzione "All of the below" come prima voce
options=("All of the below")
mapfile -t contracts < <(grep '^# CONTRACT:' "$input_file" | awk -F ': ' '{print $2}')
options+=("${contracts[@]}")

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
    if [[ $current -gt 0 ]]; then
        echo "Description of ${options[current]}"
        echo ${MODULE_DESCRIPTIONS[current-1]}
    else
        echo "Select this option to include ALL contracts"
    fi
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
                if [[ $current -eq 0 ]]; then
                    # Toggle su "All of the below"
                    found=false
                    new_selected=()
                    for i in "${selected[@]}"; do
                        if [[ $i -eq 0 ]]; then
                            found=true
                        else
                            new_selected+=("$i")
                        fi
                    done
                    if $found; then
                        # Deseleziono correttamente "All of the below"
                        selected=("${new_selected[@]}")
                    else
                        # Seleziono tutto
                        selected=($(seq 0 $((${#options[@]}-1))))
                    fi
                else
                    # Toggle su una voce normale
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
                        # Deseleziono questa voce
                        selected=("${new_selected[@]}")
                        # Se "All of the below" era selezionato, lo tolgo
                        tmp=()
                        for j in "${selected[@]}"; do
                            [[ $j -ne 0 ]] && tmp+=("$j")
                        done
                        selected=("${tmp[@]}")
                    else
                        selected+=("$current")
                    fi
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
    # Ignoro l'opzione "All of the below" (indice 0)
    if [[ $i -gt 0 ]]; then
      selected_contracts+=("${options[i]}")
    fi
  done

  exec ./use_template.sh "$project_path" "$2" "${selected_contracts[@]}"
else
  echo "No contracts selected, exiting"
fi
