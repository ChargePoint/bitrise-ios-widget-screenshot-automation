#!/bin/bash

# Generate strings for the main project
printf "Generating Localizable.strings\n"
cd "./bitrise-screenshot-automation"
mkdir "en.lproj"
find ../ -name "*.swift" -print0 | xargs -0 genstrings -a -SwiftUI -o en.lproj
iconv -f UTF-16 -t UTF-8 "./en.lproj/Localizable.strings" > "./en.lproj/Localizable_UTF8.strings"
cp "./en.lproj/Localizable_UTF8.strings" "./Localization/Base.lproj/Localizable.strings"
cp "./en.lproj/Localizable_UTF8.strings" "./Localization/en.lproj/Localizable.strings"
rm -rf "en.lproj"

cd ..

./updateStoryboardStrings.sh
