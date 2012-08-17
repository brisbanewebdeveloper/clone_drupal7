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
filecontent=( `cat "modules.txt"` )
for t in "${filecontent[@]}"
do
    if [ -n "$t" ]
    then
        if [ -d "$1/sites/all/modules/$t" ]
        then
            echo Module/Theme directory $1 exists
        else
            git clone http://git.drupal.org/project/$t.git $1/sites/all/modules/$t
        fi
    fi
done


# Theme
if [ -d "$1/sites/all/themes/omega" ]
then
    git clone http://git.drupal.org/project/omega.git $1/sites/all/themes/omega
fi

