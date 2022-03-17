var $table_t; $type_t : Text

var $configSave_o : 4D:C1709.File
var $element_o; $autreElement_o; $enregistrement_o; $class_o; $type_o : Object
var $collection_c; $typeData_c : Collection

crgpdToolNewCollection(->$collection_c; ->$typeData_c)

Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		OBJECT SET ENABLED:C1123(*; OBJECT Get name:C1087(Objet courant:K67:2); False:C215)
	: (Form event code:C388=Sur clic:K2:4)
		$table_t:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue
		CONFIRM:C162("Souhaitez-vous sauvegarder vos choix pour la table « "+$table_t+" » et les appliquer automatiquement ultérieurement ?"; "Oui"; "Non")
		
		If (OK=1)  // Sauvegarde du fichier de config pour une utilisation ultérieure
			$configSave_o:=Folder:C1567(fk dossier ressources:K87:11; *).file("cioRgpd/configSave.json")
			
			If ($configSave_o.exists=False:C215)
				
				If ($configSave_o.create()=True:C214)
					$content_o:=New object:C1471("detail"; New collection:C1472(New object:C1471("table"; $table_t; "data"; Form:C1466.setDataType)))
					$configSave_o.setText(JSON Stringify:C1217($content_o; *))
				Else 
					ALERT:C41("Le fichier de sauvegarde n'a pas pu être sauvegardé")
				End if 
				
			Else 
				$content_o:=JSON Parse:C1218($configSave_o.getText())
				
				$collection_c:=$content_o.detail.indices("table = :1"; $table_t)
				$remplacer_b:=($collection_c.length=0)
				
				If ($collection_c.length=1)
					CONFIRM:C162("Une sauvegarde pour la table « "+$table_t+" » existe déjà, voulez-vous la remplacer ?"; "Oui"; "Non")
					
					If (OK=1)
						$content_o.detail.remove($collection_c[0])
					End if 
					
					$remplacer_b:=(OK=1)
				End if 
				
				If ($remplacer_b=True:C214)
					$content_o.detail.push(New object:C1471("table"; $table_t; "data"; Form:C1466.setDataType))
					$configSave_o.setText(JSON Stringify:C1217($content_o; *))
				End if 
				
			End if 
			
		End if 
		
		// Création d'une collection qui pour chaque champ de la table sélectionnée, on a le type de champ que l'utilisateur a sélectionné
		For each ($element_o; Form:C1466.setDataType)
			$collection_c:=OB Entries:C1720($element_o)
			
			For each ($autreElement_o; $collection_c) Until (Bool:C1537($autreElement_o.value)=True:C214)
				
				If (Value type:C1509($autreElement_o.value)=Est un booléen:K8:9)
					
					If ($autreElement_o.value=True:C214)
						$type_t:=$autreElement_o.key
					End if 
					
				End if 
				
			End for each 
			
			If ($type_t="")
				$type_t:="Type par défaut du champ"
			End if 
			
			$typeData_c.push(New object:C1471("lib"; $element_o.lib; "type"; $type_t))
			CLEAR VARIABLE:C89($type_t)
		End for each 
		
		$collection_c:=$typeData_c.query("type # :1"; "Type par défaut du champ")
		
		If ($collection_c.length>0)
			CONFIRM:C162("Souhaitez-vous vraiment anonymiser "+Choose:C955(Form:C1466.data.length>1; "les "+String:C10(Form:C1466.data.length)+" enregistrements"; "l'enregistrement")+" de la table « "+\
				$table_t+" » ?"; "Valider"; "Annuler")
			
			If (OK=1)
				$class_o:=crgpdToolGetClass("RGPDDisplay").new()
				crgpdToolProgressBar(0; "Initialisation"; True:C214; "anonyme")
				
				For each ($enregistrement_o; Form:C1466.data) Until (progressBar_el=0)
					
					If (Mod:C98($enregistrement_o.indexOf(Form:C1466.data)+1; 100)=0)  // Tous les 100 enregistrements on met à jour la barre de progression
						crgpdToolProgressBar(($enregistrement_o.indexOf(Form:C1466.data)+1)/Form:C1466.data.length; "Anonymisation de votre sélection en cours..."; True:C214; "anonyme")
					End if 
					
					For each ($type_o; $typeData_c)
						$enregistrement_o[$type_o.lib]:=$class_o.generateValue($type_o; $enregistrement_o[$type_o.lib])
					End for each 
					
					$enregistrement_o.save()
				End for each 
				
				crgpdToolProgressBar(1; "arrêt")
			End if 
			
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 