#!/bin/bash

regions_file="regions.txt"

# Read regions from the file into the regions array
IFS=$'\n' read -d '' -r -a regions < "$regions_file"

for region in "${regions[@]}"; do
    echo "Processing region: $region"
    
    # Delete Subnets
    subnet_ids=$(aws ec2 describe-subnets --region "$region" --query "Subnets[].SubnetId" --output text)
    for subnet_id in $subnet_ids; do
        aws ec2 delete-subnet --region "$region" --subnet-id "$subnet_id"
    done
    
    # Delete Route Tables
    route_table_ids=$(aws ec2 describe-route-tables --region "$region" --query "RouteTables[].RouteTableId" --output text)
    for route_table_id in $route_table_ids; do
        aws ec2 delete-route-table --region "$region" --route-table-id "$route_table_id"
    done
    
    # Detach and Delete Internet Gateways
    igw_ids=$(aws ec2 describe-internet-gateways --region "$region" --query "InternetGateways[].InternetGatewayId" --output text)
    for igw_id in $igw_ids; do
        vpc_id=$(aws ec2 describe-internet-gateways --region "$region" --internet-gateway-ids "$igw_id" --query "InternetGateways[].Attachments[].VpcId" --output text)
        if [ -n "$vpc_id" ]; then
            aws ec2 detach-internet-gateway --region "$region" --internet-gateway-id "$igw_id" --vpc-id "$vpc_id"
        fi
        aws ec2 delete-internet-gateway --region "$region" --internet-gateway-id "$igw_id"
    done

    # Delete Security Groups
    security_group_ids=$(aws ec2 describe-security-groups --region "$region" --query "SecurityGroups[].GroupId" --output text)
    for security_group_id in $security_group_ids; do
        aws ec2 delete-security-group --region "$region" --group-id "$security_group_id"
    done

    # Delete VPCs
    vpc_ids=$(aws ec2 describe-vpcs --region "$region" --query "Vpcs[].VpcId" --output text)
    for vpc_id in $vpc_ids; do
        aws ec2 delete-vpc --region "$region" --vpc-id "$vpc_id"
    done

    echo "--------------------------------------"
done
