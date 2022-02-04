Class constructor
	
Function getData($collectionToComplete_p : Pointer)
	var $table_t; $champ_t : Text
	var $table_o : Object
	
	$table_t:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue
	$champ_t:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante1")->currentValue
	
	$table_o:=ds:C1482[$table_t].all()
	
	For each ($enregistrement_o; $table_o)
		$collectionToComplete_p->push(New object:C1471)
		
		For each ($propriete_t; $enregistrement_o)
			
			If ($champ_t="Tous les champs") | ($champ_t=$propriete_t)
				$collectionToComplete_p->[$collectionToComplete_p->length-1][$propriete_t]:=$enregistrement_o[$propriete_t]
			End if 
			
		End for each 
		
	End for each 