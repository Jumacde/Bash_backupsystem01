#!/bin/bash
source "$(dirname "$0")/log_manager.sh"
source "$(dirname "$0")/device_manager.sh"

main() {
	get_logdir
	check_mount
	start_backup

}
main
