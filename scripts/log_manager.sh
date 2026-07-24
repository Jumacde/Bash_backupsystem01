#!/bin/bash
# set log for test- and prod version
# get log path from .env 
ENV_FILE="$(dirname "$0")/.env"

# check and get log path
if [ -f "$ENV_FILE" ]; then
	export $(grep -v '^#' "$ENV_FILE" | xargs)
else
	echo "ERROR: .env file not found."
	exit 1 # if .env file not found end this script.
fi

log_dir=""

get_logdir() {
	# log dir for prod enviroment.
	if [ "${ENV}" = "prod" ]; then
		log_dir="${prod_log}"
	else
		# log dir to test enviroment.
		log_dir="${test_log}"
	fi
	# create a new directory for log file.
	mkdir -p "$(dirname "$log_dir")"
}

# add a method: allow to show detailed log data.
log_message() {
	local PRIORITY="${0##*/}"
	local message="$1"
	local status="$2"
	echo "$(TZ="Europe/Berlin" date  +"%d-%m-%Y %H:%M:%S") [${PRIORITY}] [${status}] -  ${message}" >> "${log_dir}"

}
