#!/bin/bash
source "$(dirname "$0")/log_manager.sh"
ENV_FILE="$(dirname "$0")/.env"

# check exist of the .env file.
if [ -f "$ENV_FILE" ]; then
        export $(grep -v '^#' "$ENV_FILE" | xargs)
	#set -a
	#source "$ENV_FILE"
	#set +a
else
        echo "ERROR: .env file not found."
        exit 1 # if .env file not found end this script.
fi

# directory path of backup data 
src_dir="${backup_dir}"
# option setting of target_dir
#OPTION_DIR="${OP_DIR[@]}"
OPTION_DIR=(${OPTION_DIR//:/ })

# directory path of back up devices
target_dir1="${device_dir1}"
target_dir2="${device_dir2}"
# to get the result of function
mount_result=""

check_mount() {
	# first set status of both devices are deactive
	local mount1=0
	local mount2=0
	# chck mount status both devices
	#
	[[ -d "$(dirname "$target_dir1")" ]] && mount1=1
        [[ -d "$(dirname "$target_dir2")" ]] && mount2=1
	case "${mount1}${mount2}" in
		# if both devices are mounted.
		"11")	
			# create back up directory both devices if they exist not.
			mkdir -p "$target_dir1"
        		mkdir -p "$target_dir2"
			log_message "SUCCESS" "${target_dir1} and ${target_dir2} are mounted."
                        echo "SUCCESS"
                        ;;
		# if only device1 is mounted
		"10")	
			# create back up dorectory only for device1
			mkdir -p "$target_dir1"
			log_message "WARN" "only ${target_dir1} is mounted."
                        echo "WARN1"
                        ;;
		# if only device2 is mounted
		"01")
			# create back up dorectory only for device2
			mkdir -p "$target_dir2"
			log_message "WARN" "only ${target_dir2} is mounted."
                        echo "WARN2"
                        ;;
		# if both devices are not mounted
		"00") 
			log_message "FAILD" "both devices are not mounted."
                        echo "FAILED"
                        ;;
	esac
}

start_backup() {
	mount_result=$(check_mount)
	case "$mount_result" in
		# start back up system to both devices
		"SUCCESS")
			for sub in "${OPTION_DIR[@]}" ; do
			# delete old copied data and send only new data. 
                        	rsync -av --delete "${src_dir}${sub}" "${target_dir1}${sub}" >> "$log_dir" 2>&1
                        	rsync -av --delete "${src_dir}${sub}" "${target_dir2}${sub}" >> "$log_dir" 2>&1
			done
                        log_message "SUCCESS" "backup process to both devices is successfully finished."
                        exit 0
                        ;;

		# start back up system to device1
		"WARN1")
			for sub in "${OPTION_DIR[@]}" ; do
				rsync -av --delete "${src_dir}${sub}" "${target_dir1}${sub}" >> "$log_dir" 2>&1
			done
                        log_message "SUCCESS" "backup process to ${target_dir1} is successfully finished."
                        exit 0
                        ;;
		# start back up system to device2
		"WARN2")
			mkdir -p "$target_dir2"

                        for sub in "${OPTION_DIR[@]}" ; do
				rsync -av --delete "${src_dir}${sub}" "${target_dir2}${sub}" >> "$log_dir" 2>&1
			done
                        log_message "SUCCESS" "backup process to ${target_dir2} is successfully finished."
                        exit 0
                        ;;
		# no device can be sand back updata. then exit this program.
		"FAILED")
			exit 1
			;;
	esac
}

