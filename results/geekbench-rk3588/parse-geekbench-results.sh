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
		Scores="$(grep " Score" ${file} | cut -c26- | tail -n8 | tr "\n" "|" | sed -e 's/  */ /g' -e 's/|/| /g')"
		GHz=$(grep Cluster ${file} | cut -c19- | tail -n1 | awk -F" " '{print $4}')
		[ "${GHz}" != "2.40" ] && GHz="*${GHz}*"
		GBURL="https://browser.geekbench.com/v5/cpu/${file%.*}"
		echo "| [\`${DeviceName}\`](${GBURL}) | ${GHz} | ${Governor} | ${Scores}"
	done
} # ParseScores

CompareMultiWithSingle() {
	echo "## RK3588(S) Geekbench scores, multi / single scores"
	echo "| Device | A76 GHz | Governor | Multi | Single | Total | Crypto | Int | FP |"
	echo "| ----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: |"

	ls *.txt | sort | while read file ; do
		DeviceName=$(sed -n 17p ${file} | sed 's/rockchip //' | sed 's/  */ /g')
		Governor=$(sed -n 39p ${file} | awk -F" " '{print $2}' | sed 's/  */ /g')
		Scores="$(grep " Score" ${file} | cut -c26- | tail -n8 | tr "\n" "|" | sed -e 's/  */ /g' -e 's/|/| /g')"
		TotalScores=$(LANG=C awk -F" " '{printf ("%0.3f",$9/$1); }' <<<"${Scores}")
		CryptoScores=$(LANG=C awk -F" " '{printf ("%0.3f",$11/$3); }' <<<"${Scores}")
		IntegerScores=$(LANG=C awk -F" " '{printf ("%0.3f",$13/$5); }' <<<"${Scores}")
		FloatingPointScores=$(LANG=C awk -F" " '{printf ("%0.3f",$15/$7); }' <<<"${Scores}")
		GHz=$(grep Cluster ${file} | cut -c19- | tail -n1 | awk -F" " '{print $4}')
		[ "${GHz}" != "2.40" ] && GHz="*${GHz}*"
		GBURL="https://browser.geekbench.com/v5/cpu/${file%.*}"
		echo "| [\`${DeviceName}\`](${GBURL}) | ${GHz} | ${Governor} | $(LANG=C awk -F" " '{print $9" | "$1}' <<<"${Scores}") | ${TotalScores} | ${CryptoScores} | ${IntegerScores} | ${FloatingPointScores} |"
	done
} # CompareMultiWithSingle

ParseCreepbenchResults >results.md
ParseScores >scores.md
CompareMultiWithSingle >multi-vs-single.md