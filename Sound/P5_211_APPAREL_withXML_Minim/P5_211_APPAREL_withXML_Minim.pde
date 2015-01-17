/**
 - - - - - - - --
 A P P A R E L 2D
 - - - - - - - --
 Cette application simule les déformations apportées à une forme vectorielle par des paramètres.
 La forme en soi est stockée dans un fichier SVG, et est convertie via une classe personnalisée
 en une succession de lignes (2 points).
 
 Les détails de la classe nommée "Forme" se trouvent à l'onglet "D_Class_Forme", qui regroupe l'ensemble
 des méthodes nécessaires à la conversion du SVG, ainsi que quelques méthodes utilitaires (comme "reset()");
 
 On distinguera 3 actions possibles requiérant cet objet Forme :
 - l'obtention d'information :              dans l'onglet "A_Get"
 - le dessin de ces informations :          dans l'onglet "B_Draw"
 - et la modification de ces informations : dans l'onglet "C_Modificateurs"
 
 Ces méthodes ont été volontairement séparées de la classe, afin de permettre une meilleure compréhension 
 du code, et ne pas avoir à parcourir un fichier de classe interminable !
 
 N'hésitez pas à parcourir ces 3 onglets afin d'y découvrir les options mises à votre disposition ! :)
 
 
 - - -  - - - - - - -
 X M L  T W I T T E R
 - - -  - - - - - - -
 Pour jouer avec des données XML en provenance de Twitter, il vous faudra utiliser les fonctions prédéfinies 
 dans l'onglet "E_XML" , qui regroupe à la fois le système de chargement du XML, ainsi que des fonctions cruciales 
 à l'analyse des données chargées.
 
 Afin de les utiliser, il est impératif de lancer la fonction :
 "init_XMLbyUser( String user_name)"
   -> user_name : le nom d'utilisateur Twitter à cibler ( équivaut au "screen_name" de l'API Twitter )
 
 **/


import processing.opengl.*;
import processing.xml.*;
import geomerative.*;  


//------------------------------------------------------------
//  VARIABLES GLOBALES  accessibles à tous les niveaux du code

// Variables spaciales
float view_X, view_Y;
float real_X, real_Y;

// Objets
Forme apparel; // classe personnalisée simplifiant une forme SVG en succession de lignes
PImage textureBmp0, textureBmp1, textureBmp2; // fichiers de texture 

// XML
XMLElement xml; // notre objet global XML 
// Liste des smileys pouvant être identifiés comme étant joyeux ou tristes
String[] smileys_happy = {":)", ":-)", ":D", ":-D", ":P", ":-P", ";)", ";-)", ";P", ";D", "^.^", "^^", "^_^" };
String[] smileys_sad   = {":(", ":,(", ":x", ":-x", "-_-", ":-(", ":s", ":S" };

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
  
  // Onglet "E_XML"
  init_XMLbyUser( "lab_normals" ); // chargement du XML à traiter
}


//-----------------------------------
//  BOUCLE PRINCIPALE  --------------
void draw() {

  background(255); // couleur de fond
  strokeWeight(1); // epaisseur du trait

  // VUE générale
  view_X = width/2 + apparel._center.x *-1;  // on calcule de quoi combien de pixels doit-on décaler 
  view_Y = height/2 + apparel._center.y *-1; // la scène toute entière afin de placer la Forme au centre de l'écran


  // pushMatrix() and popMatrix() isole des transformations de matrice
  pushMatrix(); //-----------------------------------------------
  // on déplace la scène aux coordonnées calculées juste au-dessus
  translate(view_X, view_Y);
  // on recalcule les coordonnées de la souris, en fonction du décalage opérée précédemment
  real_X = mouseX - view_X; // real mouse X position
  real_Y = mouseY - view_Y; // real mouse Y position

  // Couleurs --
  noFill();   // pas de remplissage lors du dessin
  noStroke(); // pas de contour lors du dessin

  // - - - - - - - - - - - - - - - - - - - - - - - - 
  // TRANSFORMATIONS (les points sont modifiés)
  // - les transformations doivent être effectuées avant le dessin


  // - - - - - - - - - - - - - - - - - - - - - - - - 
  // DESSINS (les points sont utilisés, mais pas transformés)
  // -
  stroke(color(0, 0, 0)); // les lignes seront de couleur noir
  apparel.draw(AS_LINES); // on dessine les lignes de la forme.

  stroke(color(255, 0, 0)); // les lignes seront de couleur rouge
  strokeWeight(3);
//  apparel.draw(AS_POINTS); // on dessine les points de chaque ligne de la forme
  
  
  // On dessine le centre de la FORME par une ellipse (afin de vérifier que le centre est bien... au centre !)
  stroke(255, 0, 0);
  ellipse(apparel._center.x, apparel._center.y, 10, 10);

  popMatrix(); //-----------------------------------------------------
}


//////////////////////////////////////////////////////////////////////
void keyPressed() {
  if (key == ' ') apparel.reset(); // SPACEBAR == reset de la Forme
}

