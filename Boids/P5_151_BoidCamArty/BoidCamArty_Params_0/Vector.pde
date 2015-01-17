
/**
 * Datentyp, um einen 2D-Vektor zu speichern.
 * plus einige nützliche Vektor-Rechen funktionen.
 * @author Patrick Meister
 *
 */

public class Vector {

  public float x, y;

  public Vector(float _x, float _y) {
    x = _x;
    y = _y;
  } 
  
  public Vector() {
   x = 0;
   y = 0; 
  }

  public Vector copy() {
    return new Vector(x, y); 
  }

  public float length() {
    return sqrt(x*x + y*y);
  }
  
  public void setXY(float x, float y) {
   this.x = x;
  this.y = y; 
  }
  
  public Vector normalize() {
    return divide(length());
  }

  public Vector divide(float _divisor) {
    return new Vector(x/_divisor, y/_divisor);
  }

  // todo: winkel dieses vektors zurückgeben
  public float direction() {
    return 0.0;
  }
  
  // gibt einen vektor zurück, der die selbe richtung, aber die angegebene länge hat.
  public Vector sameDirWithLength(float _length) {
    return normalize().multiply(_length);
  
  }

  
  public Vector multiply(float _multiplier) {
    return new Vector(x * _multiplier, y * _multiplier);
  }

  public Vector multiply(Vector _multiplier) {
    return new Vector(x * _multiplier.x, y * _multiplier.y);
  }

  public Vector subtract(Vector _subtraction) {
    return new Vector(x - _subtraction.x, y - _subtraction.y); 
  }

  public Vector subtract(float _subX, float _subY) {
    return new Vector(x - _subX, y - _subY); 
  }

  public Vector add(Vector _addition) {
    return new Vector(x + _addition.x, y + _addition.y);  
  }
  
  public Vector add(float x, float y) {
    return new Vector(x+ this.x, y + this.y);  
  }
}
