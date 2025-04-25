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

#5. Ariketa
function datubasekoerabiltzaileaSortu()
{
 echo "CREATE USER 'lsi'@'localhost' IDENTIFIED BY 'lsi';" > "$HOME/datubasekoerabiltzaileasortu.sql"
 echo "GRANT CREATE,ALTER,DROP,INSERT,UPDATE,INDEX,DELETE,SELECT,REFERENCES,RELOAD on*.* TO 'lsi'@'localhost' WITH GRANT OPTION;" >> "$HOME/datubasekoerabiltzaileasortu.sql"
 echo "FLUSH PRIVILEGES;" >> "$HOME/datubasekoerabiltzaileasortu.sql"
 sudo mysql < "$HOME/datubasekoerabiltzaileasortu.sql"
}

#6. Ariketa
function datubaseaSortu() 
{
 sudo mysql < "/var/www/formulariocitas/script.sql"
}

#7. Ariketa
function ingurunebirtualaSortu()
{
 sudo apt-get update
 sudo apt install python3-dev build-essential libssl-dev libffi-dev python3-setuptools
 sudo apt install python3-venv
 sudo apt install -y python3-pip
 cd /var/www/formulariocitas
 python3 -m venv venv	
 source venv/bin/activate
}

#8. Ariketa
function ingurunebirtualeanliburutegiakInstalatu() 
{
 source venv/bin/activate
 cd /var/www/formulariocitas
 pip install flask
 pip install -r requirements.txt
}

#9. Ariketa
function flaskekozerbirariarekindenaProbatu()
{
 cd /var/www/formulariocitas
 python3 app.py &
 xdg-open http://127.0.0.1:5000
}

#10. Ariketa
function nginxInstalatu() 
{
 sudo apt update
 
 if ! command -v nginx &> /dev/null
 then
    sudo apt install nginx
 else
    echo -e " "
    echo -e "=====ERROR===== Nginx instalatuta dago dagoeneko =====ERROR===== \n"
 fi
}

#11. Ariketa
function nginxMartxanJarri()
{
 if ! systemctl is-active --quiet nginx.service;
 then
    sudo systemctl start nginx.service
 else
    echo -e " " 
    echo -e "=====ERROR===== Nginx abiaratuta dago dagoeneko =====ERROR===== \n"
 fi
}

#12. Ariketa
function nginxatakaTesteatu()
{
 sudo apt install net-tools
 sudo netstat -anp | grep nginx
}

#13. Ariketa
function indexIkusi()
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
        <th>Argazkia</th>
    </tr>
     <tr>
        <td>Surya</th>
        <td>Ortega</th>
        <td border=3 height=100 width=100>Photo1</th>
    </tr>
    <tr>
        <td>Gaizka</th>
        <td>Divasson</th>
        <td border=3 height=100 width=100>Photo2</th>
    </tr>
    <tr>
        <td>Asier</th>
        <td>Barrio</th>
        <td border=3 height=100 width=100>Photo3</th>
    </tr>
    <tr>
        <td>Asier</th>
        <td>LasHayas</th>
        <td border=3 height=100 width=100>Photo4</th>
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
function gunicornInstalatu()
{
 if pip show gunicorn >/dev/null 2>&1;
 then
    echo -e " " 
    echo -e "=====ERROR===== Gunicorn instalatuta dago dagoeneko =====ERROR===== \n"
 else
    cd /var/www/formulariocitas
    source venv/bin/activate
    pip install gunicorn 
 fi
}

#16. Ariketa
function gunicornKonfiguratu()
{
 cd /var/www/formulariocitas
 kodea='from app import app\nif __name__ == "__main__":\n\tapp.run()'
 echo -e $kodea > wsgi.py
 source venv/bin/activate
 gunicorn --bind 127.0.0.1:5000 wsgi:app &
 firefox http://127.0.0.1:5000
}

