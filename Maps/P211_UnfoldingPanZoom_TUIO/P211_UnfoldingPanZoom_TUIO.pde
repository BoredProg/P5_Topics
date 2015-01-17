import TUIO.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.providers.*;
 
UnfoldingMap map;
TuioCursorHandler tuioCursorHandler;
 
void setup() {
    size(800, 600, P3D);
 
    map = new UnfoldingMap(this,new Microsoft.AerialProvider());
 
    tuioCursorHandler = new TuioCursorHandler(this, map);
    EventDispatcher eventDispatcher = new EventDispatcher();
    eventDispatcher.addBroadcaster(tuioCursorHandler);
    eventDispatcher.register(map, "pan");
    eventDispatcher.register(map, "zoom");
    
    //noLoop();
}
 
void draw() {
    try
    {
      map.draw();
       
       
      // For debugging purpopses
      tuioCursorHandler.drawCursors();
      fill(255, 50);
      /*
      for (TuioCursor tcur : tuioCursorHandler.getTuioClient().getTuioCursors()) 
      {
        ellipse(tcur.getScreenX(width), tcur.getScreenY(height), 20, 20);
      }
      */
    }
    catch (Exception ex)
    {
    }
}
