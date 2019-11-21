#!/bin/bash

EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
GREEN='\033[0;0;32m'
STD='\033[0;0;39m'
BKNAME="homedir"-$(date '+%Y-%m-%d-%H-%M-%S')
FILES=$PWD
---------------------------------
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

backtoMenu() {
  show_menus
  read_options

}

show_menus() {
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo " M A I N - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. File Management"
	echo "2. User Control"
  echo "3. Resources"
  echo "4. Networking"
	echo "5. Exit"
}
read_options(){
	local choice
	read -p "Enter choice [ 1 - 5 ] " choice
	case $choice in
		1) fileMenu ;;
		2) userMenu ;;
    3) resMenu ;;
    4) four ;;
		5) exit 0;;
    6) recomp;;
		*) echo -e "${RED}Invalid option...${STD}" && sleep 1
	esac
}

fileMenu(){
  clear
  echo "~~~~~~~~~~~~~~~~~~~~~"
	echo " F I L E - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~"
  echo "1. Remove temp files"
  echo "2. Backup home directory" #Create backup folder and place backups of home directory
  echo "3. Compare backups" #Check all files in the backup folder and compare file sizes and MD5 hashes
  echo "4. Archive user files"
  echo "5. Main menu"
  read_fileMenu
        pause
}
read_fileMenu(){
	local choice
	read -p "Enter choice [ 1 - 5 ] " choice
	case $choice in
		1)  rm -rf /tmp/*
      echo "Cleared temp files"
      pause
      fileMenu;;
		2) sudo mkdir -p homeBk
      tar -zcvf "$BKNAME.tar.gz" /home
      sudo mv "$BKNAME.tar.gz" homeBk
      echo Home directory backed up as $BKNAME.tar.gz
      pause
    fileMenu;;
    3) compareFiles
       pause
       fileMenu;;
		4) four;;
    5) backtoMenu;;
    r) recomp;;
		*) echo -e "${RED}Invalid option...${STD}" && sleep 1
  fileMenu;;
	esac
}

userMenu(){
  clear
  echo "~~~~~~~~~~~~~~~~~~~~~"
	echo " U S E R - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~"
  echo "1. Create User(s)"
  echo "2. Ammend User Account"
  echo "3. Delete User"
  echo "4. Main Menu"
  read_userMenu
        pause
}
read_userMenu(){
	local choice
	read -p "Enter choice [ 1 - 4 ] " choice
	case $choice in
		1) echo 1
    useradd
    pause
    userMenu;;
		2) echo 2
    pause
    userMenu;;
    3) echo 3
    pause
    userMenu;;
		4) backtoMenu;;
		*) echo -e "${RED}Invalid option...${STD}" && sleep 1
    userMenu;;
	esac
}


resMenu(){
  clear
  echo "~~~~~~~~~~~~~~~~~~~~~"
	echo " R E S O U R C E - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~"
  echo "1. Disk Usage"
  echo "2. CPU Usage"
  echo "3. Memory Usage"
  echo "4. Main Menu"
  read_resMenu
        pause
}
read_resMenu(){
	local choice
	read -p "Enter choice [ 1 - 4 ] " choice
	case $choice in
		1) df -h
       pause
       resMenu;;
		2) top -bn1
       pause
       resMenu;;
    3) free -h | grep -v + > /tmp/ramcache
       echo -e ${GREEN}"Ram Usage :${STD}"
       cat /tmp/ramcache | grep -v "Swap"
       echo -e ${GREEN}"Swap Usage :${STD}"
       cat /tmp/ramcache | grep -v "Mem"
       pause
       resMenu;;
		4) backtoMenu;;
		*) echo -e "${RED}Invalid option...${STD}" && sleep 1
    resMenu;;
	esac
}


compareFiles(){
  for f in "$FILES"/homeBk/*
    do
       stat "$f"
       md5sum "$f" | awk '{ print "MD5 : " $1 }'
       echo
    done
    cd homebk
    find . -type f | wc -l | awk '{ print $1 " File(s) found" }'
    cd ../
    echo
}


trap '' SIGINT SIGQUIT SIGTSTP


while true
do
	backtoMenu
done
