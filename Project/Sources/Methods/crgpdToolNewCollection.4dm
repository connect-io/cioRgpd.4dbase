//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : crgpdToolNewCollection

Méthode qui permet d'initialiser une collection pour les variables en param

Historique
17/02/22 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var ${1} : Pointer

var $i_el : Integer

For ($i_el; 1; Count parameters:C259)
	${$i_el}->:=New collection:C1472
End for 