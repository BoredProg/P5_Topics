public class ExplodingButton {

  protected PApplet p;

  protected PVector pos = new PVector();
  protected PVector explodedPos = new PVector();
  protected float size = 50;

  private String statusNormal = "normal";
  private String statusExploded = "exploded";
  private String statusHighlighted = "highlighted";
  private String statusSelected = "selected";
  private String statusExplodedSelected = "explodedSelected";
  private String statusExplodedSelectedHighlighted = "explodedSelectedHighlighted";

  private String status = statusNormal;

  public ExplodingButton(PApplet p) {
    this.p = p;
  }

  public ExplodingButton(PApplet p, PVector pos, PVector explodedPos, float size) {
    this.p = p;
    this.pos = pos;
    if (explodedPos != null) {
      this.explodedPos = explodedPos;
    }
    this.size = size;
  }

  public ExplodingButton(PApplet p, float x, float y, float explodedX, float explodedY, float size) {
    this.p = p;
    this.pos = pos;
    this.explodedPos = new PVector(explodedX, explodedY);
    this.size = size;
  }

  public ExplodingButton(PApplet p, float x, float y, float size) {
    this.p = p;
    this.pos = new PVector(x, y);
    this.size = size;
  }

  public void draw() {
    p.strokeWeight(2);
    p.stroke(10, 150);
    if (status.equals(statusNormal)) {
      drawNormal();
    }
    if (status.equals(statusExploded)) {
      drawExploded();
    }
    if (status.equals(statusHighlighted)) {
      drawExplodedHighlighted();
    }
    if (status.equals(statusSelected)) {
      drawSelected();
    }
    if (status.equals(statusExplodedSelected)) {
      drawExplodedSelected();
    }
    if (status.equals(statusExplodedSelectedHighlighted)) {
      drawExplodedSelectedHighlighted();
    }
  }

  protected void drawNormal() {
    p.fill(200);
    p.ellipse(pos.x, pos.y, size, size);
  }

  protected void drawExploded() {
    p.fill(200);
    p.ellipse(explodedPos.x, explodedPos.y, size, size);
  }

  protected void drawExplodedHighlighted() {
    p.fill(200, 0, 0, 170);
    p.ellipse(explodedPos.x, explodedPos.y, size, size);
  }

  protected void drawSelected() {
    p.fill(255, 0, 0);
    p.ellipse(pos.x, pos.y, size, size);
  }

  protected void drawExplodedSelected() {
    p.fill(255, 0, 0);
    p.ellipse(explodedPos.x, explodedPos.y, size, size);
  }

  protected void drawExplodedSelectedHighlighted() {
    p.fill(200, 200, 0, 170);
    p.ellipse(explodedPos.x, explodedPos.y, size, size);
  }

  public void drawDebug() {
    p.stroke(1);
    p.stroke(10, 40);
    p.noFill();
    p.ellipse(pos.x, pos.y, size, size);
    p.ellipse(explodedPos.x, explodedPos.y, size, size);
  }

  public void pressed(float checkX, float checkY) {
    if (isHit(checkX, checkY, pos)) {
      if (status.equals(statusNormal)) {
        status = statusExploded;
      } 
      else if (status.equals(statusSelected)) {
        status = statusExplodedSelected;
      }
    }
  }

  public void dragged(float checkX, float checkY) {
    if (status.equals(statusExploded) || status.equals(statusHighlighted)) {
      if (isHit(checkX, checkY, explodedPos)) {
        status = statusHighlighted;
      } 
      else {
        status = statusExploded;
      }
    }

    if (status.equals(statusExplodedSelected) || status.equals(statusExplodedSelectedHighlighted)) {
      if (isHit(checkX, checkY, explodedPos)) {
        status = statusExplodedSelectedHighlighted;
      } 
      else {
        status = statusExplodedSelected;
      }
    }
  }

  public void released(float checkX, float checkY) {
    if (status.equals(statusHighlighted) && isHit(checkX, checkY, explodedPos)) {
      status = statusSelected;
    } 
    else if (status.equals(statusExploded)) {
      status = statusNormal;
    } 
    else if (status.equals(statusExplodedSelectedHighlighted)) {
      if (isHit(checkX, checkY, explodedPos)) {
        status = statusNormal;
      } 
      else {
        status = statusSelected;
      }
    } 
    else if (status.equals(statusExplodedSelected)) {
      if (isHit(checkX, checkY, explodedPos)) {
        // This state is not accessible (as onOver it's still explodedSelectedHigh)
      } 
      else {
        status = statusSelected;
      }
    }
  }

  protected boolean isHit(float checkX, float checkY, PVector pos) {
    boolean hit = dist(checkX, checkY, pos.x, pos.y) < this.size / 2;
    return hit;
  }

  public void setSelected() {
    status = statusSelected;
  }

  public void setExplodedPos(float x, float y) {
    explodedPos.x = x;
    explodedPos.y = y;
  }

  public boolean isSelected() {
    return status.equals(statusSelected);
  }

  public boolean isNormal() {
    return status.equals(statusNormal);
  }
}
