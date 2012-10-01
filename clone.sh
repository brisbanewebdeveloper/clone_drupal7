#!/bin/bash

if [ -z "$1" ]
then
    echo Usage: sh clone.sh drupal_directory
    exit 0
fi




drupal=$1
branch=7.x-1.x

# Core
if [ ! -d "$drupal" ]
then
    git clone --recursive -b $branch http://git.drupal.org/project/drupal.git $drupal
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
    git clone --recursive -b $branch http://git.drupal.org/project/omega.git $drupal/sites/all/themes/omega
fi

# Create directory for custom modules
mkdir $drupal/modules/_custom
mkdir $drupal/libraries

# Install files for WYSIWYG to use TinyMCE
unzip ${BASH_SOURCE[0]}/tinymce_3.5.6.zip
mv ${BASH_SOURCE[0]}/tinymce $drupal/libraries

# unzip ${BASH_SOURCE[0]}/tinymce-plugins-codemagic-307f692.zip
unzip ${BASH_SOURCE[0]}/codemagic.zip
mv ${BASH_SOURCE[0]}/codemagic $drupal/libraries/tinymce/jscripts/tiny_mce/plugins


# To prevent using newer version of jQuery at Admin pages
# (Because it does not work on my Chrome)
unzip ${BASH_SOURCE[0]}/jquery_update_custom.zip
mv ${BASH_SOURCE[0]}/jquery_update_custom $drupal/modules/all/_custom


# Copy javascript file for Views Slideshow
mkdir $drupal/sites/all/libraries/jquery.cycle
cp ${BASH_SOURCE[0]}/jquery.cycle.all.js $drupal/sites/all/libraries/jquery.cycle

