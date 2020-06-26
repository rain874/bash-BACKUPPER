#!/bin/sh

# bash-backuper
# Version 0.0.1
# License
# GNU General Public License version 3.0 (GPLv3)
# 2017 Rainer Schmitz

# bash-backupper muss angepasst werden. !!!
# erstetzen Sie "DATENBANKNAME" mit der Namen Ihrer der Datenbank
# erstetzen Sie "mySQLPASS" druch Ihr mySQL password


directory=$(ls -1tr --group-directories-first /var/www/backup/directory | tail -n 1)
echo "Aktuellstes Verzeichnis Backup" $directory

# Verzeichnis löschen
rm -r /var/www/html
# Verzeichnis entpacken
unzip /var/www/backup/directory/$directory -d /var/www/

# rechte
chown -R www-data:www-data /var/www/html/*

# Datenbank restore
datenbase=$(ls -1tr --group-directories-first /var/www/backup/database | tail -n 1)
echo "Aktuellstes Datenbank Backup" $datenbase

mysql --user=root --password=mySQLPASS << EOF
DROP DATABASE DATENBANKNAME;
CREATE DATABASE DATENBANKNAME;
GRANT ALL PRIVILEGES ON DATENBANKNAME.* TO 'root'@'localhost';
EOF
mysql --user=root --password=mySQLPASS DATENBANKNAME < /var/www/backup/database/$datenbase
echo "Datenbank wiederhergestellt"
