/*------------------------------------------------------------------------------
Class : cs.RGPDDisplay

Class de gestion du formulaire d'anonymisation

------------------------------------------------------------------------------*/

Function chooseTypeData()
/*------------------------------------------------------------------------------
Fonction : RGPDDisplay.chooseTypeData
	
Permet de faire matcher un champ avec un type de valeur attendue (nom, prénom etc.)
	
Paramètre
$typeData_c <- Collection qui contient pour chaque champ le type de donnée attendu
	
Historique
17/02/22 - Rémy Scanu <remy@connect-io.fr> - Création
18/03/22 - Grégory Fromain <grégory@connect-io.fr> - Modification de l'appel du fichier des relations.
------------------------------------------------------------------------------*/
	var $element_t; $type_t : Text
	var $i_el : Integer
	var $pointeur_p : Pointer
	var $base_o; $content_o : Object
	var $structureDetail_c; $collection_c; $column_c; $data_c : Collection
	
	ASSERT:C1129(Storage:C1525.config#Null:C1517; "La méthode crgpdStart doit être exécuter avant d'utiliser cette méthode.")
	
	crgpdToolNewCollection(->$column_c; ->$data_c; ->$structureDetail_c; ->$collection_c)
	
	$base_o:=New object:C1471
	
	// Création des colonnes
	$column_c:=Storage:C1525.config.champ.extract("label"; "label")
	$column_c.unshift(New object:C1471("label"; "Nom du champ"))
	
	For ($i_el; 0; Storage:C1525.config.champ.length-1)
		$base_o[Storage:C1525.config.champ[$i_el].lib]:=False:C215
	End for 
	
	// Création des data
	$structureDetail_c:=This:C1470.getStructureDetail().query("table = :1"; OBJECT Get pointer:C1124(Objet nommé:K67:5; "dataClassList")->currentValue)
	
	For each ($field4D_t; $structureDetail_c[0].champ)
		$data_c.push(OB Copy:C1225(cwToolObjectMerge(New object:C1471("field4D"; $field4D_t); $base_o)))
	End for each 
	
	If (Bool:C1537(Form:C1466.useParamSave)=True:C214)
		$content_o:=JSON Parse:C1218(Storage:C1525.relation_f.getText())
		$dataField_c:=$content_o.detail.query("table = :1"; OBJECT Get pointer:C1124(Objet nommé:K67:5; "dataClassList")->currentValue)[0].data
		For each ($field_o; $dataField_c)
			$data_c.query("field4D IS :1"; $field_o.field4D)[0][$field_o.libTypeValue]:=True:C214
		End for each 
		
	End if 
	
	Form:C1466.setDataType:=$data_c
	$collection_c:=OB Keys:C1719(Form:C1466.setDataType[0])
	
	// On reset la Listbox
	For ($i_el; LISTBOX Get number of columns:C831(*; "List Box"); 2; -1)
		LISTBOX DELETE COLUMN:C830(*; "List Box"; $i_el)
	End for 
	
	// On créé la Listbox variable en nombre et contenu des colonnes
	For ($i_el; 1; $column_c.length)
		$pointeur_p:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Colonne"+String:C10($i_el))
		
		If ($i_el>1)  // Si on est sur la 2° colonne ou plus, on centre le contenu
			LISTBOX INSERT COLUMN FORMULA:C970(*; "List Box"; $i_el+1; "Colonne"+String:C10($i_el); "This."+$collection_c[$i_el-1]; Value type:C1509(Form:C1466.setDataType[0][$collection_c[$i_el-1]]); "Entête"+String:C10($i_el); $pointeur_p)
			
			OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "Colonne"+String:C10($i_el); 3)
		End if 
		
		OBJECT SET TITLE:C194(*; "Entête"+String:C10($i_el); $column_c[$i_el-1].label)
	End for 
	
	// On redimensionne la fenêtre
	LISTBOX SET LOCKED COLUMNS:C1151(*; "List Box"; 1)
	LISTBOX SET COLUMN WIDTH:C833(*; "List Box"; 90)
	
Function getStructureDetail()->$structureDetail_c : Collection
/*------------------------------------------------------------------------------
Fonction : RGPDDisplay.getStructureDetail
	
Permet d'obtenir une collection avec le détail de la structure du client (table/champ)
	
Paramètre
$structureDetail_c <-> Collection qui contient pour chaque table
le détail des champs associés à cette table
	
Historique
16/03/22 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $i_el; $j_el : Integer
	
	$structureDetail_c:=New collection:C1472
	
	For ($i_el; 1; Get last table number:C254)
		
		If (Is table number valid:C999($i_el)=True:C214)
			$structureDetail_c.push(New object:C1471("table"; Table name:C256($i_el); "champ"; New collection:C1472))
			
			For ($j_el; 1; Get last field number:C255($i_el))
				
				If (Is field number valid:C1000($i_el; $j_el)=True:C214)
					$structureDetail_c[$structureDetail_c.length-1].champ.push(Field name:C257($i_el; $j_el))
				End if 
				
			End for 
			
		End if 
		
	End for 
	
Function checkSaveFileExist()->$exist_b : Boolean
/*------------------------------------------------------------------------------
Fonction : RGPDDisplay.checkSaveFileExist
	
Permet de savoir si dans le fichier de sauvegarde du composant il existe déjà
une correspondance entre la table et le champ sélectionné
	
Paramètre
	
Historique
11/03/22 - Rémy Scanu <remy@connect-io.fr> - Création
18/03/22 - Grégory Fromain <grégory@connect-io.fr> - Modification de l'appel du fichier des relations.
------------------------------------------------------------------------------*/
	var $content_o : Object
	var $collection_c : Collection
	
	$collection_c:=New collection:C1472
	
	If (Storage:C1525.relation_f.exists=True:C214)
		$content_o:=JSON Parse:C1218(Storage:C1525.relation_f.getText())
		$collection_c:=$content_o.detail.query("table = :1"; OBJECT Get pointer:C1124(Objet nommé:K67:5; "dataClassList")->currentValue)
		
		$exist_b:=($collection_c.length>0)
	End if 