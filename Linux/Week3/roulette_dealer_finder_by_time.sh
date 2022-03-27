#!/bin/bash

##################### Please run this script in the Dealer_Analysis directory #####################

# Commands that pass two arguments: date and time

cat Lucky_Duck_Investigations/Dealer_Schedules_0310/"$1"_Dealer_schedule | grep "$2"
