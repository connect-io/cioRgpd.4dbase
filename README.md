<p align="center"><a href="http://www.connect-io.fr" target="_blank">
    <img src="https://www.connect-io.fr/www/img/Connect-IO-noir.svg" width="300px">
</a></p>

# Présentation
Le composant cioRgpd permet d'anonymiser une base de donnée 4D
Il nécessite du code supplémentaire dans votre application notamment l'ajout de la méthode cioToolsGetStructureDetailClt qui permet d'obtenir l'architecture exacte de votre base de donnée afin que le composant puisse fonctionner, mais ne modifie aucune méthode de votre application (sauf la méthode sur ouverture pour charger le fichier de config du composant).

## Classes
* [RGPD](Documentation/Classes/RGPD.md)
* [RGPDDisplay](Documentation/Classes/RGPDDisplay.md)