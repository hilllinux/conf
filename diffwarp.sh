#!/bin/bash  
 
# diffwrap.sh  
 
# ---BEGIN--- change  
#shift 5  
#vimdiff "$@"  
LEFT=${6}  
RIGHT=${7}  
  
vimdiff -c TOhtml -c "w! ${LEFT}.${RIGHT}.diff.html | qall!" $LEFT $RIGHT
