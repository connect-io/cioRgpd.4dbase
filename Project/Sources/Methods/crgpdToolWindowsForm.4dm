//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : crgpdCreateWindowsFormCenter

Méthode qui permet de centrer un formulaire

Historique
04/02/22 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $1 : Text  // $1 = Nom du formulaire
var $2 : Variant  // $2 = Espace en pixel entre le haut/bas de l'écran et le formulaire [numérique ou objet ou texte]
var $3 : Object  // $3 = Entity Selection [optionnel]
var $4 : Pointer  // $4 = Pointeur de la Table [optionnel]

var $hauteur_el; $largeur_el; $menu_el; $largeurForm_el; $hauteurForm_el; $moitie_el; $refFen_el : Integer

$hauteur_el:=Screen height:C188(*)
$largeur_el:=Screen width:C187(*)

$menu_el:=Menu bar height:C440

If (Count parameters:C259<4)
	FORM GET PROPERTIES:C674($1; $largeurForm_el; $hauteurForm_el)
Else 
	FORM GET PROPERTIES:C674($4->; $1; $largeurForm_el; $hauteurForm_el)
End if 

$moitie_el:=$largeurForm_el/2

Case of 
	: (Value type:C1509($2)=Est un objet:K8:27)
		$refFen_el:=Open window:C153(($largeur_el/2)-$moitie_el; $menu_el+Num:C11($2.ecartHautEcran); ($largeur_el/2)+$moitie_el; $hauteur_el-Num:C11($2.ecartBasEcran); Fenêtre standard:K34:13; ""; "cwToolCloseWindows")
	: (Value type:C1509($2)=Est un entier long:K8:6) | (Value type:C1509($2)=Est un numérique:K8:4)
		$refFen_el:=Open window:C153(($largeur_el/2)-$moitie_el; $menu_el+$2; ($largeur_el/2)+$moitie_el; $hauteur_el-$2; Fenêtre standard:K34:13; ""; "cwToolCloseWindows")
	: (Value type:C1509($2)=Est un texte:K8:3)
		
		Case of 
			: ($2="centerModal")
				$refFen_el:=Open window:C153(($largeur_el/2)-$moitie_el; (($hauteur_el/2)-10)-($hauteurForm_el/2); ($largeur_el/2)+$moitie_el; (($hauteur_el/2)-10)+($hauteurForm_el/2); Form dialogue modal:K39:7; ""; "cwToolCloseWindows")
			: ($2="center")
				$refFen_el:=Open window:C153(($largeur_el/2)-$moitie_el; (($hauteur_el/2)-10)-($hauteurForm_el/2); ($largeur_el/2)+$moitie_el; (($hauteur_el/2)-10)+($hauteurForm_el/2); Fenêtre standard:K34:13; ""; "cwToolCloseWindows")
			: ($2="fullWidth")
				$refFen_el:=Open window:C153(0; $menu_el; $largeur_el; $hauteur_el-$menu_el; Fenêtre standard:K34:13; ""; "cwToolCloseWindows")
		End case 
		
End case 

Case of 
	: (Count parameters:C259=2)
		DIALOG:C40($1)
	: ($3=Null:C1517)
		DIALOG:C40($4->; $1)
	Else 
		
		Case of 
			: (Count parameters:C259=3)
				DIALOG:C40($1; $3)
			: (Count parameters:C259=4)
				DIALOG:C40($4->; $1; $3)
		End case 
		
End case 

CLOSE WINDOW:C154