#!/bin/bash
# -*- coding: utf-8 -*-


VERSION=0.1
NAME=$(basename $0)
NM=$0
AUTHOR="@svg153, @mrgarri, @roberseik (based on garquiscript.sh)"

UPDATE_source=
EDSU1516_source=http://laurel.datsi.fi.upm.es/~ssoo/SD.dir/practicas/edsu.tgz

CUR_DIR="$(pwd)"
bold=`tput bold`
normal=`tput sgr0`

USO="Usage:  ${bold}$0 { -h | --help | --compile[-in|-ed|-su] }"

FICH_IN_IN=intermediario.c
FICH_IN_CO=comun.c
FICH_IN_COh=comun.h
FICH_IN_dir=./intermediario/
#@TODO: FICH_IN={ ${FICH_IN_dir}${FICH_IN_*} } 
# -> expanda variables para que salga "./intermediario/intermediario.c ./intermediario/comun.c ./intermediario/comun.h"

FICH_ED_ED=editor.c
FICH_ED_TEST=test_editor.sh
FICH_ED_TEST_AVANZ=test_editor_avanz.sh
FICH_ED_dir=./editor/
#@TODO: FICH_ED={ ${FICH_ED_dir}${FICH_ED_ED} }

FICH_SU_SU=subscriptor.c
FICH_SU_edsuCO=edsu_comun.c
FICH_SU_edsuCOh=edsu_comun.h
FICH_SU_TEST=test_subscriptor.sh
FICH_SU_TEST_AVANZ=test_subscriptor_avanz.sh
FICH_SU_dir=./subscriptor/
#@TODO: FICH_SU={ ${FICH_SU_dir}${FICH_SU_SU} }

#@TODO: FICHEROS_BASE={ ${FICH_IN_IN} ${FICH_ED_ED} ${FICH_SU_SU} }

#@TODO: FICHEROS_ENVIAR={ ${FICH_IN} ${FICH_ED} ${FICH_SU} }
#@TODO: FICHEROS_TEST={ ${FICH_IN} ${FICH_ED} ${FICH_SU} }
#@TODO: FICHEROS_TEST_AVAN={ ${FICH_IN} ${FICH_ED} ${FICH_SU} }
#FICHEROS_ENVIAR=./intermediario/intermediario.c ./intermediario/comun.c ./intermediario/comun.h ./subscriptor/subscriptor.c ./subscriptor/edsu_comun.c ./subscriptor/edsu_comun.h ./editor/editor.c


CO="-c"
COMP="--compile"
HE="-h"
HELP="--help"
CIN="-cin"
CINTER="--compile-intermediario"
CSU="-csu"
CSUBSC="--compile-subscriptor"
CED="-ced"
CEDITO="--compile-editor"



#### Comando para poder renombrar las tabs de guake
# gconftool-2 --set /apps/guake/general/use_vte_titles --type boolean false
# http://askubuntu.com/questions/254566/annoying-autorenaming-in-guake



function mostrar_descargando {
	echo -ne "Downloading files.  \r"
	sleep 0.5
	echo -ne "Downloading files.. \r"
	sleep 0.5
	echo -ne "Downloading files...\r"
	sleep 0.5
}

function download {
	wget --quiet --output-document=$1 $2 &
	while [[ $(ps | grep -c "wget") -gt 0 ]]
		do
			mostrar_descargando
	done
	printf "\rDone!                    \n"
}

function actualizar {
	# Download new version
	download $CUR_DIR/$NAME.tmp $UPDATE_source
	# Copy over modes from old version
	OCTAL_MODE=$(stat -c '%a' $0)
	chmod $OCTAL_MODE $CUR_DIR/$NAME.tmp
	# Overwrite old file with new
	mv -f $CUR_DIR/$NAME.tmp $NAME
	
	if [[ $? == 0 ]]
		then
			
			NEWVER=$(head ${NM} | grep "VERSION=" | sed 's/[^0-9.]//g')
			if [[ $NEWVER != $VERSION ]]
				then
					echo "Succesfully updated to version $NEWVER!"
				else
					echo "No updates found."
			fi
			exit 0
		else
			echo "There was an error performing the update, please try again later. Exit code: $?"
			exit 1
	fi
}



function texto_uso {
	echo "${USO}\n"
}

function mostrar_uso {
	texto_uso
    exit 1
}



