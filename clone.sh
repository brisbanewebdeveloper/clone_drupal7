#!/bin/bash

if [ -z "$1" ]
then
    echo Usage: sh clone.sh drupal_directory
    exit 0
fi



# Core
if [ ! -d "$1" ]
then
    git clone --recursive -b 7.x http://git.drupal.org/project/drupal.git $1
    if [ ! -d "$1" ]; then
        echo Drupal directory $1 does not exist
        exit 0
    fi
    echo "sites/all" >> $1/.gitignore
    cd $1
    git add .gitignore
    git commit -m 'Updating .gitignore'
    cd ..
else
    echo Drupal directory $1 exists.
fi


# Modules
DIR="$( dirname "${BASH_SOURCE[0]}" )"
filecontent=( `cat "$DIR/modules.txt"` )
for t in "${filecontent[@]}"
do
    if [ -n "$t" ]
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
        fi

        if [ -d "$1/sites/all/modules/$module" ]
        then
            echo Module directory $module exists
        else
            if [ -n "$branch" ]
            then
                git clone --recursive -b $branch http://git.drupal.org/project/$module.git $1/sites/all/modules/$module
            else
                git clone --recursive http://git.drupal.org/project/$module.git $1/sites/all/modules/$module
            fi
        fi
    fi
done


# Theme
if [ -d "$1/sites/all/themes/omega" ]
then
    git clone --recursive http://git.drupal.org/project/omega.git $1/sites/all/themes/omega
fi

