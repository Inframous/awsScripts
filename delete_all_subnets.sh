#!/bin/bash

regions_file="regions.txt"

IFS=$'\n' read -d '' -r -a regions < "$regions_file"


for region in "${regions[@]}"; do
    echo "Processing region: $region"
    
    # Get a list of all Subnet IDs in the current region
    subnet_ids=$(aws ec2 describe-subnets --region "$region" --query "Subnets[].SubnetId" --output text)

    # Loop through each Subnet ID and delete it
    for subnet_id in $subnet_ids; do
        echo "Deleting Subnet: $subnet_id"
        
        # Delete the Subnet
        aws ec2 delete-subnet --region "$region" --subnet-id "$subnet_id"
    done
done
