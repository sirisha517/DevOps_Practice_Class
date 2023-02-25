sample comman.sh

roboshop_app_password=$1
if [ -z "${1}" ] ; then # check variabe is empty
  echo -e "\e[35mMissing roboshop app user Password\e[0"
  exit 1
fi
commponent=dispatch
golang


