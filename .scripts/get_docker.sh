#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

get_docker() {
    Title="Install Docker"
    notice "Installing docker. Please be patient, this can take a while."
    if run_script 'question_prompt' Y "Would you like to display the command output?" "${Title}" "${VERBOSE:+Y}"; then
        if use_dialog_box; then
            command_get_docker |& dialog_pipe "${Title}" "Installing docker. Please be patient, this can take a while."
        else
            command_get_docker
        fi
    else
        command_get_docker > /dev/null 2>&1
    fi
}

command_get_docker() {
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

test_get_docker() {
    run_script 'remove_snap_docker'
    run_script 'get_docker'
    docker --version || fatal "Failed to determine docker version.\nFailing command: ${F[C]}docker --version"
    docker compose version || fatal "Failed to determine docker compose version.\nFailing command: ${F[C]}docker compose version"
}
