import processing.serial.*;

Serial Radar;
String port = "COM16";           // enter relevent com port
int displayfactor = 5;           //distance to display: 1cm=5 pixels
int maxD=500; //100cm

void setup() {

  size(1200, 600);               //size of window ** ratio is important
  frame.setLocation(0, 0);   
  background(0);
  Radar = new Serial(this, port, 115200);
  Radar.write(0);
  textSize(20);
  text("Waiting for connection ...", 500, 200);
}

int reading=000;
int angle=0;
int side=1;

ArrayList<Integer> read_list=new ArrayList();   //readings are stored
int maxlistcount=180;                            //set maximum stored readings


void draw() {


  reading = Radar.read();                  // read from Serial

  //println(reading);
  //continue only if reading available
  if (reading>-1) {                       //increment angle , change side
    angle+=side; 
    if (angle<0) {
      side=1;
    } else if (angle>180) {
      side=-1;
    }


    read_list.add(reading*displayfactor);       //scale to window

    if (maxlistcount<read_list.size()) {
      read_list.remove(0);
    }

    drawline();                                   //drawing..
    delay(0);

    Radar.write((byte)angle);                   //write next angle
  }
}


void drawline() {

  background(50, 25, 0);
  textSize(20);
  textAlign(LEFT);
  fill(255, 255, 255);
  text("ULTRA SONIC RADAR DISPLAY", 25, 50);

  textSize(24);
  fill(255, 255, 100);
  text("Scanning ...", 25, 90);
  text("Angle     : "+angle, 25, 125);
  text("Distance : "+reading+" cm", 25, 150);         //primary display





  stroke(255, 100);                               // distance lables

  for (int a=1000; a>99; a-=100) {

    fill(0);
    arc(600, 550, a, a, -3.18, 0.02);
    textSize(10);
    textAlign(CENTER);
    fill(255);
    text(a/10, 600-a/2, 575);
    text(a/10, a/2+600, 575);
    text(a/10, 600+0.5735*a/2, 550-0.819*a/2);
    text(a/10, 600-0.5735*a/2, 550-0.819*a/2);
  }

  for (int A=0; A<181; A+=10) {                              // angle lables
    double tita=Math.toRadians(A);
    line(600, 550, 600+(int)(Math.cos(tita)*500), 550-(int)(Math.sin(tita)*500));
    text(A, 600+(int)(Math.cos(tita)*510), 550-(int)(Math.sin(tita)*510));
  }





  int d_ang=angle;                                       //drawing lines....
  int d_dir=side*-1;

  for (int i=read_list.size()-1; i>-1; i--) {

    int d_angd=d_ang;

    double radient=Math.toRadians(d_angd);

    int r=read_list.get(i);

    if (r>500) {
      r=500;
    }

    int x=600+(int)(Math.cos(radient)*r);
    int y=550-(int)(Math.sin(radient)*r);

    stroke(0, 255, 0, i*2);

    line(600, 550, x, y);
    // print(x);
    // println(y);

    d_ang+=d_dir;
    if (d_ang<0) {
      d_dir=d_dir*-1;
      d_ang+=d_dir*2;
    }
    if (d_ang>180) {
      d_dir=d_dir*-1;
      d_ang+=d_dir*2;
    }
  }
}
