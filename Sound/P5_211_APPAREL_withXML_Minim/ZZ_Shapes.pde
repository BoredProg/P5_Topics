/**
Ici nous créons tous les objets RShape dont on se sert pour habiller la 'Forme'

Afin de contrôler simplement leur longueur et leur hauteur, tous les objets créés ci-dessous
ont une longueur de 1.0 et une largeur de 1.0.
Tous les points les constituant auront des coordonnées comprises entre 0.0 et 1.0 pour X et Y.
**/

// Liste des objet RShape prédéfinis
RShape shape_SPIKES; // forme en dent de scie

// INITIALISATION de tous les objets RShape utilisés pour l'habillage de 'Forme'
void init_SHAPES(){
  shape_SPIKES = (RShape) new RShape( (RShape) generate_shape_SPIKES() );
}


//---------
// Création de la RShape utilisée pour le dessin des SPIKES
RShape generate_shape_SPIKES(){
  RShape _shape = new RShape();
  
  _shape.addMoveTo( 0.0      , 0.0 );
  _shape.addLineTo( 0.0825   , 0.0 );
  _shape.addLineTo( 0.12375  , 0.25 );
  _shape.addLineTo( 0.165    , 0.0 );
  _shape.addLineTo( 0.2475   , 0.5 );
  _shape.addLineTo( 0.333    , 0.0 );
  _shape.addLineTo( 0.5      , 1.0 );
  _shape.addLineTo( 1 - 0.333    , 0.0 );
  _shape.addLineTo( 1 - 0.2475   , 0.5 );
  _shape.addLineTo( 1 - 0.165    , 0.0 );
  _shape.addLineTo( 1 - 0.12375  , 0.25 );
  _shape.addLineTo( 1 - 0.0825   , 0.0 );
  _shape.addLineTo( 1.0 , 0.0 );
  
  _shape.setFill(false);
  
  return (RShape) _shape;
}
