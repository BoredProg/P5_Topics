import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.opengl.*; 
import geomerative.*; 
import ddf.minim.signals.*; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 
import ddf.minim.ugens.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P5_211_APPAREL_withSound_Minim extends PApplet {

/**
 - - - - - - - --
 A P P A R E L 2D
 - - - - - - - --
 Cette application simule les d\u00e9formations apport\u00e9es \u00e0 une forme vectorielle par des param\u00e8tres.
 La forme en soi est stock\u00e9e dans un fichier SVG, et est convertie via une classe personnalis\u00e9e
 en une succession de lignes (2 points).
 
 Les d\u00e9tails de la classe nomm\u00e9e "Forme" se trouve \u00e0 l'onglet "D_Class_Forme", qui regroupe l'ensemble
 des m\u00e9thodes n\u00e9cessaires \u00e0 la conversion du SVG, ainsi que quelques m\u00e9thodes utilitaires (comme "reset()");
 
 On distinguera 3 actions possibles requi\u00e9rant cet objet Forme :
 - l'obtention d'information :              dans l'onglet "A_Get"
 - le dessin de ces informations :          dans l'onglet "B_Draw"
 - et la modification de ces informations : dans l'onglet "C_Modificateurs"
 
 Ces m\u00e9thodes ont \u00e9t\u00e9 volontairement s\u00e9par\u00e9es de la classe, afin de permettre une meilleure compr\u00e9hension 
 du code, et ne pas avoir \u00e0 parcourir un fichier de classe interminable !
 
 N'h\u00e9sitez pas \u00e0 parcourir ces 3 onglets afin d'y d\u00e9couvrir les options mises \u00e0 votre disposition ! :)
 **/


// Imports des librairies externes

  







//------------------------------------------------------------
//  VARIABLES GLOBALES  accessibles \u00e0 tous les niveaux du code

// Variables spaciales
float view_X, view_Y;
float real_X, real_Y;

// Objets
Forme apparel; // classe personnalis\u00e9e simplifiant une forme SVG en succession de lignes
PImage textureBmp0, textureBmp1, textureBmp2; // deux fichiers de texture 

// Audio
Minim minim;
AudioInput in;

//----------------------------------
//  SETUP --------------------------
public void setup() {
  // Geomerative settings
  RG.init(this);
  RG.ignoreStyles(); // on ne tiendra pas compte des valeurs de styles du SVG charg\u00e9
  RG.setPolygonizer(RG.ADAPTATIVE); // MODE : comment Geomerative simplifie-t-il une forme vectorielle (via la m\u00e9thode "polygonize()" )

  // Onglet "ZZ_Shapes" : 
  // On cr\u00e9e tous les objets RShape utilis\u00e9s pour l'ORNEMENTATION de la 'Forme' principale
  init_SHAPES(); // ces formes ainsi cr\u00e9\u00e9es pourront \u00eatre dessin\u00e9es param\u00e9triquement

  // On charge les textures dans des objets PImage (Processing Image)
  // dont on peut \u00e9ventuellement se servir pour remplir les triangles de la forme
  textureBmp0 = loadImage("texture_chat-blanc.jpg"); // pour les felinophiles =^.^=
  textureBmp1 = loadImage("texture_ysl.jpg"); // pour ceux aux go\u00fbts douteux ...
  textureBmp2 = loadImage("texture_jambon.jpg"); // pour ceux qui aiment le gras ! :)

  // General settings
  //hint(DISABLE_OPENGL_2X_SMOOTH); // pas d'anti-aliasing par OpenGL
  size(displayWidth/2, displayHeight-30, OPENGL);   // cr\u00e9ation de la fen\u00eatre, et d\u00e9finition du mode de rendu; ici : OpenGL

  // Onglet "D_Class_Forme" : 
  // On cr\u00e9e notre objet "Forme" en lui indiquant le nom du SVG \u00e0 convertir
  apparel = new Forme("apparel_2D.svg");
  
  /* init audio */
  minim = new Minim(this);
}


//-----------------------------------
//  MAIN LOOP -----------------------
public void draw() {
  if(in != null) println("Volume sonore (0.0-1.0) : "+ ((AudioBuffer) in.mix).level());
  
  // Background and color settings
  background(255);
  strokeWeight(1);

  // VIEW settings
  view_X = width/2 + apparel._center.x *-1;  // on calcule de quoi combien de pixels doit-on d\u00e9caler 
  view_Y = height/2 + apparel._center.y *-1; // la sc\u00e8ne toute enti\u00e8re afin de placer la Forme au centre de l'\u00e9cran


  // pushMatrix() and popMatrix() isole des transformations de matrice
  pushMatrix(); //-----------------------------------------------
  // on d\u00e9place la sc\u00e8ne aux coordonn\u00e9es calcul\u00e9es juste au-dessus
  translate(view_X, view_Y);
  // on recalcule les coordonn\u00e9es de la souris, en fonction du d\u00e9calage op\u00e9r\u00e9e pr\u00e9c\u00e9demment
  real_X = mouseX - view_X; // real mouse X position
  real_Y = mouseY - view_Y; // real mouse Y position

  // Color settings
  noFill();   // pas de remplissage lors du dessin
  noStroke(); // pas de contour lors du dessin

  // - - - - - - - - - - - - - - - - - - - - - - - - 
  // TRANSFORMATIONS (les points sont modifi\u00e9s)
  // - les transformations doivent \u00eatre effectu\u00e9es avant le dessin, afin de voir ses r\u00e9percussions


  // - - - - - - - - - - - - - - - - - - - - - - - - 
  // DESSINS (les points sont utilis\u00e9s, mais pas transform\u00e9s)
  // -  
  stroke(color(0, 0, 0, 100)); // les lignes seront de couleur noir
  if(in!=null) draw_shapeOnLine(apparel, shape_SPIKES,  ((AudioBuffer) in.mix).level() *100.0f);
  else apparel.draw(AS_LINES); // on dessine les lignes de la forme.

  

  stroke(color(255, 0, 0)); // les lignes seront de couleur rouge
  strokeWeight(3);
  apparel.draw(AS_POINTS); // on dessine les points de chaque ligne de la forme


  // On dessine le centre de la FORME par une ellipse (afin de v\u00e9rifier que le centre est bien... au centre !)
  stroke(255, 0, 0);
  ellipse(apparel._center.x, apparel._center.y, 10, 10);

  popMatrix(); //-----------------------------------------------------
}


//////////////////////////////////////////////////////////////////////
public void keyPressed() {
  if (key == ' ') apparel.reset(); // SPACEBAR == reset de la Forme
  if (key == 'a') in = minim.getLineIn();
}


public void stop()
{
  // the AudioInput you got from Minim.getLineIn()
  in.close();
  minim.stop();
  
  // this calls the stop method that
  // you are overriding by defining your own
  // it must be called so that your application
  // can do all the cleanup it would normally do
  super.stop();
}

/** 
Cet onglet est consacr\u00e9 au rappatriement d'informations.
Toutes les fonctions ci-dessous retournent une liste de coordonn\u00e9es appartenant \u00e0 un objet Forme.

Liste des functions :
- getAllPoints(Forme _forme)         
  -> renvoie la liste de tous les points d'une forme, sans connection (pas de lignes)

- getAllPointsCentered(Forme _forme)
  -> renvoie la liste de tous les points d'une forme, tri\u00e9 du point le plus proche du centre
     au plus \u00e9loign\u00e9 (utile pour dessiner des connections entre points)

- getAllLines(Forme _forme) 
  -> renvoie une liste \u00e0 2 dimensions, contenant toutes les lignes d'une Forme

- getOriginalLines(Forme _forme)
  -> renvoie une liste \u00e0 2 dimensions des lignes originelles (celles non modifi\u00e9es)

- orderListByCenter(ArrayList _list, RPoint _center) 
  -> tri une liste de points du plus proche au plus \u00e9loign\u00e9 d'un centre donn\u00e9 en param\u00e8tre
     (utilis\u00e9 dans la fonction "getAllPointsCentered()" )
**/

// Retourne tous les points de la Forme, sans informations de lignes (tous les points sont au m\u00eame niveau)
public ArrayList getAllPoints(Forme _forme){
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

public ArrayList getAllPointsCentered(Forme _forme){
  ArrayList tmp = new ArrayList();
  ArrayList centeredPts = (ArrayList) getAllPoints(_forme);
  centeredPts = orderListByCenter( centeredPts, _forme._center );
  return centeredPts;
}

// Retourne toutes les lignes actuelles (transform\u00e9es) de la Forme
public ArrayList getAllLines(Forme _forme){
  return (ArrayList) _forme.list_transformed.clone();
}
// Retourne toutes les lignes de la Forme, telles qu'elles \u00e9taient lors du chargement.
public ArrayList getOriginalLines(Forme _forme){
  return (ArrayList) _forme.list_original.clone();
}


//////////////////////////////////
// Tri une liste de points en fonction de leur distance relative
// au RPoint "_center" pass\u00e9 en param\u00e8tre (du plus proche au plus \u00e9loign\u00e9).
public ArrayList orderListByCenter(ArrayList _list, RPoint _center) {
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

/** 
Cet onglet est consacr\u00e9 au dessin, sans modification des informations donn\u00e9es en param\u00e8tres.

Liste des functions :
- draw_connectPoints(Forme _forme, float min_dist, float max_conn)
  -> dessine des connections entre tous les points d'une forme, selon :
     - leur distance
     - un nombre de connections maximum par point
     
- draw_randomConnections(Forme _forme, int _max)
  -> dessine ALEATOIREMENT des lignes entre des points de la Forme (_max == le nombre de lignes \u00e0 g\u00e9n\u00e9rer)

- draw_texture3(Forme _forme, PImage bmp)
  -> dessine une texture ("bmp") dans un triangle form\u00e9 de 3 points
     l'ordre naturel des points d\u00e9terminera comment se forme ce triangle (m\u00e9thode "vertex()" au sein d'un "beginShape()" / "endShape()" )
     
- draw_texture4(Forme _forme, PImage bmp)
  -> dessine une texture ("bmp") dans un quadrilat\u00e8re form\u00e9 de 4 points
     l'ordre naturel des points d\u00e9terminera comment se forme ce quadrilat\u00e8re (m\u00e9thode "quad()")
   
- draw_shapeOnLine(Forme _forme, RShape _shape, float len)
  -> dessine une forme vectorielle pr\u00e9d\u00e9finie ("_shape") dans l'onglet ZZ_Shapes, le long
     d'une ligne appartenant \u00e0 la Forme
  -> la forme "_shape" sera plus ou moins \u00e9cras\u00e9e en fonction du param\u00e8tre "len"

**/

/** Dessine des connections entre les points, selon plusieurs param\u00e8tres :
 - tri tous les points de sorte \u00e0 ce que leur ordre refl\u00e8te leur distance par rapport au centre de la Forme
 - la distance minimale pour qu'ils se connectent les uns les autres
 - le nombre maximum de connections par point       **/
public void draw_connectPoints(Forme _forme, float min_dist, float max_conn) {
  ArrayList _points = (ArrayList) getAllPointsCentered(_forme);
  
  RPoint refRP, trgtRP;
  int count;
  for (int i=0; i<_points.size(); i++) {
    refRP = (RPoint) _points.get(i);
    count = 0;
    for (int j=0; j<_points.size(); j++) {
      if (i == j) continue;
      trgtRP = (RPoint) _points.get(j);

      // on v\u00e9rifie que la distance minimum est respect\u00e9e
      if ( refRP.dist(trgtRP) <= min_dist) {
        line(refRP.x, refRP.y, trgtRP.x, trgtRP.y);
        count++; // on compte le nombre de connection par point
      }

      if (count >= max_conn) break; // si trop de connections -> on change de point
    }
  }
}

/**
 Dessine des connections al\u00e9atoires entre chaque point de la Forme.
 Param\u00e8tre :
 - le nombre de ligne \u00e0 cr\u00e9er
 **/
public void draw_randomConnections(Forme _forme, int _max) {
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
// Dessine une texture dans un espace d\u00e9fini par 4 points
public void draw_texture4(Forme _forme, PImage bmp) {
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
// Dessine une texture dans un espace d\u00e9fini par 3 points
public void draw_texture3(Forme _forme, PImage bmp) {
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
Dessine une forme RShape pr\u00e9d\u00e9finie sur chaque ligne de la forme.
Param\u00e8tres :
  _forme -> la 'Forme' de r\u00e9f\u00e9rence
  _shape -> l'objet 'RShape' \u00e0 dessiner
  len    -> la 'hauteur' de la 'RShape'
**/
public void draw_shapeOnLine(Forme _forme, RShape _shape, float len){
  ArrayList _transformed = (ArrayList) getAllLines(_forme);
  ArrayList _line;
  RPoint A, B;
  RShape _pattern;
  
  RPoint _center = _forme._center;
  RPoint vector; // distance entre le point cibl\u00e9 et le "centre" de la forme
  
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
/** 
Cet onglet est consacr\u00e9 aux modificateurs, ces fonctions qui modifieront r\u00e9ellement les coordonn\u00e9es
des points de notre objet "Forme".
La plupart de ces fonctions utilisent les deux listes de lignes de la Forme :
- list_original    : la liste des lignes telles qu'elles existent au moment de la conversion du SVG
- list_transformed : la liste des lignes transform\u00e9es au fil des op\u00e9rations

Liste des functions :
- mod_expandPoints(Forme _forme, float x, float y, float area, float val)
  -> d\u00e9cale les points de "val" pixels, compris dans une zone centr\u00e9e sur "x" et "y", et 
     au diam\u00e8tre \u00e9gale \u00e0 "area"
     
- mod_randomPoints(Forme _forme, float x, float y)
  -> d\u00e9cale chaque point de "_forme" d'une valeur al\u00e9atoire comprise entre ["-x";"x"], et ["-y";"y"]

NOTE : D'autres modificateurs existent au sein de la classe Forme.
**/


/** D\u00e9cale chaque point de la Forme compris dans une zone d\u00e9finie par :
  - x et y : les coordon\u00e9es du centre de la zone
  - area   : le diam\u00e8tre de la zone
  - val    : la valeur de d\u00e9calage en pixels      **/
public void mod_expandPoints(Forme _forme, float x, float y, float area, float val){
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
      ratio = 1.0f - ratio;
      
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
Points al\u00e9atoires
  - chaque point est d\u00e9plac\u00e9 al\u00e9atoirement dans une zone d\u00e9limit\u00e9e par des variations maximales en X et Y
**/
public void mod_randomPoints(Forme _forme, float x, float y){
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



/**
La classe Forme :

Cette classe sert \u00e0 simplifier une forme contenue dans un fichier SVG, afin de ne la consid\u00e9rer
que comme \u00e9tant une succession de lignes, ne contenant aucune information de style.

Une fois le SVG charg\u00e9, puis "polygoniser" (via "polygonize()" ), on cr\u00e9e 2 listes \u00e0 2 dimensions :
- list_original    : la liste des lignes originelles
- list_transformed : liste dont on modifiera les informations au fil du temps

Au sein de cette classe se trouve quelque fonctions de dessin :
- draw(int ID)
  -> dessine la Forme soit sous forme de lignes (AS_LINES , 0) soit sous forme de points (AS_POINTS, 1)

- drawOriginal()
  -> dessine la Forme telle qu'elle \u00e9tait \u00e0 son chargement
  
- tesselate(int num)
  -> divise et donc cr\u00e9e de nouvelles divisions (par groupes de 3 points)

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
  public void loadSVG(String _url) {
    original =  RG.loadShape(_url);

    if (original == null) {
      println("ERREUR : l'url du SVG est incorrecte.");
      return;
    }
    //-
    SVGtoForme(original);
  }

  public void reset() {
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
  public void SVGtoForme(RShape _rs) {
    list_original = new ArrayList();
    list_transformed = new ArrayList();
    ArrayList tmpLine, tmpLine2;
    RShape rs = (RShape) new RShape(_rs);
    rs.polygonize(); // simplification de l'objet vectorielle RShape (r\u00e9gie par RG.setPolygonizer() dans le setup de l'application)

    // initialisation des variables li\u00e9es \u00e0 la forme charg\u00e9e
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
  public void draw(int _type) {
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
  // Dessine la forme originelle, telle qu'elle se pr\u00e9sentait lors du chargement initial.
  public void drawOriginal() {
    original.draw();
  }

  //----
  // Division des triangles
  public void tesselate(int d) {
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

    RPoint rp0, rp1, rp2;    // points de r\u00e9f\u00e9rence
    RPoint rp01, rp02, rp12; // nouveaux points
    ArrayList _lines, tmpLine, tmpLine2;


    /* Cr\u00e9e un nouveau point au centre de chaque ligne d'un triangles
       dans l'ordre rp0->rp1=rp01, rp0->rp2=rp02, etc.
       Puis on cr\u00e9e de nouvelles lignes dans cet ordre :
       0->01->02->0 ; 01->12->02->01 ; 01->1->12->01 ; 2->12->02->2
       En partant de 3 lignes, on arrive donc \u00e0 16 lignes ! */
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
      // r\u00e9cursif si n\u00e9cessaire (<- le but "d" n'a pas encore \u00e9t\u00e9 atteint)
      tesselate(tess_request_div);
    }
  }
  
  
}

/**
Ici nous cr\u00e9ons tous les objets RShape dont on se sert pour habiller la 'Forme'

Afin de contr\u00f4ler simplement leur longueur et leur hauteur, tous les objets cr\u00e9\u00e9s ci-dessous
ont une longueur de 1.0 et une largeur de 1.0.
Tous les points les constituant auront des coordonn\u00e9es comprises entre 0.0 et 1.0 pour X et Y.
**/

// Liste des objet RShape pr\u00e9d\u00e9finis
RShape shape_SPIKES; // forme en dent de scie

// INITIALISATION de tous les objets RShape utilis\u00e9s pour l'habillage de 'Forme'
public void init_SHAPES(){
  shape_SPIKES = (RShape) new RShape( (RShape) generate_shape_SPIKES() );
}


//---------
// Cr\u00e9ation de la RShape utilis\u00e9e pour le dessin des SPIKES
public RShape generate_shape_SPIKES(){
  RShape _shape = new RShape();
  
  _shape.addMoveTo( 0.0f      , 0.0f );
  _shape.addLineTo( 0.0825f   , 0.0f );
  _shape.addLineTo( 0.12375f  , 0.25f );
  _shape.addLineTo( 0.165f    , 0.0f );
  _shape.addLineTo( 0.2475f   , 0.5f );
  _shape.addLineTo( 0.333f    , 0.0f );
  _shape.addLineTo( 0.5f      , 1.0f );
  _shape.addLineTo( 1 - 0.333f    , 0.0f );
  _shape.addLineTo( 1 - 0.2475f   , 0.5f );
  _shape.addLineTo( 1 - 0.165f    , 0.0f );
  _shape.addLineTo( 1 - 0.12375f  , 0.25f );
  _shape.addLineTo( 1 - 0.0825f   , 0.0f );
  _shape.addLineTo( 1.0f , 0.0f );
  
  _shape.setFill(false);
  
  return (RShape) _shape;
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_APPAREL_withSound_Minim" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
