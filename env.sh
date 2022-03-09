#!/bin/bash

export PKR_VAR_vcenter_username=$(op get item "vcenter.balmerfamilyfarm.com - sso" --fields username,password | jq -r '.username')
export PKR_VAR_vcenter_password=$(op get item "vcenter.balmerfamilyfarm.com - sso" --fields username,password | jq -r '.password')
