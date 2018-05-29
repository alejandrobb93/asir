#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "Este script se debe ejecutar como root" 
   exit 1
fi

if ! nc -zw1 google.com 443 ; then
	echo "No hay conexion a internet"
	exit 1
fi

java -version 2>/dev/null
if [ $? -ne 0 ]; then


	echo "********** Instalando Java y dependencias **********"

	apt-add-repository ppa:webupd8team/java -y
	apt-get update
	echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
	apt-get install -y oracle-java8-installer

fi

echo "********** Descargando Kettle **********"

apt-get install -y libwebkitgtk-1.0.0 unzip
wget https://sourceforge.net/projects/pentaho/files/Data%20Integration/7.1/pdi-ce-7.1.0.0-12.zip
unzip pdi-ce-7.1.0.0-12.zip
mkdir /pentaho
mv data-integration /pentaho

function mysql {

        read -p "Quieres instalar el conector de MySQL para Java? (S/n)" siono
        case $siono in
                S|s|"")
                        wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.tar.gz
                        tar xvzf mysql-connector-java-5.1.46.tar.gz
                        cp mysql-connector-java-5.1.46/mysql-connector-java-5.1.46-bin.jar /pentaho/data-integration/lib
                        ;;
                N|n)
                        exit 0
						;;
                *)
                        echo "Por favor, elige una opcion valida"
                        mysql
                        ;;
        esac
}
mysql
