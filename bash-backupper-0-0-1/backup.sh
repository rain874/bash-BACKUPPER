#!/bin/sh

# bash-backupper
# Version 0.0.1 
# License
# GNU General Public License version 3.0 (GPLv3)
# 2017 Rainer Schmitz

# prüfen ob zip installiert ist
if [ $(dpkg-query -W -f='${Status}' zip 2>/dev/null | grep -c "ok zip ist installiert") -eq 0 ];
then
  apt-get install zip;
fi

# prüfen on sshpass installiert ist 
if [ $(dpkg-query -W -f='${Status}' sshpass 2>/dev/null | grep -c "ok sshpass installiert") -eq 0 ];
then
  apt-get install sshpass;
fi

# prüfen ob verzeichnisse vorhanden sind
if [ -d /var/www/backup/directory ] ; then
echo "Directory Verzeichnis vorhanden"
else
mkdir /var/www/backup/directory
fi

if [ -d /var/www/backup/database ] ; then
echo "Database Verzeichnis vorhanden"
else
mkdir /var/www/backup/database
fi

# Erstellt ein zip von html und kopiert in directory
zip -r html.zip html
mv html.zip /var/www/backup/directory/

# Starte zweites Script
bash /var/www/backup/mysql_directory_store.sh

