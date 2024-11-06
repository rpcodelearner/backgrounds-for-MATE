#! /bin/bash

if [[ "$#" -lt 1 ]]
then
  echo "Usage: $(basename "$0") FILE [DURATION [TRANSITION DURATION]]"
  exit 85 # BAD_ARGS
fi

# Our defaults
DURATION=321.0
TRANSITION_DURATION=1.2

if [[ "$#" -ge 2 ]]
then
  if [[ "$2" =~ ^[0-9]+(.[0-9])?$ ]]
  then
    DURATION="$2"
  else
    echo -n "Could not understand 2nd parameter '"
    echo -n "$2"
    echo "' as a number => using default value: " "$DURATION"
  fi
fi

if [[ "$#" -eq 3 ]]
then
  if [[ "$3" =~ ^[0-9]+(.[0-9])?$ ]]
  then
    TRANSITION_DURATION="$3"
  else
    echo -n "Could not understand 3rd parameter '"
    echo -n "$3"
    echo "' as a number => using default value: " "$TRANSITION_DURATION"
  fi
fi


echo "Looking for image files in" "$PWD ..."
declare -a imageFilesArray
for f in *.* ; do if [[ "$f" =~ \.(bmp|gif|jpeg|jpg|png|svg|webp) ]] ; then imageFilesArray+=("$f") ; fi ; done
for f in "${imageFilesArray[@]}" ; do echo " $f" ; done


echo -n "Found the above images in the current working directory. About to create/overwrite $1. Proceed? [y/N] "
read -r USER_CHOICE
if [ "$USER_CHOICE" != "y" ] ; then
   echo "Not proceeding. Exiting..."
   exit 0
fi

# Various fixed stuff
HEADER="<background>
  <starttime>
    <year>$(date +%Y)</year>
    <month>$(date +%m)</month>
    <day>$(date +%d)</day>
    <hour>$(date +%k)</hour>
    <minute>$(date +%M)</minute>
    <second>$(date +%S)</second>
  </starttime>
"
PREFIX="  <static>
   <duration>$DURATION</duration>
   <file>"
SUFFIX="</file>
  </static>"
TRANSITION_PREFIX="  <transition>
    <duration>$TRANSITION_DURATION</duration>
    <from>"
TRANSITION_MID="</from>
    <to>"
TRANSITION_SUFFIX="</to>
  </transition>"
CLOSING_TAG="</background>"


# Begin writing to specified file
echo "$HEADER" > "$1"

# Files
declare -a filePaths
for f in "${imageFilesArray[@]}" ; do
  filePaths+=("$PWD/$f") ;
done
for element in "${filePaths[@]}" ; do
  {
    echo -n "$PREFIX" ;
    echo -n "$element" ;
    echo "$SUFFIX" ;
  } >> "$1"
done

# Transitions
numberOfFiles="${#filePaths[@]}"
filePaths+=("${filePaths[0]}")  # for simplicity we add first element again at the end
for (( index=0 ; "$index" < "$numberOfFiles" ; index++ )) ; do
  {
    echo -n "$TRANSITION_PREFIX" ;
    echo -n "${filePaths[$index]}" ;
    echo -n "$TRANSITION_MID" ;
    echo -n "${filePaths[index+1]}" ;
    echo "$TRANSITION_SUFFIX" ;
  } >> "$1"
done

# Close XML structure
echo "$CLOSING_TAG" >> "$1"
echo "Done."
