#!/bin/bash

#************************************************#
#                 translate.sh                   #
#           written by Nikita Korotkih           #
#                Jan 27, 2011                    #
#                                                #
#       Translate words by Google Translator     #
#************************************************#

# TODO: 
#  - check if google return an error
#  - add special input parameters

LOG_FILE=~/t.log
E_WRONG_ARGS=85
script_parameters="wordToTranslate fromLang toLang"

#colors
black='\E[30;47m'
red='\E[31m'
green='\E[32m'
yellow='\E[33;47m'
blue='\E[34;47m'
magenta='\E[35;47m'
cyan='\E[36;47m'
white='\E[37;47m'


Reset() #  Reset text attributes to normal
{
    tput sgr0      
}

cecho ()                     # Color-echo.
                             # Argument $1 = message
                             # Argument $2 = color
{
    local default_msg="No message passed."
            # Doesn't really need to be a local variable.
    message=${1:-$default_msg}   # Defaults to default message.
    color=${2:-$black}           # Defaults to black, if not specified.

    echo -e "$color"
    echo "$message"
    
    Reset
    
    return
}  

#-------------------------------------------------------------#
# translateIt ()                                              #
# translate words and phrases by Google Translator            #
# Parameter: $wordToTranslate                                 #
# Parameter: $fromLang                                        #
# Parameter: $toLang                                          #
# Returns: result of translation or json-response from Google #
#-------------------------------------------------------------#
translateIt () 
{
    if [ $# -ne 3 ]
    then
        echo $E_WRONG_ARGS
        exit
    fi

    wget -qO- "ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=$1&langpair=$2|${3:-en}" \
        | sed 's/.*"translatedText":"\([^"]*\)".*}/\1\n/';
}



#----------------------------main---------------------------#

translationResult=$(translateIt $1 $2 $3)


if [ $translationResult == $E_WRONG_ARGS ]
then
    cecho "Usage: $(basename $0) $script_parameters" $red
    exit $E_WRONG_ARGS
fi

#count the number of occurances of a word to translate
count=$(awk -v wordToTranslate=$1 '{ 
                                        if(wordToTranslate == $3) {
                                            count += 1
                                        }
                                    } 
                                    END {
                                        print count
                                    }' $LOG_FILE
)

let count++

#output 
echo "========================"
cecho $translationResult $green  
cecho "Interested $count times" $green
echo "========================"

#and log it!
echo -e "$(date '+%m/%d/%y %H:%M:%S')\t$1\t$translationResult\t$count" >> $LOG_FILE

exit
