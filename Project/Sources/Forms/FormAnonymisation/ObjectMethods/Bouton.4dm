var $table_t; $libTypeValue_t : Text

var $element_o; $autreElement_o : Object
var $collection_c; $relation_c : Collection

crgpdToolNewCollection(->$collection_c; ->$relation_c)

Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT SET ENABLED:C1123(*; OBJECT Get name:C1087(Object current:K67:2); False:C215)
		
	: (Form event code:C388=On Clicked:K2:4)
		$table_t:=OBJECT Get pointer:C1124(Object named:K67:5; "dataClassList")->currentValue
		$anonymize_o:=cs:C1710.Anonymization.new($table_t)
		
		// Création d'une collection qui pour chaque champ de la table sélectionnée, on a le type de champ que l'utilisateur a sélectionné
		For each ($element_o; Form:C1466.setDataType)
			$collection_c:=OB Entries:C1720($element_o)
			
			For each ($autreElement_o; $collection_c) Until (Bool:C1537($autreElement_o.value)=True:C214)
				
				If (Value type:C1509($autreElement_o.value)=Is boolean:K8:9)
					If ($autreElement_o.value=True:C214)
						$libTypeValue_t:=$autreElement_o.key
					End if 
				End if 
				
			End for each 
			
			If ($libTypeValue_t="")
				$libTypeValue_t:="Type par défaut du champ"
			End if 
			
			$relation_c.push(New object:C1471("field4D"; $element_o.field4D; "libTypeValue"; $libTypeValue_t))
			CLEAR VARIABLE:C89($libTypeValue_t)
		End for each 
		$relation_c:=$relation_c.query("libTypeValue # :1"; "Type par défaut du champ")
		$anonymize_o.relationUpdate($relation_c)
		
		
		CONFIRM:C162("Souhaitez-vous sauvegarder vos choix pour la dataclasse « "+$table_t+" » et les appliquer automatiquement ultérieurement ?"; "Oui"; "Non")
		If (OK=1)  // Sauvegarde du fichier de config pour une utilisation ultérieure
			$anonymize_o.relationSave()
		End if 
		
		
		If ($anonymize_o.relation_c.length>0)
			CONFIRM:C162("Souhaitez-vous vraiment anonymiser "+Choose:C955(Form:C1466.data.length>1; "les "+String:C10(Form:C1466.data.length)+" entités"; "l'entité")+" de la dataclasse « "+\
				$table_t+" » ?"; "Valider"; "Annuler")
			
			If (OK=1)
				$anonymize_o.go()
			End if 
			
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 