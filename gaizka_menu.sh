#0. Ariketa
function proiektufitxategiakPaketatuetaKonprimitu()
{
  cd /home/$USER/formulariocitas
  tar cvzf  /home/$USER/formulariocitas.tar.gz app.py script.sql  .env requirements.txt templates/*
}

#1. Ariketa
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

#2. Ariketa
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

#3. Ariketa
function proiektufitxategiakkokapenberrianKopiatu()
{
 cd /home/$USER
 tar -xvzf /home/$USER/formulariocitas.tar.gz -C /var/www/formulariocitas
}

#4. Ariketa
function mysqlInstalatu()
{
 sudo apt install mysql-server
 sudo systemctl start mysql.service
}




#26. Ariketa
function menutikIrten()
{
 echo "Instalatzailearen bukaera"
}
### Main ###
opcionmenuppal=0
while test $opcionmenuppal -ne 26
do
    #Menua erakutsi
    echo -e "/////////////////////////////////////////////////////////// \n"
    echo -e "0 Proiektu-fitxategiak paketatu eta konprimatu \n"
    echo -e "1 Mysql kendu \n"
    echo -e "2 Kokapen berria sortu \n"
    echo -e "3 Proiektu fitxategiak kokapen berrian kopiatu \n"
    echo -e "4 Mysql Instalatu \n"
    echo -e "26 Menutik irten \n"
    	read -p "Ze aukera egin nahi duzu?" opcionmenuppal
    case $opcionmenuppal in
        	0) proiektufitxategiakPaketatuetaKonprimitu;;
        	1) mysqlKendu;;
   		2) kokapenberriaSortu;;
   		3) proiektufitxategiakkokapenberrianKopiatu;;
   		4) mysqlInstalatu;;
   	 	26) menutikIrten;;
   	 	*) ;;
    esac
done
exit 0
