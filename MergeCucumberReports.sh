temp_dir="${WORKSPACE}/reports"
echo $temp_dir                                                                             
createDirectory() {
    if [ ! -d "$temp_dir" ]
        then
       mkdir -p "$temp_dir"
        echo "******Created directory*******$temp_dir"
    fi
}

if [ -d "$temp_dir" ]; then
   echo "removing existing directory ($temp_dir) and creating a new one"
    rm -rf "$temp_dir"
	createDirectory
    #chmod -R 777 "$temp_dir"
	
else
	createDirectory
    #chmod -R 777 "$temp_dir"
	echo "($temp_dir) does not exist...creating a new one"
fi


string=$String_parameter
set -f                      # avoid globbing (expansion of *).
files_1=(${string//,/ })
total_1=0
total_1=${#files_1[*]}
echo $total_1


for (( i=0; i<=$(( $total_1 - 1 )); i++ ))
	do
    	build_dir="/var/lib/jenkins/jobs/folder/jobs/${files_1[$i]}/nextBuildNumber"
		buildnumber=$(($(ssh jenkins@1.1.1.1 "cat $build_dir") - 1))
        source="/var/lib/jenkins/jobs/folder/jobs/${files_1[$i]}/builds/${buildnumber}/cucumber-html-reports/.cache/target/cucumber/report.json"
		destination="$temp_dir/${files_1[$i]}.json"
		echo condition 1
		scp jenkins@1.1.1.1:$source $destination
	done
