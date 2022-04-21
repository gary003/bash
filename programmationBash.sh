#! /bin/bash bash

# Parameters
echo -e "name of script               \t -> " $0
echo -e "parameter 1                  \t -> " $1
echo -e "parameter 2                  \t -> " $2
echo -e "num parameters :string (\$#) \t -> " $#
echo -e "all parameters :array  (\$@) \t -> " $@
echo -e "all parameters :string (\$*) \t -> " $*

# Last printed value (0 : true, 1: false, else: errors)
test $((2 + 5)) -eq 32
echo -e "Last status in shell 2 + 5 = 32 ? \t -> " $?
test $((2 + 5)) -eq 7
echo -e "Last status in shell 2 + 5 = 7 ? \t -> " $?

# loop and array push
arr=()
for i in {15..3..2}
do
  arr+=($i)
done
echo ""

# Those 3 ways of testing are equals
if [[ -n $1 ]];then echo $1 ;fi
test ! -z $1 && echo $1
[ -n $1 ] && echo $1

# Basic String operation
str=azerty
echo "str size            -> " ${#str}
# show 1 element at index 3 (string:3:1)
echo "charAt  index 3     -> " ${str:3:1}

# Basic Array operation
echo "arr list            -> " ${arr[@]}
echo "arr size            -> " ${#arr[@]} 
echo "element index 3     -> " ${arr[3]}

# Array slice
echo "slice 0:2           -> " ${arr[@]::2}
echo "slice 2:4           -> " ${arr[@]:2:4}

# Array join
arrJoin=$(IFS=- ; echo "${arr[*]}")
echo "Array.join   :str   -> " $arrJoin

# Array split
IFS="-" read -a myarray <<< $arrJoin
echo "String.split :array -> " ${myarray[@]}

# Array map
arrSquare=()
for val in ${arr[@]}
do
  arrSquare+=($((val ** 2)))
done 
echo ${arrSquare[@]}

# launch a command line : $(<cmd>)
resCMD=$(ps)
echo $resCMD

num1=16
num2=2
num3=-5

# abs number
echo "absolute num ($num1) -> " ${num1#-} 

# launch an arithmetic operation : $((<operation>))
echo "$num1 + $num2 = $(($num1 + $num2))"
echo "$num1 * $num2 = $(($num1 * $num2))"
echo "$num1 ^ $num2 = $(($num1 ** $num2))"

# En natif, Bash ne propose que des fonctionnalités de calcul limitées (additions simples ...). bc permet des calculs plus complexes, avec gestion des décimales (ne pas oublier l'option -l, exemple :
echo "$num1 / $num3 = " $(echo "$num1/$num3" | bc -l)
echo "sqrt($num1) =  " $(echo "sqrt($num1)" | bc -l)

# Read input from console
# read -p "enter a value ... " -t 2 -s
# echo ${REPLY}
# res=${REPLY}
# echo "input read is : " $res

function sumNums() {
  if [[ $# -eq 0 ]];then
    echo "Pass at least 1 parameter"
  else
    echo "sumNums parameters -> " $@
    # total is local to the scope of sum()
    local total=0
    for num in $@
    do
      total=$(($total + $num))
    done
    echo $total
  fi
}

# The $total variable is not reachable outsude sumNums
test -z $total && echo "Trying to echo a local variable"

sumNums 7 12 6