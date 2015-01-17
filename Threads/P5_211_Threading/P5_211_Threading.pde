/*
  Script copyright Cameron Newnham 2013
  Test/Example for threading in processing
  
  This will basically just run through a huge amount of data and
  add it to an arraylist, but separating it into threads for the number of cores
*/
 
int[] res;
int cores;
int activeThreads;
ArrayList<String> data;
 
void setup() {
  size(500,500,P3D);
  cores = Runtime.getRuntime().availableProcessors();
  activeThreads = 0;
  
  res = new int[3]; 
  res[0] = 10000003;
}
 
void draw() {
  println(str(cores) + "cores available");
  threadedCalculation();
  println(data.size());
}
 
void threadedCalculation() {
  ArrayList<testThread> threads = new ArrayList<testThread>();
  data = new ArrayList<String>();  // This is test data that we want to get out of the script
  
  // This section just sorts the data into the number of cores, giving a start and end index that each core should look through
  int threadSize = res[0]/cores;
  int extra = res[0]-threadSize*cores;
  // Extra is just the remainder so that we make sure each thread has equal or equal+1 pieces of data to calculate
  // And so that we don't forget to calculate any data
  for (int i=0, index=0; i<cores; i+= 1) {
    int thisCoreStart = 0;
    int thisCoreEnd = 0;
    if (extra > 0) {
      thisCoreStart = index;
      index++;
      extra--;
      index+= threadSize;
      thisCoreEnd = index;
    } else if (extra == 0) {
      thisCoreStart = index;
      index+= threadSize;
      thisCoreEnd = index;
    }
    
    // This starts a new thread
    // Your PC should automatically allocate the thread to a core
    String id = "thread"+str(i); // Just gives the thread an identifier
    testThread thread = new testThread(id, thisCoreStart, thisCoreEnd);
    thread.start();
    activeThreads++;
    threads.add(thread);
  }
  
  // Wait until all the threads have closed
  while (activeThreads > 0) {
    
    // Wait for half a second to update
    // We can do it more frequently but it won't really make a difference
    // Since we're doing big calcs anyway
    try {
      Thread.currentThread().sleep((long) 200);
    } catch (Exception e) {
    }
    
    // Just prints an update to console of where it's up to
    float totalData = res[0];
    float currentData = 0;
    for (testThread t: threads) {
      currentData+= t.threadData.size();
    }
    println(float(round(currentData/totalData*10000))/100+" %");
  }
  
  // Add the data from each thread to the data collection arraylist
  // We could optionally add it straight to the arraylist
  // But we have to make sure that multiple threads aren't trying to access
  // The same data at the same time
  for (testThread t: threads) {
    data.addAll(t.threadData);
  }
}
 
// The testThread class superclasses thread
class testThread extends Thread {
  String id; // The thread name
  int startIndex;
  int endIndex;
  ArrayList<String> threadData;
  
  testThread(String s, int _startIndex, int _endIndex) {
    id = s;
    startIndex = _startIndex;
    endIndex = _endIndex;
    threadData = new ArrayList<String>();
  }
    
  void start() {
    super.start();
  }
  
  // This gets triggered by start automatically
  void run() {  
    // The data that we want to add to the data list
    // This is where the complex behaviour goes
    for (int i = startIndex; i<endIndex; i++) {
      String thisData = str(i);
      threadData.add(thisData);
    }
    
    // We just want to run the thread once, so call quit on finishing
    quit();
  }
  
  // Close the thread
  void quit() {
    activeThreads--;
    interrupt();
  }
}
