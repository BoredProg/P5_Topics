http://forum.processing.org/two/discussion/comment/11166#Comment_11166

boolean record;
int scalePG = 10;
 
void setup() {
    size(600, 600, P3D);
    smooth();
}
 
void draw() {
    if(!record)
        background(#ffffff);
    translate(width/2, height/2);
    fill(#ff0000);
    rotateX(60);
    rotateZ(60);
    box(100);
}
void keyPressed() {
    if(keyCode == ENTER) {
        PGraphics PGpx = createGraphics(width * scalePG, height * scalePG, P3D);
        record = true;
        beginRecord(PGpx);
        PGpx.background(#ffffff, 0); // Clear the offscreen canvas (make it transparent)
        PGpx.scale(scalePG);
        draw();
        PGpx.save("myImage.png"); // Save image as PNG (JPGs can't have an alpha channel) and save it before endRecord()
        endRecord();
        record = false;
    }
}
