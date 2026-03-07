#!/bin/bash

# Makoctl helper for Waybar notification module
icon=""  # Bell icon
cmd="${1:-}"  # default empty if not passed

# Count active notifications
count=$(makoctl list | wc -l)

if [[ "$cmd" == "menu" ]]; then
    # Show menu of active notifications
    notifications=$(makoctl list | awk -F'|' '{print $1 ": " $2 " - " $3}')
    
    # Add dismiss options at the top
    options="Dismiss All\nDismiss Last\n$notifications"

    selected=$(echo -e "$options" | omarchy-launch-walker -p "Notifications" -width 40)

    if [[ -n "$selected" ]]; then
        case "$selected" in
            "Dismiss All") makoctl dismiss -a ;;
            "Dismiss Last") makoctl dismiss ;;
            *) id=$(echo "$selected" | awk -F':' '{print $1}')
               makoctl invoke -n "$id" ;;
        esac
    fi
else
    # Default: output icon + count
    echo "$icon $count"
fi
