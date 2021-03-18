#!/bin/bash

#######################################
## Global variable
#######################################
readonly DATA_PATH="./data"
readonly DATA_FILE="operations.json"

readonly BIN_PATH="./bin"
readonly JSON_PARSER="jq-win64.exe"

OPERATION_ARRAY=()
DESCRIPTION_ARRAY=()

#######################################
## Function
#######################################

# Json parser
function parse_operation() {

    local parser=$BIN_PATH/$JSON_PARSER
    local data_file=`cat $1`
    local json_length=`echo $data_file | $parser length`

    for i in `seq 0 $(expr $json_length - 1)`
    do
        OPERATION_ARRAY[${#OPERATION_ARRAY[@]}]=`echo $data_file | $parser -r .[$i].operation`
        DESCRIPTION_ARRAY[${#DESCRIPTION_ARRAY[@]}]=`echo $data_file | $parser -r .[$i].description`
    done
}

# Do operation
function do_operation() {

    # TODO : Do something
    local readonly message="Do something for $1 !"
    local readonly example="Run playbook etc..."

    echo ""
    echo "_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
    echo "   $message ($example)"
    echo "_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
    echo ""
}


#######################################
## Main Process
#######################################

# Parse input data file
echo "Parsing operations...wait"
parse_operation $DATA_PATH/$DATA_FILE

if [ ${#OPERATION_ARRAY[@]} = 0 ]; then
    # Quit program if source data is empty.
    echo "Data couldn't be found..."
    exit 1
fi

# Main loop
while true
do
    printf "%s\n" ------------------------

    while true
    do
        PS3="Select Operation : "
        select operation in ${OPERATION_ARRAY[*]}
        do
            case $REPLY in
                [1-${#OPERATION_ARRAY[@]}])
                    break;;
                *)
                    echo "Invalid! Try again."
                    ;;
            esac
        done

        printf "%s\n" "=================================================="
        printf "%s\n" "[Operation] $operation"
        printf "%s\n" "[Description] ${DESCRIPTION_ARRAY[$REPLY-1]}"
        printf "%s\n" "=================================================="
        read -p "Is this operation right ? [y/N] : " ans

        case $ans in
          [yY]*)
              break;;
          *)
              printf "%s\n" ------------------------
              continue;;
        esac
    done

    do_operation $operation

    # Confirm continue or not.
    read -p "Need to do some more operations ? [y/N] : " ans

    case $ans in
      [yY]*)
          printf "\n"
          continue;;
      *)
          break;;
    esac

done

printf "\n%s\n" Bye!

