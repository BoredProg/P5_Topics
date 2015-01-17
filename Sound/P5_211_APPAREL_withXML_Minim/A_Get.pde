/** 
Cet onglet est consacré au rappatriement d'informations.
Toutes les fonctions ci-dessous retournent une liste de coordonnées appartenant à un objet Forme.

Liste des functions :
- getAllPoints(Forme _forme)         
  -> renvoie la liste de tous les points d'une forme, sans connection (pas de lignes)

- getAllPointsCentered(Forme _forme)
  -> renvoie la liste de tous les points d'une forme, trié du point le plus proche du centre
     au plus éloigné (utile pour dessiner des connections entre points)

- getAllLines(Forme _forme) 
  -> renvoie une liste à 2 dimensions, contenant toutes les lignes d'une Forme

- getOriginalLines(Forme _forme)
  -> renvoie une liste à 2 dimensions des lignes originelles (celles non modifiées)

- orderListByCenter(ArrayList _list, RPoint _center) 
  -> tri une liste de points du plus proche au plus éloigné d'un centre donné en paramètre
     (utilisé dans la fonction "getAllPointsCentered()" )
**/

// Retourne tous les points de la Forme, sans informations de lignes (tous les points sont au même niveau)
ArrayList getAllPoints(Forme _forme){
  ArrayList tmp = new ArrayList();
  ArrayList pts;
  for(int i=0; i<_forme.list_transformed.size(); i++){
    pts = (ArrayList) _forme.list_transformed.get(i);
    for(int j=0; j<pts.size(); j++){
      tmp.add((RPoint) new RPoint((RPoint) pts.get(j)));
    }
  }
  return tmp;
}

ArrayList getAllPointsCentered(Forme _forme){
  ArrayList tmp = new ArrayList();
  ArrayList centeredPts = (ArrayList) getAllPoints(_forme);
  centeredPts = orderListByCenter( centeredPts, _forme._center );
  return centeredPts;
}

// Retourne toutes les lignes actuelles (transformées) de la Forme
ArrayList getAllLines(Forme _forme){
  return (ArrayList) _forme.list_transformed.clone();
}
// Retourne toutes les lignes de la Forme, telles qu'elles étaient lors du chargement.
ArrayList getOriginalLines(Forme _forme){
  return (ArrayList) _forme.list_original.clone();
}


//////////////////////////////////
// Tri une liste de points en fonction de leur distance relative
// au RPoint "_center" passé en paramètre (du plus proche au plus éloigné).
ArrayList orderListByCenter(ArrayList _list, RPoint _center) {
  if (_list.size()==0) return _list;
  
  ArrayList newOrder = new ArrayList();
  RPoint tmpPt;
  float distance, distance2;
  boolean done;
  
  for (int i=0; i<_list.size(); i++) {
    tmpPt = (RPoint) _list.get(i);
    
    if (newOrder.size()==0) {
      newOrder.add((RPoint) tmpPt);
      continue;
    }
    
    done = false;
    for (int j=0; j<newOrder.size(); j++) {
      distance  = _center.dist(tmpPt);
      distance2 = _center.dist((RPoint) newOrder.get(j));

      if (distance < distance2) {
        newOrder.add(j, (RPoint) tmpPt);
        done = true;
        break;
      }
      if (j >= newOrder.size()-1 && !done) {
        newOrder.add((RPoint) tmpPt);
        break;
      }
    }
  }
  
  _list = (ArrayList) newOrder.clone();
  return _list;
}

