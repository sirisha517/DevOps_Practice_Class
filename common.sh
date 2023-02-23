code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
 echo -e "\e[35m$1\e[0m" # if we change colour in one place it will effect in all places
  }

status_check(){
  if [ $? -eq 0 ]; then
    echo SUCESS
    else
      echo FAILURE
      exit
  fi
}