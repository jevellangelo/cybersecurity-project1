#!/bin/bash


if [[ $3 == "Blackjack" || $3 == "blackjack" ]]; then
	cat Lucky_Duck_Investigations/Dealer_Schedules_0310/"$1"_Dealer_schedule | grep "$2" | awk '{print $3,$4}'
elif [[ $3 == "Roulette" || $3 == "roulette" ]]; then
	cat Lucky_Duck_Investigations/Dealer_Schedules_0310/"$1"_Dealer_schedule | grep "$2" | awk '{print $5,$6}'
elif [[ $3 == "Texas Hold EM" || $3 == "texas hold em" || $3 == "poker" ]]; then
	cat Lucky_Duck_Investigations/Dealer_Schedules_0310/"$1"_Dealer_schedule | grep "$2" | awk '{print $7,$8}'
fi
