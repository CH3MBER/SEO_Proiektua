#!/usr/bin/bash
#0. Ariketa
function proiektufitxategiakPaketatuetaKonprimitu()
{
    cd /home/$USER/formulariocitas
    tar cvzf  /home/$USER/formulariocitas.tar.gz app.py script.sql  .env requirements.txt templates/*
    echo ""
    read -p "ENTER SAKATU..."
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
    echo ""
    read -p "ENTER SAKATU..."
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
    read -p "ENTER SAKATU..."
}

#3. Ariketa
function proiektufitxategiakkokapenberrianKopiatu()
{
    if [ -e /home/$USER/formulariocitas.tar.gz ] 
    then
    	cd /var/www/formulariocitas
    	sudo tar xvzf /home/$USER/formulariocitas.tar.gz
    else
    	echo -e " Ez dago fitxategia."
    fi
    echo ""
    read -p "ENTER SAKATU..."
}

#4. Ariketa
function mysqlInstalatu()
{
    aux=$(sudo dpkg -s mysql-server | grep "Status: install ok installed")
    if [ -z "$aux" ]; then
	sudo apt update
	sudo apt install mysql-server
	echo -e "Instalatu egin da \n"
    fi
	
    if  ! systemctl is-active --quiet mysql
    then 
	sudo systemctl start mysql.service
    fi
    echo -e "Abiarazita dago \n"
    echo ""
    read -p "ENTER SAKATU..."
}

#5. Ariketa
function datubasekoerabiltzaileaSortu()
{
   SQL_SCRIPT="$HOME/datubasekoerabiltzaileasortu.sql"

    echo "CREATE USER 'lsi'@'localhost' IDENTIFIED BY 'lsi';" > "$SQL_SCRIPT"
    echo "GRANT CREATE, ALTER, DROP, INSERT, UPDATE, INDEX, DELETE, SELECT, REFERENCES, RELOAD ON *.* TO 'lsi'@'localhost' WITH GRANT OPTION;" >> "$SQL_SCRIPT"
    echo "FLUSH PRIVILEGES;" >> "$SQL_SCRIPT"

    echo "Erabiltzailea sortzeko SQL script-a sortu da hemen: $SQL_SCRIPT"
    echo "Exekutatzen: sudo mysql < $SQL_SCRIPT"
    sudo mysql < "$SQL_SCRIPT"
    echo ""
    read -p "ENTER SAKATU..."
}

#6. Ariketa
function datubaseaSortu()
{
    sudo mysql -u lsi -p < /var/www/formulariocitas/script.sql
    #konprobaketa sar daiteke
    echo ""
    read -p "ENTER SAKATU..."
}

#7.Ariketa
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
    read -p "ENTER SAKATU..."
}

#8. Ariketa
function ingurunebirtualeanliburutegiakInstalatu()
{
    cd /var/www/formulariocitas
    echo "Ingurune birtuala aktibatzen..."
    python3 -m venv venv
    source /var/www/formulariocitas/venv/bin/activate
    sudo apt install -y python3-pip
    pip install -r /var/www/formulariocitas/requirements.txt
    echo ""
    read -p "ENTER SAKATU..."
}

#9. Ariketa
function flaskekozerbirariarekindenaProbatu()
{
    source /var/www/formulariocitas/venv/bin/activate
    if ls -lias | grep app.py
    then
    	python3 app.py &
    	firefox http://127.0.0.1:5000/ &
    else 
    	echo -e "\napp.py ez da existitzen \n"
    fi
    echo ""
    read -p "ENTER SAKATU..."
}

#10. Ariketa
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
    read -p "ENTER SAKATU..."
}

#11. Ariketa
function nginxMatxanJarri()
{
    if systemctl is-active -q nginx
    then
    	echo -e "Aktibatuta dagoeneko\n"
    else
    	sudo systemctl start nginx
    	echo -e "Aktibatu da\n"
    fi
    echo ""
    read -p "ENTER SAKATU..."
}

#12. Ariketa
function nginxatakaTesteatu()
{
    aux=$(sudo dpkg net-tools | grep "Status: install ok installed")
    if [ -z "$aux" ]; then
	sudo apt install net-tools
    fi
    sudo netstat -tulnp | grep nginx
    echo ""
    read -p "ENTER SAKATU..."
}

#13. Ariketa
function indexIkusi()
{
    firefox http://127.0.0.1 &
    echo ""
    read -p "ENTER SAKATU..."
}

#14. Ariketa
function indexPertsonalizatu()
{
    index='<!DOCTYPE html>
	<html>
	<head>
	<title>GL2-ko bakarrak</title>
	</head>
	<body>
	<center>
	<h1>Taldea: GL2-ko bakarrak</h1>
	<br>
	<h2>Azpitaldea: Astearteak</h2>
	</center>
	<br>
	<table border="2" align="center">
		<thead>
			<tr>
				<th>Izena</th>
				<th>Abizenak</th>
				<th>Posta elektronikoa</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>Surya</th>
				<td>Ortega Aguirre</th>
				<td>sortega024@ikasle.ehu.eus</th>
			</tr>
			<tr>
				<td>Gaizka</th>
				<td>Divasson Jaureguibarria</th>
				<td>gdivasson001@ikasle.ehu.eus</th>
			</tr> 
			<tr>
				<td>Asier</th>
				<td>Barrio Borge</th>
				<td>abarrio028@ikasle.ehu.eus</th>
			</tr>
			<tr>
				<td>Asier</th>
				<td>Las Hayas Fernández</th>
				<td>alashayas001@ikasle.ehu.eus</th>
			</tr>
			<tr>
				<td>Uriel</th>
				<td>Martin Pulido</th>
				<td>umartin025@ikasle.ehu.eus</th>
			</tr>
		</tbody>
	</table>
	<center>
	<br>
	<h2>Taldeburua:</h2>
	<p>Surya Ortega Aguirre</p>
	<p>sortega024@ikasle.ehu.eus</p>
	</center>
	</body>
	</html>'
    echo "$index" > index.html
    sudo mv index.html /var/www/html
    firefox http://127.0.0.1/index.html &
    echo ""
    read -p "ENTER SAKATU..."
}

#15. Ariketa
function gunicornInstalatu()
{
    if pip list | grep -q gunicorn; then
        echo "Gunicorn dagoeneko instalatuta dago ingurune birtualean."
    else
        echo "Gunicorn ez dago instalatuta. Instalatzen..."
        source /var/www/formulariocitas/venv/bin/activate
        pip install gunicorn
    fi
    echo ""
    read -p "ENTER SAKATU..."
}

#16. Ariketa
function gunicornKonfiguratu()
{
    if ! ls -lias | grep -q wsgi.py
    then 
	wsgi='from app import app 
		if __name__ == "__main__":
			app.run()'
	echo "$wsgi" > wsgi.py
    fi
    source /var/www/formulariocitas/venv/bin/activate
    /var/www/formulariocitas gunicorn --bind 127.0.0.1:5000 wsgi:app
    firefox http://127.0.0.1:5000 &
    echo ""
    read -p "ENTER SAKATU..."
}

#17. Ariketa
function jabetasunaetabaimenakEzarri()
{
    PROIEKTUA="/var/www/formulariocitas"
    
    if [ ! -d "$PROIEKTUA" ]; then
    	echo -e "'$PROIEKTUA' karpeta ez da existitzen"
    	return 1
    fi
    sudo chmod -R 755 /var/www/formulariocitas
    sudo chmod 600 /var/www/formulariocitas/.env
    sudo chmod 600 /var/www/formulariocitas/app.py
    sudo chown -R www-data:www-data /var/www/formulariocitas
    echo -e "Baimenak eta jabetzak aldatu dira \n"
    echo ""
    read -p "ENTER SAKATU..."

}

#18. Ariketa
function flaskaplikazioarentzakosystemdzerbitzuaSortu()
{
    FITXATEGIA="/etc/systemd/system/formulariocitas.service"
    
     sudo tee "$FITXATEGIA" > /dev/null <<EOF
	[Unit]
	Description=Gunicorn instance to serve formulariocitas
	After=network.target
	[Service]
	User=www-data
	Group=www-data
	WorkingDirectory=/var/www/formulariocitas
	Environment="PATH=/var/www/formulariocitas/venv/bin"
	ExecStart=/var/www/formulariocitas/venv/bin/gunicorn --bind 127.0.0.1:5000 wsgi:app
	[Install]
	WantedBy=multi-user.target
EOF
	
    sudo systemctl daemon-reload
    sudo systemctl enable formulariocitas.service
    sudo systemctl start formulariocitas.service
    echo ""
    read -p "ENTER SAKATU..."
}

#19. Ariketa
function nginxenatakaAldatu()
{
    kodea='server {listen 3128;server_name localhost;location / {include proxy_params;proxy_pass  http://127.0.0.1:5000;}}'
    echo "$kodea" | sudo tee /etc/nginx/conf.d/formulariocitas.conf > /dev/null
    sudo nginx -t &> /dev/null
    if [ $? -eq 0 ]
    then
	echo -e "Ez dago sintaxi errorerik \n"
    else
    	echo -e "Sintaxi errorea detektatuta \n"
    fi
    echo ""
    read -p "ENTER SAKATU..."
}

#20. Ariketa
function nginxkonfiguraziofitxategiakKargatu()
{
    echo "NGINX konfigurazio-aldaketak kargatzen..."
    sudo systemctl reload nginx
    echo ""
    read -p "ENTER SAKATU..."
}

#21. Ariketa
function nginxBerrabiarazi()
{
    echo "NGINX web zerbitzua berrabiarazten..."
    sudo systemctl restart nginx
    echo ""
    read -p "ENTER SAKATU..."
}

#22. Ariketa
function hostbirtualaProbatu()
{
    firefox http://127.0.0.1:3128/ &
    echo ""
    read -p "ENTER SAKATU..."
}

#23. Ariketa
function nginxlogakIkuskatu()
{
    LOGFILE="/var/log/nginx/error.log"

    if [ -f "$LOGFILE" ]; then
        echo "NGINX error log-aren azken 10 lerroak:"
        tail -n 10 "$LOGFILE"
    else
        echo "Errorea: $LOGFILE ez da existitzen."
    fi
    echo ""
    read -p "ENTER SAKATU..."
}
	
#24. Ariketa
function ekoizpenzerbitzarianKopiatu()
{
    aux=$(sudo dpkg -s openssh-server | grep "Status: install ok installed")
    if [ -z "$aux" ]; then
        sudo apt update
	sudo apt install openssh-server
    else
	echo "Instalatuta dago"
    fi
    	echo ""

    if systemctl is-active -q ssh
    then
    	echo -e "Aktibatuta dagoeneko\n"
    else
    	sudo systemctl start ssh
    	echo -e "Aktibatu da\n"	
    fi	
    	
    sudo ufw allow ssh	
    read -p "IP helbidea sartu" ip	
    #ip="127.0.0.1"
    ssh $USER@$ip
    #exit
    
    scp -r /home/$USER/formulariocitas.tar.gz $USER@$ip:/tmp
    scp -r /home/$USER/menu.sh $USER@$ip:/tmp

    echo ""
    read -p "ENTER SAKATU..."
}

#25. Ariketa
function sshkonexiosaiakerakKontrolatu()
{
    cat /var/log/auth.log > auth.log.txt
    less auth.log.txt | tr -s ' ' '@' > auth.log.ilarazka.txt
    txarto="Failed@password"
    ondo="Accepted@password"
    echo -e "Konexio saiakerak gaur, aste honetan eta hilabete honetan hauek izan dira:\n"
    echo -e "____________________________\n"
    for linea in `less auth.log.ilarazka.txt | grep $txarto`
    do
	erabiltzailea=`echo $linea | cut -d@ -f15`
	agindua=`echo $linea | cut -d@ -f6`
	eguna=`echo $linea | cut -d@ -f2`
	hilabetea=`echo $linea | cut -d@ -f1`
	ordua=`echo $linea | cut -d@ -f3`
	echo -e "$hilabetea\t$eguna\t$ordua\t$erabiltzailea\t$agindua\n"
    done
    rm auth.log.txt auth.log.ilarazka.txt
    
    echo ""
    read -p "ENTER SAKATU..."
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

