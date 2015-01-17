public class ExplodingButtonGroup {

  public static final float DEFAULT_RADIUS = 100;

  public PVector center = new PVector(300, 300);
  public float radius;

  ArrayList explodingButtons = new ArrayList();

  public ExplodingButtonGroup(PVector groupCenter) {
    this(groupCenter, DEFAULT_RADIUS, null);
  }

  public ExplodingButtonGroup(PVector groupCenter, float groupRadius) {
    this(groupCenter, groupRadius, null);
  }

  public ExplodingButtonGroup(PVector groupCenter, float groupRadius, ArrayList explodingButtons) {
    this.center = groupCenter;
    this.radius = groupRadius;
    if (explodingButtons != null) {
      this.explodingButtons = explodingButtons;
    }
  }

  public void updatePositionsInGroupCircle() {
    float angle = 0;
    float dAngle = TWO_PI / explodingButtons.size();

    for (int i = 0; i < explodingButtons.size(); i++) {
      ExplodingButton explodingButton = (ExplodingButton) explodingButtons.get(i);
      angle += dAngle;
      float x = center.x + (int) (radius * Math.cos(angle));
      float y = center.y + (int) (radius * Math.sin(angle));
      explodingButton.setExplodedPos(x, y);
    }
  }

  public void draw() {
    for (int i = 0; i < explodingButtons.size(); i++) {
      ExplodingButton explodingButton = (ExplodingButton) explodingButtons.get(i);
      explodingButton.drawDebug();
      explodingButton.draw();
    }
  }

  public void addExplodingButton(ExplodingButton btn) {
    this.explodingButtons.add(btn);
    updatePositionsInGroupCircle();
  }

  public void setExplodingButtonGroup(ArrayList explodingButtons) {
    this.explodingButtons = explodingButtons;
  }

  public void pressed(int mouseX, int mouseY) {
    for (int i = 0; i < explodingButtons.size(); i++) {
      ExplodingButton explodingButton = (ExplodingButton) explodingButtons.get(i);
      explodingButton.pressed(mouseX, mouseY);
    }
  }

  public void dragged(int mouseX, int mouseY) {
    for (int i = 0; i < explodingButtons.size(); i++) {
      ExplodingButton explodingButton = (ExplodingButton) explodingButtons.get(i);
      explodingButton.dragged(mouseX, mouseY);
    }
  }

  public ExplodingButton released(int mouseX, int mouseY) {
    // TODO Return list to allow multiple selection
    ExplodingButton selectedExplodingButton = null;
    for (int i = 0; i < explodingButtons.size(); i++) {
      ExplodingButton explodingButton = (ExplodingButton) explodingButtons.get(i);
      explodingButton.released(mouseX, mouseY);
      boolean hit = explodingButton.isHit(mouseX, mouseY, explodingButton.explodedPos);
      if (hit && (explodingButton.isSelected() || explodingButton.isNormal())) {
        selectedExplodingButton = explodingButton;
      }
    }
    return selectedExplodingButton;
  }

  public boolean isEmpty() {
    return explodingButtons.isEmpty();
  }
}

