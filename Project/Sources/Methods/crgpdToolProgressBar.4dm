//%attributes = {}
// ----------------------------------------------------
// Nom utilisateur (OS) : Rémy Scanu
// Date et heure : 07/02/22, 16:48:49
// ----------------------------------------------------
// Méthode : crgpdToolProgressBar
// Description
// 
//
// Paramètres
// ----------------------------------------------------
C_REAL:C285($1)
C_TEXT:C284($2)
C_BOOLEAN:C305($3)

C_BOOLEAN:C305($nonTempo_b)

Case of 
	: ($2="Initialisation")
		C_LONGINT:C283(progressBar_el)
		
		progressBar_el:=Progress New  // on crée une nouvelle barre
		
		Progress SET BUTTON ENABLED(progressBar_el; $3)
		//Progress SET ICON(progressBar_el; Storage.image["progress-bar"]; Vrai)
	: ($2="arrêt") | (Progress Stopped(progressBar_el)=True:C214)
		
		If (progressBar_el>0)  // Si la barre de progression n'a pas été arrêté
			Progress QUIT(progressBar_el)
			
			If (Progress Stopped(progressBar_el)=True:C214)  // Si l'utilisateur a cliqué sur le bouton stop on stop tout
				CLEAR VARIABLE:C89(progressBar_el)
			End if 
			
		End if 
		
	Else 
		Progress SET PROGRESS(progressBar_el; $1; $2; True:C214)
		
		If (Count parameters:C259=3)
			$nonTempo_b:=$3
		End if 
		
		If ($nonTempo_b=False:C215)
			DELAY PROCESS:C323(Current process:C322; 120)
		End if 
		
End case 