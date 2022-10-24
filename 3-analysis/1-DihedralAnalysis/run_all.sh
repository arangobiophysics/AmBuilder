#!/bin/bash

################
# 20221023
# Andres S. Arango
#
for DCD in {0..15}; do
for NUMBER in {1..125}; do
	/Scr/hyunpark/anaconda3/envs/deeplearning/bin/python -m dihedral_scan --residues $NUMBER --dcdnum $DCD --selection "C7 O5 C12 C10" --complex "CHL.AMB" --resname AMB     
done
done
