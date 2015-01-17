import com.temboo.core.*;
import com.temboo.Library.Delicious.*;

// Create a session using your Temboo account application details
TembooSession session = new TembooSession("capturevision", "myFirstApp", "bc155faadd9d41f6b7572d257a38e774");

void setup() {
	// Run the GetTags Choreo function
	thread("runGetTagsChoreo");
        
        println("hehe");
}

void runGetTagsChoreo() {
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
