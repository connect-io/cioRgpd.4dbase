/*------------------------------------------------------------------------------
Class : cs.RGPDDisplay

Class de gestion du formulaire d'anonymisation

------------------------------------------------------------------------------*/

Function centerElementInWindows($objet_c : Collection; $refFenetre_el : Integer)
/*------------------------------------------------------------------------------
Fonction : RGPDDisplay.centerElementInWindows
	
Permet de centrer par programmation des objets par rapport à la taille de la fenêtre
	
Paramètres
$objet_c       -> Collection qui contient tous les noms d'objet à appliquer la resize
$refFenetre_el -> Référence de la fenêtre où est située la listbox
	
Historique
21/02/22 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $objet_t : Text
	var $gauche_el; $haut_el; $droite_el; $bas_el; $gaucheObjet_el; $hautObjet_el; $droiteObjet_el; $basObjet_el; $largeur_el; $largeurObjet_el : Integer
	
	GET WINDOW RECT:C443($gauche_el; $haut_el; $droite_el; $bas_el; $refFenetre_el)
	$largeur_el:=$droite_el-$gauche_el
	
	For each ($objet_t; $objet_c)
		OBJECT GET COORDINATES:C663(*; $objet_t; $gaucheObjet_el; $hautObjet_el; $droiteObjet_el; $basObjet_el)
		$largeurObjet_el:=$droiteObjet_el-$gaucheObjet_el
		
		If ($largeurObjet_el<=$largeur_el)
			OBJECT SET COORDINATES:C1248(*; $objet_t; ($largeur_el-$largeurObjet_el)/2; $hautObjet_el)
		End if 
		
	End for each 
	
Function chooseTypeData()
/*------------------------------------------------------------------------------
Fonction : RGPDDisplay.chooseTypeData
	
Permet de faire matcher un champ avec un type de valeur attendue (nom, prénom etc.)
	
Paramètre
$typeData_c <- Collection qui contient pour chaque champ le type de donnée attendu
	
Historique
17/02/22 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $element_t; $type_t : Text
	var $i_el : Integer
	var $pointeur_p : Pointer
	var $configSave_o : 4D:C1709.File
	var $base_o; $content_o : Object
	var $structureDetail_c; $collection_c; $column_c; $data_c : Collection
	
	ASSERT:C1129(Storage:C1525.config#Null:C1517; "La méthode crgpdStart doit être exécuter sur démarrage de la base")
	
	crgpdToolNewCollection(->$column_c; ->$data_c; ->$structureDetail_c; ->$collection_c)
	
	$base_o:=New object:C1471
	$configSave_o:=Folder:C1567(fk dossier ressources:K87:11; *).file("cioRgpd/configSave.json")
	
	// Création des colonnes
	$column_c:=Storage:C1525.config.champ.extract("lib"; "titre")
	$column_c.unshift(New object:C1471("titre"; "Nom du champ"))
	
	For ($i_el; 0; Storage:C1525.config.champ.length-1)
		$base_o[Storage:C1525.config.champ[$i_el].libInCollection]:=False:C215
	End for 
	
	// Création des data
	If (Bool:C1537(Form:C1466.useParamSave)=True:C214)
		$content_o:=JSON Parse:C1218($configSave_o.getText())
		$data_c:=$content_o.detail.query("table = :1"; OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue)[0].data
	Else 
		$structureDetail_c:=This:C1470.getStructureDetail().query("table = :1"; OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue)
		
		For each ($element_t; $structureDetail_c[0].champ)
			$data_c.push(OB Copy:C1225(cwToolObjectMerge(New object:C1471("lib"; $element_t); $base_o)))
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
		
		OBJECT SET TITLE:C194(*; "Entête"+String:C10($i_el); $column_c[$i_el-1].titre)
	End for 
	
	// On redimensionne la fenêtre
	LISTBOX SET LOCKED COLUMNS:C1151(*; "List Box"; 1)
	LISTBOX SET COLUMN WIDTH:C833(*; "List Box"; 150)
	
Function generateValue($type_o : Object; $valueDefaut_v : Variant)->$value_v : Variant
/*------------------------------------------------------------------------------
Fonction : RGPDDisplay.generateValue
	
Générer une valeur pour anonymiser un champ d'une table
	
Paramètres
$type_o        -> Type de valeur attendue (nom, prénom, adresse etc.)
$valueDefaut_v -> Valeur par défaut du champ à anonymiser
$value_v       <- Valeur du champ une fois anonymiser
	
Historique
17/02/22 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $random_el; $nbJour_el : Integer
	var $collection_c : Collection
	var $typeDefaut_v : Variant
	
	$collection_c:=Storage:C1525.config.champ.query("libInCollection = :1"; $type_o.type)
	
	If ($collection_c.length=1)
		
		If ($type_o.type="dateNaissance")
			$nbJour_el:=crgpdToolGetNbJour(Date:C102($collection_c[0].value.debut); Date:C102($collection_c[0].value.fin))
			$random_el:=(Random:C100%($nbJour_el-0+1))+0
			
			$value_v:=Add to date:C393(Date:C102($collection_c[0].value.debut); 0; 0; $random_el)
		Else 
			$random_el:=(Random:C100%($collection_c[0].value.length-1-0+1))+0
			$value_v:=$collection_c[0].value[$random_el]
		End if 
		
	Else   // Type par défaut du champ
		$typeDefaut_v:=Value type:C1509($valueDefaut_v)
		
		// toDo
		Case of 
			: ($typeDefaut_v=Est un texte:K8:3)
			: ($typeDefaut_v=Est un entier long:K8:6)
			: ($typeDefaut_v=Est un numérique:K8:4)
			: ($typeDefaut_v=Est une date:K8:7)
		End case 
		
		$value_v:=$valueDefaut_v
	End if 
	
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
------------------------------------------------------------------------------*/
	var $content_o : Object
	var $fichier_o : 4D:C1709.File
	var $collection_c : Collection
	
	$collection_c:=New collection:C1472
	$fichier_o:=File:C1566(Get 4D folder:C485(Dossier Resources courant:K5:16; *)+"cioRgpd"+Séparateur dossier:K24:12+"configSave.json"; fk chemin plateforme:K87:2)
	
	If ($fichier_o.exists=True:C214)
		$content_o:=JSON Parse:C1218($fichier_o.getText())
		$collection_c:=$content_o.detail.query("table = :1"; OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue)
		
		$exist_b:=($collection_c.length>0)
	End if 
	
