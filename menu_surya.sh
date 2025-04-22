#!/usr/bin/bash
function proiektufitxategiakPaketatuetaKonprimitu()
{
  cd /home/$USER/formulariocitas
  tar cvzf  /home/$USER/formulariocitas.tar.gz app.py script.sql  .env requirements.txt templates/*
}
function mysqlKendu()
{
	#Zerbitzua gelditu
	sudo systemctl stop mysql.service
	#Ezabatu paketeak +konfigurazioak +datuak	
	sudo apt purge mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-*
	#ezabatu beharrezkoak ez diren paketeak
	sudo apt autoremove
	#Cache-a garbitu
	sudo apt autoclean	
	#Datuak ezabatzen
	sudo rm -rf /var/lib/mysql
	#Konfigurazioa ezabatzen
	sudo rm -rf /etc/mysql/
	#bitakora ezabatzen
	sudo rm -rf /var/log/mysql
}

function kokapenberriaSortu()
{
    if [ -d /var/www/formulario ]
    then
        echo -e "Katalogoaren edukina ezabatzen...\n"
        sudo rm -rf /var/www/formulariocitas
    fi
    echo "Katalogoa sortzen..."
    sudo mkdir -p /var/www/formulariocitas
    echo " katalogoaren jabetza aldatzen..."
    sudo chown -R $USER:$USER /var/www/formulariocitas
    echo ""
    read -p "PULSA ENTER PARA CONTINUAR..."
}

function prioektufitxategiakkokapenberrianKopiatu()
{
	if [ ! -f "formulariocitas.tar.gz" ] 
	then
		echo "artxiboa ez da existitzen..."
		return 1
	else 
		tar -xzvf formulariocitas.tar.gz -C /var/www/formulariocitas
		echo "Artxiboa deskomprimitu da..."
	fi
}

function mysqlInstalatu()
{
	if  dpkg -l | grep -q mysql-server 
	then 
		echo "Instalatuta dago \n"
	else 
		sudo apt update
		sudo apt install mysql-server
		echo "Instalatu egin da \n"
	fi
	
	if  ! systemctl is-active --quiet mysql
	then 
		sudo systemctl start mysql.service
	fi
	echo "Abiarazita dago \n"
}

function datubasekoerabiltzaileaSortu()
{
	if [ ! -f "datubasekoerabiltzaileasortu.sql" ]
	then 
		echo "CREATE USER 'lsi'@'localhost' IDENTIFIED BY 'lsi';" > "./datubasekoerabiltzaileasortu.sql"
		echo "GRANT CREATE, ALTER, DROP, INSERT, UPDATE, INDEX, DELETE, SELECT, REFERENCES, RELOAD ON *.* TO 'lsi'@'localhost' WITH GRANT OPTION;" >> "./datubasekoerabiltzaileasortu.sql"
		echo "FLUSH PRIVILEGES;" >> "./datubasekoerabiltzaileasortu.sql"
		echo "Erabiltzailea sortuta \n"
		sudo mysql < "datubasekoerabiltzaileasortu.sql"
	else
		echo "Erabiltzailea sortuta dago dagoeneko \n"
	fi
		
}

function datubaseaSortu()
{
	sudo mysql -u lsi -p < "/var/www/formulariocitas/script.sql"
	echo "Sortu da taula \n"
}

function ingurunebirtualaSortu() 
{
	sudo apt-get update
	sudo apt install python3-dev build-essential libssl-dev libffi-dev python3-setuptools
	sudo apt install python3-venv
	sudo apt install -y python3-pip
	python3 -m venv /var/www/formulariocitas/venv
	source /var/www/formulariocitas/vvenv/bin/activate
	echo "Instalatu egin da guztia \n"
}

function menutikIrten()
{
echo "Instalatzailearen bukaera"
}
### Main ###
opcionmenuppal=0
while test $opcionmenuppal -ne 26
do
    #Menua erakutsi
    echo -e "0 Proiektu-fitxategiak paketatu eta konprimatu \n"
    echo -e "1 Mysql kendu \n"
    echo -e "2 Kokapen berria sortu \n" 
    echo -e "3 Proiektu fitxategiak kokapen berrian Kopiatu \n"
    echo -e "4 mysql instalatu\n"
    echo -e "5 Datubaseko erabiltzailea sortu \n" 
    echo -e "6 Datu basea sortu \n"
    echo -e "7 Ingurune birtuala sortu \n"
    echo -e "26 Menutik irten \n"
    	read -p "Ze aukera egin nahi duzu?" opcionmenuppal
    case $opcionmenuppal in
        	0) proiektufitxategiakPaketatuetaKonprimitu;;
        	1) mysqlKendu;;
   	 2) kokapenberriaSortu;;
   	 3) prioektufitxategiakkokapenberrianKopiatu;;
   	 4) mysqlInstalatu;;
   	 5) datubasekoerabiltzaileaSortu;;
   	 6) datubaseaSortu;;
   	 7) ingurunebirtualaSortu;;
   	 26) menutikIrten;;
   	 *) ;;
    esac
done
exit 0

