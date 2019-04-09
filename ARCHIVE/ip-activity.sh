#!/bin/bash

function Activity {
    echo -e "\n### Geolocation info:\n";
    GeoIpInfo "$1"
    echo -e "\n### WHOIS info:\n";
    timeout 5 WhoisInfo "$1" || echo "Whois lookup failed"
    logfiles=$(find /var/log/apache2/ -iname '*access*log*' -o -iname '*error*log*')
    logextract=$(for logfile in $logfiles; do
        zgrep --no-filename "$1" "$logfile";
        done) || true
    echo -e "\n#### Return codes:\n";
    echo "$logextract" | awk -F'"' '{print $3}' | awk -F" " '{print $1}' | sort | uniq -c | sort -nr
    echo -e "\n#### User agents:\n";
    echo "$logextract" | awk -F'"' '{print $6}' | sort | uniq -c | sort -nr
    echo -e "\n#### Visited URIs:\n";
    echo "$logextract" | awk -F'"' '{print $2}' | grep -E -v "\.png\|.css\|.ico|\.js|genthumbnail|createthumb" | sort | uniq -c | sort -nr
}

function GeoIpInfo {
    geoiplookup "$1" | grep -E -v "ASNum Edition"
}

function WhoisInfo {
    whois "$1" | grep -E -i '(^address|^netname|^city|^country)' | sort --uniq
}

Activity "$1"