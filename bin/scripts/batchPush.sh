#! /bin/sh

set -e

# $1 -> branch name

if [ $# -lt 1 ]; then
	echo "Please provide branch name param to execute the script"
	exit 1
fi

BRANCH=$1

## Function declarations
pushToGithub() {
	echo "Pushing on Github to branch ${3}"
	echo "Running for indexes $1 -> $2"

	for (( i=$1; i<$2; i++)); do
		# echo "${file_array[$i]}"
		git add "${file_array[$i]}"
	done
	git commit -m "Automated commit"
	git push -u origin $3
}

ls -lrt

echo "Current Directory"
pwd

echo "Running GIT-STATUS"
git status

echo "Fetching list of files can be commited"
git ls-files -m -o --exclude-from=.gitignore > files_list.txt

while read -r line || [[ $line ]]; do
    file_array+=("$line")
done < files_list.txt

echo "${#file_array[@]}"
len=${#file_array[@]}

echo "##Pushing files in batches of 50 files per push"

# echo "${file_array[@]:0:10}"

for (( i=0; i<$len; i=i+10 )); do
	target=$((i+10))
	pushToGithub $i $target $BRANCH 
done

echo "Script execution completed"