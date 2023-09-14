#!/bin/bash

regions_file="regions.txt"

IFS=$'\n' read -d '' -r -a regions < "$regions_file"

for region in "${regions[@]}"; do
    echo "Processing region: $region"
    
    # Get a list of all VPC IDs in the current region
    vpc_ids=$(aws ec2 describe-vpcs --region "$region" --query "Vpcs[].VpcId" --output text)

    # Loop through each VPC ID and delete it
    for vpc_id in $vpc_ids; do
        echo "Deleting VPC: $vpc_id"
        
        # Delete all associated resources before deleting the VPC
        aws ec2 delete-vpc --region "$region" --vpc-id "$vpc_id"
    done
done
