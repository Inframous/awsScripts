# AWS Mess

These are a bunch of bash scripts that aim to delete dangling AWS Resources.
The scripts are pretty self explanatory, the name implies the script's function.
Mind you this only covers: VPCs, Internet Gateways, Subnets and Security Groups.
(Might be updated to handle clusters and EC2 instances in the future.)

#### Use:
Fill in the `regions.txt` file separating each region with a new line i.e
```code
us-east-1
us-west-2
```
You can run `search_dangling_resources.sh` to look for ALL resources in your `region.txt` file.
Then either run `DELETE_ALL_AWS.sh` or choose the 'resource-destroyer' of your choice.

#### Requirements:
- bash/zsh terminal
- AWS cli configured with credentials (that allow the manipulation the above mentioned resources).