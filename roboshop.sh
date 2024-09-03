#!/bin/bash

instance=("web" "catalogue" "mongodb" "user" "cart" "redis" "rabbitmq" "payment" "shipping" "mysql" "cart" "dispatch")

AMI_ID=
SECURITY_GROUP_ID=
ZONE_ID=
DOMAIN=

for i in {$instance[@]}
do
    if [ $i == mongodb ] || [ $i == mysql ] || [ $i == shipping ]
    then 
       INSTANCE_TYPE="t2.medium"
    else   
       INSTANCE_TYPE="t2.micro"
    fi  

    IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=Instance-$i}]" --query 'instances[0].privateIPadderss' --output text)


    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
   {
    "Comment": "Testing creating a record set"
    ,"Changes": [{
      "Action"              : "CREATE"
      ,"ResourceRecordSet"  : {
        "Name"              : "'$i'.'$DOMAIN'"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "'$IP_ADDRESS'"
        }]
      }
    }]
   }
   '

done