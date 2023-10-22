
tasks1[1]="technical"
tasks1[2]="project"
tasks1[3]="scripting"
tasks1[4]="server"
tasks1[5]="security"
tasks1[6]="workstation"
tasks1[7]="API"
tasks1[8]="hardware"
tasks1[9]="database"
tasks1[10]="filesystem"
tasks1[11]="cluster"
tasks1[12]="log"
tasks1[13]="vulnerability"
tasks1[14]="php"
tasks1[15]="java"
tasks1[16]="lua"
tasks1[17]="python"
tasks1[18]="django"
tasks1[19]="mysql"
tasks1[20]="postgresql"
tasks1[21]="bash"

tasks2[1]="optimization"
tasks2[2]="assesment"
tasks2[3]="evaluation"
tasks2[4]="monitoring"
tasks2[5]="upgrades"
tasks2[6]="experimentation"
tasks2[7]="research"
tasks2[8]="implementation"
tasks2[8]="consulting"

dividers[1]="and"
dividers[2]="and some"
dividers[3]="and a little bit of"
dividers[4]="/"
dividers[5]="and a lot of"
dividers[6]="with some"
dividers[7]="with plenty of"
dividers[8]="&"

times[1]="8"
times[2]="8.5"
times[3]="9"
times[4]="9.5"
times[5]="10"
times[6]="10.5"

RANDOM=$(od -N 1 /dev/urandom | awk '{ print $2 }')
task1="${tasks1[$((RANDOM %= $((${#tasks1[@]}))))]} ${tasks2[$((RANDOM %= $((${#tasks2[@]}))))]}"
RANDOM=$(od -N 1 /dev/urandom | awk '{ print $2 }')
task2="${tasks1[$((RANDOM %= $((${#tasks1[@]}))))]} ${tasks2[$((RANDOM %= $((${#tasks2[@]}))))]}"

until [ "$task1" != "$task2" ]; do
  RANDOM=$(od -N 1 /dev/urandom | awk '{ print $2 }')
  task1="${tasks1[$((RANDOM %= $((${#tasks1[@]}))))]} ${tasks2[$((RANDOM %= $((${#tasks2[@]}))))]}"
done

RANDOM=$(od -N 1 /dev/urandom | awk '{ print $2 }')
time="${times[$((RANDOM %= $((${#times[@]}))))]}"

until [ -n "$time" ]; do
  RANDOM=$(od -N 1 /dev/urandom | awk '{ print $2 }')
  time="${times[$((RANDOM %= $((${#times[@]}))))]}"
done

# https://github.com/konklone/basecamper
echo "$task1 ${dividers[$((RANDOM %= $((${#dividers[@]}))))]} $task2"
