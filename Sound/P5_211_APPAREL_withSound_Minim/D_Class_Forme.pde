/**
La classe Forme :

Cette classe sert à simplifier une forme contenue dans un fichier SVG, afin de ne la considérer
que comme étant une succession de lignes, ne contenant aucune information de style.

Une fois le SVG chargé, puis "polygoniser" (via "polygonize()" ), on crée 2 listes à 2 dimensions :
- list_original    : la liste des lignes originelles
- list_transformed : liste dont on modifiera les informations au fil du temps

Au sein de cette classe se trouve quelque fonctions de dessin :
- draw(int ID)
  -> dessine la Forme soit sous forme de lignes (AS_LINES , 0) soit sous forme de points (AS_POINTS, 1)

- drawOriginal()
  -> dessine la Forme telle qu'elle était à son chargement
  
- tesselate(int num)
  -> divise et donc crée de nouvelles divisions (par groupes de 3 points)

**/

int AS_LINES   = 0;
int AS_POINTS  = 1;

class Forme
{
  ArrayList list_original;
  ArrayList list_transformed;
  RShape original;
  RPoint _center;
  float _width, _height;
  int tess_div, tess_request_div;

  Forme(String _url) {
    list_transformed = new ArrayList();
    loadSVG(_url);

    tess_div         = 1;
    tess_request_div = 1;
  }

  //---------------------------------------
  //- INIT
  void loadSVG(String _url) {
    original =  RG.loadShape(_url);

    if (original == null) {
      println("ERREUR : l'url du SVG est incorrecte.");
      return;
    }
    //-
    SVGtoForme(original);
  }

  void reset() {
    list_transformed = new ArrayList();
    tess_div = 1;

    ArrayList _lines;
    ArrayList _newLines;
    for (int i=0; i<list_original.size(); i++) {
      _lines = (ArrayList) list_original.get(i);
      _newLines = new ArrayList();
      for (int j=0; j<_lines.size(); j++) {
        _newLines.add((RPoint) new RPoint((RPoint) _lines.get(j)));
      }
      list_transformed.add((ArrayList) _newLines);
    }
  }

  //-
  void SVGtoForme(RShape _rs) {
    list_original = new ArrayList();
    list_transformed = new ArrayList();
    ArrayList tmpLine, tmpLine2;
    RShape rs = (RShape) new RShape(_rs);
    rs.polygonize(); // simplification de l'objet vectorielle RShape (régie par RG.setPolygonizer() dans le setup de l'application)

    // initialisation des variables liées à la forme chargée
    _center  = (RPoint) rs.getCenter();
    _width   = rs.getWidth();
    _height  = rs.getHeight();

    RPolygon tmpRP = (RPolygon) ((RShape) rs).toPolygon();
    RContour[] _contours = tmpRP.contours;
    RPoint[] _points;

    for (int i=0; i<_contours.length; i++) {
      _points = (RPoint[]) _contours[i].points;
      tmpLine = new ArrayList();
      tmpLine2 = new ArrayList();
      for (int p=0; p<_points.length; p++) {
        tmpLine.add((RPoint) new RPoint(_points[p].x, _points[p].y) );
        tmpLine2.add((RPoint) new RPoint(_points[p].x, _points[p].y) );
      }
      list_original.add((ArrayList) new ArrayList(tmpLine));
      list_transformed.add((ArrayList) new ArrayList(tmpLine2));
    }
  }

  //----------------------------------
  //- AFFICHAGE
  void draw(int _type) {
    // objets temporaires
    ArrayList _line;
    RPoint rp0 = new RPoint();
    RPoint rp1 = new RPoint();

    for (int i=0; i<list_transformed.size(); i++) {
      _line = (ArrayList) list_transformed.get(i);
      for (int j=0; j<_line.size(); j++) {
        rp0 = (RPoint) _line.get(j);
        if (j<_line.size()-1) rp1 = (RPoint) _line.get(j+1);

        // LINES -------------------
        if (_type == AS_LINES && j<_line.size()-1 ) {
          line(rp0.x, rp0.y, 
          rp1.x, rp1.y);
        }
        // POINTS ------------------------
        else if (_type == AS_POINTS) {
          point(rp0.x, rp0.y);
        }
      }
    }
  }

  //-------
  // Dessine la forme originelle, telle qu'elle se présentait lors du chargement initial.
  void drawOriginal() {
    original.draw();
  }

