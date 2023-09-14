#!/bin/bash

regions_file="regions.txt"

IFS=$'\n' read -d '' -r -a regions < "$regions_file"


for region in "${regions[@]}"; do
    echo "Processing region: $region"
    
    # Get a list of all security group IDs in the current region
    group_ids=$(aws ec2 describe-security-groups --region "$region" --query "SecurityGroups[].GroupId" --output text)

    # Loop through each security group ID and delete it
    for group_id in $group_ids; do
        echo "Deleting Security Group: $group_id"
        aws ec2 delete-security-group --region "$region" --group-id "$group_id"
    done
done
