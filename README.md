# NMAPSENTINEL

Created by MarmutHandsome

Version 1.0



### Nmap Tool

Nmap Tool is a Bash script that simplifies the process of running Nmap scans with various options. It allows you to perform different types of scans on a list of target IPs/hosts by specifying command-line options.

#### Features

- Perform fast scans, full scans, and custom scans with ease.
- Scan specific ports, services, or protocols.
- Automate common scanning tasks for services like FTP, SSH, Telnet, SMTP, DNS, SMB, SNMP, MSSQL, MySQL, RDP, Cassandra, and more.
- Easily customize your scan parameters using command-line options.
- Generate detailed output files for each scan.

#### Usage

```bash
./nmap_tool.sh [options] input_file [output_directory]

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
    -o, --output OUTPUT      Specify the custom output file name

Example:
    ./nmapsentinel.sh --fast-scan input.txt
    ./nmapsentinel.sh --full-scan input.txt
    ./nmapsentinel.sh --port 80 input.txt
    ./nmapsentinel.sh --port-specific 22 input.txt -o custom_output.txt
```

#### Prerequisites

- Nmap should be installed on your system.
- Ensure you have permission to run Nmap commands with sudo.

#### Installation

1. Clone or download this repository to your local machine.

```bash
git clone https://github.com/nieshakenzie/nmapsentinel.git
```

2. Make the script executable:

```bash
chmod +x nmapsentinel.sh
```

#### Contributing

Contributions are welcome! If you have suggestions, feature requests, or bug reports, please open an issue or create a pull request.
