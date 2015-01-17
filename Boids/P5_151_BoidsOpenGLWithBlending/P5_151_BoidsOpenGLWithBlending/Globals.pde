 //plano do z
int minZ = -500;
int maxZ = 500;


//boids:
int numBoids = 200; // 40
float bVar = 1.1;
float bDamp = 0.95;
float bK = 0.010;

//target:
int numT = 125;
float tVar = 2;                // 2 : vitesse de la cible
float tDamp =0.98;

//points
int numP         = 10;         // 60 :  number of vertices in trail // cool : 15 (birds), 150 (snakes).
float pK         = 0.35;       // 0.35
float pDamp      = 0.53;       // 0.53
float larg       = 25;         // 25

// glow :
boolean _useGlow = false;
