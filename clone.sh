#!/bin/bash

if [ -z "$1" ]
then
    echo Usage: sh clone.sh drupal_directory
    exit 0
fi




drupal=$1

# Core
if [ ! -d "$drupal" ]
then
    git clone --recursive -b 7.x http://git.drupal.org/project/drupal.git $drupal
    if [ ! -d "$drupal" ]; then
        echo Drupal directory $drupal does not exist
        exit 0
    fi
    echo "sites/all" >> $drupal/.gitignore
    cd $drupal
    git add .gitignore
    git commit -m 'Updating .gitignore'
    cd ..
else
    echo Drupal directory $drupal exists.
fi


# Modules
DIR="$( dirname "${BASH_SOURCE[0]}" )"
filecontent=( `cat "$DIR/modules.txt"` )
for module in "${filecontent[@]}"
do
    if [ -n "$module" ]
    then

        # Check if branch is specified
        if [[ "$t" =~ : ]]
        then
            arr=$(echo $t | tr ":" "\n")
            arr=( `echo $arr` ) # Somehow $arr does not get splited properly on my iMac without this
            module=${arr[0]}
            branch=${arr[1]}
        else
            module=$t
            branch=7.x-1.x
        fi

        if [ -d "$drupal/sites/all/modules/$module" ]
        then
            echo Module directory $module exists
        else
            git clone --recursive -b $branch http://git.drupal.org/project/$module.git $drupal/sites/all/modules/$module
        fi
    fi
done


# Theme
if [ -d "$drupal/sites/all/themes/omega" ]
then
    echo Theme directory omega exists
else
    git clone --recursive http://git.drupal.org/project/omega.git $drupal/sites/all/themes/omega
fi

