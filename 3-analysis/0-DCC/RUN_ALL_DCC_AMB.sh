#!/bin/bash

#This script runs a tweaked version of correlationplus

declare -a arr=("CHL.219" "CHL.243" "CHL.AMB" "CHL.EPI" "ERG.219" "ERG.243" "ERG.AMB" "ERG.EPI")

## now loop through the above array
for i in "${arr[@]}"
do
   echo "$i"
   # or do whatever with individual element of the array

correlationplus calculate -p /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/5-forpaper/$i.0/min/1.C22.pdb \
                          -f /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/5-forpaper/$i.0/min/1.eqnA.C22.dcd\
                                            -o test.$i.dat
done
