//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : crgpdToolDeleteProperty

Méthode qui permet de supprimer plusieurs propriétés d'un objet

Historique
04/02/22 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $1 : Object
var ${2} : Text

var $i_el : Integer

For ($i_el; 2; Count parameters:C259)
	OB REMOVE:C1226($1; ${$i_el})
End for 