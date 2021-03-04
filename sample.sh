#!/bin/bash

#######################################
## 定義部
#######################################
readonly DATA_PATH="./data"
readonly BIN_PATH="./bin"
readonly JSON_PARSER="jq-win64.exe"

OPERATION_ARRAY=()
DESCRIPTION_ARRAY=()

#######################################
## 関数
#######################################
# Json parser
function parse_operation() {

    parser=$BIN_PATH/$JSON_PARSER
    data_file=`cat ${1}`

    json_length=`echo ${data_file} | $parser length`

    for i in `seq 0 $(expr ${json_length} - 1)`
    do
        OPERATION_ARRAY[${#OPERATION_ARRAY[@]}]=`echo ${data_file} | $parser -r .[${i}].operation`
        DESCRIPTION_ARRAY[${#DESCRIPTION_ARRAY[@]}]=`echo ${data_file} | $parser -r .[${i}].description`
    done
}

# 処理実行関数
function do_operation() {

    # TODO : 何か処理を実行
    local readonly message="Do something for $1 !"
    local readonly example="Run playbook etc..."

    echo ""
    echo "_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
    echo "   $message ($example)"
    echo "_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
    echo ""
}


#######################################
## Main処理
#######################################

# 処理一覧ファイルを解析
echo "Parcing operations...wait"
parse_operation $DATA_PATH/operations.json

if [ ${#OPERATION_ARRAY[@]} = 0 ]; then
    # 0要素の場合はおしまい
    echo "Data couldn't be found..."
    exit 1
fi

#######################################
# 処理部
#######################################
while true
do
    #######################################
    # リストから選択させる
    #######################################
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

        case "$ans" in
          [yY]*)
              break;;
          *)
              printf "%s\n" ------------------------
              continue;;
        esac
    done


    #######################################
    # 処理を実行
    #######################################
    do_operation $operation

    #######################################
    # 処理を続行するかを確認
    #######################################
    read -p "Need to do some more operations ? [y/N] : " ans

    case "$ans" in
      [yY]*)
          printf "\n"
          continue;;
      *)
          break;;
    esac

done

printf "\n%s" Finished...

