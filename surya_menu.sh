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
		echo -e "artxiboa ez da existitzen..."
		return 1
	else 
		tar -xzvf formulariocitas.tar.gz -C /var/www/formulariocitas
		echo -e "Artxiboa deskomprimitu da..."
	fi
}

function mysqlInstalatu()
{
	if  dpkg -l | grep -q mysql-server 
	then 
		echo -e "Instalatuta dago \n"
	else 
		sudo apt update
		sudo apt install mysql-server
		echo -e "Instalatu egin da \n"
	fi
	
	if  ! systemctl is-active --quiet mysql
	then 
		sudo systemctl start mysql.service
	fi
	echo -e "Abiarazita dago \n"
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
		echo -e "Erabiltzailea sortuta dago dagoeneko \n"
	fi
		
}

function datubaseaSortu()
{
	sudo mysql -u lsi -p < "/var/www/formulariocitas/script.sql"
	echo -e "Sortu da taula \n"
}

function ingurunebirtualaSortu() 
{
	sudo apt-get update
	sudo apt install python3-dev build-essential libssl-dev libffi-dev python3-setuptools
	sudo apt install python3-venv
	sudo apt install -y python3-pip
	python3 -m venv /var/www/formulariocitas/venv
	source /var/www/formulariocitas/venv/bin/activate
	echo -e "Instalatu egin da guztia \n"
}

function ingurunebirtualeanliburutegiakInstalatu()
{
	source /var/www/formulariocitas/venv/bin/activate
	sudo apt install -y python3-pip
	pip install -r requirements.txt
	echo -e "Liburutegiak instalatu dira \n"
}

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
	
}

function nginxInstalatu()
{
	if dpkg -s | grep -q nginx
	then
		echo -e "\nInstalatuta dago dagoeneko \n"
	else 
		sudo apt update
		sudo apt install nginx
	fi
}

function nginxMatxanJarri()
{
	if systemctl is-active -q nginx
	then
		echo -e "\nAktibatuta dagoeneko\n"
	else
		sudo systemctl start nginx
		echo -e "\nAktibatu egin da \n"
	fi 
		
}

function nginxatakaTesteatu()
{
	if ! dpkg -s | grep -q net-tools
	then 
		sudo apt install net-tools
	fi
	sudo netstat -tulnp | grep nginx
}

function indexIkusi()
{
	firefox http://127.0.0.1 &
}

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
}

function gunicornInstalatu()
{
	if pip list | grep -q gunicorn
	then 
		echo -e "Instalatuta dagoeneko \n"
	else
		source /var/www/formulariocitas/venv/bin/activate
		pip install gunicorn
	fi
}

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

}

function jabetasunaetabaimenakEzzarri()
{
	sudo chmod -R 755 /var/www/formulariocitas
	sudo chmod 600 /var/www/formulariocitas/.env
	sudo chmod 600 /var/www/formulariocitas/app.py
	sudo chown -R www-data:www-data /var/www/formulariocitas
	echo -e "Baimenak eta jabetzak aldatuta \n"
}

function flaskaplikazioarentzakosystemdzerbitzuaSortu()
{
	service='[Unit]
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
	'
	echo "$service" | sudo tee /etc/systemd/system/formulariocitas.service > /dev/null
	sudo systemctl daemon-reload
	if systemctl status formulariocitas.service | grep -q active
	then 
		echo -e "Aktbatuta dago \n"
	else 
		sudo systemctl enable formulariocitas.service	
		echo -e "Aktibatu egin da \n"
	fi
}

function nginxenatakaAldatu()
{
	conf='
	
		server {
    				listen 3128;
				server_name localhost;
	    		location / {
	        		include proxy_params;
	        		proxy_pass  http://127.0.0.1:5000;
	    		}
		}
	
	'
	echo "$conf" | sudo tee /etc/nginx/conf.d/formulariocitas.conf > /dev/null
	
	echo -e "Artxiboa sortu egin da. \n"
	
	#sudo nginx -c /etc/nginx/conf.d/formulariocitas.conf -t
	sudo nginx -t &> /dev/null
	if [ $? -eq 0 ]
	then
		echo -e "Ez dago sintaxi errorerik \n"
	else
		echo -e "Sintaxi errorea detektatuta \n"
	fi
		
}

function nginxkonfiguraziofitxategiakKargatu()
{
	sudo systemctl restart nginx
	echo -e "Kargatu dira aldaketa berriak \n"
}

function nginxBerrabirazi()
{
	sudo systemctl reload nginx
	echo -e "Berrabirazi egin da \n"
}

function hostbirtualaProbatu()
{
	firefox http://127.0.0.1:3128/ &
}

function nginxlogakIkuskatu()
{
	less /var/log/nginx/error.log
}

function ekoizpenzerbitzarianKopiatu()
{
	if ! dpkg -s  | grep -q openssh-server 
	then 
		sudo apt update 
		sudo apt install openssh-server
		echo -e "Instalatu egin da \n"
	else
		echo -e "Instalatuta dagoeneko \n"
	fi
	
	if systemctl status ssh | grep -q active
	then 
		echo -e "Dagoeneko aktibatuta \n"
	else 
		sudo systemctl enable ssh
		echo -e "Aktibatu egin da \n"
	fi
	
	ip -br address
	
	
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
    echo -e "8 Ingurune birtualean liburutegiak instalatu \n"
    echo -e "9 Flaskeko zerbitzariarekin dena probatu \n"
    echo -e "10 nginx instalatu \n"
    echo -e "11 nginx martxan jarri \n"
    echo -e "12 nginx ataka testeatu \n"
    echo -e "13 idex ikusi \n"
    echo -e "14 index pertsonalizatu \n"
    echo -e "15 Gunicron instalatu \n"
    echo -e "16 Gunicron konfiguratu \n"
    echo -e "17 Jabetasuna eta baimenak ezarri \n"
    echo -e "18 Flask aplikazioarentzako systemd zerbitzua sortu \n"
    echo -e "19 Nginx-en ataka aldatu \n"
    echo -e "20 Nginx konfigurazio fitxategia kargatu \n"
    echo -e "21 Nginx berrabirazi \n"
    echo -e "22 Host birtuala probatu \n"
    echo -e "23 Nginx logal iksutatu \n"
    echo -e "24 Ekopizpen zerbitzarian kopiatu \n"
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
   	 8) ingurunebirtualeanliburutegiakInstalatu;;
   	 9) flaskekozerbirariarekindenaProbatu;;
   	 10) nginxInstalatu;;
   	 11) nginxMatxanJarri;;
   	 12) nginxatakaTesteatu;;
   	 13) indexIkusi;;
   	 14) indexPertsonalizatu;;
   	 15) gunicornInstalatu;;
   	 16) gunicornKonfiguratu;;
   	 17) jabetasunaetabaimenakEzzarri;;
   	 18) flaskaplikazioarentzakosystemdzerbitzuaSortu;;
   	 19) nginxenatakaAldatu;;
   	 20) nginxkonfiguraziofitxategiakKargatu;;
   	 21) nginxBerrabirazi;;
   	 22) hostbirtualaProbatu;;
   	 23) nginxlogakIkuskatu;;
   	 24) ekoizpenzerbitzarianKopiatu;;
   	 26) menutikIrten;;
   	 *) ;;
    esac
done
exit 0
