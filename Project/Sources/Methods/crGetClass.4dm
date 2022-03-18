//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : crGetClass

Renvoie une class vers la base hôte.

Historique
04/02/22 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $1 : Text  // Nom de la classe à renvoyer.
var $0 : Object  // Objet de la class

ASSERT:C1129($1#""; "La variable $1 est vide.")

$1:=Uppercase:C13(Substring:C12($1; 1; 1))+Substring:C12($1; 2)

$0:=cs:C1710[$1]