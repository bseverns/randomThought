/* algorithmicCompExample<br/>
 is an example of algorithmic composition.  It uses a class to construct
 sentences.  The syllables of the words are played by an Instrument.
 This is intended to sound like a conversation between two robots, where
 the voice of each robot is inspired by the teacher from the Peanuts cartoons. 
 <p>
 For more information about Minim and additional features, visit http://code.compartmental.net/minim/
 <p>
 authour: Anderson Mills<br/>
 Anderson Mills's work was supported by numediart (www.numediart.org)
 */

// import everything necessary to make sound.
import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

// create all of the variables that will need to be accessed in
// more than one methods (setup(), draw(), stop())
Minim minim;
AudioOutput out;

float fundFreqA = 110.0;  // fundamental freq of talker A
float fundFreqB = 146.0;  // fundamental freq of talker B

float gapMin = 0.5;       // min gap between sentences
float gapMax = 1.9;       // max gap between sentences

//EXPLORE MULTIPE AUDIO UNITS -- STEREO AMP/DRIVER
float balanceA = 0.95;     // stereo position of talker A
float balanceB = -0.95;    // stereo position of talker B

PeanutsSentencer theTeacher;

float fundFreq;
float balance;

// many different variables which give appropriate ranges for the 
// rhythm of the sentences and the syllables
int nSentences = 2;      // total number of sentences

int sOut = 0;

int nSylls;

  // setup is run once at the beginning
  void setup()
{
  size(512, 200, P2D);
  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO, 1024);
  // give a 1 second pause before any talking
  out.setNoteOffset( 1.0 );

  // create a "teacher"

  theTeacher = new PeanutsSentencer( out );
}

// draw is run many times
void draw()
{
  // erase the window to black
  background( 0 );
  // draw using a white stroke
  stroke( 255 );
  // draw the waveforms
  for ( int i = 0; i < out.bufferSize() - 1; i++ )
  {
    // find the x position of each buffer value
    float x1  =  map( i, 0, out.bufferSize(), 0, width );
    float x2  =  map( i+1, 0, out.bufferSize(), 0, width );
    // draw a line from one buffer position to the next for both channels
    line( x1, 50 + out.left.get(i)*50, x2, 50 + out.left.get(i+1)*50);
    line( x1, 150 + out.right.get(i)*50, x2, 150 + out.right.get(i+1)*50);
  }
}


/*
INVESTIGATE RPi//Ardu//WebCm//PIR connectivity/workability
 
 if(arduino.analogRead(0) > trig){
 fundFreq = fundFreqA;
 balance = balanceA;
 trigger();
 }  else if (arduino.AnalogRead(1) > trig){
 fundFreq = fundFreqB;
 balance = balanceB;
 trigger();
 }
 
 */

//VOID TRIGGER(){}
void keyPressed() {
  if (key==' ') {
    sOut++;
    float startSum = 0.0;

    if (sOut>1) {
      // specify that time in beats is also time in seconds
      out.setTempo( 60f ); //variable manipulate?
      fundFreq = fundFreqB;
      balance = balanceB;
      sOut=0;
    } else {
      // specify that time in beats is also time in seconds
      out.setTempo( 45f ); //variable manipulate?
      fundFreq = fundFreqA;
      balance = balanceA;
    }

    // set up theTeacher for the next sentence
    theTeacher.setParameters( startSum, fundFreq, balance );
    // have theTeacher make the playNote calls and return the length of the sentence
    float lastLen = theTeacher.saySentence();
    // add in a little gap
    float gapTime = (float)Math.random()*(gapMax - gapMin ) + gapMin;
    // and move the coversation forward
    startSum += lastLen + gapTime;
  }
}
