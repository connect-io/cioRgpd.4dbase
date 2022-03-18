//%attributes = {}
/*------------------------------------------------------------------------------
Méthode : crpdToolJsoncToJson

Converti du JSONC en JSON

Historique
01/10/20 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
------------------------------------------------------------------------------*/

// Déclarations
var $0 : Text  // Texte en format JSON
var $1 : Text  // Texte en format JSONC

var $textOut_t : Text

$textOut_t:=$1
$textOut_t:=crgpdToolTextReplaceByRegex($textOut_t; "\\/\\*(.*?)\\*\\/"; "")
$textOut_t:=crgpdToolTextReplaceByRegex($textOut_t; "[^:\"]\\/\\/(.*?)##r"; "##r")

$0:=$textOut_t
