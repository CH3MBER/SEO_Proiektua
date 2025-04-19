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
function proiektufitxategiakkokapenberrianKopiatu()
{
    if [ -d /home/$USER/formulariocitas.tar.gz ] 
    then
    	cd /var/www/formulariocitas
    	sudo tar xvzf /home/$USER/formulariocitas.tar.gz
    fi
}
function mysqlInstalatu()
#{

#	if [  ]
#	then


#	else

#}
function menutikIrten()
{
echo "Instalatzailearen bukaera"
}
### Main ###
opcionmenuppal=0
while test $opcionmenuppal -ne 26
do
    #Menua erakutsi
    echo -e "0 Proiektu-fitxategiak paketatu eta konprimatu"
    echo -e "1 Mysql kendu \n"
    echo -e "2 Kokapen berria sortu \n"
    echo -e "3 Proiektu-fitxategiak despaketatu eta deskonprimatu \n"
    echo -e "26 Menutik irten \n"
    	read -p "Ze aukera egin nahi duzu?" opcionmenuppal
    case $opcionmenuppal in
        	0) proiektufitxategiakPaketatuetaKonprimitu;;
        	1) mysqlKendu;;
   	 	2) kokapenberriaSortu;;
   	 	3) proiektufitxategiakkokapenberrianKopiatu;;
   	 	26) menutikIrten;;
   	 	*) ;;
    esac
done
exit 0

