/////////////////////////
////
//     QUICK & DIRTY!!!!!!
///
/////////////////////////


/**
 * Datentyp, um einen 2D-Vektor zu speichern.
 * plus einige nützliche Vektor-Rechen funktionen.
 * @author Patrick Meister
 *
 */

public class Vector3 {

  public float x, y, z;

  public Vector3(float _x, float _y, float _z) {
    x = _x;
    y = _y;
    z = _z;
  } 

  public Vector3() {
    x = 0;
    y = 0; 
    z = 0;
  }

  public Vector3 copy() {
    return new Vector3(x, y, z); 
  }

/*
  public float length() {
    return sqrt(x*x + y*y);
  }
*/

  public void setXY(float x, float y, float z) {
    this.x = x;
    this.y = y; 
    this.z = z;
  }
  /*
  public Vector3 normalize() {
   return divide(length());
   }
   
   public Vector3 divide(float _divisor) {
   return new Vector3(x/_divisor, y/_divisor);
   }
   
   // todo: winkel dieses vektors zurückgeben
   public float direction() {
   return 0.0;
   }
   
   // gibt einen vektor zurück, der die selbe richtung, aber die angegebene länge hat.
   public Vector3 sameDirWithLength(float _length) {
   return normalize().multiply(_length);
   
   }
   
   
   public Vector3 multiply(float _multiplier) {
   return new Vector3(x * _multiplier, y * _multiplier);
   }
   
   public Vector3 multiply(Vector3 _multiplier) {
   return new Vector3(x * _multiplier.x, y * _multiplier.y);
   }
   
   public Vector3 subtract(Vector3 _subtraction) {
   return new Vector3(x - _subtraction.x, y - _subtraction.y); 
   }
   
   public Vector3 subtract(float _subX, float _subY) {
   return new Vector3(x - _subX, y - _subY); 
   }
   
   public Vector3 add(Vector3 _addition) {
   return new Vector3(x + _addition.x, y + _addition.y);  
   }
   
   public Vector3 add(float x, float y) {
   return new Vector3(x+ this.x, y + this.y);  
   }
   */
}
