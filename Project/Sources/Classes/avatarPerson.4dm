/* -----------------------------------------------------------------------------
Class : cs.avatarPerson

Class qui permet de générer des profils de personnes cohérentes mais aléatoire

-----------------------------------------------------------------------------*/

Function generate()
/*------------------------------------------------------------------------------
Fonction : avatarPerson.generate
	
Génération d'une fiche [Personne] de la table du client
	
Paramètre
	
Historique
18/03/22 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $property_t : Text
	var $content_o; $entity_e : Object
	var $isValidTable_c; $specificField_c : Collection
	
	crgpdToolNewCollection(->$isValidTable_c; ->$specificField_c)
	
	$content_o:=JSON Parse:C1218(crgpdToolJsoncToJson(Storage:C1525.person_f.getText()))
	$isValidTable_c:=Storage:C1525.structureDetail.query("table = :1"; $content_o.person.dataClass)
	
	If ($isValidTable_c.length=1)
		This:C1470.person:=ds:C1482[$content_o.person.dataClass].new()
		This:C1470.specifiField_c:=$content_o.person.sex.query("gender.lib = :1"; Choose:C955(Mod:C98(Random:C100; 2)=0; "male"; "female"))
		
		$specificField_c:=OB Keys:C1719(This:C1470.specifiField_c[0])
		
		// On traite d'abord tous les champs propre au sexe de la personne
		For each ($property_t; $specificField_c)
			This:C1470.generateValue($property_t)
		End for each 
		
		// Ensuite toutes les autres propriétés qui ne dépendent pas du sexe de la personne
		This:C1470.specifiField_c:=New collection:C1472(New object:C1471)
		
		For each ($property_t; $content_o.person)
			
			If ($property_t#"dataClass") & ($property_t#"sex")
				This:C1470.specifiField_c[0][$property_t]:=New object:C1471("fieldName"; $content_o.person[$property_t].fieldName)
				This:C1470.generateValue($property_t)
			End if 
			
		End for each 
		
		This:C1470.person.save()
	End if 
	
Function isValidField($lib_t : Text)->$isValid_b : Boolean
/*------------------------------------------------------------------------------
Fonction : avatarPerson.isValidField
	
Vérifie si un champ existe pour la dataclasse Personne de la base hôte
	
Paramètre
$entity_e -> Entité en cours de création
	
Historique
18/03/22 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	$isValid_b:=(This:C1470.person[This:C1470.specifiField_c[0][$lib_t].fieldName]#Null:C1517)
	
Function generateValue($lib_t : Text)
/*------------------------------------------------------------------------------
Fonction : avatarPerson.generateValue
	
Générer une valeur pour anonymiser un champ d'une table.
	
Paramètres
	
Historiques
18/03/22 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $random_el; $nbDay_el : Integer
	var $value_v : Variant
	
	If (This:C1470.isValidField($lib_t)=True:C214)
		$value_v:=This:C1470.specifiField_c[0][$lib_t].value
		
		Case of 
			: (Value type:C1509($value_v)=Est un objet:K8:27)
				
				If ($lib_t="birthday")
					$nbDay_el:=crgpdToolGetNbJour(Date:C102($value_v.min); Date:C102($value_v.max))
					$random_el:=(Random:C100%($nbDay_el-0+1))+0
					
					$value_v:=Add to date:C393(Date:C102($value_v.min); 0; 0; $random_el)
				Else 
					$value_v:=(Random:C100%($value_v.max-$value_v.min+1))+$value_v.min
				End if 
				
			: (Value type:C1509($value_v)=Est une collection:K8:32)
				$random_el:=(Random:C100%($value_v.length-1-0+1))+0
				$value_v:=$value_v[$random_el]
			Else 
		End case 
		
		If (Value type:C1509(This:C1470.person[This:C1470.specifiField_c[0][$lib_t].fieldName])=Value type:C1509($value_v))
			This:C1470.person[This:C1470.specifiField_c[0][$lib_t].fieldName]:=$value_v
		End if 
		
	End if 