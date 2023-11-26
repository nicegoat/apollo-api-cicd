#!/bin/bash

array=${1// /}
## substitute , with space
array=${array//,/ }
array=${array//\"/ }
## remove [ and ]
array=${array##[}
array=${array%]}
## create an array
array=($array)
#echo $array[@]
#eval "array=($array)"
echo "${array[@]}"
