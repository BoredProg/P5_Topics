import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import com.temboo.core.*; 
import com.temboo.Library.Delicious.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P5_211_TembooDeliciousTags extends PApplet {




// Create a session using your Temboo account application details
TembooSession session = new TembooSession("capturevision", "myFirstApp", "bc155faadd9d41f6b7572d257a38e774");

public void setup() {
	// Run the GetTags Choreo function
	thread("runGetTagsChoreo");
        
        println("hehe");
}

public void runGetTagsChoreo() {
	// Create the Choreo object using your Temboo session
	GetTags getTagsChoreo = new GetTags(session);

	// Set credential
	getTagsChoreo.setCredential("SProd55");

	// Set inputs

	// Run the Choreo and store the results
	GetTagsResultSet getTagsResults = getTagsChoreo.run();
	
	// Print results
	println(getTagsResults.getResponse());

}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_TembooDeliciousTags" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
