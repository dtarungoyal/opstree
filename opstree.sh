#!/bin/bash

yum install docker &>/dev/null
systemctl start docker &>/dev/null
systemctl enable docker &>/dev/null

docker swarm init &>/dev/null

while IFS=, read -r field1 field2 field3 field4 field5  #reads the column value from csv file

do

    echo "Imagee use in container:$field1 , Number of replicas:$field2 , Health parameter $field3 , Listening Port:$field4 , Expose_port:$field5"

#docker service command work with the swarm mode and it will make sure the no. of replicas always up
#and running. It is self healing the container.
#--replica value scale the deployment 


    docker service create --replicas $field2 --health-cmd "curl $field3 || exit 1" --health-interval=5s --health-timeout=10s --health-retries=3 -p $field5:$field4 --name opstree $field1


done < input.csv  # input.csv is the file where we give the input parametes
