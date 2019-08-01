#!/bin/bash
set -u

source "$(dirname $0)/utils.sh"
goto_root

function check_command() {
    local cmd="$1"
    if ! command -v ${cmd} > /dev/null 2>&1; then
        echo "This requires ${cmd} command, please install it first."
        exit 1
    fi
}

function verlte() {
    [  "$1" = "$(echo -e "$1\n$2" | sort -V | head -n1)" ]
}

function verlt() {
    [ "$1" = "$2" ] && return 1 || verlte $1 $2
}

function check_version() {
    if [[ "$1" == "terraform" ]]; then
        tmp_dir=$(mktemp -d)
        cd ${tmp_dir}
        cur_ver=$(terraform version | head -n 1 | cut -d' ' -f2)
        cur_ver=${cur_ver#"v"}
        cd - > /dev/null
        rm -fr ${tmp_dir}
        req_ver=$(grep required_version README.md | awk '{print $4}')
        req_ver=${req_ver%'"'}
    elif [[ "$1" == "terraform-docs" ]]; then
        req_ver="0.6.0"
        cur_ver=$(terraform-docs --version)
    else
        return
    fi
    if ! verlte $req_ver $cur_ver; then
        echo "This requires at least version ${req_ver} of $1, please upgrade (current version is ${cur_ver})"
        exit 2
    fi
}

for cmd in terraform terraform-docs; do
    check_command $cmd
    check_version $cmd
done
