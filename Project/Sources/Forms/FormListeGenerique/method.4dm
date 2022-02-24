Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		var $i_el; $gauche_el; $haut_el; $droite_el; $bas_el; $largeurForm_el; $hauteurForm_el; $gaucheCalcul_el; $droiteCalcul_el : Integer
		var $data_o : Object
		var $collection_c : Collection
		var $pointeur_p : Pointer
		
		var elementSelection_c : Collection
		
		elementSelection_c:=New collection:C1472
		
		If (Form:C1466.data.length>0)
			$collection_c:=OB Keys:C1719(Form:C1466.data[0])
		End if 
		
		For ($i_el; 1; Form:C1466.column.length)
			$pointeur_p:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Colonne"+String:C10($i_el))
			
			If ($i_el=1)
				LISTBOX SET COLUMN FORMULA:C1203(*; "Colonne1"; "This."+$collection_c[$i_el-1]; Value type:C1509(Form:C1466.data[0][$collection_c[$i_el-1]]))
			Else 
				LISTBOX INSERT COLUMN FORMULA:C970(*; "List Box"; $i_el+1; "Colonne"+String:C10($i_el); "This."+$collection_c[$i_el-1]; Value type:C1509(Form:C1466.data[0][$collection_c[$i_el-1]]); "Entête"+String:C10($i_el); $pointeur_p)
			End if 
			
			If (Form:C1466.column[$i_el-1]["text-align"]#Null:C1517)
				OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "Colonne"+String:C10($i_el); Form:C1466.column[$i_el-1]["text-align"])
			End if 
			
			OBJECT SET TITLE:C194(*; "Entête"+String:C10($i_el); Form:C1466.column[$i_el-1].titre)
		End for 
		
		OBJECT GET COORDINATES:C663(*; "List Box"; $gauche_el; $haut_el; $droite_el; $bas_el)
		
		Case of 
			: (Form:C1466.title=Null:C1517) & (Form:C1466.subTitle=Null:C1517)
				crgpdToolMoveObject(0; New collection:C1472("Zone de saisie"; "Zone de saisie1"))
			: (Form:C1466.title=Null:C1517)
				crgpdToolMoveObject(0; New collection:C1472("Zone de saisie"))
				
				OBJECT SET COORDINATES:C1248(*; "Zone de saisie1"; $gauche_el; 20)
				OBJECT SET COORDINATES:C1248(*; "List Box"; $gauche_el; 60)
			: (Form:C1466.subTitle=Null:C1517)
				crgpdToolMoveObject(0; New collection:C1472("Zone de saisie1"))
				
				OBJECT SET COORDINATES:C1248(*; "List Box"; $gauche_el; 60)
		End case 
		
		GET WINDOW RECT:C443($gauche_el; $haut_el; $droite_el; $bas_el; Frontmost window:C447)
		FORM GET PROPERTIES:C674("FormListeGenerique"; $largeurForm_el; $hauteurForm_el)
		
		$largeurForm_el:=$largeurForm_el+(285*(Form:C1466.column.length-1))
		$gaucheCalcul_el:=((Screen width:C187(*)/2)-10)-($largeurForm_el/2)
		
		If ($gaucheCalcul_el<0)  // La Fenêtre va être plus large que la largeur de l'écran...
			$gaucheCalcul_el:=20
			$droiteCalcul_el:=Screen width:C187(*)-60
		Else 
			$droiteCalcul_el:=((Screen width:C187(*)/2)-10)+($largeurForm_el/2)
		End if 
		
		SET WINDOW RECT:C444($gaucheCalcul_el; $haut_el; $droiteCalcul_el; $bas_el; Frontmost window:C447; *)
		
		If (Form:C1466.title#Null:C1517)
			OBJECT SET COORDINATES:C1248(*; "Zone de saisie"; $gaucheCalcul_el; 20; $droiteCalcul_el)
		End if 
		
		If (Form:C1466.subTitle#Null:C1517)
			OBJECT SET COORDINATES:C1248(*; "Zone de saisie1"; $gaucheCalcul_el; 60; $droiteCalcul_el)
		End if 
		
		OBJECT SET COORDINATES:C1248(*; "List Box"; $gaucheCalcul_el; Choose:C955(Form:C1466.subTitle#Null:C1517; 120; 20); $droiteCalcul_el)
End case 