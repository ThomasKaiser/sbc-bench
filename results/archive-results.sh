#!/bin/bash
#
# Archive sbc-bench results (just in case ix.io disappears).
# To be executed from results dir.

grep "| \[http://ix.io" ../Results.md | awk -F"http://" '{print $2}' | sed 's/](//' | while read ; do
	ResultFile="${REPLY##*/}.txt"
	if [ -f "${ResultFile}" ]; then
		grep -q "^tinymembench" "${ResultFile}" || (wget -q -O "${ResultFile}" "http://${REPLY}" ; sleep 5)
	else
		wget -O "${ResultFile}" "http://${REPLY}"
		sleep 5
	fi
done