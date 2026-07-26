# Bash_backupsystem01
backup data system.
edit this program from the project external_device02.
whats differents?
1. target directories of backup data.  
  some data(/home/users/) are sand to other devices.
      whats i planed
      case1: set each directory in the .env file.
      ex)  
       backup_dir1=/home/users/A
       backup_dir2=/home/users/B
       backup_dir3=/home/users/C
        ==> not move forward with this idea.
          cause number of code can be too huge.
      case2: separate the basic directory path (/home/users) and each directory include backup date(/A, /B, /C).
      - .env: set a optional_targetdir "OP_DIR"
          OP_DIR=(A B C)
      - divecie_manager.sh 
          OPTION_DIR="${OP_DIR[@]}"
          i tried first call all directories inclde backup date using by @.
        => faild.
        
      case3: edit case2. i tried then using by separate with : 
          - .env:
            OP_DIR="src/":".local/bin/":"Documents/"
          - .device_manager.sh
          OPTION_DIR=(${OPTION_DIR//:/ })
        == > success.
          





 
