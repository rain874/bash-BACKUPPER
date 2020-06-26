#!/bin/sh

# bash-backupper
# Version 0.0.1
# License
# GNU General Public License version 3.0 (GPLv3)
# 2017 Rainer Schmitz
# bash-backupper muss angepasst werden. !!!
# erstetzen Sie "YOUSSHPASS" druch Ihr sshpassword
# erstetzen Sie "datenbankNAME" mit der Namen Ihrer der Datenbank
# erstetzen Sie "mySQLPASS" druch Ihr mySQL password
# erstetzen Sie "sshbenutzer@deinsshserver.de" druch Ihren sshbenutzernamen und ssh serveradresse

# Timestamp
datum=$(date +'%Y-%m-%d-%H%M%S')
# umbenennen
mv /var/www/backup/directory/html.zip /var/www/backup/directory/html-$datum.zip

sshpass -p "YOUSSHPASS" scp /var/www/backup/directory/html-$datum.zip sshbenutzer@deinsshserver.de:./backup/directory/

# Datenbank Backup bitte Name der Datenbank bei DBNAME angeben
DBNAME=datenbankNAME
SQLFILE=$DBNAME-${datum}.sql
#mysqldump --login-path=local --opt $DBNAME > /var/www/backup/database/$SQLFILE
# mysqldump --user=root --password --lock-tables --databases $DBNAME > /var/www/backup/database/$SQLFILE
mysqldump --user=root --password=mySQLPASS --lock-tables --databases $DBNAME > /var/www/backup/database/$SQLFILE

# sql Datei auf den BackupServer Kopieren
sshpass -p "YOUSSHPASS" scp /var/www/backup/database/$SQLFILE sshbenutzer@deinsshserver.de:./backup/database/

echo "Verzeichnis und Datenbank wurden gesichert und auf den BackupServer übertragen"

read -p"Möchten Sie sich einen Donwloadlink ausgeben (j/n)" response
if [ "$response" == "j" ]; then
       echo "Verzeichnis Download"
       echo "wget --http-user=backup --http-password=directorypass https://www.deinsshserver.de/backup/directory/"html-$datum.zip""
       echo "Datenbank Download"
       echo "wget --http-user=backup --http-password=directorypass https://www.deinsshserver.de/backup/database/"$SQLFILE""
fi
