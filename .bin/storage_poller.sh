#!/bin/bash


getNumberOfDrives() {
        exclude=("Virtual Memory" "Physical Memory")
        allDrives=$(snmpbulkwalk -v 2c -c public 10.0.0.108 1.3.6.1.2.1.25.2.3.1.3 2>/dev/null)
        for exclusion in "${exclude[@]}"; do
                allDrives=$( echo "$allDrives" | sed "/${exclusion}/d" )
        done
        numberOfDrives=$(echo "$allDrives" | wc -l)
        echo "Number of Drives: $numberOfDrives"
}
main() {
        getNumberOfDrives
}
main
