#!/usr/bin/bash
function proiektufitxategiakPaketatuetaKonprimitu()
{
  cd /home/$USER/formulariocitas
  tar cvzf  /home/$USER/formulariocitas.tar.gz app.py script.sql  .env requirements.txt templates/*
}

#1. Ariketa           //8 Lerroa
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

#2. Ariketa              //27 Lerroa
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

#3. Ariketa              //43 Lerroa
function proiektufitxategiakkokapenberrianKopiatu()
{
    if [ -e /home/$USER/formulariocitas.tar.gz ] 
    then
	echo "Formularioa aurkituta"
	cd /var/www/formulariocitas
	sudo tar xvzf /home/$USER/formulariocitas.tar.gz
    else
	echo "Ez da formularioa aurkitu"
    fi
	read -p "PULSA ENTER PARA CONTINUAR..."
}

#4. Ariketa            //57 Lerroa
function mysqlInstalatu()
{
   if [ -e /usr/bin/mysql ]
   then
	echo "mysql instalatuta dago"
	if [ sudo systemctl status mysql.service | grep "active (running)" ]
	then
		echo "mysql abiarazita dago"
	else
		echo "mysql ez dago abiarazita"
		sudo systemctl start mysql.service
		echo "mysql abiarazi da"
	fi
   else
	echo "EZ daukazu mysql instalatuta, instalatuko zaizu"
	sudo apt update
	sudo apt install mysql-server
   fi
}

#5. Ariketa          //78 Lerroa
function datubasekoerabiltzaileaSortu()
{
   echo "Datu baserako erabiltzaile berri bat sortuko da:"
   echo "CREATE USER 'lsi' @ 'localhost' IDENTIFIED BY 'lsi';" > “$HOME/datubasekoerabiltzaileasortu.sql”
   echo "GRANT CREATE, ALTER, DROP, INSERT, UPDATE, INDEX, DELETE, SELECT, REFERENCES, RELOAD on*.* TO 'lsi' @ 'localhost' WITH GRANT OPTION;" > “$HOME/datubasekoerabiltzaileasortu.sql”
   echo "FLUSH PRIVILEGES;" > “$HOME/datubasekoerabiltzaileasortu.sql”

   sudo mysql < “$HOME/datubasekoerabiltzaileasortu.sql”
}

#6. Ariketa              //89 Lerroa
function datubaseaSortu()
{
   echo "Datu base berria sortzen..."
   sudo mysql <  /var/www/formulariocitas/script.sql
}

#7. Ariketa            //96 Lerroa
function ingurunebirtualaSortu()
{
   sudo apt update

   sudo apt install python3-dev build-essential libssl-dev libffi-dev python3-setuptools
   sudo apt install python3-pip
   sudo apt install python3-venv

   cd var/www/formulariocitas
   source venv/bin/activate
   echo "Ingurune birtuala sortu egin da."
}

#8. Ariketa
function ingurunebirtualeanliburutegiakInstalatu()
{
   echo "Ingurune birtualari liburutegiak instalatuko zaizkio:"
   cd /var/www/formulariocitas
   source venv/bin/activate
   sudo apt install r python3-pip
   pip install -r requirements.txt
}

#9. Ariketa
function flashekozerbitzariarekindenaProbatu()
{
   cd /var/www/formulariocitas
   python3 app.py & xdg-open http://127.0.0.1:5000
}

#10. Ariketa
function nginxIstalatu()
{
   if ( usr/bin/nginx) then
      echo "nginx jada instalatuta dago."
   else
      sudo apt update
      sudo apt install nginx -y
   fi
}

#11. Ariketa
function nginxMartxanJarri()
{
   if (systemctl is-active -q nginx)
   then
      echo "Programa aktibatuta dago jada"
   else
      sudo systemctl start nginx
      echo "Programa aktibatua izan da"
   fi
}

#12. Ariketa
function nginxatakaTesteatu()
{
   if ( $usr/bin/net-tools) then
      sudo atp update
      sudo apt install net-tools
      sudo netstat | grep nginx
   fi
}

#13. Ariketa
function indexIsuki()
{
   firefox http://127.0.0.1
}

#14. Ariketa
function indexPertsonalizatu()
{
    cd /var/www/html
 indexKodea='<!DOCTYPE html>
  <html>
  <head>
<title>GL2-ko bakarrak</title>
 </head>
 <body>
<center>
    <h1>GL2-ko bakarrak</h1>
</center>
<table border="5" bordercolor="red" align="center">
    <tr>
        <th colspan="3">GL2-ko bakarrak</th>
    </tr>
    <tr>
        <th>Izena</th>
        <th>Abizenak</th>
        <th>Posta elektronikoa</th>
    </tr>
     <tr>
        <td>Surya</th>
        <td>Ortega</th>
        <td border=3 height=100 width=100>surya@gmail.com</th>
    </tr>
    <tr>
        <td>Gaizka</th>
        <td>Divasson</th>
        <td border=3 height=100 width=100>gaizka@gmail.com</th>
    </tr>
    <tr>
        <td>Asier</th>
        <td>Barrio</th>
        <td border=3 height=100 width=100>asierb@gmail.com</th>
    </tr>
    <tr>
        <td>Asier</th>
        <td>LasHayas</th>
        <td border=3 height=100 width=100>asierl@gmail.com</th>
    </tr>
</table>
<center>
    Talde burua Surya Ortega da
</center>
  </body>
  <html>
'
 echo "$indexKodea" > "index.html"
 mv "index.nginx-debian.html" "index.html"
 firefox http://127.0.0.1/index.html 
}

#15. Ariketa
function  gunirconrInstalatu()
{
   if (pip list | grep gunicorn) then
      echo "Instalatuta dago dagoeneko."
   else
      sudo apt update
      sudo apt install gunicorn
   fi
}

#16. Ariketa
function gunicornKonfiguratu()
{
   cd /var/www/formulariocitas
   fitxInfor = from app import app\ nif __name__ == "__main__":\ app.run()
   echo -e $fitxInfor > wsgi.py
   source venv/bin/activate
   (venv) /var/www/formulariocitas$ gunicorn --bind 127.0.0.1:5000 wsgi:app
}

#17. Ariketa
function jabetasunaetabaimenakEzarri()
{
   sudo chmod 755 /var/www/formulariocitas
   sudo chmod 600 /var/www/formulariocitas/.env
   sudo chmod 600 /var/www/formulariocitas/app.py
   sudo chmod -R www-data:www-data /var/www/formulariocitas
}

#18. Ariketa
function flaskaplikazioarentzakosystemdzerbitzuaSortu()
{
   serbitzuaKodea = [Unit]\n
Description=Gunicorn instance to serve formulariocitas\n
After=network.target
[Service]
User=www-data
Group=www-data
WorkingDirectory=/var/www/formulariocitas
Environment="PATH=/var/www/formulariocitas/venv/bin"
ExecStart=/var/www/formulariocitas/venv/bin/gunicorn --bind 127.0.0.1:5000 wsgi:app
[Install]
WantedBy=multi-user.target

   echo -e $kodea | sudo tee /etc/systemd/system/formulariocitas.service > /dev/null
   sudo systemctl daemon-reload
   sudo systemctl start formulariocitas
   sudo status formulariocitas
}

#19. Ariketa
function nginxenatakaAldatu()
{
   
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
    echo -e "0 Proiektu-fitxategiak paketatu eta konprimatu"
    echo -e "1 Mysql kendu \n"
    echo -e "2 Kokapen berria sortu \n"
    echo -e "3 Fitxategia deskomprimitu \n"
    echo -e "4 Mysql instalatu \n"
    echo -e "5 Mysql datu baserako erabiltzailea sortu \n"
    echo -e "6 Datu base berria sortu \n"
    echo -e "7 Ingurune birtual berria sortu \n"
    echo -e "8 Ingurune birtualean liburutegiak instalatu \n"
    echo -e "9 Flash zerbitzariarekin frogaketa egin \n"
    echo -e "10 nginx programa instalatu \n"
    echo -e "11 nginx programa abiaratu \n"
    echo -e "12 nginx ataka bistaratu \n"
    echo -e "13 indexa ikusi \n"
    echo -e "14 index informazioa pertsonalizatu \n"
    echo -e "15 gunicorn programa instalatu \n"
    echo -e "16 gunicorn konfiguratu \n"
    echo -e "17 Proiektuko fitxategiei jabetasun eta baimenak ezarri \n"
    echo -e "26 Menutik irten \n"
    	read -p "Ze aukera egin nahi duzu?" opcionmenuppal
    case $opcionmenuppal in
        	0) proiektufitxategiakPaketatuetaKonprimitu;;
        	1) mysqlKendu;;
   	 2) kokapenberriaSortu;;
	 3) proiektufitxategiakkokapenberrianKopiatu;;
	 4) mysqlInstalatu;;
	 5) datubasekoerabiltzaileaSortu;;
	 6) datubaseaSortu;;
	 7) ingurunebirtualaSortu;;
	 8) ingurunebirtualeanliburutegiakInstalatu;;
	 9) flashekozerbitzariarekindenaProbatu;
	 10)nginxIstalatu;;
	 11)nginxMartxanJarri;;
	 12)nginxatakaTesteatu;;
	 13)indexIkusi;;
	 14)indexPertsonalizatu;;
	 15) gunicornInstalatu;;
	 16) gunicornKonfiguratu;;
	 17) jabetasunetabaimenakEzarri;;
   	 26) menutikIrten;;
   	 *) ;;
    esac
done
exit 0
