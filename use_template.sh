#!/usr/bin/env bash

project_path=$1
template=$2    
shift
shift
contracts=("$@")

template_file="./templates/$template"

base_name=$(basename "$template" .md)
capitalized_name="$(tr '[:lower:]' '[:upper:]' <<< ${base_name:0:1})${base_name:1}"
out_file="$project_path/contracts/contracts/interfaces/I${capitalized_name}.sol"
go_file="$project_path/$base_name/contract.go"

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

npx solc@latest --abi "./contracts/contracts/interfaces/I${capitalized_name}.sol" \
    -o "./contracts/abi" --base-path . --include-path ./node_modules

abi_dir="./contracts/abi"
abi_file=$(ls "$abi_dir"/*.abi 2>/dev/null | head -n 1)
readable_file="$abi_dir/I${capitalized_name}.abi"

if [[ -n "$abi_file" && -f "$abi_file" ]]; then
    mv "$abi_file" "$readable_file"
    echo "ABI file renamed in $readable_file"
else
    echo "No ABI found in $abi_dir"
fi

base_name=$(basename "$template" .md)
type_name="$(tr '[:lower:]' '[:upper:]' <<< ${base_name:0:1})${base_name:1}"
pkg_name="$(echo "$base_name" | tr '[:upper:]' '[:lower:]')"

echo "Generating precompile with type=$type_name and pkg=$pkg_name"

./scripts/generate_precompile.sh --abi "$readable_file" --type "$type_name" --pkg "$pkg_name" --out "./$pkg_name"

popd > /dev/null
echo "ABI generated in $project_path/contracts/abi"

for contract in "${contracts[@]}"; do
  function_name=$(awk -v contract="$contract" '
    $0 ~ "^# CONTRACT: " contract { in_block=1; next }
    in_block && /^---$/ { in_block=0; exit }
    in_block && /^## SOL INTERFACE:/ {
      match($0, /function[[:space:]]+([^(]+)/, arr)
      print arr[1]
      exit
    }
  ' "./templates/$template")

  code=$(awk -v contract="$contract" '
    $0 ~ "^# CONTRACT: " contract { in_block=1; next }
    in_block && /^---$/ { in_block=0; exit }
    in_block && /^## GO IMPLEMENTATION:/ { go_block=1; next }
    go_block && in_block { print }
  ' "./templates/$template")

  echo "Function: $function_name"

  awk -v template="$template" -v fn="$function_name" -v insert="$code" '
    BEGIN {found_fn=0; inserted=0}
    index($0, fn) {found_fn=1}
    found_fn && !inserted && /_ = inputStruct/ {
      print $0

	  print ""
      print "\t//============================================================"
      print "\t// CODE INJECTED FROM TEMPLATE " template
      print "\t//============================================================"
	  print ""

      n = split(insert, lines, "\n")
      for (i=1; i<=n; i++) {
        if (lines[i] != "")
          print "\t" lines[i]
      }

  	  print ""
      print "\t//============================================================"
      print "\t// END OF INJECTED CODE"
      print "\t//============================================================"
  	  print ""

      inserted=1
      next
    }
    {print}
  ' "$go_file" > "${go_file}.tmp" && mv "${go_file}.tmp" "$go_file"

done

