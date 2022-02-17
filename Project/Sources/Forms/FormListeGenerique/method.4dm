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
			
			OBJECT SET TITLE:C194(*; "Entête"+String:C10($i_el); Form:C1466.column[$i_el-1].titre)
		End for 
		
		GET WINDOW RECT:C443($gauche_el; $haut_el; $droite_el; $bas_el; Frontmost window:C447)
		FORM GET PROPERTIES:C674("FormListeGenerique"; $largeurForm_el; $hauteurForm_el)
		
		$largeurForm_el:=$largeurForm_el+(285*(Form:C1466.column.length-1))
		$gaucheCalcul_el:=((Screen width:C187(*)/2)-10)-($largeurForm_el/2)
		
		If ($gaucheCalcul_el<0)  // La Fenêtre va être plus large que la largeur de l'écran...
			$gaucheCalcul_el:=20
			$droiteCalcul_el:=Screen width:C187(*)-20
		Else 
			$droiteCalcul_el:=((Screen width:C187(*)/2)-10)+($largeurForm_el/2)
		End if 
		
		SET WINDOW RECT:C444($gaucheCalcul_el; $haut_el; $droiteCalcul_el; $bas_el; Frontmost window:C447; *)
		OBJECT SET COORDINATES:C1248(*; "List Box"; $gaucheCalcul_el; 20; $droiteCalcul_el)
End case 