//Requried Libraries imported:
import processing.serial.*;
import processing.core.*;

//https://happycoding.io/tutorials/processing/collision-detection - hitbox detection input 

//hitbox variables and different picture variables:
int pictY=410, pictX=200, pictSW=60, pictSH=80, pictSpeedY=0, pictAW=55, pictAH=90, pictMW=60, pictMH=80,pictmX=200, pictmY=410;
//ground variables:
int groundY=450;
//collision object variables
int objW = int(random(100,150)), objH= int(random(-300,-200)), objY=450, objX=1000, objSpeedX=0, objstate, objRW,objRH;
//variables if needed for compution of IMU Data
float ax, ay, az, gx, gy, gz, maindata;
//varaibales for Serial protocoll
String test, output, portInput_usb;
//variable to start the game
boolean start=false;
//variable to track gamestate internally
int rs ,is=0,gs=0, i=0,fs=0;
// all the variables used to convert the raw variables of the accelorometer or magenetometer to be used to move squaty 
float accvalue;
//initialization of used img classes https://processing.org/reference/PImage.html#:~:text=The%20PImage%20class%20contains%20fields,simplify%20the%20process%20of%20compositing. 
PImage SS,SA,SM,E1,HH,RR;
//Serial port for usb communication
Serial myPort;
//for speration of lines of data coming in
int lf= 10; //linefeed in ASCII
// for receiving data from arduino
String myString = null;
// Array for spliting data from myString
String parsedvariable[];
//array to determine which acceleration paramater should be used 
//how acc data works inspiration: https://www.youtube.com/watch?v=MAR4yvxQpzc&ab_channel=LEOMO  implementation is own code based on this video
float[] avec;
// variable to save which array variable to use
int num;
// variables to determine which acc axis is beeing influenced by gravity
float orientation_gforce=1.0, buffer, threshold=0.05;
// variable to use in squatymove function
float squatymetrix;


//setup class for first initialization of all necceseary components
void setup() {
  printArray(Serial.list());
  size(1000, 500);
  textSize(40);
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 115200);
  SS=loadImage("SS.png");
  SA=loadImage("SA.png");
  SM=loadImage("SM.png");
  E1=loadImage("E1.png");
  HH=loadImage("HH.png");
  RR=loadImage("RR.png");
  myPort.clear();
  myString=myPort.readStringUntil(lf);
  myString=null;
  
}
void draw(){
  game();

} 
//parses Usb data everytime a comma is in the string, then saves it in individual variables
void parseUsbdata(){
  if (myString !=null){
    parsedvariable = myString.split(",");
    ax = float(parsedvariable[0]);
    ay = float(parsedvariable[1]);
    az = float(parsedvariable[2]);
    gamestart();
  }
}
//function to start the game gets the orientation of acc, starts illusion of moving object
void gamestart(){
   if (!start){
     orientation();
     start = true;
     objSpeedX = -5;
     gs=1;
    }
}
//determinse which axis is being influenced by gravity uses this axis in powering squaty 
void orientation() { 
   for (i = 0; i<parsedvariable.length; i++){
     buffer = float(parsedvariable[i]);
     if (abs(buffer - orientation_gforce) < threshold){
       num = i;
     }else{}
   }
 }

//reads data from the usb Serial port if not null and saves it in variable myString if not null game starts
void recieveUsbdata(){
   while (myPort.available()>0){
    myString = myPort.readStringUntil(lf);
  }
}
//finish function simply tracks if the fs variable for succesfull repetitions is 5 and sets variables for gs (gamestates)
void finish(){
  if (fs == 5){
    fs = 0;
    gs =2;
  }
}
// game function calls primarly gameengine function and gamerender function also listens for the startevent
void game(){
  finish();
  recieveUsbdata();
  parseUsbdata();
  switch (gs){
    case 0:
      gameengine();
      gamerender(0);
      break;
    case 1:
      gameengine();
      gamerender(1);
      break;
    case 2:
      gamerender(2);
      noLoop();
      break;
    case 3:
      gamerender(3);
      noLoop();
      break;
  }
}

