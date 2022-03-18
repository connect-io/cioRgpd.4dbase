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
	
	This:C1470.dataClass_t:=$dataClass_t  // Nom de la table
	This:C1470.data_es:=ds:C1482[$dataClass_t].all()
	This:C1470.relation_c:=New collection:C1472()
	
	
	
Function relationUpdate($relation_c : Collection)
/*------------------------------------------------------------------------------
Fonction : Anonymization.relationUpdate
	
Mise à jour des relations entre les champs et le type d'anonymisation.
	
Paramètre
$relation_c -> Relations entre les champs et le type d'anonymisation.
	
Historique
18/03/22 - Grégory Fromain <gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	This:C1470.relation_c:=$relation_c
	
	
	
Function relationReload()
/*------------------------------------------------------------------------------
Fonction : Anonymization.relationReload
	
Rechargement des relations entre les champs et le type d'anonymisation depuis
le fichier relation.json
	
Historique
18/03/22 - Grégory Fromain gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $dataClassRelation_c : Collection
	
	This:C1470.relation_c:=New collection:C1472()
	
	$dataClassRelation_c:=JSON Parse:C1218(Storage:C1525.relation_f.getText()).detail.query("table = :1"; This:C1470.dataClass_t)
	If ($dataClassRelation_c.length=1)
		This:C1470.relation_c:=$dataClassRelation_c[0].data
	End if 
	
	
	
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
	
	
	
Function go()
/*------------------------------------------------------------------------------
Fonction : Anonymization.go
	
Lancement de l'anonymisation.
	
Historique
18/03/22 - Grégory Fromain <gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	var $entity_o : Object
	var $type_o : Object
	var progressBar_el : Integer
	
	crgpdToolProgressBar(0; "Initialisation"; True:C214; "anonyme")
	
	For each ($entity_o; This:C1470.data_es) Until (progressBar_el=0)
		
		If (Mod:C98($entity_o.indexOf(This:C1470.data_es)+1; 100)=0)  // Tous les 100 enregistrements on met à jour la barre de progression
			crgpdToolProgressBar(($entity_o.indexOf(This:C1470.data_es)+1)/This:C1470.data_es.length; "Anonymisation de votre table en cours..."; True:C214; "anonyme")
		End if 
		
		For each ($type_o; This:C1470.relation_c)
			$entity_o[$type_o.field4D]:=This:C1470.generateValue($type_o; $entity_o[$type_o.field4D])
		End for each 
		
		$entity_o.save()
	End for each 
	
	crgpdToolProgressBar(1; "arrêt")
	
	
	
Function generateValue($type_o : Object; $valueDefaut_v : Variant)->$value_v : Variant
/*------------------------------------------------------------------------------
Fonction : Anonymization.generateValue
	
Générer une valeur pour anonymiser un champ d'une table.
	
Paramètres
$type_o        -> Type de valeur attendue (nom, prénom, adresse etc.)
$valueDefaut_v -> Valeur par défaut du champ à anonymiser
$value_v       <- Valeur du champ une fois anonymiser
	
Historiques
17/02/22 - Rémy Scanu <remy@connect-io.fr> - Création
18/03/22 - Grégory Fromain <gregory@connect-io.fr> - Reprise du code de Rémy.
------------------------------------------------------------------------------*/
	
	var $nbDay_el : Integer  // Nombre de jour entre 2 dates.
	var $random_el : Integer  // Nombre aléatoire entre 2 dates.
	var $collection_c : Collection
	
	$typeAnonymization_c:=Storage:C1525.config.champ.query("lib = :1"; $type_o.libTypeValue)
	
	If ($typeAnonymization_c.length=1)
		
		If ($type_o.libTypeValue="dateNaissance")
			$nbDay_el:=crgpdToolGetNbJour(Date:C102($typeAnonymization_c[0].value.debut); Date:C102($typeAnonymization_c[0].value.fin))
			$random_el:=(Random:C100%($nbDay_el-0+1))+0
			
			$value_v:=Add to date:C393(Date:C102($typeAnonymization_c[0].value.debut); 0; 0; $random_el)
		Else 
			$random_el:=(Random:C100%($typeAnonymization_c[0].value.length-1-0+1))+0
			$value_v:=$typeAnonymization_c[0].value[$random_el]
		End if 
		
	Else   // Type par défaut du champ
		
		$value_v:=$valueDefaut_v
	End if 