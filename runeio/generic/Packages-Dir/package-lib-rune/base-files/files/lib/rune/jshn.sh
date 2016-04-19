
jshn_append_json_struct () {

        msg01D=`jshn -r "${1}"`
        msg02D=`jshn -r "${2}" | tail -n +2`
        msg0D=`echo -e "${msg01D}\n${msg02D}\n"`
        eval "$msg0D"
}

