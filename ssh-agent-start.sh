#!/bin/bash
#------------------------------------------------------------------------------
# Copyright (C) 2014 by Samuel Garcia
# samugarcia.it at gmail dot com  -  www.samugarcia.com
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#------------------------------------------------------------------------------
# Script para iniciar ssh-agent y recuperar sesiones anteriores desde que se
# arranco el sistema.
#
# version 1
#------------------------------------------------------------------------------
# Este script debe ejecutarse en modo source:
# source /ruta/ssh-agent-start.sh
#------------------------------------------------------------------------------

# Ruta hacia este script. En modo source no funciona utilizar $0 como base para
# esto.
RUTA=${BASH_SOURCE%/*}

# Ejecutar el script temporal de arranque preexistente, sea valido, o sea de un
# reinicio anterior y ya no valido.
source $RUTA/.ssh-agent-temp.sh &> /dev/null

# Si el script temporal es valido, aqui almacena el PID de ssh-agent
PID_ENCONTRADO=`ps -p $SSH_AGENT_PID | grep ssh-agent`

# Si no almacena ningun PID, no hay ninguna sesion ya iniciada.
# En ese caso ejecuta ssh-agent para crear el script temporal, ejecuta luego el
# script temporal, y lo deja preparado para nuevas terminales que se abran.
# Tambien carga la clave privada.
if [ "$PID_ENCONTRADO" == "" ]
then
	ssh-agent > $RUTA/.ssh-agent-temp.sh
	chmod ug+x $RUTA/.ssh-agent-temp.sh
	source $RUTA/.ssh-agent-temp.sh > /dev/null
	echo Iniciada nueva sesión de ssh-agent.
	ssh-add
else
	echo Recuperada sesión anterior de ssh-agent.
fi

# Establece comando para cerrar la sesion de ssh-agent matando el proceso.
alias ssh-agent-stop="kill -9 $SSH_AGENT_PID"
