//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : crgpdToolMoveObject

Permet de déplacer un ou plusieurs ojets dans un formulaire 4D

Historique
23/02/22 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $1 : Integer
var $2 : Collection

var $element_t : Text

Case of 
	: ($1=0)  // Faire disparaître les objets
		
		For each ($element_t; $2)
			OBJECT SET COORDINATES:C1248(*; $element_t; -9999; -9999)
		End for each 
		
End case 