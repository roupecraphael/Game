//Requried Libraries imported:
import processing.serial.*;
import processing.core.*;

//https://happycoding.io/tutorials/processing/collision-detection - hitbox detection input 

//hitbox variables and different picture variables:
int pictY=450, pictX=200, pictSW=60, pictSH=80, pictSpeedY=0, pictAW=55, pictAH=90, pictMW=60, pictMH=80;
//ground variables:
int groundY=450;
//collision object variables
int objW = int(random(100,150)), objH= int(random(-300,-200)), objY=450, objX=1000, objSpeedX=0, objstate, objRW,objRH;
//variables if needed for compution of IMU Data
float ax, ay, az, gx, gy, gz, mx, my, mz, maindata;
//varaibales for Serial protocoll
String test, output, portInput_usb;
//variable to start the game
boolean start=false;
//variable to track gamestate internally
int rs ,is=0,gs=0, i=0,fs=0;

//initialization of used classes 
PImage SS,SA,SM,E1,HH,RR;
Serial usbport;


//setup class for first initialization of all necceseary components
void setup() {
  size(1000, 500);
  textSize(40);
  Serial usbport = new Serial(this, Serial.list()[2], 115200);
  println("USB device found");
  usbport.clear();
  SS=loadImage("SS.png");
  SA=loadImage("SA.png");
  SM=loadImage("SM.png");
  E1=loadImage("E1.png");
  HH=loadImage("HH.png");
  RR=loadImage("RR.png");
  output = usbport.readStringUntil('a');
  output = null;
  
}
void draw(){
  if(usbport.available() > 0) {
    output = usbport.readStringUntil('\n');
    if (usbport != null) {
      println(output);
    }
  }
  game();
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
  startevent();
  switch (gs){
    case 0:
      gameengine();
      gamerender(0);
      break;
    case 1:
      gameengine();
      gamerender(1);
      print(fs);
      break;
    case 2:
      gamerender(2);
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
      break;
    //case 1 is the moving position the mouse has been pressed an the game is running currently
    case 1:
      backgroundrender();
      groundrender();
      objrender();
      imgrender(2);
      keyevent();
      break;
    // case 2 is the finishing position the game has finished the fs variable counts 5 and ends the game with squaty having stronger legs
    case 2:
      backgroundrender();
      groundrender();
      imgrender(4);
      break;
    case 3:
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
      print("Finish");
      imgend();
      noLoop();
      break;
  } 
}
//display starting position and ground position
void imgstart(){
  image(SA, pictX, pictY, pictAW, pictAH);
}
//display img for running animation
void imgjump(){
  image(SS, pictX, pictY, pictSW, pictSH);
}
//display img for finisch animation
void imgend(){
  image(SM, pictX, pictY, pictMW, pictMH);
}
//displays img for failanimation
void imgfail(){
  imageMode(CENTER);
  image(E1, width/2, height/2,500,200);
  image(E1, width/2, height/2,600,300);
  image(E1, width/2, height/2,700,400);
  noLoop();
}
//displays img for sykscrapper
void imghouse(){
  image(HH,objX, objY,objW,objH);
}
//displays img for ferris wheel
void imgRR(){
    image(RR,objX, objY,objRW,objRH);
}

void keyevent(){
  if (keyPressed){
    if (key== 'w' || key == 'W') {
      pictSpeedY = -10;
      pictY += pictSpeedY;
    }
    if (key=='s'|| key == 'S') {
      pictSpeedY = 10;
      pictY += pictSpeedY;
    }
  }
}
//the game only begins one the mouse is pressed <- event listener
void startevent(){
  loop();
  if (mousePressed){
    if (!start){
      start = true;
      objSpeedX = -5;
      gs=1;
    }
  }
}
//call all computing functions in correct order for game to run
void gameengine(){
  borderengine();
  obstacle();
  hitdetection();
}
//tracks if the jumping image of squatty is or is not in collision with the moving buildings source https://www.jeffreythompson.org/collision-detection/rect-rect.php
boolean hitbox(float r1x, float r1y, float r1w, float r1h, float r2x, float r2y, float r2w, float r2h) {
  // are the sides of one image touching the other?
  if (r1x + r1w >= r2x &&    // r1 right edge past r2 left
      r1x <= r2x + r2w &&    // r1 left edge past r2 right
      r1y + r1h >= r2y &&    // r1 top edge past r2 bottom
      r1y <= r2y + r2h) {    // r1 bottom edge past r2 top
        return true;
      }
    return false;    
}
//currently not working would pause game and display text
void hitdetection(){
  boolean hit =hitbox(pictX, pictY, pictSW, pictSH, objX, objY, objW, objH);
  if (hit){
    fill(0, 408, 612);
    textSize(120);
    text("Oh no, Better luck next time!", 40, 240);    
    noLoop();
  }
  else{
  //debugging purpose not functional
  //print(pictY, objX,"\n");
  }
}


//stop player from falling through ground
void borderengine(){
  if (pictY + pictAH > groundY) {
    pictY = 370;
  }
  if(pictY+pictAH <80){
    pictY=0;
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
  //creates the ilussion of obj moving
  objX += objSpeedX;
}



void getData(){
  while (usbport.available() > 0) {
    if (output != null) {
      try {
        maindata = Float.parseFloat(output);
        println(maindata);
      } 
      catch (NumberFormatException e) {
        println("Error: invalid data received from Arduino");
       }
     }
   }
} 
