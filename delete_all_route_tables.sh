#!/bin/bash

regions_file="regions.txt"

IFS=$'\n' read -d '' -r -a regions < "$regions_file"


for region in "${regions[@]}"; do
    echo "Processing region: $region"
    
    # Get a list of all Route Table IDs in the current region
    route_table_ids=$(aws ec2 describe-route-tables --region "$region" --query "RouteTables[].RouteTableId" --output text)

    # Loop through each Route Table ID and delete it
    for route_table_id in $route_table_ids; do
        echo "Deleting Route Table: $route_table_id"
        
        # Delete the Route Table
        aws ec2 delete-route-table --region "$region" --route-table-id "$route_table_id"
    done
done