function print_opciones {
	printf "\t${bold}-r or --run:${normal} Ejecuta: , abriendo 2 terminales.\n"
	printf "\t${bold}-ra or --run-avanced:${normal} Ejecuta: intermediario.c, subcriptor.c, editor.c, abriendo 3 terminales.\n"
	printf "\t${bold}-e or --send:${normal} Envia: los fichero: \"${FICHEROS_ENVIAR}\" a su cuenta de \"nMat@triqui3.fi.upm.es:~/DATSI/SD/EDSU.2015/\" .\n"
	printf "\t${bold}-c or --compile:${normal} Compila: \"${FICH_BASE}\".\n"
	printf "\t${bold}$CIN or $CINTER:${normal} Compila: \"${FICH_IN_IN}\" .\n"
	printf "\t${bold}$CED or $CEDITO:${normal} Compila: \"${FICH_ED_ED}\" .\n"
	printf "\t${bold}$CSU or $CSUBSC:${normal} Compila: \"${FICH_SU_SU}\" .\n"	
}

function print_otras_opciones {
	printf "\t${bold}-h or --help:${normal} Muestra el texto de uso o ayuda.\n"
	printf "\t${bold}-v or --version:${normal} Muestra la version actual del script.\n"
	printf "\t${bold}-u or --update:${normal} Actualiza el script a la ultima version.\n"
}

function print_acciones_script {
	printf "Compila y ejecuta los archivos: intermediario.c, subcriptor.c, editor.c.\n"
	printf "Enviar los ficheros ${FICHEROS} a tu cuenta de triqui.fi.upm.es\n"
}

function mostrar_ayuda {
	print_acciones_script
	textto_uso
	
	echo "OPCIONES:"
		print_opciones
		printf "\n"
		
	echo "Otras opciones:"
		print_opciones
		printf "\n"
	
	printf "You can ask my cat now how this script works and she'll just meaow you.\n"
	printf "\n"
	
	exit 1	
}

function compilar_intermediario {
	cd ./intermediario
	make
	cd ..
}

function compilar_editor {
	cd ./editor
	make
	cd ..
}

function compilar_subscriptor {
	cd ./subscriptor
	make
	cd ..
}

function compilar_all {
	compilar_intermediario
	compilar_editor
	compilar_subcriptor
}


function print_info_envio {
	printf "Se van a enviar los ficheros:\n"
	printf "\t${bold}\"${FICHEROS_ENVIAR}\"\n"
	printf "a su cuenta de:\n"
	printf "\t${bold}\"nMat@triqui3.fi.upm.es:~/DATSI/SD/EDSU.2015/\"\n"
	printf "para ello, tendrá que instroduccir su contraseña para poder enviarlos al servidor.\n"
	printf "${bold}{¿Esta seguro de querer continuar? [Y/n].}\n"
}

function enviar_aTriqui {

	printf "Por favor introucca su cuenta en triqui. Ejemplo: t110025.\n"
	printf "\n"
				
	while [[ -z "$USER" ]] ; do
		read USER_IMPUT
		if [[ $input == "N" || $input == "n" || $input == "" ]] ; then
			printf "${bold}No se realizara el envio.\n"
			printf "Se cerrara el script.\n"
			printf "Adios.\n"
			exit 1
		else
			printf "${bold}Por favor, introduca un caracter valido [Y/n].\n"
		fi
	done
	
	scp ${FICHEROS_ENVIAR} $USER@triqui3.fi.upm.es:~/DATSI/SD/EDSU.2015/
}

function aTriqui {
	print_info_envio

	while [[ -z "$USER_IMPUT" ]] ; do
		read USER_IMPUT
		if [[ $USER_IMPUT == "N" || $USER_IMPUT == "n" || $USER_IMPUT == "" ]] ; then
			printf "${bold}No se realizara el envio.\n"
			printf "Se cerrara el script.\n"
			printf "Adios.\n"
			exit 1		
		elif [[ $input == "Y" || $input == "y" ]] ; then
			enviar_aTriqui
		else
			printf "${bold}Por favor, introduca un caracter valido [Y/n].\n"
		fi
	done
		

	
}




case "$1" in
	"$HE")
    	mostrar_uso
    	exit 1
        ;;
    "$HELP")
    	mostrar_ayuda
    	exit 1
        ;;
        
    "$CO" | "$COMP")
        compilar_all
        exit 0
        ;;
     
    "$CIN" | "$CINTER")
        compilar_intermediario
        exit 0
        ;;
       
    "$CED" | "$CEDITO")
	    compilar_editor
        exit 0
        ;;
        
    "$CSU" | "$CSUBSC")
		compilar_subcriptor
		exit 0
        ;;
        
    *)
        mostrar_ayuda
        exit 1
        
esac



