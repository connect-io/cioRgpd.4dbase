<!-- Type your summary here -->
## Description

### Description
Gestion du formulaire d'anonymisation d'une base donnée 4D

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : checkSaveFileExist](#fonction--checkSaveFileExist)
* [Fonction : chooseTypeData](#fonction--chooseTypeData)
* [Fonction : getStructureDetail](#fonction--getStructureDetail)

--------------------------------------------------------------------------------

## Fonction : constructor

### Fonctionnement
```4d
cs.RGPDDisplay.new() -> $instance_o
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |


### Example
```4d
class_o := crgpdToolGetClass("RGPDDisplay").new()
```

--------------------------------------------------------------------------------

## Fonction : checkSaveFileExist
Permet de savoir si dans le fichier de relation du composant il existe déjà
un traitement d'anonymisation effectué pour la table sélectionnée

### Fonctionnement
```4d
class_o.checkSaveFileExist()
```

| Paramètre   | Type       | entrée/sortie | Description |
| ----------- | ---------- | ------------- | ----------- |



### Example
```4d
class_o.checkSaveFileExist()
```

--------------------------------------------------------------------------------

## Fonction : chooseTypeData
Permet de faire matcher un champ avec un type de valeur attendue (nom, prénom etc.)

### Fonctionnement
```4d
class_o.chooseTypeData()
```

| Paramètre   | Type       | entrée/sortie | Description |
| ----------- | ---------- | ------------- | ----------- |



### Example
```4d
class_o.chooseTypeData()
```

--------------------------------------------------------------------------------

## Fonction : getStructureDetail
Permet d'obtenir une collection avec le détail de la structure du client (table/champ)

### Fonctionnement
```4d
class_o.getStructureDetail()
```

| Paramètre          | Type       | entrée/sortie | Description |
| ------------------ | ---------- | ------------- | ----------- |
| $structureDetail_c | Collection | Sortie        | Collection qui contient le détail de la structure du client |



### Example
```4d
class_o.getStructureDetail()
```

--------------------------------------------------------------------------------