#!/bin/bash


greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

essid=""
password=""
    


declare -i exist=0

#Muestra la lista de redes
function list(){       

    dir=$(mktemp -d)
    declare -i contador=0
    declare -i status=1
    
    while [ $status -ne 0 ] && [ $contador -ne 3  ]
    do
        iwlist $1 scan 2>/dev/null 1> $dir/file.txt
        long=$(cat $dir/file.txt)
        if [ $? -eq 0 ] && [ ${#long} -ge 4 ]; then
            status=0
            cat $dir/file.txt | grep -T "ESSID:" | tr -d "ESSID:"|  sed 's/"//g' | sed 's/ //g' | sort -u 
        else
            contador=$(($contador + 1))
            status=1
        fi
    done

    if [ ${#long} -le 4 ];then
        echo -e "\nNo se han encontrado redes intentelo de nuevo"
        exit 1
    fi
}

function testConnection(){
    declare -i counter=0
    
    while [ $counter -le 17 ]; do
        sleep 3
        counter=$(($counter+1))

        iw dev $1 link | grep $2 &>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "\n ${greenColour}Conexión establecida! ${endColour}"
            counter=17
            exit 0
        elif [ $? -ne 0 ] && [ $counter -eq 17 ]; then
            echo "${redColour}Conexión reusada intente otra vez ${endColour}"
            nmcli connection down $essid
            exit 1
        fi
    done

}


function manageWifi(){
    sleep 4
    list $1
    if [ $? -eq 0 ]; then

        echo -e "\n Ingrese el nombre de red:"
        read essid
        echo -e "\n Ingrese la contraseña de red:"
        read -s password
        echo -e "\n ${yellowColour}Estableciendo conexión con $essid.. ${endColour}"
        nmcli device wifi connect $essid password $password &>/dev/null 
        wait
    else
       echo "Error fatal"
    fi

}


if [ "$(whoami)" == "root" ]; then

    if [ $1 ]; then

        nmcli device status | grep $1 | grep -vE wifi-p2p | grep -E "\bconectado|\bconnected" &>/dev/null

        if [ $? -eq 0 ]; then
            disconnect=""
            netConnected=$(nmcli device status | grep $1 | grep -vE wifi-p2p | awk '{print $4}') &>/dev/null
            echo -e "\n Estas conectado/a a la red ${greenColour} $netConnected ${endColour}\n"
            echo -e "¿Quieres desconectarte? <si> <no>"
            read disconnect

            if [ "$disconnect" == "si" ]; then
                nmcli connection down $netConnected
                exit 0
            fi
        
        fi

        for line in $( ip -o link show | awk -F': ' '{print $2}'); do

            if [ "$line" == "$1" ] && [ "$line" != "lo" ]; then

                ifconfig $line | grep UP &>/dev/null

                if [ $? -eq 0 ]; then
                    echo -e "${yellowColour}========  Redes wifi  =======${endColour}"
                    manageWifi $line
                    sleep 10
                    testConnection $1 $essid
                    exist=1
                else
                    ifconfig $line up 

                    if [ $? -eq 0 ]; then
                        echo -e "${yellowColour}========  Redes wifi  =======${endColour}"
                        manageWifi $line 
                        echo -e "Estableciendo conexión con $essid.."
                        sleep 5
                        testConnection $1 $essid
                        exist=1
                    else
                        echo -e "Error al conectar $line"
                    fi
                fi
            
            fi
        done

        if [ $exist -eq 0 ]; then
            echo -e "La interfaz no existe"
        fi

    else
        echo -e "${yellowColour}wifi.sh ${turquoiseColour}<interface name>${endColour}"
    fi
else

    echo -e "${redColour}Permiso denegado <Debe ser root>${endColour}"
fi