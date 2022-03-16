var $champ_t; $table_t : Text
var $element_o; $enregistrement_o; $class_o; $type_o : Object
var $collection_c; $typeData_c : Collection

$collection_c:=New collection:C1472

Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		OBJECT SET ENABLED:C1123(*; OBJECT Get name:C1087(Objet courant:K67:2); False:C215)
	: (Form event code:C388=Sur clic:K2:4)
		$table_t:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue
		$champ_t:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante1")->currentValue
		
		$class_o:=crgpdToolGetClass("RGPDDisplay").new()
		$typeData_c:=$class_o.chooseTypeData()
		
		$collection_c:=$typeData_c.query("type # :1"; "Type par défaut du champ")
		
		If ($collection_c.length>0)
			
			CONFIRM:C162("Souhaitez-vous vraiment anonymiser "+Choose:C955(Form:C1466.data.length>1; "les "+String:C10(Form:C1466.data.length)+" enregistrements"; "l'enregistrement")+" de la table « "+\
				OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue+" » ?"; "Valider"; "Annuler")
			
			If (OK=1)
				crgpdToolProgressBar(0; "Initialisation"; True:C214; "anonyme")
				
				For each ($enregistrement_o; Form:C1466.data) Until (progressBar_el=0)
					crgpdToolProgressBar(($enregistrement_o.indexOf(Form:C1466.data)+1)/Form:C1466.data.length; "Anonymisation de votre sélection en cours..."; True:C214; "anonyme")
					
					$element_o:=New object:C1471("table"; $table_t; "champ"; $champ_t; "primaryKey"; $enregistrement_o.getKey())
					
					If ($champ_t="Tous les champs")
						$element_o.champType:=""
					Else 
						$element_o.champType:=Value type:C1509($enregistrement_o[$champ_t])
					End if 
					
					For each ($type_o; $typeData_c)
						$class_o.applyValue($enregistrement_o; $element_o; $type_o)
					End for each 
					
				End for each 
				
				crgpdToolProgressBar(1; "arrêt")
				
				Form:C1466.changeChamp:=True:C214
				POST OUTSIDE CALL:C329(Current process:C322)
			End if 
			
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 