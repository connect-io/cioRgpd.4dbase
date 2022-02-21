/* -----------------------------------------------------------------------------
Class : cs.RGPDDisplay

Class de gestion du formulaire d'anonymisation

-----------------------------------------------------------------------------*/

Class constructor
	
Function applyValue($enregistrement_o : Object; $element_o : Object; $type_o : Object)
/* -----------------------------------------------------------------------------
Fonction : RGPDDisplay.applyValue
	
Applique une valeur aléatoire pour anonymiser un champ d'une table
	
Paramètre
$enregistrement_o -> Entité à anonymiser
$element_o -> Objet créer dans la function getData (avec les propriétés table, champ, champType, primaryKey)
$type_o -> Type de valeur attendue (nom, prénom, adresse etc.)
	
Historique
17/02/22 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	If ($element_o.champ="Tous les champs")
		$enregistrement_o[$type_o.lib]:=This:C1470.generateValue($type_o; Value type:C1509($enregistrement_o[$type_o.lib]); $enregistrement_o[$type_o.lib])
	Else 
		$enregistrement_o[$element_o.champ]:=This:C1470.generateValue($type_o; $element_o.champType; $enregistrement_o[$element_o.champ])
	End if 
	
	$enregistrement_o.save()
	
Function chooseTypeData()->$typeData_c : Collection
/* -----------------------------------------------------------------------------
Fonction : RGPDDisplay.chooseTypeData
	
Permet de faire matcher un champ avec un type de valeur attendue (nom, prénom etc.)
	
Paramètre
$typeData_c <- Collection qui contient pour chaque champ le type de donnée attendu
	
Historique
17/02/22 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $champ_t; $element_t; $type_t : Text
	var $element_o; $configuration_o; $base_o; $autreElement_o : Object
	var $collection_c; $column_c; $data_c : Collection
	
	ASSERT:C1129(Storage:C1525.rgpd#Null:C1517; "La méthode crgpdStart doit être exécuter sur démarrage de la base")
	
	$base_o:=New object:C1471
	
	crgpdToolNewCollection(->$data_c; ->$column_c; ->$typeData_c; ->$collection_c)
	
	$champ_t:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante1")->currentValue
	
/*$collection_c:=Storage.rgpd.champ.extract("lib"; "lib")
$collection_c.unshift(Créer objet("lib"; "Type par défaut du champ"))
	
$typeData_c:=Créer collection
	
Si ($champ_t="Tous les champs")
	
Pour chaque ($element_t; OBJET Lire pointeur(Objet nommé; "Popup Liste déroulante1")->values)
	
Si ($element_t#"Tous les champs")
$typeData_c.push(Créer objet("lib"; $element_t; "type"; ""))
Fin de si 
	
Fin de chaque 
	
Sinon 
$typeData_c.push(Créer objet("lib"; $champ_t; "type"; ""))
Fin de si 
	
Pour chaque ($element_o; $typeData_c)
	
Repeter 
			crgpdToolWindowsForm("FormSelectValue"; "center"; Créer objet("collection"; $collection_c; \
						"property"; "lib"; "selectSubTitle"; "Merci de sélectionner le type de donnée du champ «"+$element_o.lib+"»"; "title"; "Choix du type de donnée du champ «"+$element_o.lib+"» :"))
	
$element_o.type:=selectValue_t
	
Si (selectValue_t="")
ALERTE("Merci de sélectionner un type de donnée")
Fin de si 
	
Jusque (selectValue_t#"")
	
Fin de chaque */
	
	$column_c:=Storage:C1525.rgpd.champ.extract("lib"; "titre")
	$column_c.unshift(New object:C1471("titre"; "Nom du champ"))
	
	For ($i_el; 0; Storage:C1525.rgpd.champ.length-1)
		$base_o[Storage:C1525.rgpd.champ[$i_el].libInCollection]:=False:C215
	End for 
	
	If ($champ_t="Tous les champs")
		
		For each ($element_t; OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante1")->values)
			$element_o:=cwToolObjectMerge(New object:C1471("lib"; $element_t); $base_o)
			
			If ($element_t#"Tous les champs")
				$data_c.push(OB Copy:C1225($element_o))
			End if 
			
		End for each 
		
	Else 
		$element_o:=cwToolObjectMerge(New object:C1471("lib"; $champ_t); $base_o)
		
		$data_c.push(OB Copy:C1225($element_o))
	End if 
	
	$configuration_o:=New object:C1471(\
		"column"; $column_c; \
		"data"; $data_c; "columnRules"; New object:C1471("booleanUniqueByLine"; True:C214; "clic"; "noCopyCollection"))
	
	crgpdToolWindowsForm("FormListeGenerique"; "center"; $configuration_o)
	
	For each ($element_o; $data_c)
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
	
Function generateValue($type_o : Object; $typeDefaut_v : Variant; $valueDefaut_v : Variant)->$value_v : Variant
/* -----------------------------------------------------------------------------
Fonction : RGPDDisplay.generateValue
	
Générer une valeur pour anonymiser un champ d'une table
	
Paramètre
$type_o -> Type de valeur attendue (nom, prénom, adresse etc.)
$valueDefaut_v -> Valeur par défaut du champ à anonymiser
$value_v <- Valeur du champ une fois anonymiser
	
Historique
17/02/22 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $random_el; $nbJour_el : Integer
	var $collection_c : Collection
	
	$collection_c:=Storage:C1525.rgpd.champ.query("libInCollection = :1"; $type_o.type)
	
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
		
		// toDo
		Case of 
			: ($typeDefaut_v=Est un texte:K8:3)
			: ($typeDefaut_v=Est un entier long:K8:6)
			: ($typeDefaut_v=Est un numérique:K8:4)
			: ($typeDefaut_v=Est une date:K8:7)
				
		End case 
		
		$value_v:=$valueDefaut_v
	End if 
	
Function getData($collectionToComplete_p : Pointer)
/* -----------------------------------------------------------------------------
Fonction : RGPDDisplay.getData
	
Obtenir les valeurs du/des champs d'une table pour les anonymiser
	
Paramètre
	$collectionToComplete_p <-> Pointeur de la collection qui contient tous \
		les enregistrements par rapport au(x) champ(s) et à la table recherchée
	
Historique
17/02/22 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $table_t; $champ_t : Text
	var $table_o : Object
	
	$table_t:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue
	$champ_t:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante1")->currentValue
	
	$table_o:=ds:C1482[$table_t].all()
	
	crgpdToolProgressBar(0; "Initialisation"; True:C214)
	
	For each ($enregistrement_o; $table_o) Until (progressBar_el=0)
		crgpdToolProgressBar(($enregistrement_o.indexOf($table_o)+1)/$table_o.length; "Extraction des données en cours..."; True:C214)
		
		$collectionToComplete_p->push(New object:C1471)
		
		For each ($propriete_t; $enregistrement_o)
			
			If ($champ_t="Tous les champs") | ($champ_t=$propriete_t)
				$collectionToComplete_p->[$collectionToComplete_p->length-1][$propriete_t]:=$enregistrement_o[$propriete_t]
				$collectionToComplete_p->[$collectionToComplete_p->length-1].table:=$table_t
				$collectionToComplete_p->[$collectionToComplete_p->length-1].champ:=Choose:C955($champ_t="Tous les champs"; $champ_t; $propriete_t)
				$collectionToComplete_p->[$collectionToComplete_p->length-1].champType:=Choose:C955($champ_t="Tous les champs"; ""; Value type:C1509($enregistrement_o[$propriete_t]))
				$collectionToComplete_p->[$collectionToComplete_p->length-1].primaryKey:=$enregistrement_o.getKey()
			End if 
			
		End for each 
		
	End for each 
	
	crgpdToolProgressBar(1; "arrêt")
	
Function resizeFullWidth($fullWidth_b; $objet_c : Collection)
/* -----------------------------------------------------------------------------
Fonction : RGPDDisplay.resizeFullWidth
	
	Permet de resizer par programmation un ojet pour l'adapter au plein écran ou \
		à la taille d'origine de la fenêtre
	
Paramètre
	$fullWidth_b -> Booléen qui indique si on est dans le cas d'une resize \
		d'un objet pour le plein écran
$objet_c -> Collection qui contient tous les noms d'objet à appliquer la resize
	
Historique
17/02/22 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $objet_t : Text
	var $gauche_el; $haut_el; $droite_el; $bas_el : Integer
	var $pointeur_p : Pointer
	
	For each ($objet_t; $objet_c)
		$pointeur_p:=OBJECT Get pointer:C1124(Objet nommé:K67:5; $objet_t)
		
		If (Is nil pointer:C315($pointeur_p)=False:C215)
			OBJECT GET COORDINATES:C663(*; $objet_t; $gauche_el; $haut_el; $droite_el; $bas_el)
			
			Case of 
				: ($fullWidth_b=True:C214)
					
					If (Form:C1466.objet[$objet_t]=Null:C1517)
						Form:C1466.objet[$objet_t]:=New object:C1471("gauche"; $gauche_el; "haut"; $haut_el; "droite"; $droite_el; "bas"; $bas_el)
					End if 
					
					$droite_el:=Screen width:C187(*)
				: (Form:C1466.objet[$objet_t]#Null:C1517)
					$gauche_el:=Form:C1466.objet[$objet_t].gauche
					$haut_el:=Form:C1466.objet[$objet_t].haut
					$droite_el:=Form:C1466.objet[$objet_t].droite
					$bas_el:=Form:C1466.objet[$objet_t].bas
			End case 
			
			OBJECT SET COORDINATES:C1248(*; $objet_t; $gauche_el; $haut_el; $droite_el; $bas_el)
		End if 
		
	End for each 
	
Function resizeWindows($nbColonne_el : Integer; $refFenetre_el : Integer)
/* -----------------------------------------------------------------------------
Fonction : RGPDDisplay.resizeWindows
	
Permet de resizer par programmation la fenêtre qui affiche les éléments à anonymiser
	
Paramètre
$nbColonne_el -> Nombre de colonne que la listbox doit contenir
$refFenetre_el -> Référence de la fenêtre où est située la listbox
	
Historique
17/02/22 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $gauche_el; $haut_el; $bas_el; $droite_el; $moitie_el; $largeur_el; $largeurForm_el; $hauteurForm_el; $gaucheCalcul_el; $droiteCalcul_el : Integer
	
	$largeur_el:=Screen width:C187(*)
	
	$droiteCalcul_el:=610+(150*($nbColonne_el-1))
	OBJECT SET COORDINATES:C1248(*; "List Box"; 240; 60; Choose:C955($droiteCalcul_el<=$largeur_el; $droiteCalcul_el; $largeur_el-20))
	
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