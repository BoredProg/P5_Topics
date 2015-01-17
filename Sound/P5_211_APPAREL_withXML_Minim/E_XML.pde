/** - - - - - - - - - - - - - - - - - - - - - - - - 
XML :: les Fonctions d'analyse

:: TWEETS ::
Ci-dessous une liste des fonctions vous permettant de récupérer des informations spécifiques du flux XML,
sous forme d'ArrayList :
tout les "!"   --> get_ExclamFromTweets(XMLElement xml_obj)
tout les "?"   --> get_QuestionsFromTweets(XMLElement xml_obj)
tout les "@"   --> get_ArobaseFromTweets(XMLElement xml_obj)
tout les "..." --> get_3PointsFromTweets(XMLElement xml_obj) 
tout les ":)"  --> get_SmileysHappy(XMLElement xml_obj) 
tout les ":("  --> get_SmileysSad(XMLElement xml_obj) 

... à vous de compléter cette liste si nécessaire !


:: UTILISATEUR ::
Une autre fonction vous permet de récupérer les infos utilisateurs de la première entrée.
Le type de l'info renverra toujours une "String", aussi il est de votre responsabilité de 
bien interpréter cette String afin de pouvoir l'utiliser correctement.

- get_UserInfoByString(XMLElement xml_obj, String _target)
  -> xml_obj : l'objet XML principal
  -> _target : la chaîne de caractère représentant la propriété à renvoyer

**/


// XML :: Variables nécessaires au fonctionnement de notre système de lecture XML
String request_url = "https://api.twitter.com/1/statuses/user_timeline.xml?screen_name=";
String local_url   = "twitter_"; // le nom du fichier local; se finit par ".xml" mais est volontairement omis ici


/** - - - - - - - - - - - - - - 
    I N I T I A L I S A T I O N 
    - - - - - - - - - - - - - -  **/ 
void init_XMLbyUser(String user_name){  
  String __request_url = request_url + user_name;
  String __local_url   = local_url + user_name + ".xml";
  
  // on vérifie si une copie locale a été enregistrée
  if( loadStrings(__local_url) != null ) __request_url = __local_url; // auquel cas on pointe vers cette ressource locale
  if(__request_url != __local_url)  saveStrings("data/"+__local_url, loadStrings(__request_url) ); // on crée la copie locale si besoin est
  
  // on charge finalement le XML
  xml = new XMLElement(this, __request_url);
}


// les FONCTIONS - - - -
// "!"
// Transmet un objet ArrayList, d'une taille égale aux nombres de tweets parcourus, contenant le nombre de "!" par tweet
ArrayList get_ExclamFromTweets(XMLElement xml_obj) {
  XMLElement _xml = xml_obj;
  ArrayList retour = new ArrayList();

  if(_xml.getChildCount() == 0 || _xml == null) return retour;
  
  for (int i = 0; i < _xml.getChildCount(); i++) {
    String status_str   = _xml.getChild(i).getChild("text").getContent(); 
    retour.add( (int) get_countStringFrom(status_str, "!") );
  }
  return retour;
}

// "?"
// Transmet un objet ArrayList, d'une taille égale aux nombres de tweets parcourus, contenant le nombre de "?" par tweet
ArrayList get_QuestionsFromTweets(XMLElement xml_obj) {
  XMLElement _xml = xml_obj;
  ArrayList retour = new ArrayList();

  if(_xml.getChildCount() == 0 || _xml == null) return retour;
  
  for (int i = 0; i < _xml.getChildCount(); i++) {
    String status_str   = _xml.getChild(i).getChild("text").getContent(); 
    retour.add( (int) get_countStringFrom(status_str, "?") );
  }
  return retour;
}

// "@"
// Transmet un objet ArrayList, d'une taille égale aux nombres de tweets parcourus, contenant le nombre de "@" par tweet
ArrayList get_ArobaseFromTweets(XMLElement xml_obj) {
  XMLElement _xml = xml_obj;
  ArrayList retour = new ArrayList();
  
  if(_xml.getChildCount() == 0 || _xml == null) return retour;

  for (int i = 0; i < _xml.getChildCount(); i++) {
    String status_str   = _xml.getChild(i).getChild("text").getContent(); 
    retour.add( (int) get_countStringFrom(status_str, "@") );
  }
  return retour;
}

// "..."
// Transmet un objet ArrayList, d'une taille égale aux nombres de tweets parcourus, contenant le nombre de "..." par tweet NON-TRONQUÉ
ArrayList get_3PointsFromTweets(XMLElement xml_obj) {
  XMLElement _xml = xml_obj;
  ArrayList retour = new ArrayList();
  
  if(_xml.getChildCount() == 0 || _xml == null) return retour;

  for (int i = 0; i < _xml.getChildCount(); i++) {
    String status_str  = _xml.getChild(i).getChild("text").getContent(); 
    String trunc_str   = _xml.getChild(i).getChild("truncated").getContent(); 
    
    if(trunc_str == "false")  retour.add( (int) 0 );
    else retour.add( (int) get_countStringFrom(status_str, "...") );
  }
  return retour;
}

// :D
// Transmet un objet ArrayList, d'une taille égale aux nombres de tweets parcourus, contenant le nombre de smileys joyeux par tweet
ArrayList get_SmileysHappy(XMLElement xml_obj) {
  XMLElement _xml = xml_obj;
  ArrayList retour = new ArrayList();
  int count = 0;
  if(_xml.getChildCount() == 0 || _xml == null) return retour;

  for (int i = 0; i < _xml.getChildCount(); i++) {
    String status_str  = _xml.getChild(i).getChild("text").getContent(); 
    
    count = 0;
    for(int s=0; s<smileys_happy.length; s++){
      count += get_countStringFrom(status_str, smileys_happy[s]);
    }
    
    retour.add( count );
  }
  return retour;
}

// :-(
// Transmet un objet ArrayList, d'une taille égale aux nombres de tweets parcourus, contenant le nombre de smileys malheureux par tweet
ArrayList get_SmileysSad(XMLElement xml_obj) {
  XMLElement _xml = xml_obj;
  ArrayList retour = new ArrayList();
  int count = 0;
  if(_xml.getChildCount() == 0 || _xml == null) return retour;

  for (int i = 0; i < _xml.getChildCount(); i++) {
    String status_str  = _xml.getChild(i).getChild("text").getContent(); 
    
    count = 0;
    for(int s=0; s<smileys_sad.length; s++){
      count += get_countStringFrom(status_str, smileys_sad[s]);
    }
    
    retour.add( count );
  }
  return retour;
}

/////////////////////////
// Retourne une information utilisateur sous la forme d'une chaîne de caractère devant être typée par la suite, selon sa nature
// Ex.: "friends_count"     -> int
//      "profile_image_url" -> String
//      "geo_enabled"       -> boolean
String get_UserInfoByString(XMLElement xml_obj, String _target) {
  XMLElement _xml = xml_obj;
  String retour = "";
  
  if(_xml.getChildCount() == 0 || _xml == null) return retour;
  
  // ici on ne considère que le premier noeud du XML, car les infos utilisateurs sont les mêmes pour chaque tweet
  retour = _xml.getChild( 0 ).getChild( "user/"+_target ).getContent(); 
  return retour;
}


// -------------------------------------------------------------------------
// Outil : donne le nombre de fois qu'une chaîne est présente dans une autre
int get_countStringFrom(String _str, String _search) {
  int pos   = 0;
  int count = 0;

  while (pos < _str.length () && pos != -1) {
    pos = _str.indexOf(_search, pos);
    if (pos != -1) {
      count ++;
      pos ++;
    }
  }
  return count;
}

