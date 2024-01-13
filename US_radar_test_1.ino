#include <Servo.h>
Servo rotator;

#define servopin 5
#define trig 3
#define echo 2
float t;
float D;
int angle;

void setup() {
  Serial.begin(115200);
  delay(10);
rotator.attach(servopin);
  pinMode(trig, OUTPUT);
  pinMode(echo, INPUT);

  digitalWrite(trig, LOW);
  delayMicroseconds(5);
rotator.write(0);
delay(1000);
Serial.println("READY TO START");
}

void loop() {

if(Serial.available()){
  angle=Serial.read();
  rotator.write(angle);
  delay(10);
  Serial.write((byte)getdistance());
 
}

}

long getdistance() {

float T=0;
for(int i=0; i<5;i++){
 
 digitalWrite(trig, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig, LOW);

  t = pulseIn(echo, HIGH);
delay(0);
 T += t;
  
}
  T=T/5;
 D=T/29.1/2;
//D=t/29.1/2;
 if(D<=0){
  D=0;
 }
  return D;
}
