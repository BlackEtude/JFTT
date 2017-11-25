#!/bin/bash

bison -d calc_bison.y -o calc_bison.c
flex -o calc_flex.c calc_flex.l
gcc calc_flex.c calc_bison.c -lm -lfl -o calc
./calc -t