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
    if [ -e /home/$USER/formulariocitas.tar.gz ] 
    then
    	cd /var/www/formulariocitas
    	sudo tar xvzf /home/$USER/formulariocitas.tar.gz
    else
    	echo -e " Ez dago fitxategia."
    fi
    read -p "PULSA ENTER PARA CONTINUAR..."
}
function mysqlInstalatu()
{
echo -e " Blablabla" 
}
function datubasekoerabiltzaileaSortu()
{
   SQL_SCRIPT="$HOME/datubasekoerabiltzaileasortu.sql"

    echo "CREATE USER 'lsi'@'localhost' IDENTIFIED BY 'lsi';" > "$SQL_SCRIPT"
    echo "GRANT CREATE, ALTER, DROP, INSERT, UPDATE, INDEX, DELETE, SELECT, REFERENCES, RELOAD ON *.* TO 'lsi'@'localhost' WITH GRANT OPTION;" >> "$SQL_SCRIPT"
    echo "FLUSH PRIVILEGES;" >> "$SQL_SCRIPT"

    echo "Erabiltzailea sortzeko SQL script-a sortu da hemen: $SQL_SCRIPT"
    echo "Exekutatzen: sudo mysql < $SQL_SCRIPT"
    sudo mysql < "$SQL_SCRIPT"
}
function datubaseaSortu()
{
    sudo mysql -u lsi -p < /var/www/formulariocitas/script.sql
    #konprobaketa sar daiteke
}
function ingurunebirtualaSortu()
{
    declare -a lista_paquetes
    lista_paquetes=("python3" "python3-pip" "python3-dev" "build-essential" "libssl-dev" "libffi-dev" "python3-setuptools" "python3-venv")
    
    for i in "${lista_paquetes[@]}"
    do
    	nombre="$i"
    	aux=$(sudo dpkg -s $nombre | grep "Status: install ok installed")
    	if [ -z "$aux" ]; then
    		sudo apt install $nombre -y
    	else
    		echo "ezer"
    	fi
    done
    cd /var/www/formulariocitas
    python3 -m venv venv
    source /var/www/formulariocitas/venv/bin/activate
    echo ""
    read -p "PULSA ENTER PARA CONTINUAR..."
}
function ingurunebirtualeanliburutegiakInstalatu()
{
    cd /var/www/formulariocitas
    echo "Ingurune birtuala aktibatzen..."
    python3 -m venv venv
    source /var/www/formulariocitas/venv/bin/activate
    sudo apt install -y python3-pip
    pip install -r /var/www/formulariocitas/requirements.txt
    echo ""
    read -p "PULSA ENTER PARA CONTINUAR..."
}
function flaskekozerbirariarekindenaProbatu()
{
echo -e " Formulariocitas\n"
}
function nginxInstalatu()
{
    aux=$(sudo dpkg -s nginx | grep "Status: install ok installed")
    if [ -z "$aux" ]; then
        sudo apt update
	sudo apt install nginx -y
    else
	echo "Instalatuta dago"
    fi
    	echo ""
    read -p "PULSA ENTER PARA CONTINUAR..."
}
function nginxMatxanJarri()
{
echo -e " Formulariocitas\n"
#Aqui habria que combrobar si esta activo, usando systemctl y supongo que grep tambien
}
function nginxatakaTesteatu()
{
echo -e " Formulariocitas\n"
}
function indexIkusi()
{
echo -e " Formulariocitas\n"
}
function indexPertsonalizatu()
{
echo -e " Formulariocitas\n"
}
function gunicornInstalatu()
{
    cd /var/www/formulariocitas
    source /var/www/formulariocitas/venv/bin/activate
    if pip show gunicorn > /dev/null 2>&1; then
        echo "Gunicorn dagoeneko instalatuta dago ingurune birtualean."
    else
        echo "Gunicorn ez dago instalatuta. Instalatzen..."
        pip install gunicorn
    fi
    echo ""
    read -p "PULSA ENTER PARA CONTINUAR..."
}
function gunicornKonfiguratu()
{
echo -e " Formulariocitas\n"
}
function jabetasunaetabaimenakEzarri()
{
echo -e " Formulariocitas\n"
}
function flaskaplikazioarentzakosystemdzerbitzuaSortu()
{
echo -e " Formulariocitas\n"
}
function nginxenatakaAldatu()
{
echo -e " Formulariocitas\n"
}
function nginxkonfiguraziofitxategiakKargatu()
{
    echo "NGINX konfigurazio-aldaketak kargatzen..."
    sudo systemctl reload nginx
}
function nginxBerrabiarazi()
{
    echo "NGINX web zerbitzua berrabiarazten..."
    sudo systemctl restart nginx
}
function hostbirtualaProbatu()
{
echo -e " Formulariocitas\n"
}
function nginxlogakIkuskatu()
{
    LOGFILE="/var/log/nginx/error.log"

    if [ -f "$LOGFILE" ]; then
        echo "NGINX error log-aren azken 10 lerroak:"
        tail -n 10 "$LOGFILE"
    else
        echo "Errorea: $LOGFILE ez da existitzen."
    fi
}
function ekoizpenzerbitzarianKopiatu()
{
echo -e " Formulariocitas\n"
}
function sshkonexiosaiakerakKontrolatu()
{
echo -e " Formulariocitas\n"
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
    echo -e "0 Proiektu-fitxategiak paketatu eta konprimatu"
    echo -e "1 Mysql kendu \n"
    echo -e "2 Kokapen berria sortu \n"
    echo -e "3 Proiektu-fitxategiak despaketatu eta deskonprimatu \n"
    echo -e "4 MySQL zerbitzaria instalatu eta abiarazi \n"
    echo -e "5 Datu basearen erabiltzailea sortu \n"
    echo -e "6 Datu basea sortu \n"
    echo -e "7 Lan egingo den ingurune birtuala sortu \n"
    echo -e "8 Ingurune birtualean liburutegiak instalatu \n"
    echo -e "9 Flask-eko zerbitzariarekin proba egin \n"
    echo -e "10 NGINX instalatu \n"
    echo -e "11 NGINX abiarazi \n"
    echo -e "12 NGINX-ko ataka konprobatu \n"
    echo -e "13 Index-a ikusi \n"
    echo -e "14 Index pertsonalizatua erakutsi \n"
    echo -e "15 Gunicorn instalatu \n"
    echo -e "16 Gunicorn konfiguratu \n"
    echo -e "17 Jabetasun eta baimenak ezarri \n"
    echo -e "18 Flask-erako systemd zerbitzua sortu \n"
    echo -e "19 NGINX ataka aldatu \n"
    echo -e "20 NGINX konfigurazio fitxategiak kargatu \n"
    echo -e "21 NGINX berabiarazi \n"
    echo -e "22 Host birtuala probatu \n"
    echo -e "23 NGINX logak ikuskatu \n"
    echo -e "24 Ezkoizpena zerbitzarian kopiatu \n"
    echo -e "25 ssh konexioarekin saiakerak kontrolatu \n"
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
   	 	11) nginxMatxanJarri;;
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
   	 	24) ekoizpenzerbitzarianKopiatu;;
   	 	25) sshkonexiosaiakerakKontrolatu;;
   	 	26) menutikIrten;;
   	 	*) ;;
    esac
done
exit 0

