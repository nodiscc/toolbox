#!/bin/bash
#Description: converts todotxt (http://todotxt.com/) task files to osmo
#(http://clayo.org/osmo/) task entries. Note that you must already have started
#osmo one time and added a task entry to use this. Status: experimental! Do
#a backup of your ~/.osmo directory before running this.

while getopts ":i" opt
do
case $opt in
	i)
	grep summary ~/.osmo/tasks_entries.xml | sed 's/<\/*summary>//g' | sed 's/^ *//g'
	exit
	;;
esac
done


#Check if todotxt config file exists
if [ ! -f ~/.todo/config ]
then echo "todotxt config file not found \!"; exit 1
fi

#Find todo.txt file location
export TODO_DIR=`grep "^export TODO_DIR" ~/.todo/config`
eval $TODO_DIR
export TODO_FILE="$TODO_DIR/todo.txt"

#Check if todo.txt file exists
if [ ! -f $TODO_FILE ]
then echo "todo.txt file not found \!"; exit 1
fi


export TASK_ID="1"
export TEMPFILE=`mktemp`

#Put the contents of osmo tasks in a temp file, minus the last 2 lines
head -n -2 ~/.osmo/tasks_entries.xml >> $TEMPFILE

#Function: Check if task Id is already assigned
_CheckIdAvailable() {
while grep "<id>$TASK_ID</id>" ~/.osmo/tasks_entries.xml >/dev/null
do
TASK_ID=$(( $TASK_ID + 1 ))
done
}


#Begin reading todo.txt
cat $TODO_FILE | while read LINE
do
_CheckIdAvailable
#Escape some characters osmo doesn't like
LINE=`echo "$LINE" | sed 's/\&/\&amp;amp;/g'`
#Write task entry to temp file
echo "    <entry>
      <id>$TASK_ID</id>
      <status>0</status>
      <due_date>0</due_date>
      <due_time>-1</due_time>
      <summary>"${LINE}"</summary>
    </entry>" >> $TEMPFILE
#Increment task id
TASK_ID=$(( $TASK_ID + 1 ))
done
#Close temp file XML tags
echo "  </tasks_entries>
</osmo_tasks>" >> $TEMPFILE

killall osmo
cp $TEMPFILE ~/.osmo/tasks_entries.xml
rm $TEMPFILE

