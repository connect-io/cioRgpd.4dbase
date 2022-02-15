var $champ_t : Text
var $continue_b : Boolean
var $element_o; $enregistrement_o : Object

ASSERT:C1129(Storage:C1525.rgpd#Null:C1517; "La méthode crgpdStart doit être exécuter sur démarrage de la base")

$continue_b:=(Storage:C1525.rgpd#Null:C1517)

If ($continue_b=True:C214)
	
	If (Form:C1466.elementSelection.length>0)
		CONFIRM:C162("Souhaitez-vous vraiment anonymiser "+Choose:C955(Form:C1466.elementSelection.length>1; "les "+String:C10(Form:C1466.elementSelection.length)+" enregistrements sélectionnés"; "l'enregistrement sélectionné")+" ?"; "Valider"; "Annuler")
		
		If (OK=1)
			
			If ($champ_t#"Tous les champs")
				
			End if 
			
			crgpdToolProgressBar(0; "Initialisation"; True:C214)
			
			For each ($element_o; Form:C1466.elementSelection)
				crgpdToolProgressBar((Form:C1466.elementSelection.indexOf($element_o)+1)/Form:C1466.elementSelection.length; "Anonymisation de votre sélection en cours..."; True:C214)
				
				$enregistrement_o.get($element_o.ID)
				
				If ($enregistrement_o#Null:C1517)
					$champ_t:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante1")->currentValue
					
					If ($champ_t#"Tous les champs")
						
					End if 
					
				End if 
				
			End for each 
			
		End if 
		
		crgpdToolProgressBar(1; "arrêt")
		POST OUTSIDE CALL:C329(Current process:C322)
	Else 
		ALERT:C41("Merci de sélectionner un/ou plusieurs enregistrements")
	End if 
	
End if 