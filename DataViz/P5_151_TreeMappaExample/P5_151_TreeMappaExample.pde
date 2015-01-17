import org.gicentre.treemappa.*;     // For treemappa classes
import org.gicentre.utils.colour.*;  // Colours needed by treemappa.
import org.gicentre.utils.move.*;    // For the ZoomPan class.

import processing.opengl.*;
// Example to draw a zoomable spatial treemap based on postcode locations.
// Postcode data extracted from Ordannce Survey codePoint open
// Contains Ordnance Survey data Crown copyright and database right 2010.
// Contains Royal Mail data copyright and database right 2010.
// Jo Wood, giCentre
// V1.4, 25th March, 2011.

PTreeMappa pTreeMappa;
ZoomPan zoomer;

void setup()
{
  size(700,800, OPENGL);
  smooth();
  zoomer = new ZoomPan(this);  
  
  // Display labels in a serif font
  textFont(createFont("sans serif",40));

  // Create an empty treemap.    
  pTreeMappa = new PTreeMappa(this);
  
  // Load the data and build the treemap.
  pTreeMappa.readData("EPostcodes.csv"); 
  
  // Customise the appearance of the treemap
  pTreeMappa.getTreeMapPanel().setBorders(1);
  pTreeMappa.getTreeMapPanel().setShowLeafLabels(false); 
  pTreeMappa.getTreeMapPanel().setShowBranchLabels(true);
  pTreeMappa.getTreeMapPanel().setBranchMaxTextSize(0,0.1);
  pTreeMappa.getTreeMapPanel().setMutation(0.4);
  pTreeMappa.getTreeMapPanel().setLayouts("spatial");
  
  // Layout needs updating because we have changed border size and the
  // treemap layout algorithm.
  pTreeMappa.getTreeMapPanel().updateLayout();
}

void draw()
{
  background(255);
  //rotateX(frameCount / 100);
  // Allow zooming and panning.
  zoomer.transform();
  
  // Get treemappa to draw itself.
  pTreeMappa.draw();
}
