// FLOWER UNWARPER 
// By Golan Levin, June 2010
// http://www.flong.com
// For Processing 1.1 or 0185 
// Requires the ControlP5 Library, 
// http://www.sojamo.de/libraries/controlP5/

import controlP5.*;
ControlP5 controlP5;
float maxRadiusPercent; 
float minRadiusPercent;
float verticalPow; 
float aspectRatio; 


//=============================================
// Important parameters for the unwarping
float imgCx; // optical x-center of the warped (annular) image
float imgCy; // optical y-center of the warped (annular) image 
float max_radius;  // outer radius of the warped annulus, in pixels
float min_radius;  // inner radius of the warped annulus, in pixels

// The input (warped, annular) image
PImage inputImage;
int inputImageW, inputImageH;
float inputImageScalingFactor;
float inputImageDrawingWidth;
float inputImageDrawingHeight;

// The output (unwarped, panoramic) image
PImage outputImage;
float  unwarpedAspectRatio;
int    unwarpedW, unwarpedH;
float  outputImageDrawingHeight;

// Intermediate data structures for the unwarping
float srcxArray[];
float srcyArray[];
int patchR[][];
int patchG[][];
int patchB[][];

// Interaction state variables
boolean bMousePressedInInputImage;
boolean bMousePressedInOutputImage;
boolean bUseCubicInterpolation; 

float angularShift = 0;
String inputFileName;
String inputFileNames[];
int    currentFlowerIndex;


//=============================================
void setup() {
  size(1300,800);

  maxRadiusPercent = 0.98;
  minRadiusPercent = 0.05;
  verticalPow = 1.50;
  aspectRatio = 4.5;
  bUseCubicInterpolation = false;
  
  controlP5 = new ControlP5(this);
  controlP5.addSlider("maxRadiusPercent", 0.0, 1.0, 0.80,  900, 10,300,15);
  controlP5.addSlider("minRadiusPercent", 0.0, 0.5, 0.05,  900, 30,300,15);
  controlP5.addSlider("verticalPow",      1.0, 2.0, 1.50,  900, 50,300,15);
  controlP5.addSlider("aspectRatio",      2.0, 7.0, 6.00,  900, 70,300,15);



  String path = sketchPath + "/data";
  inputFileNames = listFileNames (path);
  currentFlowerIndex = 0;
  for (int i=0; i<inputFileNames.length; i++) {
    println(inputFileNames[i]);
  }

  boolean bFoundFlowerImage = false;
  while ((bFoundFlowerImage == false) && (currentFlowerIndex < inputFileNames.length)) {
    inputFileName = inputFileNames[currentFlowerIndex];
    println("File " + currentFlowerIndex + ": " + inputFileName); 
    if (inputFileName.endsWith("jpg") || inputFileName.endsWith("JPG")) {
      bFoundFlowerImage = true;
    } 
    else {
      currentFlowerIndex++;
      inputFileName = inputFileNames[currentFlowerIndex];
    }
  } 

  
  loadFlower();
}


//=============================================
void loadFlower() {

  
  inputFileName = inputFileNames[currentFlowerIndex];
  if (inputFileName.endsWith("jpg") || inputFileName.endsWith("JPG")) {

    inputImage = loadImage (inputFileName);
    inputImageW = inputImage.width;
    inputImageH = inputImage.height;

    max_radius  = inputImageH/2.0 * maxRadiusPercent;
    min_radius  = inputImageH/2.0 * minRadiusPercent;
    imgCx = inputImageW/2;
    imgCy = inputImageH/2;

    unwarpedAspectRatio = aspectRatio;
    unwarpedW = 2048;
    unwarpedH = (int)(unwarpedW / unwarpedAspectRatio); 
    outputImageDrawingHeight = height-unwarpedH;
    outputImage = createImage(unwarpedW, unwarpedH, RGB);

    srcxArray = new float[unwarpedW*unwarpedH];
    srcyArray = new float[unwarpedW*unwarpedH];
    patchR = new int[4][4];
    patchG = new int[4][4];
    patchB = new int[4][4];

    inputImageScalingFactor  = outputImageDrawingHeight / (float)inputImageH;
    inputImageDrawingWidth   = inputImageW * inputImageScalingFactor;
    inputImageDrawingHeight  = inputImageH * inputImageScalingFactor;

    computeInversePolarTransform();
  }
}


