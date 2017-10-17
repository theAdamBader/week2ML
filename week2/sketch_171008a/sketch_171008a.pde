// This demo changes the pitch of the sound played and the screen color to match the class received
// Works with 1 classifier output, any number of classes
// REFERENCE: Rebecca Fiebrink, 2016 (ColorAndSound)

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
OscP5 oscP5;
NetAddress dest;

//For object
int currentHue = 0;
int currentShape= 0;
float sph = 0;//Adam

//For sound:
Minim       minim;
AudioOutput out;
Oscil       wave;

void setup() {
  size(400, 400, P3D);
  colorMode(HSB);
  smooth();

  //Set up sound:
  minim = new Minim(this);
  out = minim.getLineOut();
  wave = new Oscil( 440, 0.5f, Waves.SINE);
  wave.setAmplitude(0.0);
  // patch the Oscil to the output
  wave.patch( out );

  //Initialize OSC communication
  oscP5 = new OscP5(this, 12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1", 6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
}

void draw() {
  frameRate(30);
  background(0);
  ruShpere();
}

void ruShpere() {//adam
  fill(currentHue, 255, 255);
  translate(width/2, height/2); 
  rotateY(sph*2);
  stroke(255);
  sphere(currentShape);

  sph += 0.01;
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
  //println("received message");
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    if (theOscMessage.checkTypetag("f")) {
      float f = theOscMessage.get(0).floatValue();
      println("received1");
      showMessage((int)f);
    }
  }
}

void showMessage(int i) {
  currentHue = (int)generateColor(i);
  currentShape = (int)generateColor(i);//adam
  wave.setFrequency((float)(261 * Math.pow(1.059, i*4)));
  wave.setAmplitude(0.5);
}

float generateColor(int which) {
  float f = 300; //adam
  int i = which;
  if (i <= 0) {
    return 300;//adam
  } else {
    return (generateColor(which-1) + 1.09*255) %255;//modified
  }
}