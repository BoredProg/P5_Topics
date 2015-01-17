import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import org.gicentre.treemappa.*; 
import org.gicentre.utils.colour.*; 
import org.gicentre.utils.move.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P5_151_TreeMappaExample extends PApplet {

     // For treemappa classes
  // Colours needed by treemappa.
    // For the ZoomPan class.


// Example to draw a zoomable spatial treemap based on postcode locations.
// Postcode data extracted from Ordannce Survey codePoint open
// Contains Ordnance Survey data Crown copyright and database right 2010.
// Contains Royal Mail data copyright and database right 2010.
// Jo Wood, giCentre
// V1.4, 25th March, 2011.

PTreeMappa pTreeMappa;
ZoomPan zoomer;

public void setup()
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
  pTreeMappa.getTreeMapPanel().setBranchMaxTextSize(0,0.1f);
  pTreeMappa.getTreeMapPanel().setMutation(0.4f);
  pTreeMappa.getTreeMapPanel().setLayouts("spatial");
  
  // Layout needs updating because we have changed border size and the
  // treemap layout algorithm.
  pTreeMappa.getTreeMapPanel().updateLayout();
}

public void draw()
{
  background(255);
  //rotateX(frameCount / 100);
  // Allow zooming and panning.
  zoomer.transform();
  
  // Get treemappa to draw itself.
  pTreeMappa.draw();
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_151_TreeMappaExample" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
