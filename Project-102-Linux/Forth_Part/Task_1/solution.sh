sed -i "s/ec2-private_ip/$(grep -i "privateipaddress" info.json | head -1 | cut -d'"' -f4)/g" terraform.tf

# $(grep -i "privateipaddress" info.json | head -1 | cut -d'"' -f4) : this part will get the Private_IP_Address of EC-2 and store it as a variable 