void controlEvent(ControlEvent theEvent) {
  String touchedName = theEvent.controller().name();
  if (touchedName == "aspectRatio"){
    
    unwarpedAspectRatio = aspectRatio;
    unwarpedW = 2048;
    unwarpedH = (int)(unwarpedW / unwarpedAspectRatio); 
    outputImageDrawingHeight = height-unwarpedH;
    outputImage = createImage(unwarpedW, unwarpedH, RGB);

    srcxArray = new float[unwarpedW*unwarpedH];
    srcyArray = new float[unwarpedW*unwarpedH];
    patchR = new int[4][4];
    patchG = new int[4][4];
    patchB = new int[4][4];

    inputImageScalingFactor  = outputImageDrawingHeight / (float)inputImageH;
    inputImageDrawingWidth   = inputImageW * inputImageScalingFactor;
    inputImageDrawingHeight  = inputImageH * inputImageScalingFactor;

    computeInversePolarTransform();
  }
}



//=============================================
void draw() {
  background(64,64,64);

  computeInversePolarTransform();

  // slow but smooth OR fast but inaccurate and pixelated
  if (bUseCubicInterpolation) {
    unwarpBicubic();
  } 
  else {
    unwarpNearestNeighbor();
  }

  drawOutputImage();
  drawInputImage();
}


//=============================================
void keyPressed() {
  switch (key) {

  case 'f':
    currentFlowerIndex = (currentFlowerIndex+1) % (inputFileNames.length);
    loadFlower();
    break;


  case 'c': 
    // switch between cubic and nearest-neighbor interpolation.
    bUseCubicInterpolation = !bUseCubicInterpolation; 
    break;

  case 'e':
    // export the unwarped output image.
    unwarpBicubic();
    int nInputFilenameChars  = inputFileName.length();
    String outputName = "output/" + (inputFileName.substring(0, nInputFilenameChars-4)) + "_rectified.jpg";
    outputImage.save(outputName);
    break;
  }

  // OR, nudge the center point for unwarping the input image.
  float incr = 0.25;
  switch (keyCode) {
  case 37: // LEFT
    imgCx -= incr;
    break;
  case 39: // RIGHT
    imgCx += incr;
    break;
  case 40: // DOWN
    imgCy += incr;
    break;
  case 38: // UP
    imgCy -= incr;
    break;
  }
}


//=============================================
void mouseReleased() {
  bMousePressedInInputImage     = false;
  bMousePressedInOutputImage    = false;
}

void mousePressed() {
  bMousePressedInInputImage     = false;
  bMousePressedInOutputImage    = false;

  if ((mouseX < inputImageDrawingWidth) && (mouseY < inputImageDrawingHeight)) {
    bMousePressedInInputImage = true;
  } 
  else if (mouseY > inputImageDrawingHeight) {
    bMousePressedInOutputImage = true;
  }
}

void mouseDragged() {
  if (bMousePressedInInputImage && (mouseX < inputImageDrawingWidth) && (mouseY < inputImageDrawingHeight)) {
    imgCx = (float)mouseX/(float)inputImageDrawingWidth  * inputImageW;
    imgCy = (float)mouseY/(float)inputImageDrawingHeight * inputImageH;
  } 
  else if (bMousePressedInOutputImage && (mouseY > inputImageDrawingHeight)) {
    angularShift = map (mouseX,0,width, 0, TWO_PI);
  }
}

//=============================================
void drawOutputImage() {
  // draw the unwarped panoramic strip
  // float 
  // unwarpedW
  float ow = width; 
  float oh = width / aspectRatio;
  image(outputImage, 0, outputImageDrawingHeight, ow,oh);
}

