#!/bin/bash

# Step 1: Investigation Preparation

# Begin by making a single directory titled Lucky_Duck_Investigations
mkdir Lucky_Duck_Investigations

# Create directory for this specific investigation
mkdir Lucky_Duck_Investigations/Roulette_Loss_Investigation

# Create subdirectories
mkdir Lucky_Duck_Investigations/Roulette_Loss_Investigation/Player_Analysis 
mkdir Lucky_Duck_Investigations/Roulette_Loss_Investigation/Dealer_Analysis 
mkdir Lucky_Duck_Investigations/Roulette_Loss_Investigation/Player_Dealer_Correlation

# Create Notes for each subdirectory
touch Lucky_Duck_Investigations/Roulette_Loss_Investigation/Player_Analysis/Notes_Player_Analysis
touch Lucky_Duck_Investigations/Roulette_Loss_Investigation/Dealer_Analysis/Notes_Dealer_Analysis
touch Lucky_Duck_Investigations/Roulette_Loss_Investigation/Player_Dealer_Correlation/Notes_Player_Dealer_Correlation

######################################################################################################################

# Step 2: Gathering Evidence

# Move evidence from specific days that Lucky Duck experienced heavy losses at the roulette table
cd Lucky_Duck_Investigations && wget "https://tinyurl.com/3-HW-setup-evidence" && chmod +x ./3-HW-setup-evidence && ./3-HW-setup-evidence

# Create loss day array
declare -a days=(0310 0312 0315)

# Move the schedules and player data to the Dealer_Analysis and Player_Analysis
for i in "${days[@]}"
do
	cp Dealer_Schedules_0310/"$i"_Dealer_schedule Roulette_Loss_Investigation/Dealer_Analysis
	cp Roulette_Player_WinLoss_0310/"$i"_win_loss_player_data Roulette_Loss_Investigation/Player_Analysis
done

#### Complete the player analysis
cd Roulette_Loss_Investigation/Player_Analysis

# Use grep to isolate all of the losses that occurred on March 10, 12, and 15.
cat *data | grep '-' > Roulette_Losses

# Record in the Notes_Player_Analysis file:

# The times the losses occurred on each day.
cat Roulette_Losses | awk -F' ' '{print $1,$2}' > Notes_Player_Analysis

# If there is a certain player that was playing during each of those times.
cat Roulette_Losses | awk '{$1=$2=$3=""; print $0}' | grep -o 'Mylie Schmidt' | uniq >> Notes_Player_Analysis

# The total count of times this player was playing. 
cat Roulette_Losses | awk '{$1=$2=$3=""; print $0}' | grep 'Mylie Schmidt' | wc -l >> Notes_Player_Analysis

#### Complete the dealer analysis.
cd ../Dealer_Analysis

# Isolate time from loss days in win/loss player data
for i in "${days[@]}"
do
	cat ../Player_Analysis/"$i"_win_loss_player_data | grep - | awk -F' ' '{print $1,$2}' > "$i"_loss_days
done

# Use the times found above to determine the roulette dealer for those days
for i in "${days[@]}"
do
	tail -24 "$i"_Dealer_schedule | awk -F' ' '{print $1,$2,$5,$6}' | grep -f "$i"_loss_days >> Dealers_working_during_losses
done

# The primary dealer working at the times where losses occured
cat Dealers_working_during_losses | awk '{print $3,$4}' | uniq >> Notes_Dealer_Analysis

# How many times the dealer worked when major losses occured > $100,000
cat ../Player_Analysis/*_win_loss_player_data | grep - | awk '{print $3}' | sed 's/-\$//' | sed 's/,//' | awk '$1>100000{c++} END{print c+0}' >> Notes_Dealer_Analysis


####################################################################################################

# Move Notes and Evidence files to Lucky_Duck_Investigations directory
mv Dealers_working_during_losses ../../../
mv Notes_Dealer_Analysis ../../../
mv ../Player_Analysis/Roulette_Losses ../../../
mv ../Player_Analysis/Notes_Player_Analysis ../../../

# Complete the player/employee correlation
cat <<EOF > ../Player_Dealer_Correlation/Notes_Player_Dealer_Correlation
The analysis of the player win/loss data showed that there was one player that played everyday during a loss.
The player's name was Mylie Schmidt and she played a total of 13 days.

The analysis of the dealer schedule data showed that there was one roulette dealer that managed the table 
during a loss. The dealer's name was Billy Jones. Any day that the casino incurred losses on the roulette
table, Billy Jones was the dealer. 

Based on that information, it is highly plausible that Billy Jones and Mylie Schmidt are colluding to scam 
Lucky Duck out of thousands of dollars.
EOF

cd .. && mv Player_Dealer_Correlation/Notes_Player_Dealer_Correlation ../../
