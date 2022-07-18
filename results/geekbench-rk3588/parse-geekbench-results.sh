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
		echo "| [\`${DeviceName}\`](${file}) (${UploadDate}) | ${GBVersion} | ${STScore} | ${MTScore} | ${Clusters} |"
	done
} # ParseCreepbenchResults

ParseCreepbenchResults >results.md