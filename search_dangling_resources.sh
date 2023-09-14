#!/bin/bash

regions_file="regions.txt"

IFS=$'\n' read -d '' -r -a regions < "$regions_file"


for region in "${regions[@]}"; do
    echo "Processing region: $region"
    
    echo "Instances:"
    aws ec2 describe-instances --region "$region" --query "Reservations[].Instances[].[InstanceId, InstanceType, State.Name]" --output table

    echo "Security Groups:"
    aws ec2 describe-security-groups --region "$region" --query "SecurityGroups[].[GroupId, GroupName]" --output table

    echo "VPCs:"
    aws ec2 describe-vpcs --region "$region" --query "Vpcs[].VpcId" --output table

    echo "Internet Gateways:"
    aws ec2 describe-internet-gateways --region "$region" --query "InternetGateways[].InternetGatewayId" --output table

    echo "Subnets:"
    aws ec2 describe-subnets --region "$region" --query "Subnets[].SubnetId" --output table

    echo "--------------------------------------"
done
