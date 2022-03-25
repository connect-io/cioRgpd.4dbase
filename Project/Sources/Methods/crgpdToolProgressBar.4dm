//%attributes = {}
/*------------------------------------------------------------------------------
Méthode : crgpdToolProgressBar

Méthode qui permet de gérer une barre de progression

Historique
04/02/22 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
C_REAL:C285($1)
C_TEXT:C284($2)
C_BOOLEAN:C305($3)
C_TEXT:C284($4)

C_BOOLEAN:C305($nonTempo_b)

Case of 
	: ($2="Initialisation")
		C_LONGINT:C283(progressBar_el)
		
		progressBar_el:=Progress New  // on crée une nouvelle barre
		Progress SET BUTTON ENABLED(progressBar_el; $3)
		
		If (Count parameters:C259=4)
			Progress SET ICON(progressBar_el; Storage:C1525.image[$4]; True:C214)
		Else 
			Progress SET ICON(progressBar_el; Storage:C1525.image["progress-bar"]; True:C214)
		End if 
		
	: ($2="arrêt") | (Progress Stopped(progressBar_el)=True:C214)
		
		If (progressBar_el>0)  // Si la barre de progression n'a pas été arrêté
			Progress QUIT(progressBar_el)
			
			If (Progress Stopped(progressBar_el)=True:C214)  // Si l'utilisateur a cliqué sur le bouton stop on stop tout
				CLEAR VARIABLE:C89(progressBar_el)
			End if 
			
		End if 
		
	Else 
		Progress SET PROGRESS(progressBar_el; $1; $2; True:C214)
		
		If (Count parameters:C259>=3)
			$nonTempo_b:=$3
		End if 
		
		If ($nonTempo_b=False:C215)
			DELAY PROCESS:C323(Current process:C322; 120)
		End if 
		
End case 