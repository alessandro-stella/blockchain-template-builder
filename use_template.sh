#!/usr/bin/env bash

project_path=$1
template=$2    
shift
shift
contracts=("$@")

template_file="./templates/$template"

if [[ ! -f "$template_file" ]]; then
    echo "❌ Errore: File template non trovato a $template_file. Terminazione."
    exit 1
fi

base_name=$(basename "$template" .md)
capitalized_name="$(tr '[:lower:]' '[:upper:]' <<< ${base_name:0:1})${base_name:1}"
out_file="$project_path/contracts/contracts/interfaces/I${capitalized_name}.sol"

mkdir -p "$(dirname "$out_file")"

cat > "$out_file" <<EOF
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

// Auto-generated Solidity interface from template $template

interface I$capitalized_name {
EOF

for contract in "${contracts[@]}"; do
    block=$(awk -v module="$contract" '
        BEGIN {found=0}
        /^# CONTRACT:/ {
            if ($0 ~ module) {found=1; print $0}
            else {found=0}
        }
        found==1 {print}
    ' "$template_file")

    sol_interface=$(echo "$block" | grep "## SOL INTERFACE:" | sed 's/## SOL INTERFACE: //')

    if [[ -n "$sol_interface" ]]; then
        echo "    $sol_interface" >> "$out_file"
    fi
done

echo "}" >> "$out_file"

echo
echo "Generated file: $out_file"

echo "ABI compilation with solc..."
pushd "$project_path" > /dev/null
npx solc@latest --abi "./contracts/interfaces/I${capitalized_name}.sol" -o "./abis" --base-path . --include-path ./node_modules
popd > /dev/null
echo "ABI generated in $project_path/abis"
