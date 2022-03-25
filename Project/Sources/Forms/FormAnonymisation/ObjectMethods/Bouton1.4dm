var $table_t : Text
var $nbNewRecord_el; $i_el : Integer
var $avatarPerson_o : cs:C1710.avatarPerson

Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		OBJECT SET ENABLED:C1123(*; OBJECT Get name:C1087(Objet courant:K67:2); False:C215)
	: (Form event code:C388=Sur clic:K2:4)
		$table_t:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "dataClassList")->currentValue
		$nbNewRecord_el:=Num:C11(Request:C163("Nombre de nouveaux enregistrements à créer pour la dataclasse « "+$table_t+" » ?"; "1"; "Valider"; "Annuler"))
		
		TRACE:C157
		// TODO contrôle pour ne pouvoir créer que sur des tables spécifiques
		If ($nbNewRecord_el>0)
			$avatarPerson_o:=cs:C1710.avatarPerson.new()
			
			For ($i_el; 1; $nbNewRecord_el)
				$avatarPerson_o.generate()
			End for 
			
		End if 
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 