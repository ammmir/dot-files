#!/bin/sh

cd ..
ln -sv dot-files/.[a-f,h-z]* dot-files/.gitconfig dot-files/.gitignore .

cd ~/Library/Developer/Xcode/UserData
ln -sv ../../../../dot-files/Library/Developer/Xcode/UserData/FontAndColorThemes .
