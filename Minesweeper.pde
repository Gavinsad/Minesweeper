import de.bezier.guido.*;
 public final static int NUM_ROWS =10;
public final static int NUM_COLS = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>();

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
 buttons = new MSButton[20][20];
      for(int r=0;r<buttons.length;r++){
       for (int c=0;c<buttons[r].length;c++){
         buttons[r][c] = new MSButton(r,c);
       }
      }
    
    setMines();
}
public void setMines()
{ 
  while(mines.size()<18){
int r = (int)(Math.random()*NUM_ROWS);
int c = (int)(Math.random()*NUM_COLS);
if(!mines.contains(buttons[r][c])){
   
 mines.add(buttons[r][c]); 

  
}

  }
  
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
  int cliked =0;
    for(int r=0;r<buttons.length;r++){
       for (int c=0;c<buttons[r].length;c++){
        if(buttons[r][c].clicked==true){
         cliked++;
        }
       }
      }
      if(NUM_ROWS*NUM_COLS-mines.size()==cliked){return true;}
  
    return false;
}
public void displayLosingMessage(int r,int c)
{
       
        buttons[r][c].setLabel("L");
        
      
     System.out.println("L");
    noLoop();
}
public void displayWinningMessage()
{    
    for(int r=0;r<buttons.length;r++){
       for (int c=0;c<buttons[r].length;c++){
        buttons[r][c].setLabel("W");
        
        }
       }
       noLoop();
}
public boolean isValid(int r, int c)
{
   if(r<NUM_ROWS&&r>=0){
    if(c<NUM_COLS&&c>=0){
      return true;
    }
  }
  return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
   for(int r=row-1;r<row+2;r++){
  for(int c=col-1;c<col+2;c++){
    if(isValid(r,c)&&mines.contains(buttons[r][c])){
      numMines++;
    }
    }
  }

if (mines.contains(buttons[row][col  ])==true){
  numMines--;
}
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
   public void mousePressed() {
    if (mouseButton == LEFT) {
        if (!clicked && !flagged) { 
            clicked = true;
            setLabel(countMines(myRow, myCol));

           
            if (countMines(myRow, myCol) == 0) {
                if (isValid(myRow - 1, myCol) && !buttons[myRow - 1][myCol].clicked) {
                    buttons[myRow - 1][myCol].mousePressed();
                }
                if (isValid(myRow + 1, myCol) && !buttons[myRow + 1][myCol].clicked) {
                    buttons[myRow + 1][myCol].mousePressed();
                }
                if (isValid(myRow, myCol - 1) && !buttons[myRow][myCol - 1].clicked) {
                    buttons[myRow][myCol - 1].mousePressed();
                }
                if (isValid(myRow, myCol + 1) && !buttons[myRow][myCol + 1].clicked) {
                    buttons[myRow][myCol + 1].mousePressed();
                }
            }
        }
    } 
    
    else if (mouseButton == RIGHT) {
        flagged = !flagged;
        if (!flagged) {
            clicked = false;  // Unflagging allows the button to be clicked again
        }
    }
}
    public void draw () 
    {    
        if (flagged)
            fill(255,139,40);
         else if( clicked && mines.contains(this) ) {
            displayLosingMessage(myRow,myCol);
             fill(255,0,0);
             
           }

        else if(clicked)
            fill(62,180,137);
        else 
            fill(152,255,152);

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
