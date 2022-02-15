/* -----------------------------------------------------------------------------
Class : cs.RGPDDisplay

Class de gestion du formulaire d'anonymisation

-----------------------------------------------------------------------------*/

Class constructor
	
Function getData($collectionToComplete_p : Pointer)
	var $table_t; $champ_t : Text
	var $table_o : Object
	
	$table_t:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue
	$champ_t:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante1")->currentValue
	
	$table_o:=ds:C1482[$table_t].all()
	
	crgpdToolProgressBar(0; "Initialisation"; True:C214)
	
	For each ($enregistrement_o; $table_o) Until (progressBar_el=0)
		crgpdToolProgressBar(($enregistrement_o.indexOf($table_o)+1)/$table_o.length; "Extraction des données en cours..."; True:C214)
		
		$collectionToComplete_p->push(New object:C1471)
		
		For each ($propriete_t; $enregistrement_o)
			
			If ($champ_t="Tous les champs") | ($champ_t=$propriete_t)
				$collectionToComplete_p->[$collectionToComplete_p->length-1][$propriete_t]:=$enregistrement_o[$propriete_t]
				$collectionToComplete_p->[$collectionToComplete_p->length-1].type:=Value type:C1509($enregistrement_o[$propriete_t])
				$collectionToComplete_p->[$collectionToComplete_p->length-1].ID:=$enregistrement_o.getKey()
			End if 
			
		End for each 
		
	End for each 
	
	crgpdToolProgressBar(1; "arrêt")
Function resizeWindows($nbColonne_el : Integer; $refFenetre_el : Integer)
	var $gauche_el; $haut_el; $bas_el; $droite_el; $moitie_el; $largeur_el; $largeurForm_el; $hauteurForm_el; $gaucheCalcul_el; $droiteCalcul_el : Integer
	
	$largeur_el:=Screen width:C187(*)
	
	$droiteCalcul_el:=610+(150*($nbColonne_el-1))
	OBJECT SET COORDINATES:C1248(*; "List Box"; 240; 60; Choose:C955($droiteCalcul_el<=$largeur_el; $droiteCalcul_el; $largeur_el-20))
	
	GET WINDOW RECT:C443($gauche_el; $haut_el; $droite_el; $bas_el; $refFenetre_el)
	FORM GET PROPERTIES:C674("FormAnonymisation"; $largeurForm_el; $hauteurForm_el)
	
	$largeurForm_el:=$largeurForm_el+(150*($nbColonne_el-1))
	
	If ($largeurForm_el>$largeur_el)
		$largeurForm_el:=$largeur_el-20
	End if 
	
	$moitie_el:=$largeurForm_el/2
	$gaucheCalcul_el:=($largeur_el/2)-$moitie_el
	
	If ($gaucheCalcul_el<0)  // La Fenêtre va être plus large que la largeur de l'écran...
		$droiteCalcul_el:=$largeur_el-Abs:C99($gaucheCalcul_el)
	Else 
		$droiteCalcul_el:=($largeur_el/2)+$moitie_el
	End if 
	
	SET WINDOW RECT:C444(Abs:C99($gaucheCalcul_el); $haut_el; $droiteCalcul_el; $bas_el; $refFenetre_el; *)
	LISTBOX SET COLUMN WIDTH:C833(*; "List Box"; 150)