//=============================================
void drawInputImage() {
  // draw the warped input image
  image (inputImage, 0,0, inputImageDrawingWidth, inputImageDrawingHeight);

  // draw crosshairs at unwarping center point
  smooth();
  stroke(255,0,0);
  float crossSize = 8;
  float crossX = map(imgCx, 0, inputImageW, 0, inputImageDrawingWidth); 
  float crossY = map(imgCy, 0, inputImageH, 0, inputImageDrawingHeight); 
  line (crossX, crossY-crossSize, crossX, crossY+crossSize);
  line (crossX-crossSize, crossY, crossX+crossSize, crossY);
  noSmooth();
}



//=============================================
void computeInversePolarTransform() {
  int   srcx, srcy, srcIndex;
  int   dstRow, dstIndex;
  float radius, angle;

  max_radius  = inputImageH/2.0 * maxRadiusPercent;
  min_radius  = inputImageH/2.0 * minRadiusPercent;

  for (int dsty=0; dsty<unwarpedH; dsty++) {
    float y = ((float)dsty/(float)unwarpedH); //0..1
    float yfrac = pow(y, verticalPow);
    radius  = (yfrac * (max_radius-min_radius)) + min_radius; 
    dstRow = dsty*unwarpedW;

    for (int dstx=0; dstx<unwarpedW; dstx++) {
      dstIndex = dstRow + dstx;
      angle    = (0 - ((float)dstx/(float)unwarpedW) * TWO_PI) + angularShift;

      srcxArray[dstIndex] = imgCx + radius*cos(angle);
      srcyArray[dstIndex] = imgCy + radius*sin(angle);
    }
  }
}



//=============================================
void unwarpNearestNeighbor() {

  int inputImageN = inputImageW * inputImageH; 
  int dstRow, dstIndex;
  int srcx, srcy, srcIndex;
  color black = color(0,0,0); 
  color col;

  outputImage.loadPixels();
  for (int dsty=0; dsty<unwarpedH; dsty++) {
    dstRow = dsty*unwarpedW;

    for (int dstx=0; dstx<unwarpedW; dstx++) {
      dstIndex = dstRow + dstx;
      srcx  = (int) srcxArray[dstIndex];
      srcy  = (int) srcyArray[dstIndex];
      srcIndex = srcy*inputImageW + srcx;

      col = black;
      if ((srcIndex >= 0) && (srcIndex < inputImageN)) {
        col = inputImage.pixels[srcIndex];
      }
      outputImage.pixels[dstIndex] = col;
    }
  }
  outputImage.updatePixels();
}



//=============================================
void unwarpBicubic() {
  int dstRow, dstIndex;
  float srcxf, srcyf;
  float px, py;
  float px2, py2;
  float px3, py3; 

  float interpR, interpG, interpB;
  int srcx, srcy, srcIndex;
  color black = color(0,0,0); 
  color srcColor;
  color col;
  int patchIndex;
  int loIndex = inputImageW+1;
  int hiIndex = (inputImageW*inputImageH)-(inputImageW*3)-1;
  int patchRow;
  color inputPixels[] = inputImage.pixels;

  outputImage.loadPixels();
  for (int dsty=0; dsty<unwarpedH; dsty++) {
    dstRow = dsty*width;

    for (int dstx=0; dstx<unwarpedW; dstx++) {
      dstIndex = dstRow + dstx;
      srcxf = srcxArray[dstIndex];
      srcyf = srcyArray[dstIndex];
      srcx  = (int) srcxf;
      srcy  = (int) srcyf;
      srcIndex = srcy*inputImageW + srcx;

      col = black;
      srcColor = black;

      for (int dy=0; dy<4; dy++) {
        patchRow = srcIndex + ((dy-1)*inputImageW);
        for (int dx=0; dx<4; dx++) {
          patchIndex = patchRow + (dx-1);
          if ((patchIndex >= loIndex) && (patchIndex < hiIndex)) {
            srcColor = inputPixels[patchIndex];
          }
          patchR[dx][dy] = (srcColor & 0x00FF0000) >> 16;
          patchG[dx][dy] = (srcColor & 0x0000FF00) >>  8;
          patchB[dx][dy] = (srcColor & 0x000000FF)      ;
        }
      }

      px = srcxf - srcx;
      py = srcyf - srcy;
      px2 =  px * px;
      px3 = px2 * px;
      py2 =  py * py;
      py3 = py2 * py;

      interpR = bicubicInterpolate (patchR, px,py, px2,py2, px3,py3);
      interpG = bicubicInterpolate (patchG, px,py, px2,py2, px3,py3);
      interpB = bicubicInterpolate (patchB, px,py, px2,py2, px3,py3);

      col = color (interpR, interpG, interpB);
      outputImage.pixels[dstIndex] = col;
    }
  }
  outputImage.updatePixels();
}


