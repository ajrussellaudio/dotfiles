ipv4() {
    curl ipv4.icanhazip.com
}

ipv6() {
    curl ipv6.icanhazip.com
}

iplocal() {
    p_flag=''
    while getopts "p" flag; do
        case "$flag" in
            p) p_flag='true';;
            *) echo "Usage: iplocal [-p]"; return 1;;
        esac
    done
    for interface in $(ipconfig getiflist); do
        if [[ "$interface" != "lo0" ]]; then
            local ip=$(ipconfig getifaddr "$interface")
            if [[ -n "$ip" ]]; then
                if [[ "$p_flag" == 'true' ]]; then
                    echo "$ip"
                else
                    echo "$interface: $ip"
                fi
            fi
        fi
    done
}
