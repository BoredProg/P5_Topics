/**
 - - - - - - - --
 A P P A R E L 2D
 - - - - - - - --
 Cette application simule les déformations apportées à une forme vectorielle par des paramètres.
 La forme en soi est stockée dans un fichier SVG, et est convertie via une classe personnalisée
 en une succession de lignes (2 points).
 
 Les détails de la classe nommée "Forme" se trouve à l'onglet "D_Class_Forme", qui regroupe l'ensemble
 des méthodes nécessaires à la conversion du SVG, ainsi que quelques méthodes utilitaires (comme "reset()");
 
 On distinguera 3 actions possibles requiérant cet objet Forme :
 - l'obtention d'information :              dans l'onglet "A_Get"
 - le dessin de ces informations :          dans l'onglet "B_Draw"
 - et la modification de ces informations : dans l'onglet "C_Modificateurs"
 
 Ces méthodes ont été volontairement séparées de la classe, afin de permettre une meilleure compréhension 
 du code, et ne pas avoir à parcourir un fichier de classe interminable !
 
 N'hésitez pas à parcourir ces 3 onglets afin d'y découvrir les options mises à votre disposition ! :)
 **/


// Imports des librairies externes
import processing.opengl.*;
import geomerative.*;  

import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.ugens.*;

//------------------------------------------------------------
//  VARIABLES GLOBALES  accessibles à tous les niveaux du code

// Variables spaciales
float view_X, view_Y;
float real_X, real_Y;

// Objets
Forme apparel; // classe personnalisée simplifiant une forme SVG en succession de lignes
PImage textureBmp0, textureBmp1, textureBmp2; // deux fichiers de texture 

// Audio
Minim minim;
AudioInput in;

//----------------------------------
//  SETUP --------------------------
void setup() {
  // Geomerative settings
  RG.init(this);
  RG.ignoreStyles(); // on ne tiendra pas compte des valeurs de styles du SVG chargé
  RG.setPolygonizer(RG.ADAPTATIVE); // MODE : comment Geomerative simplifie-t-il une forme vectorielle (via la méthode "polygonize()" )

  // Onglet "ZZ_Shapes" : 
  // On crée tous les objets RShape utilisés pour l'ORNEMENTATION de la 'Forme' principale
  init_SHAPES(); // ces formes ainsi créées pourront être dessinées paramétriquement

  // On charge les textures dans des objets PImage (Processing Image)
  // dont on peut éventuellement se servir pour remplir les triangles de la forme
  textureBmp0 = loadImage("texture_chat-blanc.jpg"); // pour les felinophiles =^.^=
  textureBmp1 = loadImage("texture_ysl.jpg"); // pour ceux aux goûts douteux ...
  textureBmp2 = loadImage("texture_jambon.jpg"); // pour ceux qui aiment le gras ! :)

  // General settings
  //hint(DISABLE_OPENGL_2X_SMOOTH); // pas d'anti-aliasing par OpenGL
  size(displayWidth/2, displayHeight-30, OPENGL);   // création de la fenêtre, et définition du mode de rendu; ici : OpenGL

  // Onglet "D_Class_Forme" : 
  // On crée notre objet "Forme" en lui indiquant le nom du SVG à convertir
  apparel = new Forme("apparel_2D.svg");
  
  /* init audio */
  minim = new Minim(this);
}


//-----------------------------------
//  MAIN LOOP -----------------------
void draw() {
  if(in != null) println("Volume sonore (0.0-1.0) : "+ ((AudioBuffer) in.mix).level());
  
  // Background and color settings
  background(255);
  strokeWeight(1);

  // VIEW settings
  view_X = width/2 + apparel._center.x *-1;  // on calcule de quoi combien de pixels doit-on décaler 
  view_Y = height/2 + apparel._center.y *-1; // la scène toute entière afin de placer la Forme au centre de l'écran


  // pushMatrix() and popMatrix() isole des transformations de matrice
  pushMatrix(); //-----------------------------------------------
  // on déplace la scène aux coordonnées calculées juste au-dessus
  translate(view_X, view_Y);
  // on recalcule les coordonnées de la souris, en fonction du décalage opérée précédemment
  real_X = mouseX - view_X; // real mouse X position
  real_Y = mouseY - view_Y; // real mouse Y position

  // Color settings
  noFill();   // pas de remplissage lors du dessin
  noStroke(); // pas de contour lors du dessin

  // - - - - - - - - - - - - - - - - - - - - - - - - 
  // TRANSFORMATIONS (les points sont modifiés)
  // - les transformations doivent être effectuées avant le dessin, afin de voir ses répercussions


  // - - - - - - - - - - - - - - - - - - - - - - - - 
  // DESSINS (les points sont utilisés, mais pas transformés)
  // -  
  stroke(color(0, 0, 0, 100)); // les lignes seront de couleur noir
  if(in!=null) draw_shapeOnLine(apparel, shape_SPIKES,  ((AudioBuffer) in.mix).level() *100.0);
  else apparel.draw(AS_LINES); // on dessine les lignes de la forme.

  

  stroke(color(255, 0, 0)); // les lignes seront de couleur rouge
  strokeWeight(3);
  apparel.draw(AS_POINTS); // on dessine les points de chaque ligne de la forme


  // On dessine le centre de la FORME par une ellipse (afin de vérifier que le centre est bien... au centre !)
  stroke(255, 0, 0);
  ellipse(apparel._center.x, apparel._center.y, 10, 10);

  popMatrix(); //-----------------------------------------------------
}


//////////////////////////////////////////////////////////////////////
void keyPressed() {
  if (key == ' ') apparel.reset(); // SPACEBAR == reset de la Forme
  if (key == 'a') in = minim.getLineIn();
}


void stop()
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

