#!/bin/bash

regions_file="regions.txt"

IFS=$'\n' read -d '' -r -a regions < "$regions_file"


for region in "${regions[@]}"; do
    echo "Processing region: $region"
    
    # Get a list of all Internet Gateway IDs in the current region
    igw_ids=$(aws ec2 describe-internet-gateways --region "$region" --query "InternetGateways[].InternetGatewayId" --output text)

    # Loop through each Internet Gateway ID and delete it
    for igw_id in $igw_ids; do
        echo "Detaching and deleting Internet Gateway: $igw_id"
        
        # Detach the Internet Gateway from any VPCs before deleting it
        aws ec2 detach-internet-gateway --region "$region" --internet-gateway-id "$igw_id" --vpc-id "$(aws ec2 describe-internet-gateways --region "$region" --internet-gateway-ids "$igw_id" --query "InternetGateways[].Attachments[].VpcId" --output text)"
        
        # Delete the Internet Gateway
        aws ec2 delete-internet-gateway --region "$region" --internet-gateway-id "$igw_id"
    done
done
