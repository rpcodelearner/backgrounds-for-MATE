# backgrounds-for-MATE
A bash script that helps making slide-show backgrounds for MATE

# Purpose / Scope
The MATE Desktop Environment allows the selection of more than an image as background, slide show style, but it requires a proper XML file.
This script provides a simple way to gather a bunch of image files and create the corresponding XML file.

# Usage (short version)
`makeSlideShow.sh FILE [DURATION [TRANSITION_DURATION]]`

FILE (mandatory) - this file is the only output of the script and it will be either created or overwritten.

DURATION (optional) - how long each picture will be displayed (seconds)

TRANSITION_DURATION (optional) - how many seconds it takes to fade from a picture to the next

**IMPORTANT**: The script uses a regex to look for all image files in $PWD and generate the relevant content, so it must be run from where the pictures reside.
The regex can be found at about line 40, column 36 as of the first uploaded version.
The output XML file contains full absolute paths, so MATE will be able to use this file even if you store it away from the pictures, but I cannot see any advantage in doing so.
Also, since I decided for some interaction with the user, I could not write the output at stdout (as some of you may have preferred).

# Usage (longer version for Linux-beginners)
1. create a folder and store there the pics you want to use as backgrounds; here I call it the 'PICS_FOLDER'

2. copy the 'makeSlideShow.sh' script somewhere on your machine; putting the script in the PICS_FOLDER sounds quick-and-dirty but it works.

3. (open a shell, locate the script and) ensure makeSlideShow.sh is executable with `chmod u+x makeSlideShow.sh`

4. open a shell and change the shell working directory to the PICS_FOLDER. This is IMPORTANT, as the script looks for images in the so-called Present Working Directory (PWD).
The script and the output file may lay in different places, just remember that it is up to you to specify the proper paths. If you are not sure what I mean, just keep pics, script and then the XML file in the same place.

5. run the script, providing as argument the name of an XML file that it will create, for example mySlideShow.xml. This argument is mandatory
Optionally, you can provide also:
DURATION - how long each picture will be displayed
TRANSITION_DURATION - how long it takes to fade from a picture to the next
Example: './makeSlideShow.sh foobar.xml'  # if the pics and the script are in the PICS_FOLDER

6. in MATE main menu, go to Preferences > Look and Feel > Appearance > Background > Add..
Then select "All Files" instead of "Images" and pick the XML file that you have just created.

7. Should you prefer some picture to stay longer than others, consider manually editing the XML file with an editor.

8. Finally, if you need to include an image format I forgot about, learn what a regex is, then go to line 40, column 36 and whereabouts. Add there the relevant file extension(s) and one or more pipe symbol(s) '|'. Notice the format and respect it: (extension_1|extension_2|...|extension_N)
