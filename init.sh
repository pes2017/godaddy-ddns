#!/bin/bash

# This script is used to check and update your GoDaddy DNS server to the IP address of your current internet connection.
# Special thanks to mfox for his ps script
# https://github.com/markafox/GoDaddy_Powershell_DDNS
#
# First go to GoDaddy developer site to create a developer account and get your key and secret
#
# https://developer.godaddy.com/getstarted
# Be aware that there are 2 types of key and secret - one for the test server and one for the production server
# Get a key and secret for the production server
# 
#Update the first 4 variables with your information
 
domain="$DOMAIN"   # your domain
name="$NAME"     # name of A record to update
key="$KEY"      # key for godaddy developer API
secret="$SECRET"   # secret for godaddy developer API
ipDetectorEndpoint="$IP_DETECTOR_ENDPOINT" # any public ip echo service endpoint that returns JSON

headers="Authorization: sso-key $key:$secret"

#echo $headers

result=$(curl -s -X GET -H "$headers" \
 "https://api.godaddy.com/v1/domains/$domain/records/A/$name")

echo "$result"

dnsIp=$(echo $result | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
# echo "dnsIp:" $dnsIp

# Get public ip address there are several websites that can do this.
ret=$(curl -s GET "$ipDetectorEndpoint")
currentIp=$(echo $ret | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
echo "Found exist record for $NAME.$DOMAIN, detected dnsIp is $dnsIp, currentIp is $currentIp"

 if [ "$dnsIp" != "$currentIp" ];
 then
	echo "Updating $NAME.$DOMAIN with $currentIp"
#	echo "Ips are not equal"
	request='[{"data":"'$currentIp'","ttl":3600}]'
#	echo $request
	nresult=$(curl -i -s -X PUT \
 -H "$headers" \
 -H "Content-Type: application/json" \
 -d $request "https://api.godaddy.com/v1/domains/$domain/records/A/$name")
	echo $nresult
fi
