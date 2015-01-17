/** 
Cet onglet est consacré au dessin, sans modification des informations données en paramètres.

Liste des functions :
- draw_connectPoints(Forme _forme, float min_dist, float max_conn)
  -> dessine des connections entre tous les points d'une forme, selon :
     - leur distance
     - un nombre de connections maximum par point
     
- draw_randomConnections(Forme _forme, int _max)
  -> dessine ALEATOIREMENT des lignes entre des points de la Forme (_max == le nombre de lignes à générer)

- draw_texture3(Forme _forme, PImage bmp)
  -> dessine une texture ("bmp") dans un triangle formé de 3 points
     l'ordre naturel des points déterminera comment se forme ce triangle (méthode "vertex()" au sein d'un "beginShape()" / "endShape()" )
     
- draw_texture4(Forme _forme, PImage bmp)
  -> dessine une texture ("bmp") dans un quadrilatère formé de 4 points
     l'ordre naturel des points déterminera comment se forme ce quadrilatère (méthode "quad()")
   
- draw_shapeOnLine(Forme _forme, RShape _shape, float len)
  -> dessine une forme vectorielle prédéfinie ("_shape") dans l'onglet ZZ_Shapes, le long
     d'une ligne appartenant à la Forme
  -> la forme "_shape" sera plus ou moins écrasée en fonction du paramètre "len"

**/

/** Dessine des connections entre les points, selon plusieurs paramètres :
 - tri tous les points de sorte à ce que leur ordre reflète leur distance par rapport au centre de la Forme
 - la distance minimale pour qu'ils se connectent les uns les autres
 - le nombre maximum de connections par point       **/
void draw_connectPoints(Forme _forme, float min_dist, float max_conn) {
  ArrayList _points = (ArrayList) getAllPointsCentered(_forme);
  
  RPoint refRP, trgtRP;
  int count;
  for (int i=0; i<_points.size(); i++) {
    refRP = (RPoint) _points.get(i);
    count = 0;
    for (int j=0; j<_points.size(); j++) {
      if (i == j) continue;
      trgtRP = (RPoint) _points.get(j);

      // on vérifie que la distance minimum est respectée
      if ( refRP.dist(trgtRP) <= min_dist) {
        line(refRP.x, refRP.y, trgtRP.x, trgtRP.y);
        count++; // on compte le nombre de connection par point
      }

      if (count >= max_conn) break; // si trop de connections -> on change de point
    }
  }
}

/**
 Dessine des connections aléatoires entre chaque point de la Forme.
 Paramètre :
 - le nombre de ligne à créer
 **/
void draw_randomConnections(Forme _forme, int _max) {
  ArrayList _points = (ArrayList) getAllPoints(_forme);
  RPoint rpA, rpB;
  int idA, idB;
  for (int i=0; i<_max; i++) {
    idA = floor(random(_points.size()));
    idB = floor(random(_points.size()));
    if (idA == idB) {
      i--;
      continue;
    }
    else {
      rpA = (RPoint) _points.get(idA);
      rpB = (RPoint) _points.get(idB);
      line(rpA.x, rpA.y, rpB.x, rpB.y);
    }
  }
}

//-------------------------------------------------------
// Dessine une texture dans un espace défini par 4 points
void draw_texture4(Forme _forme, PImage bmp) {
  ArrayList _points = (ArrayList) getAllPoints(_forme);
  RPoint tmpRP;

  textureMode(NORMAL);
  beginShape();
  texture(bmp);

  for (int i=0; i<_points.size(); i++) {
    tmpRP = (RPoint) _points.get(i);

    if ( i%4 == 0 && i!=0 ) {
      endShape();
      beginShape();
      texture(bmp);
    }

    if (i%4==0) vertex(tmpRP.x, tmpRP.y, 0, 0);
    if (i%4==1) vertex(tmpRP.x, tmpRP.y, 1, 0);
    if (i%4==2) vertex(tmpRP.x, tmpRP.y, 1, 1);
    if (i%4==3) vertex(tmpRP.x, tmpRP.y, 0, 1);

    if ( i >= _points.size()-1) {
      endShape();
      break;
    }
  }
}

//-------------------------------------------------------
// Dessine une texture dans un espace défini par 3 points
void draw_texture3(Forme _forme, PImage bmp) {
  ArrayList _points = (ArrayList) getAllPoints(_forme);
  RPoint tmpRP;

  textureMode(NORMAL);
  beginShape();
  texture(bmp);

  for (int i=0; i<_points.size(); i++) {
    tmpRP = (RPoint) _points.get(i);

    if ( i%3 == 0 && i!=0 ) {
      endShape();
      beginShape();
      texture(bmp);
    }

    if (i%3==0) vertex(tmpRP.x, tmpRP.y, 0, 0);
    if (i%3==1) vertex(tmpRP.x, tmpRP.y, 1, 0);
    if (i%3==2) vertex(tmpRP.x, tmpRP.y, 1, 1);

    if ( i >= _points.size()-1) {
      endShape();
      break;
    }
  }
}

/**
Dessine une forme RShape prédéfinie sur chaque ligne de la forme.
Paramètres :
  _forme -> la 'Forme' de référence
  _shape -> l'objet 'RShape' à dessiner
  len    -> la 'hauteur' de la 'RShape'
**/
void draw_shapeOnLine(Forme _forme, RShape _shape, float len){
  ArrayList _transformed = (ArrayList) getAllLines(_forme);
  ArrayList _line;
  RPoint A, B;
  RShape _pattern;
  
  RPoint _center = _forme._center;
  RPoint vector; // distance entre le point ciblé et le "centre" de la forme
  
  for(int i=0; i<_transformed.size(); i++){
    _line = (ArrayList) _transformed.get(i);

    for(int j=0; j<_line.size()-1; j++){
      A = (RPoint) _line.get(j);
      B = (RPoint) _line.get(j+1);
      
      _pattern = (RShape) new RShape( _shape );
      float angle = atan2(B.y-A.y, B.x-A.x);
      
      _pattern.translate(A);
      _pattern.scale( A.dist(B) , len , A);
      _pattern.rotate(angle, A);
      
      _pattern.draw();
      
    }
  }
}
