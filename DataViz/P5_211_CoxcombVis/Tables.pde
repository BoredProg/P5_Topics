//TableGroup////////////////////a class for gathering all tables together, really straightforward
/////////////////////////////////////////////////////////////////////////////////////////////////

class TableGroup {
  Table[] ts;
  int[] sums,maleCol;
  int N,R,C,tablesMaxSum;
  String[] titles;
  
  //CONSTRUCTOR
  TableGroup (int N){
    //instantiate the table array and the tables inside, set the number of tables
    ts=new Table[this.N=N];   
    for(int i=0;i<N;i++){
      ts[i]= new Table(i); 
    }
    //get number of columns and rows of data
    R= ts[0].getNumRows()-1;  
    C= ts[0].getNumCols()-1;  
    //data necessary for the displaying of the button row as visualization
    tablesMaxSum=0;                
    titles=new String[N];   
    maleCol=new int[N];  
    sums=new int[N];          
    for(int i=0;i<N;i++){
      sums[i]=ts[i].totalSum();
      maleCol[i]=ts[i].colSum(1);
      tablesMaxSum=sums[i]>tablesMaxSum?sums[i]:tablesMaxSum; 
      titles[i]=ts[i].getString(0,0);
    }
  }
  
  //METHODS
  int getSums(int index){return sums[index];}
  int getMaxSum(){return tablesMaxSum;}
  String getTitle(int index){return titles[index];}
  
  Table get(int index){return ts[index];}   
  
  int getRows(){return R;}
  int getCols(){return C;}
  int getN(){return N;}
  
  String[] getTitles(){return titles;}
  int[] getSums(){return sums;}
  int[] getMales(){return maleCol;}
  
}  //end of TableGroup class
    
//Table////////////////////////////////main class table, based on Ben Fry's one on Visualizing Data
///////////////////////////////////////////////////////////////////////////////////////////////////

class Table {
  String[][] data;
  int numRows, numCols;

  //CONSTRUCTOR
  Table(int indice) {   
    String[] filas = loadStrings(indice+".tsv"); 
    numRows = filas.length;
    data = new String[numRows][];
    for (int i = 0; i < filas.length; i++) {
      if (trim(filas[i]).length() == 0) {
        continue;
      }   
      if (filas[i].startsWith("#")) {       //this doesn't work on processingjs
        continue;
      }   
      data[i] = split(filas[i],"\t");       //dont use TAB on processingjs
    }       
    numCols=data[0].length;
  }

  //METHODS

  //Returns number of rows
  int getNumRows() { return numRows; }

  //Return number of cols
  int getNumCols() { return numCols; }

  //Returns name of a row, specified by index
  String getRowName(int rowIndex) { return getString(rowIndex,0); }

  //Returns value as String | be careful with method overloading using processingjs
  //String getString(String rowName, int col) { return getString(getRowIndex(rowName),col); }
  String getString(int rowIndex, int colIndex) { return data[rowIndex][colIndex]; }

  //Returns value as Int | be careful, bla, bla..
  //int getInt(String rowName, int col) { return parseInt(getString(rowName,col));}   
  int getInt(int rowIndex, int colIndex) { return parseInt(getString(rowIndex,colIndex)); }

  //Returns value as Float | be careful, bla, bla..
  //float getFloat(String rowName, int col) { return parseFloat(getString(rowName,col)); }
  float getFloat(int rowIndex, int colIndex) { return parseFloat(getString(rowIndex,colIndex)); }

  //Find file by its name and returns -1 in case of failure
  int getRowIndex(String name) {
    for (int i = 0; i < numRows; i++) {
      if (data[i][0].equals(name)) {
        return i;
      }
    }
    println("I didn't found any row called '"+ name+"!'");
    return -1;
  }

  //Returns the sum of all the values in a row, specified by index
  int rowSum (int index) {
    int sum=0;
    for (int i=1;i<numCols;i++) {
      sum+=getInt(index,i);
    }
    return sum;
  }
  
  //Returns the sum of all the values in a column, specified by index
  int colSum (int index) {
    int sum=0;
    for (int i=1;i<numRows;i++) {
      sum+=getInt(i,index);
    } 
    return sum;
  }
  
  //Returns the row with maximum value sum
  int maxRowSum() { 
    int maxSum=0;  
    for (int i=1; i<numRows; i++) {
      if (rowSum(i)>=maxSum) {
        maxSum=rowSum(i);
      }
    }
    return maxSum;
  }
  
  //Returns the total sum of all the values in the table
  int totalSum() {
    int sum=0;  
    for (int i=1; i<numRows; i++) {
      sum+=rowSum(i);
    } 
    return sum;
  }
  
} //End of Table class
