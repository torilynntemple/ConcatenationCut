# ConcatenationCut

## What this is used for
This package is meant to go along with my concatenation script for miniscope analysis. When concatenating your sessions together, sometimes it is neccessary for other types of analysis packages to split the sessions back up into your original folders, this is the script that will do that for you. From the concatenation script you are given a single ms structure and a single behav structure (if you included any behavorial data), the package will take those structures and cut them into multiple ms structures pertaining to each of your sessions and save them into each of your folders. This way the same cells are found throughout each session. 

## How to use
In order to use this you will set it up in the same way as your concatenation script. Add the package to path, open "cutVideoBatch", and have your folders with each of your recorded sessions in the current folder with your ms and or behavorial structures. 
