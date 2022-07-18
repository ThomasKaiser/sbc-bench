#!/bin/bash

ParseCreepbenchResults() {
	echo "| Device | Version | Single | Multi | Clusters |"
	echo "| ----: | :----: | :----: | :----: | :---- |"

	ls *.txt | sort | while read file ; do
		DeviceName=$(sed -n 17p ${file} | sed 's/rockchip //' | sed 's/  */ /g')
		STScore=$(sed -n 21p ${file})
		MTScore=$(sed -n 23p ${file})
		Clusters="$(grep Cluster ${file} | cut -c19- | tr "\n" "/" | sed -e 's/\ \ \ \//\ \/ /g' -e 's/\/\ $//')"
		GBVersion=$(sed -n 25p ${file} | awk -F" " '{print $2}')
		UploadDate=$(sed -n 29p ${file} | awk -F" " '{print $4" "$5" "$6}')
		GBURL="https://browser.geekbench.com/v5/cpu/${file%.*}"
		echo "| [\`${DeviceName}\`](${GBURL}) (${UploadDate}) | ${GBVersion} | ${STScore} | ${MTScore} | ${Clusters} |"
	done
} # ParseCreepbenchResults

ParseScores() {
	echo "## RK3588(S) Geekbench scores, on the left single scores, on the right multi"
	echo "| Device | A76 GHz | Governor | Total | Crypto | Int | FP | Total | Crypto | Int | FP |"
	echo "| ----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: |"

	ls *.txt | sort | while read file ; do
		DeviceName=$(sed -n 17p ${file} | sed 's/rockchip //' | sed 's/  */ /g')
		Governor=$(sed -n 39p ${file} | awk -F" " '{print $2}' | sed 's/  */ /g')
		Scores="$(grep " Score" ${file} | cut -c26- | tail -n8 | tr "\n" "|" | sed 's/  */ /g')"
		GHz=$(grep Cluster ${file} | cut -c19- | tail -n1 | awk -F" " '{print $4}')
		GBURL="https://browser.geekbench.com/v5/cpu/${file%.*}"
		echo "| [\`${DeviceName}\`](${GBURL}) | ${GHz} | ${Governor} | ${Scores}"
	done
} # ParseScores

ParseCreepbenchResults >results.md
ParseScores >scores.md