Function resizeFullWidth($fullWidth_b; $objet_c : Collection)
/*------------------------------------------------------------------------------
Fonction : RGPDDisplay.resizeFullWidth
	
Permet de resizer par programmation un ojet pour l'adapter au plein écran ou 
à la taille d'origine de la fenêtre
	
Paramètre
$fullWidth_b -> Booléen qui indique si on est dans le cas d'une resize 
                d'un objet pour le plein écran
$objet_c     -> Collection qui contient tous les noms d'objet à appliquer la resize
	
Historique
17/02/22 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $objet_t : Text
	var $gauche_el; $haut_el; $droite_el; $bas_el : Integer
	var $pointeur_p : Pointer
	
	For each ($objet_t; $objet_c)
		$pointeur_p:=OBJECT Get pointer:C1124(Objet nommé:K67:5; $objet_t)
		
		If (Is nil pointer:C315($pointeur_p)=False:C215)
			OBJECT GET COORDINATES:C663(*; $objet_t; $gauche_el; $haut_el; $droite_el; $bas_el)
			
			Case of 
				: ($fullWidth_b=True:C214)  // Plein écran
					
					If (Form:C1466.objet[$objet_t]=Null:C1517)  // On stocke si on ne la pas déjà fait les coordonnées par défaut de l'objet
						Form:C1466.objet[$objet_t]:=New object:C1471("gauche"; $gauche_el; "haut"; $haut_el; "droite"; $droite_el; "bas"; $bas_el)
					End if 
					
					$droite_el:=Screen width:C187(*)
				: (Form:C1466.objet[$objet_t]#Null:C1517)  // On restitue les valeurs par défaut des coordonnées de l'objet
					$gauche_el:=Form:C1466.objet[$objet_t].gauche
					$haut_el:=Form:C1466.objet[$objet_t].haut
					$droite_el:=Form:C1466.objet[$objet_t].droite
					$bas_el:=Form:C1466.objet[$objet_t].bas
			End case 
			
			OBJECT SET COORDINATES:C1248(*; $objet_t; $gauche_el; $haut_el; $droite_el; $bas_el)
		End if 
		
	End for each 
	
Function resizeWindows($nbColonne_el : Integer; $refFenetre_el : Integer)
/*------------------------------------------------------------------------------
Fonction : RGPDDisplay.resizeWindows
	
Permet de resizer par programmation la fenêtre qui affiche les éléments à anonymiser
	
Paramètre
$nbColonne_el  -> Nombre de colonne que la listbox doit contenir
$refFenetre_el -> Référence de la fenêtre où est située la listbox
	
Historique
17/02/22 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $gauche_el; $haut_el; $bas_el; $droite_el; $moitie_el; $largeur_el; $largeurForm_el; $hauteurForm_el; $gaucheCalcul_el; $droiteCalcul_el : Integer
	
	$largeur_el:=Screen width:C187(*)
	
	$droiteCalcul_el:=580+(150*($nbColonne_el-1))
	
	OBJECT GET COORDINATES:C663(*; "List box"; $gauche_el; $haut_el; $droite_el; $bas_el)
	OBJECT SET COORDINATES:C1248(*; "List Box"; $gauche_el; $haut_el; Choose:C955($droiteCalcul_el<=$largeur_el; $droiteCalcul_el; $largeur_el-20))
	
	GET WINDOW RECT:C443($gauche_el; $haut_el; $droite_el; $bas_el; $refFenetre_el)
	FORM GET PROPERTIES:C674("FormAnonymisation"; $largeurForm_el; $hauteurForm_el)
	
	$largeurForm_el:=$largeurForm_el+(150*($nbColonne_el-1))
	
	If ($largeurForm_el>$largeur_el)
		$largeurForm_el:=$largeur_el-20
	End if 
	
	$moitie_el:=$largeurForm_el/2
	$gaucheCalcul_el:=($largeur_el/2)-$moitie_el
	
	If ($gaucheCalcul_el<0)  // La Fenêtre va être plus large que la largeur de l'écran...
		$droiteCalcul_el:=$largeur_el-Abs:C99($gaucheCalcul_el)
	Else 
		$droiteCalcul_el:=($largeur_el/2)+$moitie_el
	End if 
	
	SET WINDOW RECT:C444(Abs:C99($gaucheCalcul_el); $haut_el; $droiteCalcul_el; $bas_el; $refFenetre_el; *)
	LISTBOX SET COLUMN WIDTH:C833(*; "List Box"; 150)