/** 
Cet onglet est consacré aux modificateurs, ces fonctions qui modifieront réellement les coordonnées
des points de notre objet "Forme".
La plupart de ces fonctions utilisent les deux listes de lignes de la Forme :
- list_original    : la liste des lignes telles qu'elles existent au moment de la conversion du SVG
- list_transformed : la liste des lignes transformées au fil des opérations

Liste des functions :
- mod_expandPoints(Forme _forme, float x, float y, float area, float val)
  -> décale les points de "val" pixels, compris dans une zone centrée sur "x" et "y", et 
     au diamètre égale à "area"
     
- mod_randomPoints(Forme _forme, float x, float y)
  -> décale chaque point de "_forme" d'une valeur aléatoire comprise entre ["-x";"x"], et ["-y";"y"]

NOTE : D'autres modificateurs existent au sein de la classe Forme.
**/


/** Décale chaque point de la Forme compris dans une zone définie par :
  - x et y : les coordonées du centre de la zone
  - area   : le diamètre de la zone
  - val    : la valeur de décalage en pixels      **/
void mod_expandPoints(Forme _forme, float x, float y, float area, float val){
  // Data -
  ArrayList _original    = (ArrayList) getOriginalLines(_forme);
  ArrayList _transformed = (ArrayList) getAllLines(_forme);
  ArrayList _newlines    = new ArrayList();
  ArrayList _lines;
  ArrayList _refs, _target;
  // Variables -
  RPoint    _center = new RPoint(x, y);
  RPoint    refRP, newRP; // RPoint temporaires
  RPoint    vector;
  float distance;
  float ratio;
  
  // On boucle sur chaque point de la Forme
  for(int i=0; i<_original.size(); i++){
    _refs   = (ArrayList) _original.get(i);
    _target = (ArrayList) _transformed.get(i);
    for(int p=0; p<_refs.size(); p++){
      refRP = (RPoint) _refs.get(p);
      newRP = (RPoint) _target.get(p);
      
      distance = refRP.dist(_center);
      ratio = distance / area;
      ratio = 1.0 - ratio;
      
      if(distance <= area){
        vector = new RPoint( refRP.x - _center.x, refRP.y - _center.y );
        vector.normalize();
        newRP.x = refRP.x + (vector.x * val * ratio);
        newRP.y = refRP.y + (vector.y * val * ratio);
      }
      else{
        newRP.x = refRP.x;
        newRP.y = refRP.y;
      }
    }
  }
}


/**
Points aléatoires
  - chaque point est déplacé aléatoirement dans une zone délimitée par des variations maximales en X et Y
**/
void mod_randomPoints(Forme _forme, float x, float y){
  ArrayList _transformed = (ArrayList) getAllLines(_forme);
  ArrayList _line;
  RPoint tmpRP;
  
  for(int i=0; i<_transformed.size(); i++){
    _line = (ArrayList) _transformed.get(i);
    for(int j=0; j<_line.size(); j++){
      tmpRP = (RPoint) _line.get(j);
      tmpRP.x = tmpRP.x + random(x)-(x/2);
      tmpRP.y = tmpRP.y + random(y)-(y/2);
    }
  }
}



