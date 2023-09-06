#!/bin/bash

# Nmap Tool - A simple script for running Nmap scans with different options

# Function to validate input file
validate_input_file() {
    if [ ! -f "$1" ]; then
        echo "Error: The input file '$1' does not exist."
        exit 1
    fi
}

# Main function
main() {
    parser() {
        local script_name="$0"
        cat <<EOF
Usage: $script_name [options] input_file

Options:
    -h, --help               Show this help message and exit
    -p, --port PORT          Specify a specific port to scan
    --fast-scan              Perform a fast scan
    --full-scan              Perform a full scan
    --full-scan-slower       Perform a slower full scan
    --ftp                    Perform a scanning port 21
    --ssh                    Perform a scanning port 22
    --telnet                 Perform a scanning port 23
    --smtp                   Perform a scanning port 25,465,587
    --dns                    Perform a scanning port 53
    --smb / --smb-brute      Perform a scanning port 139,445
    --snmp                   Perform a scanning port 161,162,10161,10162
    --mssql                  Perform a scanning port 1433
    --mysql                  Perform a scanning port 3306
    --rdp                    Perform a scanning port 3389
    --cassandra              Perform a scanning port 9042, 9160
    --port-specific PORT     Specify a specific port to scan (e.g., 21, 22, 23, etc.)

Example:
    $script_name --fast-scan input.txt
    $script_name --full-scan input.txt
    $script_name --port 80 input.txt
    $script_name --port-specific 22 input.txt
EOF
    }

    local input_file
    local port
    local fast_scan
    local full_scan
    local full_scan_slower
    local port_specific
    local ssh
    local ftp
    local telnet
    local smtp
    local dns
    local smb
    local smb_brute
    local snmp
    local mssql
    local mysql
    local rdp
    local cassandra

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                parser
                exit 0
                ;;
            -p|--port)
                port="$2"
                shift 2
                ;;
            --fast-scan)
                fast_scan=true
                shift
                ;;
            --full-scan)
                full_scan=true
                shift
                ;;
            --full-scan-slower)
                full_scan_slower=true
                shift
                ;;
            --ftp)
                ftp=true
                shift
                ;;
            --ssh)
                ssh=true
                shift
                ;;
            --telnet)
                telnet=true
                shift
                ;;
            --smtp)
                smtp=true
                shift
                ;;
            --dns)
                dns=true
                shift
                ;;
            --smb)
                smb=true
                shift
                ;;
            --smb-brute)
                smb_brute=true
                shift
                ;;
            --snmp)
                snmp=true
                shift
                ;;
            --mssql)
                mssql=true
                shift
                ;;
            --mysql)
                mysql=true
                shift
                ;;
            --rdp)
                rdp=true
                shift
                ;;
            --cassandra)
                cassandra=true
                shift
                ;;
            --port-specific)
                port_specific="$2"
                shift 2
                ;;
            *)
                input_file="$1"
                shift
                ;;
        esac
    done

    # Check if an input file is provided
    if [ -z "$input_file" ]; then
        echo "Error: Please provide an input file."
        parser
        exit 1
    fi

    # Validate the input file
    validate_input_file "$input_file"

    if [ "$fast_scan" = true ]; then
        command="sudo nmap -sV -sC -O -T4 -n -Pn -oA fastscan -iL $input_file -oN fastscan.txt -vv"
    elif [ "$full_scan" = true ]; then
        command="sudo nmap -sV -sC -O -T4 -n -Pn -p- -oA fullfastscan -iL $input_file -oN fullfastscan.txt -vv"
    elif [ "$full_scan_slower" = true ]; then
        command="sudo nmap -sV -sC -O -p- -n -Pn -oA fullscan -iL $input_file -oN fullscan.txt -vv"
    elif [ "$ftp" = true ]; then
        command="sudo nmap -sV -p21 -sC -A --script ftp-* -iL $input_file -oN ftp.txt -vv"
    elif [ "$ssh" = true ]; then
        command="sudo nmap -p22 -iL {file} -sC -sV --script ssh2-enum-algos --script ssh-hostkey --script-args ssh_hostkey=full --script ssh-auth-methods --script-args="ssh.user=root" -iL $input_file -oN ssh.txt -vv"
    elif [ "$telnet" = true ]; then
        command="sudo nmap -n -sV -Pn --script "'*telnet* and safe'" -p 23 -iL $input_file -oN telnet.txt -vv"
    elif [ "$smtp" = true ]; then
        command="sudo nmap --script=smtp-commands,smtp-enum-users,smtp-vuln-cve2010-4344,smtp-vuln-cve2011-1720,smtp-vuln-cve2011-1764 -p 25 -iL $input_file -oN smtp.txt -vv"
    elif [ "$dns" = true ]; then
        command="sudo nmap -n --script "'(default and *dns*) or fcrdns or dns-srv-enum or dns-random-txid or dns-random-srcport'" -iL $input_file -oN dns.txt -vv"
    elif [ "$smb" = true ]; then
        command="sudo nmap -p 139,445 -vv -Pn --script=smb-vuln-cve2009-3103.nse,smb-vuln-ms06-025.nse,smb-vuln-ms07-029.nse,smb-vuln-ms08-067.nse,smb-vuln-ms10-054.nse,smb-vuln-ms10-061.nse,smb-vuln-ms17-010.nse -iL $input_file -oN smb.txt -vv"
    elif [ "$smb_brute" = true ]; then
        command="sudo nmap --script smb-vuln* -Pn -p 139,445 -iL $input_file -oN smb_brute.txt -vv"
    elif [ "$snmp" = true ]; then
        command="sudo nmap --script "'snmp* and not snmp-brute'" -iL $input_file -oN snmp.txt -vv"
    elif [ "$mssql" = true ]; then
        command="sudo nmap --script ms-sql-info,ms-sql-empty-password,ms-sql-xp-cmdshell,ms-sql-config,ms-sql-ntlm-info,ms-sql-tables,ms-sql-hasdbaccess,ms-sql-dac,ms-sql-dump-hashes --script-args mssql.instance-port=1433,mssql.username=sa,mssql.password=,mssql.instance-name=MSSQLSERVER -sV -p 1433 -iL $input_file -oN mssql.txt -vv"
    elif [ "$mysql" = true ]; then
        command="sudo nmap --script=mysql-databases.nse,mysql-empty-password.nse,mysql-enum.nse,mysql-info.nse,mysql-variables.nse,mysql-vuln-cve2012-2122.nse -p 3306 -iL $input_file -oN mysql.txt -vv"
    elif [ "$rdp" = true ]; then
        command="sudo nmap --script "'rdp-enum-encryption or rdp-vuln-ms12-020 or rdp-ntlm-info'" -p 3389 -T4 -iL $input_file -oN rdp.txt -vv"
    elif [ "$cassandra" = true ]; then
        command="sudo nmap -sV --script cassandra-info -p 9042,9160 -iL $input_file -oN cassandra.txt -vv"
    elif [ -n "$port" ]; then
        command="sudo nmap -sC -sV -sS -p$port -iL $input_file -oN $port.txt -vv"
    elif [ -n "$port_specific" ]; then
        command="sudo nmap -sC -sV -sS -p$port_specific -iL $input_file -oN $port_specific.txt -vv"
    else
        echo "Error: Please specify a valid scan option."
        parser
        exit 1
    fi

    # Execute the Nmap command
    echo "Starting!!!"
    # echo "Running the following Nmap command:"
    # echo "$command"
    eval "$command"
}

main "$@"
