#!/usr/bin/env bash

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

DEFAULT_VERSION=latest

show_help() {
cat << EOF
Usage: $(basename "$0") <options>

    -h, --help                              Display help
    -v, --version                           The YAKS version to use (default: $DEFAULT_VERSION)
    --github-token                          Optional token used when fetching the latest YAKS release to avoid hitting rate limits

EOF
}

main() {
    local version="$DEFAULT_VERSION"
    local github_token=

    parse_command_line "$@"

    install_yaks
    cleanup_workspace
}

parse_command_line() {
    while :; do
        case "${1:-}" in
            -h|--help)
                show_help
                exit
                ;;
            -v|--version)
                if [[ -n "${2:-}" ]]; then
                    version="$2"
                    shift
                else
                    echo "ERROR: '-v|--version' cannot be empty." >&2
                    show_help
                    exit 1
                fi
                ;;
            --github-token)
                if [[ -n "${2:-}" ]]; then
                    github_token="$2"
                    shift
                else
                    echo "ERROR: '--github-token' cannot be empty." >&2
                    show_help
                    exit 1
                fi
                ;;
            *)
                break
                ;;
        esac

        shift
    done
}

install_yaks() {
    install_version=$version
    info=
    if [[ "$version" = "latest" ]]
    then
        if [[ -z "$github_token" ]]
        then
            install_version=$(curl --silent "https://api.github.com/repos/citrusframework/yaks/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        else
            install_version=$(curl -H "Authorization: $github_token" --silent "https://api.github.com/repos/citrusframework/yaks/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        fi
        info="=$install_version"
    fi

    if [[ "$version" = "nightly" ]]
    then
        if [[ -z "$github_token" ]]
        then
            install_version=$(curl --silent "https://api.github.com/repos/citrusframework/yaks/releases" | grep '"tag_name":' | head -1 | sed -E 's/.*"([^"]+)".*/\1/')
        else
            install_version=$(curl -H "Authorization: $github_token" --silent "https://api.github.com/repos/citrusframework/yaks/releases" | grep '"tag_name":' | head -1 | sed -E 's/.*"([^"]+)".*/\1/')
        fi
        info="=$install_version"
    fi

    if [[ "$version" == "nightly:"* ]]
    then
        install_version=$(echo $install_version | tr -d nightly:)
    fi

    os=$(get_os)
    binary_version=$(echo $install_version | tr -d v)

    echo "Loading citrusframework/yaks/releases/download/$install_version/yaks-$binary_version-$os-64bit.tar.gz"

    echo "Installing YAKS client version $version$info on $os..."

    curl -L --silent https://github.com/citrusframework/yaks/releases/download/$install_version/yaks-$binary_version-$os-64bit.tar.gz -o yaks.tar.gz
    mkdir -p _yaks
    tar -zxf yaks.tar.gz --directory ./_yaks

    if [[ "$os" = "windows" ]]
    then
        mkdir /yaks
        mv ./_yaks/yaks.exe /yaks/
        echo "/yaks" >> $GITHUB_PATH
    else
        sudo mv ./_yaks/yaks /usr/local/bin/
    fi

    echo "YAKS client installed successfully!"
}

cleanup_workspace() {
    if [[ -f "./yaks.tar.gz" ]]
    then
        rm yaks.tar.gz
    fi

    if [[ -d "./_yaks" ]]
    then
        rm -r _yaks
    fi
}

get_os() {
    osline="$(uname -s)"
    case "${osline}" in
        Linux*)     os=linux;;
        Darwin*)    os=mac;;
        CYGWIN*)    os=windows;;
        MINGW*)     os=windows;;
        Windows*)   os=windows;;
        *)          os="UNKNOWN:${osline}"
    esac
    echo ${os}
}

main "$@"
