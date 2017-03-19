# gdrive-pandoc
Unix script to retreive GDrives sources and compile them to PDF using Pandoc.

## Installation

Ce convertisseur utilise [Gdrive](https://github.com/prasmussen/gdrive), [Pandoc](http://pandoc.org/) et [LaTeX](https://fr.wikipedia.org/wiki/LaTeX).

1. Installer [Gdrive](https://github.com/prasmussen/gdrive).
2. Installer [Pandoc](http://pandoc.org/).
3. Installer LaTeX et Xelatex:
    `sudo apt-get install texlive texlive-xetex`

## Configuration rapide

1. Ouvrir le fichier `config/_CONFIG.txt` :

| Propriété  |  Sens |
|--------------|--------------|
| SECTIONS_FILEPATH  | Fichier définissant les références GDrive à compiler  |
| BUILDNAME  | Nom de sortie  |
| REFERENCES  |  Référence GDrive à utiliser comme référence (natbib) |
| REFERENCES_NAME  |  Le nom du document GDrive à utiliser comme références suivi de l'extension `.asc`. *Exemple : si le document s'appelle "Références" régler cette variable sur `Références.asc` |
|BEFORE|Fichier à insérer avant le début du document (Déprécié : `$include-before$` dans la template)|
|AFTER|Fichier à insérer après la fin du document (Déprécié : `$include-after$` dans la template)|
|TEMPLATE|Template LaTeX à utiliser|
|CSL|Fichier CSL pour la bibliographie| 
|EXPORT|Référence du *Dossier* Gdrive vers lequel exporter la compilation|

2. Ouvrir le fichier `config/_SECTIONS.txt` :

Utiliser une ligne pour référencer un document GDrive. Ils seront assembler les uns après les autres.

## Composition

Sur les documents à assembler sur Google Drive :

- il est inutile d'user de style : LaTeX aplanit tout (pas de gras, ni d'italique);
- pour ajouter une référence :

1. Dans le Google doc Références, ajouter une référence via **l'un des trois** templates suivants :

*NB: Utilisez un nom de référence unique à vos références. C'est un ID écrit avec des LETTRES MAJUSCULES ou minuscules ou des chiffres. Pas d'espace, pas de tirets, pas d'underscore. Ex: Pour nommer le document "Budget Jaune 2016" vous pouvez créer la référence budgetJaune2016*

```
@article{nomDeReferenceUnique,
    author =       "Albert Einstein",
    title =        "Zur Elektrodynamik bewegter",
    journal =      "Annalen der Physik",
    volume =       "322",
    number =       "10",
    pages =        "891--921",
    year =         "1905",
    DOI =          "http://dx.doi.org/10.1002/andp.19053221004"
}

@book{nomDeReferenceUnique,
    author    = "Michel Goossens and Frank Mittelbach and Alexander Samarin",
    title     = "The Companion",
    year      = "1993",
    publisher = "Addison-Wesley",
    address   = "Reading, Massachusetts"
}

@misc{nomDeReferenceUnique,
    author    = "Donald Knuth",
    title     = "Knuth: Computers and Typesetting",
    url       = "http://www-cs-faculty.stanford.edu/\~{}uno/abcde.html"
}
```

*NB: Si vous n'avez pas un certain champ, supprimez-le. Mais vous devez avoir a minima l'auteur et le titre*

2. Pour citer votre référence dans un autre google doc du rapport, utilisez simplement dans le texte votre ID de référence entre accolades : {nomDeReferenceUnique}

- pour créer une note de bas de page :
    - N'utilisez pas la fonctionnalité "Note de bas de page" de Google ! Mettez votre note de bas de page entre double-accolades. Attention, votre note de bas de page doit être un unique paragraphe.
    - Exemple: {{Coucou c'est cool.}}
    - Contre-exemple: {{Ceci est écrit.
    Sur plusieurs paragraphes.
    Ca ne marchera pas.}}


## Compilation

Lancer la commande `make create` pour créer le rapport et `make export` pour l'exporter ensuite sur votre Drive (ou `make convert` pour faire ces deux opérations d'un coup).

