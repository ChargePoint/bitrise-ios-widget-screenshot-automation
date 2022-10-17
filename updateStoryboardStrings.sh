#!/bin/bash

# Function to generate strings file and copy file with UTF-8 encoding
generate_strings()
{
    file=$1
    filename=$2
    
    ibtool ${file} --generate-strings-file ../../en.lproj/${filename}.strings
    iconv -f UTF-16 -t UTF-8 "../../en.lproj/${filename}.strings" > "../../en.lproj/${filename}_UTF8.strings"
    cp "../../en.lproj/${filename}_UTF8.strings" "../en.lproj/${filename}.strings"
}

generate_storyboard_strings()
{
    for file in *.storyboard; do
        filename=${file%.storyboard}
        generate_strings ${file} ${filename}
    done
}

printf "\nGenerating Storyboard strings\n"
cd "./bitrise-screenshot-automation"
mkdir en.lproj
cd "./Localization/Base.lproj"
generate_storyboard_strings

rm -rf "../../en.lproj"
