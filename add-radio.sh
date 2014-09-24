#!/bin/bash
set -e
source /usr/lib/elive-tools/functions


main(){
    # pre {{{
    local name count radio_name_id radio_domain file

    count=0
    # }}}

    echo -e "1) Sky.fm (radiotunes)"
    echo -e "2) Di.fm  (digitally imported)"

    read -N1 option

    echo ""
    echo -e "radio ID name for url?"
    read radio_name_id

    echo -e "Pretty Name?"
    read radio_name_pretty
    file="tree/usr/share/elive-demo-files-skel/Music/${radio_name_pretty}.pls"

    case $option in
        1)
            radio_domain="radiotunes.com:80/"
            radio_name_id="radiotunes_$radio_name_id"
            radio_name_pretty="RadioTunes - ${radio_name_pretty}"
            ;;
        2)
            radio_domain="di.fm:80/"
            radio_name_id="di_${radio_name_id}"
            radio_name_pretty="Digitally Imported - ${radio_name_pretty}"
            ;;
        *)
            echo -e "E: wrong option"
            exit 1
            ;;
    esac

    mplayer "http://pub1.${radio_domain}/${radio_name_id}"

    if ! el_confirm "Continue?" ; then
        exit
    fi

    rm -f "$file"

    echo "[playlist]" >> "$file"
    echo "NumberOfEntries=9" >> "$file"

    while [ "$count" -lt 9 ] ; do
        count="$(( $count + 1 ))"

        echo "File${count}=http://pub${count}.${radio_domain}/${radio_name_id}" >> "$file"
        echo "Title${count}=${radio_name_pretty}" >> "$file"
        echo "Lenght${count}=-1" >> "$file"
    done
}

#
#  MAIN
#
main "$@"

# vim: set foldmethod=marker :
