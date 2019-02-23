#!/bin/bash
#Description: Example interactive menu in bash
#Source: https://github.com/shamun/Bash

_temp="/tmp/answer.$$"
PN=`basename "$0"`
VER='0.31'
dialog 2>$_temp
DVER=`cat $_temp | head -1`

### gauge demo ###
gauge() 
{
  {
    for I in $(seq 1 100) ; do
        echo $I
        sleep 0.01
      done
    echo 100; 
  } | dialog --backtitle "Dialog - Progress sample" \
                         --gauge "Progress" 6 60 0
}

### File or Directory selection menu with dialog
file_menu() {
    fileroot=$HOME
    IFS_BAK=$IFS
    IFS=$'\n' # wegen Filenamen mit Blanks
    array=( $(ls $fileroot) )
    n=0
    for item in ${array[@]}
    do
        menuitems="$menuitems $n ${item// /_}" # subst. Blanks with "_"  
        let n+=1
    done
    IFS=$IFS_BAK
    dialog --backtitle "Dialog - Sample menu with variable items" \
           --title "Select a file" --menu \
           "Choose one of the menu points" 16 40 8 $menuitems 2> $_temp
    if [ $? -eq 0 ]; then
        item=`cat $_temp`
        selection=${array[$(cat $_temp)]}
        dialog --msgbox "You choose:\nNo. $item --> $selection" 6 42
    fi
}

### File Select sample 
file_select() {
    dialog --backtitle "Dialog - fselect sample"\
           --begin 3 10 --title " use [blank] key to select "\
           --fselect "$HOME/" 10 60 2>$_temp

    result=`cat $_temp`
    dialog --msgbox "\nYou selected:\n$result" 9 52
}

### create Today's calendar ###
calendar() {
    today=date +"%d %m %Y"
    echo "heute=$today"
    dialog --backtitle "Dialog - Calendar sample" \
           --calendar "choose a date" 2 1 $today 2>$_temp
    datum=`cat $_temp`
    dialog --title " Date selected " --msgbox "\nYour date: $datum" 6 30
}    

### Check List - multi select sample ###
checklist() {
    dialog --backtitle "Dialog - CheckList (multi select) sample" \
           --checklist "tag item(s) to choose" 15 50 8 \
           01 "first item to select" off\
           02 "second item - on by default" on\
           03 "third item" off\
           04 "more items ..." off 2>$_temp
    result=`cat $_temp`
    dialog --title " Item(s) selected " --msgbox "\nYou choose item(s): $result" 6 44
}    

### Radio List - single select sample ###
radiolist() {
    dialog --backtitle "Dialog - RadioList (single select) sample" \
           --radiolist "tag item to choose" 15 50 8 \
           01 "first item to select" off\
           02 "second item - on by default" on\
           03 "third item" off\
           04 "more items ..." off 2>$_temp
    result=`cat $_temp`
    dialog --title " Item(s) selected " --msgbox "\nYou choose item: $result" 6 44
}    

### Input Box sample 
inputbox() {
    dialog --backtitle "Dialog - InputBox sample"\
           --inputbox "Enter a line, please" 8 52 2>$_temp

    result=`cat $_temp`
    dialog --msgbox "\nYou entered:\n$result" 9 52
}

### Message Box sample - show versions 
version() {
    dialog --backtitle "Dialog - MessageBox sample" \
           --msgbox "$PN - Version $VER\na Linux dialog Tutorial\n\nusing:\n$DVER" 9 52
}

### Text Box sample - show file test.txt
textbox() {
    filename="test.txt"
    if [ -e $filename ]; then
        dialog --backtitle "Dialog - TextBox sample - use [up] [down] to scroll"\
               --begin 3 5 --title " viewing File: $filename "\
               --textbox $filename 20 70
    else
        dialog --msgbox "*** ERROR ***\n$filename does not exist" 6 42
    fi
}

### Form Sample ###
formbox () {
	dialog --backtitle "Dialog - Form sample" \
	    --form " Form Test - use [up] [down] to select input field " 21 70 18 \
	    "name" 2 4 "" 2 15 20 0\
	    "surname" 4 4 "" 4 15 20 0\
	    "city" 6 4 "" 6 15 20 0\
	    "county" 8 4 "Germany" 8 15 "-20" 0\
	    2>$_temp
	
	if [ ${?} -ne 0 ]; then return; fi   
    result=`cat $_temp`
    echo "Result=$result"
    dialog --title "Items are separated by \\n" --cr-wrap \
           --msgbox "\nYou entered:\n$result" 12 52
}

### Text Box sample - show file test.txt
tailbox() {
    dialog --backtitle "Dialog - TailBox sample"\
           --begin 3 5 --title " viewing File: /var/log/messages "\
           --tailbox /var/log/messages 18 70
}

### create main menu using dialog
main_menu() {
    dialog --backtitle "Dialog - Linux Shell Tutorial" --title " Main Menu - V. $VER "\
        --cancel-label "Quit" \
        --menu "Move using [UP] [DOWN], [Enter] to select" 17 60 10\
        Calendar "Show today's calendar "\
        Editor "Start vi editor with test.txt"\
        File "Show Dirctory & File selector"\
        Form "Show a form"\
        Home_Menu "Show files in \$HOME for selection"\
        Input "Show Box for typing a line"\
        Gauge "Progress bar"\
        Multi "Multi select list"\
        Radio "Single select list"\
        Show "Show file test.txt"\
        Tail "Watch /var/log/messages"\
        Version "Show program version info"\
        Quit "Exit demo program" 2>$_temp
        
    opt=${?}
    if [ $opt != 0 ]; then rm $_temp; exit; fi
    menuitem=`cat $_temp`
    echo "menu=$menuitem"
    case $menuitem in
        Gauge) gauge;;
        File) file_select;;
        Home_Menu) file_menu;;
        Input) inputbox;;
        Calendar) calendar;;
        Editor) vi test.txt;;
        Multi) checklist;;
        Radio) radiolist;;
        Show) textbox;;
        Tail) tailbox;;
        Version) version;;
        Form) formbox;;
        Quit) rm $_temp; exit;;
    esac
}

while true; do
  main_menu
done
