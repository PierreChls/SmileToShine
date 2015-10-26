import gab.opencv.*;
import processing.video.*;
import pSmile.PSmile;
import pSmile.*;
import java.awt.Rectangle;
import processing.video.*;

PImage src, dst, thresh, fond;
int x1, y1, x2, y2;
OpenCV opencv;
Rectangle[] faces;

Boolean verif_photo=false;

Capture cam;
int x = 0;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;


void setup() {
  size(1200, 700);
  fond = loadImage("fond.png"); 
  
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();     
  }     
  
  if(verif_photo==true){

  }
  
}


void draw() {

  if (cam.available() == true) {
    cam.read();
  }

  if(verif_photo==false){
    image(cam, 0, 0);
    image(fond,0,0);
  }
  
  if(verif_photo==true){
    //Filter
    image(src, 0, 0);
    
  
    //FindContours
  
    noFill();
    strokeWeight(1);
    for (Contour contour : contours) {
      stroke(0, 255, 0);
        contour.draw();
    }
    
    //FaceDetection
    for (int i = 0; i < faces.length; i++) {
      noFill();
      stroke(255, 0, 0);
      strokeWeight(3);
      x1=faces[i].x;
      y1=faces[i].y+200;
      x2=faces[i].width;
      y2=faces[i].height-200;
      rect(x1, y1, x2, y2);  
      
    }
  }
}
  
void keyPressed(){
  if(key=='p'){
    saveFrame("data/line.png");
    
    src = loadImage("line.png"); 
    opencv = new OpenCV(this, src);
    size(opencv.width, opencv.height);
  
    //FaceDetection
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
    faces = opencv.detect();
    
    //Filter
    opencv.threshold(90);
    thresh = opencv.getSnapshot();
    
    //FindContours
    opencv.gray();
    opencv.threshold(90);
    contours = opencv.findContours();
    println("found " + contours.size() + " contours");
    
    verif_photo=true;
  }
}
