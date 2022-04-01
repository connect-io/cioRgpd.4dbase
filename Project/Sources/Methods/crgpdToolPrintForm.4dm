//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : crgpdToolPrintForm

Méthode qui permet d'imprimer un formulaire projet

Historique
04/02/22 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $1 : Text  // Nom du formulaire projet

var $i_el : Integer
var $print_b : Boolean

ARRAY TEXT:C222($formObject_at; 0)
ARRAY POINTER:C280($formVariable_ap; 0)

PRINT SETTINGS:C106(Dialogue impression:K47:17)

OPEN PRINTING JOB:C995
FORM LOAD:C1103($1; *)

FORM GET OBJECTS:C898($formObject_at; $formVariable_ap)

For ($i_el; 1; Size of array:C274($formObject_at))
	$print_b:=Print object:C1095(*; $formObject_at{$i_el})
End for 

CLOSE PRINTING JOB:C996