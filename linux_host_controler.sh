#!/bin/bash
original=/etc/hosts
backup=/etc/hosts.original


start(){
if  [ -f "$backup" ]
	then
		MainMenu
		
    else
    backup_method
	fi
}

backup_method (){

if [ -f "$original" ]
	then
    echo "Please input your ROOT password:"
	 sudo cp /etc/hosts /etc/hosts.original
		MainMenu
    else
        echo "There is no 'hosts' file in your system"
        read -p "Do you want to install the default one? [y/n]" -n 1 confirm
        printf "### Host Database                   \n
#                                                       \n
# localhost is used to configure the loopback interface \n
# when the system is booting.  Do not change this entry.\n
##                                                      \n
127.0.0.1 localhost                                     \n
255.255.255.255 broadcasthost                           \n
::1 localhost                                           \n
fe80::1%lo0 localhost\n" >> default
    echo "Please input your ROOT password:"
    sudo cp default /etc/hosts
    sudo cp default /etc/hosts.original
		
fi
}
border()
{
    title="| $1 |"
    edge=$(echo "$title" | sed 's/./*/g')
    echo -e "\e[32m$edge"
    echo -e "\e[32m$title"
    echo -e "\e[32m$edge"
    echo -e "\e[39m"
    
}
status() {
	local count=$(grep '^0.0.0.0' "$original" | wc -l | tr -d ' ')

	border "$count domains currently blocked"
}
MainMenu(){
clear
printf "Welcome to Linux Host Controler\n "
status
PS3='Please enter your choice: '
options=("Activate Host Control" "Deactivate Host Control" "Block a particular domain" "Unblock a particular domain" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Activate Host Control")
        read -p "Enable Host Control as AdBlocker??? [y/n]" -n 1 confirm
		if [[ $confirm == 'y' ]]
		then
        activete
		MainMenu
		else 
		MainMenu
		fi
            ;;
            
        "Deactivate Host Control")
        printf "This option will restore the original Hosts file. \nYou will loose any particular blocked domain.\n "
        read -p "Are you sure you will like the default values to be restored ??? [y/n]" -n 1 confirm
		if [[ $confirm == 'y' ]]
		then
        deactivate
		MainMenu
		else 
		MainMenu
		fi
            ;;
            
        "Block a particular domain")
        printf "This option will allow you to block all users to access an custom domain, website or IP address.\n You may use this at home as a parental control ,or employee control at work\n "
        read -p "Proceed with blocking ??? [y/n]" -n 1 confirm
		if [[ $confirm == 'y' ]]
		then
        blocker
		MainMenu
		else 
		MainMenu
		fi
          
            ;;
        "Unblock a particular domain")
         printf "This option will allow you to unblock all users to access an custom domain, website or IP address.\You may use this at home as a parental control ,or employee control at work\n "
        read -p "Proceed with blocking ??? [y/n]" -n 1 confirm
		if [[ $confirm == 'y' ]]
		then
        unblocker
		MainMenu
		else 
		MainMenu
		fi
            
            ;;  
        "Quit")
            exit
            ;;
        *) echo "invalid option $REPLY";;
    esac

done
}
activete(){

if [ -f "$backup" ]
	then
		asabler
		echo "Input your Root password please:"
		echo ""
		sudo cp assabled_hosts /etc/hosts
		MainMenu
    else
    echo ""
    read -p "Oopps...there is no backup. Will you like to make one before proceeding?? [y/n]" -n 1 confirm
		if [[ $confirm == 'y' ]]
		then
		backup_method
		asabler
		MainMenu
		else 
		asabler
		echo "Input your Root password please:"
		echo ""
		sudo cp assabled_hosts /etc/hosts
		MainMenu
		fi
    
	fi


}

asabler(){

echo "Creating local database"
curl https://someonewhocares.org/hosts/zero/hosts --show-error -\#  --output "db1" 
curl https://abpvn.com/android/abpvn.txt --show-error -\#  --output "db2" 
curl http://mirror1.malwaredomains.com/files/immortal_domains.txt --show-error -\#  --output "db3"
sed -i 's/^/0.0.0.0 / ' db3
curl http://sbc.io/hosts/hosts --show-error -\#  --output "db4" && sed -i '1,39d' db4
curl http://sysctl.org/cameleon/hosts --show-error -\#  --output "db5"
curl https://adaway.org/hosts.txt --show-error -\#  --output "db6" && sed -i '1,24d' db6
curl https://openphish.com/feed.txt --show-error -\#  --output "db7" && sed -i 's/^/0.0.0.0 / ' db7
curl https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts --show-error -\#  --output "db8" && sed -i '/^\(127.0.0.1\|-t\(h\|o\)\)/!d' db8 && sed -i 's/127.0.0.1/0.0.0.0/g' db8
curl https://raw.githubusercontent.com/Lerist/Go-Hosts/master/hosts-ad --show-error -\#  --output "db9" 
curl https://raw.githubusercontent.com/bjornstar/hosts/master/hosts --show-error -\#  --output "db10" && sed -i '/^\(0.0.0.0\|-t\(h\|o\)\)/!d' db10
curl https://v.firebog.net/hosts/static/w3kbl.txt --show-error -\#  --output db11 && sed -i '1,8d' db11 && sed '/^#/d' db11 && sed -i 's/^/0.0.0.0 / ' db11
clear
echo "Database created" 
sleep 1
echo "Now we assamble the file HOSTS file"
cat db1 db2 db3 db4 db5 db6 db7 db8 db9 db10 db11 >> assabled_hosts
echo '# Custom Hosts will be added below' >> assabled_hosts
echo "All DONE. Flishing database....."
sleep 2
rm db1 db2 db3 db4 db5 db6 db7 db8 db9 db10 db11 
}


blocker(){
cp /etc/hosts hosts
echo "Please enter the website or IP address you will like to block"
read website
block_address=$(getent hosts $website )
echo "$block_address" | tee -a custom_hosts
sed 's/^/0.0.0.0 / ' custom_hosts | tee -a hosts
sudo cp hosts /etc/hosts
rm custom_hosts

clear
MainMenu
}

unblocker(){
cp /etc/hosts hosts
echo "Please enter the domain , site or IP you will like to block access to."
read address
sed -i "/$address/d"  hosts
sudo cp hosts /etc/hosts
clear
MainMenu

}
deactivate(){
sudo cp /etc/hosts.original /etc/hosts
echo "HOSTS file restored"
sleep 1
MainMenu
}

start
