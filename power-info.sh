#!/usr/bin/env bash

set -uo pipefail

# Colour table
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Info table
IDNUM=$(id -u)
RUNBY=$(whoami)
info1=$(date)

# Get battery info func
get_bat_info() {
BATNAME=$( upower -e | grep "battery_BAT" )
FULLBATINFO=$( upower -i "$BATNAME" )
}

# Parse info func
parse_bat_info() {
CAPACITY=$(echo "$FULLBATINFO" | grep "capacity:" | awk '{print $NF}')
#STATE=$(echo "$FULLBATINFO" | grep "state:" | awk '{print $NF}')
VENDOR=$(echo "$FULLBATINFO" | grep "vendor:" | awk '{print $NF}')
PERC=$(echo "$FULLBATINFO" | grep "percentage:" | awk '{print $NF}')
POWERSUP=$(echo "$FULLBATINFO" | grep "power supply:" | awk '{print $NF}')
TECH=$(echo "$FULLBATINFO" | grep "technology:" | awk '{print $NF}')
VOLTAGE=$(echo "$FULLBATINFO" | grep "voltage:" | awk '{print $(NF-1)}')
VOLTAGE_MIN=$(echo "$FULLBATINFO" | grep "voltage-min-design:" | awk '{print $(NF-1)}')
ENERGY_FULL=$(echo "$FULLBATINFO" | grep "energy-full:" | awk '{print $(NF-1)}')
ENERGY_FULL_DESIGN=$(echo "$FULLBATINFO" | grep "energy-full-design:" | awk '{print $(NF-1)}')
ENERGY_RATE=$(echo "$FULLBATINFO" | grep "energy-rate:" | awk '{print $(NF-1)}')
CAP_LEVEL=$(echo "$FULLBATINFO" | grep "capacity-level:" | awk '{print $NF}')
CYCLES=$(echo "$FULLBATINFO" | grep "charge-cycles:" | awk '{print $NF}')
#WARN=$(echo "$FULLBATINFO" | grep "warning-level:" | awk '{print $NF}')
}

get_bat_info
parse_bat_info

# Remove % from $PERC
PERC_NUM="${PERC%\%}"

# Make cap a whole number
CAPACITY_NUM="${CAPACITY%\%}"
CAPACITY_INT="${CAPACITY_NUM%%.*}"

banner(){
cat <<EOF
Battery-info-Printer
Started at: $info1
Script ran by: $RUNBY
ID Number: $IDNUM
<---info--->
EOF
}
main_info() {
echo -e "Vendor: $VENDOR" # User output one, Vendor info

# User output two, battery health / wear
if [[ $CAPACITY_INT -gt 80 ]]; then
    echo -e "Battery health: ${GREEN}$CAPACITY${NC}"
elif [[ $CAPACITY_INT -ge 60 ]]; then
    echo -e "Battery health: ${YELLOW}$CAPACITY${NC}"
else
    echo -e "Battery health: ${RED}$CAPACITY${NC}"
fi

# User output three, Power supply info
if [[ $POWERSUP == "yes" ]]; then
    echo -e "On power supply? ${GREEN}Yes${NC}"
else
    echo -e "${RED}Not on power supply${NC}"
fi

# User output four, Battery precenage info
if [[ $PERC_NUM -gt 75 ]]; then
    echo -e "Battery precentage:${GREEN} $PERC High battery...${NC}"
elif [[ $PERC_NUM -ge 50 ]]; then
    echo -e "Battery precentage:${YELLOW} $PERC Medium battery...${NC}"
else
        echo -e "Battery precentage:${RED} $PERC Low battery...${NC}"
fi
}

extened_info() {
cat <<EOF
Native device:       $BATNAME
Technology:          $TECH
Capacity level:      $CAP_LEVEL
Voltage:              $VOLTAGE V
Voltage (min):        $VOLTAGE_MIN V
Energy (full):         $ENERGY_FULL Wh
Energy (design):       $ENERGY_FULL_DESIGN Wh
Charge rate:           $ENERGY_RATE W
Charge cycles:          $CYCLES
EOF
}

# Main code start

cat <<EOF
Please choose your options:
1. Basic battery info
2. Extended battery info
3. Exit
EOF

read USERSELECTION

case $USERSELECTION in
    1)  banner
        main_info
        ;;
    2)  banner
        main_info
        extened_info
        ;;
    3) exit ;;
    *) echo "Option unknown" ;;
esac
