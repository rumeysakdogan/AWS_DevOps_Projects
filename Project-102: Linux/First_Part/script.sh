#!/bin/bash

cat event_history.csv | grep -i serdar | grep -i "terminateinstances" | grep -Eo "i-[a-z0-9]{17}" > result.txt

#another solution: grep -e "serdar.*Terminate*" event_history.csv | grep -o -e "i-[0-9a-f]\{17\}" > result.txt