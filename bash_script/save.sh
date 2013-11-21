#!/bin/bash

dd_ext="chupacabra"
taille_max=5000

echo "" >> ~/.tempo.txt
date >> ~/.tempo.txt

###################################
##### sauvegarde de HOME ##########
###################################

cd ~

###### gooogle !!!!!!!! ######
test -e libpeerconnection.log && rm -f libpeerconnection.log

# sauvegarde du home
tar -uvf ~/.sauvegarde.tar $(ls | grep -v -e "^Documents$" -e "^T.*ements$" -e "^workspace$" -e "netbeans-" -e "glassfish-" ) >> .tempo.txt

# je ne sauvegarde que les petits fichiers
for nom_fic in Documents/* Téléchargements/*
do
	# je calcule la taille de chaque fichier lu
	taille_fic=$(echo $(du "$nom_fic") | cut -d " " -f1) ;

	# si le fichier n est pas trop gros (< $taille_max) alors je sauvegarde
	if [ -n "$taille_fic" ];then
		if [ "$taille_fic" -lt "$taille_max" ];then
			tar -uvf ~/.sauvegarde.tar "$nom_fic" >> .tempo.txt
		fi
	fi
done

# je ne sauvegarde pas metadata de workspace
for nom_fic in workspace/*
do
	# si le fichier n est pas ".metadata" alors je sauvegarde
	if [ ! $( echo "$nom_fic" | grep -e "metadata" ) ];then
		tar -uvf ~/.sauvegarde.tar "$nom_fic" >> .tempo.txt
	fi
done

###################################
## sauvegarde des peripheriques ###
###################################

cd /media/$LOGNAME/

#je verifie si des peripheriques sont branchés
if [ $(ls | wc -l) -gt 0 ];then
	for i in $(ls)
	do
		echo "*******    appareil détecté : "$i"    *******" >> ~/.tempo2.txt
		# je ne sauvergarde pas le backup du dd_ext ni son fichier texte
		for u in $(ls -A "$i" | grep -v -e "^.sauvegarde.tar$" -e "^.texte_sauvegarde_e.txt$")
		do
			tar -uvf ~/.sauvegarde_perif.tar "$i"/"$u" >> ~/.tempo2.txt
		done
	done

	#je m'adapte a qui lance le script (moi ou le systeme)
	test -z "$USER" && taille_texte=4 || taille_texte=1

	# si .tempo_e.txt n est pas vide alors il y a eu des fichiers enregistrés
	if [ $(more ~/.tempo2.txt | wc -l ) -gt "$taille_texte" ];then
		cat ~/.tempo2.txt >> ~/.tempo.txt
	fi

	rm -f ~/.tempo2.txt

fi

###################################
##### sauvegarde DD externe #######
###################################

# je verifie que le dd externe est bien branché
if [ -e /media/$LOGNAME/$dd_ext ];then
	cd ~

	echo "" >> /media/$LOGNAME/$dd_ext/.tempo_e.txt
	date >> /media/$LOGNAME/$dd_ext/.tempo_e.txt

	# sauvegarde du home
	tar -uvf /media/$LOGNAME/$dd_ext/.sauvegarde.tar $(ls | grep -v -e "^Documents$" -e "^T.*ments$" -e "^workspace$" -e "netbeans-" -e "glassfish-" ) >> /media/$LOGNAME/$dd_ext/.tempo_e.txt

	# je ne sauvegarde que les petits fichiers
	for nom_fic in Documents/* Téléchargements/*
	do
		# je calcule la taille de chaque fichier lu
		taille_fic=$(echo $(du "$nom_fic") | cut -d " " -f1) ;
		# si le fichier n est pas trop gros (< $taille_max) alors je sauvegarde
		if [ -n "$taille_fic" ];then
			if [ "$taille_fic" -lt "$taille_max" ];then
				tar -uvf /media/$LOGNAME/$dd_ext/.sauvegarde.tar "$nom_fic" >> /media/$LOGNAME/$dd_ext/.tempo_e.txt
			fi
		fi
	done

	# je ne sauvegarde pas metadata de workspace
	for nom_fic in workspace/*
	do
		# si le fichier n est pas ".metadata" alors je sauvegarde
		if [ ! $( echo "$nom_fic" | grep -e "metadata" ) ];then
			tar -uvf ~/.sauvegarde.tar "$nom_fic" >> .tempo.txt
		fi
	done

	#je m'adapte a qui lance le script (moi ou le systeme)
	test -z "$USER" && taille_texte=5 || taille_texte=2

	# si .tempo_e.txt n est pas vide alors il y a eu des fichiers enregistrés
	if [ $(more /media/$LOGNAME/$dd_ext/.tempo_e.txt | wc -l) -gt "$taille_texte" ];then
		cat  /media/$LOGNAME/$dd_ext/.tempo_e.txt >> /media/$LOGNAME/$dd_ext/.texte_sauvegarde_e.txt
		echo "La sauvegarde externe a bien été faite" >> .tempo.txt
	fi

	rm -f /media/$LOGNAME/$dd_ext/.tempo_e.txt

fi

###################################
#### ecriture de l execution ######
###################################

#je m'adapte a qui lance le script (moi ou le systeme)
test -z "$USER" && taille_texte=5 || taille_texte=2

# si .tempo.txt n est pas vide alors il y a eu des fichiers enregistrés
if [ $(more ~/.tempo.txt | wc -l ) -gt $taille_texte ];then
	cat ~/.tempo.txt >> ~/.texte_sauvegarde.txt
fi

rm -f ~/.tempo.txt

exit 0

