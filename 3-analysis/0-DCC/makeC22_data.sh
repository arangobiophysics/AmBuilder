#!/bin/bash

################
# 20220918
# Andres S. Arango
#

declare -a arr=("CHL.219" "CHL.243" "CHL.AMB" "CHL.EPI" "ERG.219" "ERG.243" "ERG.AMB" "ERG.EPI")

## now loop through the above array
for i in "${arr[@]}"
do
	vmd -dispdev text -e ./scrape_only_C22.tcl -args $i
done
#done
#done
