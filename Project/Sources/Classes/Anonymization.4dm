/*------------------------------------------------------------------------------
Class : cs.Anonymization

Class qui permet l'anonymisation d'une table. 

------------------------------------------------------------------------------*/

Class constructor($dataClass_t : Text)
/*------------------------------------------------------------------------------
Fonction : Anonymization.new
	
Initialisation de la class Anonymization.
	
Paramètre
$dataClass_t -> Table dans lequel est éxécuté le traitement.
	
Historique
18/03/22 - Grégory Fromain <gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	This:C1470.dataClass_t:=$dataClass_t  // Nom de la dataclasse
	This:C1470.data_es:=ds:C1482[$dataClass_t].all()
	
	This:C1470.relation_c:=New collection:C1472()
	
Function generateValue($type_o : Object; $entity_o : Object)->$value_v : Variant
/*------------------------------------------------------------------------------
Fonction : Anonymization.generateValue
	
Générer une valeur pour anonymiser un champ d'une table.
	
Paramètres
$type_o        -> Type de valeur attendue (nom, prénom, adresse etc.)
$entity_o      -> Entity du champ qu'on souhaite anonymiser
$value_v       <- Valeur du champ une fois anonymisé
	
Historiques
17/02/22 - Rémy Scanu <remy@connect-io.fr> - Création
18/03/22 - Grégory Fromain <gregory@connect-io.fr> - Reprise du code de Rémy.
------------------------------------------------------------------------------*/
	var $nom_t; $prenom_t : Text
	var $nbDay_el : Integer  // Nombre de jour entre 2 dates.
	var $random_el : Integer  // Nombre aléatoire entre 2 dates.
	var $relationFileContent_o : Object
	var $relationTable_c; $collection_c; $typeAnonymization_c : Collection
	
	var type_el; length_el;  : Integer
	var index_b; unique_b; invisible_b : Boolean
	
	crgpdToolNewCollection(->$relationTable_c; ->$collection_c; ->$typeAnonymization_c)
	$typeAnonymization_c:=Storage:C1525.config.champ.query("lib = :1"; $type_o.libTypeValue)
	
	If ($typeAnonymization_c.length=1)
		
		Case of 
			: ($type_o.libTypeValue="dateNaissance")
				$nbDay_el:=crgpdToolGetNbJour(Date:C102($typeAnonymization_c[0].value.debut); Date:C102($typeAnonymization_c[0].value.fin))
				$random_el:=(Random:C100%($nbDay_el-0+1))+0
				
				$value_v:=Add to date:C393(Date:C102($typeAnonymization_c[0].value.debut); 0; 0; $random_el)
			: ($type_o.libTypeValue="nomPrenom")
				$relationFileContent_o:=JSON Parse:C1218(Storage:C1525.relation_f.getText())
				$relationTable_c:=$relationFileContent_o.detail.query("table = :1"; $entity_o.getDataClass().getInfo().name)
				
				If ($relationTable_c.length=1)
					$collection_c:=$relationTable_c[0].data.query("libTypeValue = :1"; "nom")
					
					If ($collection_c.length=1)
						$nom_t:=$entity_o[$collection_c[0].field4D]
					Else 
						$collection_c:=Storage:C1525.config.champ.query("lib = :1"; "nom")
						
						If ($collection_c.length=1)
							$random_el:=(Random:C100%($collection_c[0].value.length-1-0+1))+0
							$nom_t:=$collection_c[0].value[$random_el]
						End if 
						
					End if 
					
					$collection_c:=$relationTable_c[0].data.query("libTypeValue = :1"; "prenom")
					
					If ($collection_c.length=1)
						$prenom_t:=$entity_o[$collection_c[0].field4D]
					Else 
						$collection_c:=Storage:C1525.config.champ.query("lib = :1"; "prenom")
						
						If ($collection_c.length=1)
							$random_el:=(Random:C100%($collection_c[0].value.length-1-0+1))+0
							$prenom_t:=$collection_c[0].value[$random_el]
						End if 
						
					End if 
					
				End if 
				
				If ($nom_t#"") & ($prenom_t#"")  // Le nom et prénom ont été sélectionnés dans les champs à anonymiser
					$value_v:=$nom_t+" "+$prenom_t
				Else 
					$value_v:=$entity_o[$type_o.field4D]
				End if 
				
			Else 
				$random_el:=(Random:C100%($typeAnonymization_c[0].value.length-1-0+1))+0
				$value_v:=$typeAnonymization_c[0].value[$random_el]
				
				EXECUTE FORMULA:C63("LIRE PROPRIETES CHAMP:C258(->["+This:C1470.dataClass_t+"]"+$type_o.field4D+";type_el;length_el;index_b;unique_b;invisible_b)")
				
				If (unique_b=True:C214)
					$value_v:=$value_v+Substring:C12(Generate UUID:C1066; 1; 5)
				End if 
				
		End case 
		
	Else   // Type par défaut du champ
		$value_v:=$entity_o[$type_o.field4D]
	End if 
	
Function go()
/*------------------------------------------------------------------------------
Fonction : Anonymization.go
	
Lancement de l'anonymisation pour tous les enregistrements d'une table
sélectionnée
	
Historique
18/03/22 - Grégory Fromain <gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $entity_o; $retour_o; $type_o : Object
	var progressBar_el : Integer
	
/*$process1_el:=New process("_testProcess"; 0; "Process1"; This.data_es.slice(0; (This.data_es.length/2)); This.relation_c; This.dataClass_t)
$process2_el:=New process("_testProcess"; 0; "Process2"; This.data_es.slice((This.data_es.length/2)+1); This.relation_c; This.dataClass_t)*/
	
	crgpdToolProgressBar(0; "Initialisation"; True:C214; "anonyme")
	
	For each ($entity_o; This:C1470.data_es) Until (progressBar_el=0)
		
		If (Mod:C98($entity_o.indexOf(This:C1470.data_es)+1; Round:C94((This:C1470.data_es.length/100); 0))=0)  // On met à jour tous les 1% de la taille de la sélection en qu'on traite
			crgpdToolProgressBar(($entity_o.indexOf(This:C1470.data_es)+1)/This:C1470.data_es.length; "Anonymisation de votre table en cours..."; True:C214; "anonyme")
		End if 
		
		For each ($type_o; This:C1470.relation_c)
			$entity_o[$type_o.field4D]:=This:C1470.generateValue($type_o; $entity_o)
		End for each 
		
		$retour_o:=$entity_o.save()
	End for each 
	
	crgpdToolProgressBar(1; "arrêt")
	
Function relationSave()
/*------------------------------------------------------------------------------
Fonction : Anonymization.relationSave
	
Sauvegarde des relations entre les champs et le type d'anonymisation dans
le fichier relation.json
	
Historique
18/03/22 - Grégory Fromain <gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $content_o : Object
	var $dataClassRelation_c : Collection
	
	$content_o:=JSON Parse:C1218(Storage:C1525.relation_f.getText())
	
	$dataClassRelation_c:=$content_o.detail.indices("table = :1"; This:C1470.dataClass_t)
	
	If ($dataClassRelation_c.length=1)
		$content_o.detail.remove($dataClassRelation_c[0])
	End if 
	
	$content_o.detail.push(New object:C1471("table"; This:C1470.dataClass_t; "data"; This:C1470.relation_c))
	Storage:C1525.relation_f.setText(JSON Stringify:C1217($content_o; *))
	
Function relationUpdate($relation_c : Collection)
/*------------------------------------------------------------------------------
Fonction : Anonymization.relationUpdate
	
Mise à jour des relations entre les champs et le type d'anonymisation suite
à un matching dans le formulaire d'anonymisation entre les champs 4D et le type
de champ proposé
	
Paramètre
$relation_c -> Relations entre les champs et le type d'anonymisation.
	
Historique
18/03/22 - Grégory Fromain <gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	This:C1470.relation_c:=$relation_c