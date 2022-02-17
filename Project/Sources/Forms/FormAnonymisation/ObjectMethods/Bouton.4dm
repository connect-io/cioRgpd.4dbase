var $champ_t : Text
var $element_o; $enregistrement_o; $class_o; $type_o : Object
var $collection_c; $typeData_c : Collection

$collection_c:=New collection:C1472

Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		OBJECT SET ENABLED:C1123(*; OBJECT Get name:C1087(Objet courant:K67:2); False:C215)
	: (Form event code:C388=Sur clic:K2:4)
		
		If (Form:C1466.elementSelection.length>0)
			CONFIRM:C162("Souhaitez-vous vraiment anonymiser "+Choose:C955(Form:C1466.elementSelection.length>1; "les "+String:C10(Form:C1466.elementSelection.length)+" enregistrements sélectionnés"; "l'enregistrement sélectionné")+" ?"; "Valider"; "Annuler")
			
			If (OK=1)
				$champ_t:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante1")->currentValue
				
				$class_o:=crgpdToolGetClass("RGPDDisplay").new()
				$typeData_c:=$class_o.chooseTypeData()
				
				crgpdToolProgressBar(0; "Initialisation"; True:C214)
				
				For each ($element_o; Form:C1466.elementSelection)
					crgpdToolProgressBar((Form:C1466.elementSelection.indexOf($element_o)+1)/Form:C1466.elementSelection.length; "Anonymisation de votre sélection en cours..."; True:C214)
					$enregistrement_o:=ds:C1482[$element_o.table].get($element_o.primaryKey)
					
					If ($enregistrement_o#Null:C1517)
						
						For each ($type_o; $typeData_c)
							$class_o.applyValue($enregistrement_o; $element_o; $type_o)
						End for each 
						
					End if 
					
				End for each 
				
			End if 
			
			crgpdToolProgressBar(1; "arrêt")
			
			Form:C1466.changeChamp:=True:C214
			POST OUTSIDE CALL:C329(Current process:C322)
		Else 
			ALERT:C41("Merci de sélectionner un/ou plusieurs enregistrements")
		End if 
		
End case 