//=============================================
float bicubicInterpolate (int[][] p, float x,float y, float x2,float y2, float x3,float y3) {
  // adapted from http://www.paulinternet.nl/?page=bicubic. 
  // Note that this code can produce values outside of 0...255, due to cubic overshoot. 
  // Processing prvents that from happening, but C++ doesnt. Clamp the output if this happens.

  int p00 = p[0][0];  
  int p10 = p[1][0]; 
  int p20 = p[2][0]; 
  int p30 = p[3][0]; 

  int p01 = p[0][1];  
  int p11 = p[1][1]; 
  int p21 = p[2][1]; 
  int p31 = p[3][1]; 

  int p02 = p[0][2];  
  int p12 = p[1][2]; 
  int p22 = p[2][2]; 
  int p32 = p[3][2]; 

  int p03 = p[0][3];  
  int p13 = p[1][3]; 
  int p23 = p[2][3]; 
  int p33 = p[3][3]; 

  int a00 =    p11;
  int a01 =   -p10 +   p12;
  int a02 =  2*p10 - 2*p11 +   p12 -   p13;
  int a03 =   -p10 +   p11 -   p12 +   p13;
  int a10 =   -p01 +   p21;
  int a11 =    p00 -   p02 -   p20 +   p22;
  int a12 = -2*p00 + 2*p01 -   p02 +   p03 + 2*p20 - 2*p21 +   p22 -   p23;
  int a13 =    p00 -   p01 +   p02 -   p03 -   p20 +   p21 -   p22 +   p23;
  int a20 =  2*p01 - 2*p11 +   p21 -   p31;
  int a21 = -2*p00 + 2*p02 + 2*p10 - 2*p12 -   p20 +   p22 +   p30 -   p32;
  int a22 =  4*p00 - 4*p01 + 2*p02 - 2*p03 - 4*p10 + 4*p11 - 2*p12 + 2*p13 + 2*p20 - 2*p21 + p22 - p23 - 2*p30 + 2*p31 - p32 + p33;
  int a23 = -2*p00 + 2*p01 - 2*p02 + 2*p03 + 2*p10 - 2*p11 + 2*p12 - 2*p13 -   p20 +   p21 - p22 + p23 +   p30 -   p31 + p32 - p33;
  int a30 =   -p01 +   p11 -   p21 +   p31; 
  int a31 =    p00 -   p02 -   p10 +   p12 +   p20 -   p22 -   p30 +   p32;
  int a32 = -2*p00 + 2*p01 -   p02 +   p03 + 2*p10 - 2*p11 +   p12 -   p13 - 2*p20 + 2*p21 - p22 + p23 + 2*p30 - 2*p31 + p32 - p33;
  int a33 =    p00 -   p01 +   p02 -   p03 -   p10 +   p11 -   p12 +   p13 +   p20 -   p21 + p22 - p23 -   p30 +   p31 - p32 + p33;

  return 
    a00      + a01 * y      + a02 * y2      + a03 * y3 +
    a10 * x  + a11 * x  * y + a12 * x  * y2 + a13 * x  * y3 +
    a20 * x2 + a21 * x2 * y + a22 * x2 * y2 + a23 * x2 * y3 +
    a30 * x3 + a31 * x3 * y + a32 * x3 * y2 + a33 * x3 * y3;
}


// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } 
  else {
    // If it's not a directory
    return null;
  }
}