  //----
  // Division des triangles
  void tesselate(int d) {
    if(d < 1) d = 1;
    
    tess_request_div = d;
    if(tess_div > tess_request_div){
      SVGtoForme(original);
      reset();
      tesselate(tess_request_div);
    }
    if (tess_div == tess_request_div) return;

    ArrayList new_original    = new ArrayList();
    ArrayList new_transformed = new ArrayList();

    RPoint rp0, rp1, rp2;    // points de référence
    RPoint rp01, rp02, rp12; // nouveaux points
    ArrayList _lines, tmpLine, tmpLine2;


    /* Crée un nouveau point au centre de chaque ligne d'un triangles
       dans l'ordre rp0->rp1=rp01, rp0->rp2=rp02, etc.
       Puis on crée de nouvelles lignes dans cet ordre :
       0->01->02->0 ; 01->12->02->01 ; 01->1->12->01 ; 2->12->02->2
       En partant de 3 lignes, on arrive donc à 16 lignes ! */
    for (int i=0; i<list_original.size(); i++) {
      _lines = (ArrayList) list_original.get(i);

      for (int p=0; p<_lines.size()-3; p+=3) {
        rp0 = (RPoint) _lines.get(p);
        rp1 = (RPoint) _lines.get(p+1);
        rp2 = (RPoint) _lines.get(p+2);

        rp01 = new RPoint( (rp0.x+rp1.x)/2, (rp0.y+rp1.y)/2 );
        rp02 = new RPoint( (rp0.x+rp2.x)/2, (rp0.y+rp2.y)/2 );
        rp12 = new RPoint( (rp1.x+rp2.x)/2, (rp1.y+rp2.y)/2 );
        
        tmpLine = new ArrayList();
        tmpLine2= new ArrayList();
        
        tmpLine.add( (RPoint) new RPoint( rp0  ) );  tmpLine.add( (RPoint) new RPoint( rp01  ) );
        tmpLine.add( (RPoint) new RPoint( rp02  ) ); tmpLine.add( (RPoint) new RPoint( rp0  ) );
        
        tmpLine.add( (RPoint) new RPoint( rp1  ) );  tmpLine.add( (RPoint) new RPoint( rp01  ) );
        tmpLine.add( (RPoint) new RPoint( rp12  ) ); tmpLine.add( (RPoint) new RPoint( rp1  ) );
        
        tmpLine.add( (RPoint) new RPoint( rp01  ) ); tmpLine.add( (RPoint) new RPoint( rp02  ) );
        tmpLine.add( (RPoint) new RPoint( rp12  ) ); tmpLine.add( (RPoint) new RPoint( rp01  ) );
        
        tmpLine.add( (RPoint) new RPoint( rp2  ) );  tmpLine.add( (RPoint) new RPoint( rp02  ) );
        tmpLine.add( (RPoint) new RPoint( rp12  ) ); tmpLine.add( (RPoint) new RPoint( rp2  ) );
        
        tmpLine2.add( (RPoint) new RPoint( rp0  ) );  tmpLine2.add( (RPoint) new RPoint( rp01  ) );
        tmpLine2.add( (RPoint) new RPoint( rp02  ) ); tmpLine2.add( (RPoint) new RPoint( rp0  ) );
        
        tmpLine2.add( (RPoint) new RPoint( rp1  ) );  tmpLine2.add( (RPoint) new RPoint( rp01  ) );
        tmpLine2.add( (RPoint) new RPoint( rp12  ) ); tmpLine2.add( (RPoint) new RPoint( rp1  ) );
        
        tmpLine2.add( (RPoint) new RPoint( rp01  ) ); tmpLine2.add( (RPoint) new RPoint( rp02  ) );
        tmpLine2.add( (RPoint) new RPoint( rp12  ) ); tmpLine2.add( (RPoint) new RPoint( rp01  ) );
        
        tmpLine2.add( (RPoint) new RPoint( rp2  ) );  tmpLine2.add( (RPoint) new RPoint( rp02  ) );
        tmpLine2.add( (RPoint) new RPoint( rp12  ) ); tmpLine2.add( (RPoint) new RPoint( rp2  ) );
        
        
        
        new_original.add((ArrayList) tmpLine.clone());
        new_transformed.add((ArrayList) tmpLine2.clone());
      }
    }
    
    list_original = new ArrayList( (ArrayList) new_original.clone() );
    list_transformed = new ArrayList( (ArrayList) new_transformed.clone() );

    tess_div++;
    if (tess_div < tess_request_div) {
      // récursif si nécessaire (<- le but "d" n'a pas encore été atteint)
      tesselate(tess_request_div);
    }
  }
  
  
}