//call all renderfunctions - what to display when
void gamerender(int renderstate){
  rs =renderstate;
  switch(rs){
    //case 0 is the starting position when nothing has been pressed then imgrender 1 has to be displayed
    case 0:
      backgroundrender();
      groundrender();
      imgrender(1);
      objrender();
      //keyevent();
      break;
    //case 1 is the moving position the mouse has been pressed an the game is running currently
    case 1:
      backgroundrender();
      groundrender();
      objrender();
      imgrender(2);
      //keyevent();
      break;
    // case 2 is the finishing position the game has finished the fs variable counts 5 and ends the game with squaty having stronger legs
    case 2:
      backgroundrender();
      groundrender();
      imgrender(4);
      break;
    case 3:
      backgroundrender();
      groundrender();
      imgrender(3);
      break;
  }
}
//renders background so that each frames looks like a new frame
void backgroundrender(){
  background(255);
}
//renders ground so that squaty doesnt float
void groundrender(){
  fill(0);
  rect(0,groundY,width,50);
}
//depending on objstate either a skyscrapper or a ferries wheel is generated
void objrender(){
  fill(0);
  if(objstate==0){
      imghouse();
  }
  if(objstate==1){
      imgRR(); 
  }
}
//chooses which images to render gets variable from the gamerender function depending on state of game
void imgrender(int imagestate){
  is=imagestate;
  switch(is){
//if the mouse has not been pressed display standing squaty
    case 1:
      imgstart();
      break;
//if game has started display jumping squaty is not on the ground
    case 2:
      imgjump();
      break;
//hitbox was triggered display big boom
    case 3:
      imgfail();
      break;
//succesfull repetitions
    case 4:
      pictX =200;
      pictY=370;
      imgend();
      break;
  } 
}
//display starting position and ground position
void imgstart(){
  imageMode(CENTER);
  image(SA, pictX, pictY, pictAW, pictAH);
}
//display img for running animation
void imgjump(){
  imageMode(CENTER);
  image(SS, pictmX, pictmY, pictSW, pictSH);
}
//display img for finisch animation
void imgend(){
  imageMode(CORNER);
  image(SM, pictX, pictY, pictMW, pictMH);
  fill(0, 408, 612);
  textSize(120);
  text("Congratiolations!", 40, 240);   
}
//displays img for failanimation
void imgfail(){
  imageMode(CENTER);
  image(E1, width/2, height/2,500,200);
  image(E1, width/2, height/2,600,300);
  image(E1, width/2, height/2,700,400);
  fill(0, 408, 612);
  textSize(70);
  text("Oh no, Better luck next time!", 40, 240);   
}
//displays img for sykscrapper
void imghouse(){
  imageMode(CORNER);
  image(HH,objX, objY,objW,objH);
}
//displays img for ferris wheel
void imgRR(){
  imageMode(CORNER);
  image(RR,objX, objY,objRW,objRH);
}
//void keyevent(){
//  if (keyPressed){
//    if (key== 'w' || key == 'W') {
//      pictSpeedY = -10;
//      pictmY += pictSpeedY;
//    }
//    if (key=='s'|| key == 'S') {
//      pictSpeedY = 10;
//      pictmY += pictSpeedY;
//    }
//  }
//}
//call all computing functions in correct order for game to run
void gameengine(){
  borderengine();
  obstacle();
  hitdetection();
  accswitch();
}
//tracks if the jumping image of squatty is or is not in collision with the moving buildings source https://www.jeffreythompson.org/collision-detection/rect-rect.php
boolean hitbox(float r1x, float r1y, float r1w, float r1h, float r2x, float r2y, float r2w, float r2h) {
  // are the sides of one image touching the other?
  if (r2y <= r1y-objH && r2x < 200 && r2x>0){
        return true;
      }
    return false;    
}
// pauses game and display text (gs=3)
void hitdetection(){
  boolean hit =hitbox(pictmX, pictmY, pictSW, pictSH, objX, objY, objW, objH);
  if (hit){ 
    gs=3;
  }
}
//stop player from falling through ground
void borderengine(){
  if (pictmY + (pictAH/2) > groundY) {
    pictmY = 410;
  }
  if(pictmY+(pictAH/2) <80){
    pictmY=pictAH/2;
  }
}
// create random objekt Heights and Width when each obstacle fades of screen 
void obstacle(){
  if (-objW > (objX+100)){
    objX = 1000;
    objW = int(random(100,150));
    objH = int(random(-300,-200));
    objRW= int(random(200,250));
    objRH = -objRW;
    //selects a number randomly between 0 and 1
    objstate= int(random(2));
    fs= fs + 1;
  }
  //creates the ilussion of obj moving, inspiration taken from https://www.youtube.com/watch?v=IIrGAvlNckw&list=PLAE4MzuQm3Gwj2QLcqpepbTuIuzi_18mS&ab_channel=AllenThoe
  objX += objSpeedX;
}
//makes squaty move 
void squatypower(float input){
  squatymetrix = 1- abs(input) ;
  //proportinalitätsfaktor berechnet mit 0 = höchster y wert (450), 1= niedrigster y Wert (45) faktor= 45
  pictmY =  int((1/squatymetrix)*45);
  print(pictmY);
}
// uses axis determined in orientation() and makes squaty move each iteration
void accswitch() {
  switch (num) {
    case 0:
      //if num is 0 = ax nehmen
      squatypower(ax);
      break;
    case 1:
      // if num is 1 = ay nehmen
      squatypower(ay);
      break;
    case 2:
      // if num is 2 = az nehmen
      squatypower(az);
      break;
    default:
      break;
  }  
}