#17. Ariketa
function jabetasunaetabaimenakEzarri()
{
 sudo chmod -R 755 /var/www/formulariocitas 
 sudo chmod 600 /var/www/formulariocitas/.env
 sudo chmod 600 /var/www/formulariocitas/app.py
 sudo chown -R www-data:www-data /var/www/formulariocitas
}

#18. Ariketa
function flaskaplikazioarentzakosystemdzerbitzuaSortu()
{
 kodea='[Unit]\n
 Description=Gunicorn instance to serve Flask\n
 After=network.target\n
 \n
 [Service]\n
 User=www-data\n
 Group=www-data\n
 WorkingDirectory=/var/www/formulariocitas\n
 Environment="PATH=/var/www/formulariocitas/venv/bin"\n
 ExecStart=/var/www/formulariocitas/venv/bin/gunicorn --bind 127.0.0.1:5000 wsgi:app\n
 Restart=always\n
 \n
 [Install]\n
 WantedBy=multi-user.target\n'
 echo -e "$kodea" | sudo tee /etc/systemd/system/formulariocitas.service > /dev/null
 sudo systemctl daemon-reload 
 sudo systemctl start formulariocitas 
 sudo systemctl enable formulariocitas
 systemctl status formulariocitas
}

#19. Ariketa
function nginxenatakaAldatu()
{
 kodea='server {listen 3128;server_name localhost;location / {include proxy_params;proxy_pass  http://127.0.0.1:5000;}}'
 echo "$kodea" | sudo tee /etc/nginx/conf.d/formulariocitas.conf > /dev/null
 sudo nginx -t
}

#20. Ariketa
function nginxkonfiguraziofitxategiakKargatu()
{
 sudo systemctl reload nginx
}

#21. Ariketa
function nginxBerrabiarazi()
{
 sudo systemctl restart nginx
}

#22. Ariketa
function hostbirtualaProbatu()
{
 xdg-open http://127.0.0.1:3128
}

#23. Ariketa
function nginxlogakIkuskatu() 
{
 tail /var/log/nginx/error.log
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
    echo -e "5 Datubaseko erabiltzailea sortu \n"
    echo -e "6 Datubasea sortu \n"
    echo -e "7 Ingurune birtuala sortu \n"
    echo -e "8 Ingurune birtualean liburutegiak instalatu \n"
    echo -e "9 Flaskeko zerbirariarekin dena probatu\n"
    echo -e "10 Nginx instalatu \n"
    echo -e "11 Nginx martxan jarri \n"
    echo -e "12 Nginx ataka testeatu \n"
    echo -e "13 Index ikusi \n"
    echo -e "14 Index pertsonalizatu \n"
    echo -e "15 Gunicorn instalatu \n"
    echo -e "16 Gunicorn konfiguratu \n"
    echo -e "17 Jabetasuna eta baimenak ezarri \n"
    echo -e "18 Flask aplikazioarentzako systemd zerbitzua sortu \n"
    echo -e "19 Nginxen ataka aldatu \n"
    echo -e "20 Nginx konfigurazio fitxategiak kargatu \n"
    echo -e "21 Nginx berrabiarazi \n"
    echo -e "22 Host birtuala probatu \n"
    echo -e "23 Nginx logak ikuskatu \n"
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
   		9) flaskekozerbirariarekindenaProbatu;;
   		10) nginxInstalatu;;
   		11) nginxMartxanJarri;;
   		12) nginxatakaTesteatu;;
   		13) indexIkusi;;
   		14) indexPertsonalizatu;;
   		15) gunicornInstalatu;;
   		16) gunicornKonfiguratu;;
   		17) jabetasunaetabaimenakEzarri;;
   		18) flaskaplikazioarentzakosystemdzerbitzuaSortu;;
   		19) nginxenatakaAldatu;;
   		20) nginxkonfiguraziofitxategiakKargatu;;
   		21) nginxBerrabiarazi;;
   		22) hostbirtualaProbatu;;
   		23) nginxlogakIkuskatu;;
   	 	26) menutikIrten;;
   	 	*) ;;
    esac
done
exit 0
