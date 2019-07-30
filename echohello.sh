#! /bin/bash

for col in $(seq 30 38);do
	echo -e "\033["$col"mHello!\033[0m"
done
