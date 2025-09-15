import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 
import processing.video.*; 
import ddf.minim.*; 
import ddf.minim.signals.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class ns3 extends PApplet {

//libraries





//video analysis
int numPixels;
int[] backgroundPixels;
Capture video;
int presenceSum = 0;// amount the video feed has changed

//sound genereation
Minim minim;
AudioOutput out;
PSaw vsaw;

public void setup() {
  // Change size to 320 x 240 if too slow at 640 x 480
  size(1280, 960); 

  video = new Capture(this, 80, 65, 20);
  numPixels = video.width * video.height;
  minim = new Minim(this);

  out = minim.getLineOut(Minim.STEREO, 2048);
  vsaw = new PSaw();
  // adds the signal to the output
  out.addSignal(vsaw);


  // Create array to store the background image
  backgroundPixels = new int[numPixels];
  // Make the pixels[] array available for direct manipulation
  video.loadPixels();

  frameRate(15);
}

public void draw() {

  if (video.available()) {
    arraycopy(video.pixels, backgroundPixels);
    video.read(); // Read a new video frame
    video.loadPixels(); // Make the pixels of video available
    image(video, 0, 0, width, height);//display the video for proper set up

    presenceSum = 0;

    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      // Fetch the current color in that location, and also the color
      // of the background in that spot
      int currColor = video.pixels[i];
      int bkgdColor = backgroundPixels[i];
      // Extract the red, green, and blue components of the current pixel\u00d5s color
      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract the red, green, and blue components of the background pixel\u00d5s color
      int bkgdR = (bkgdColor >> 16) & 0xFF;
      int bkgdG = (bkgdColor >> 8) & 0xFF;
      int bkgdB = bkgdColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - bkgdR);
      int diffG = abs(currG - bkgdG);
      int diffB = abs(currB - bkgdB);

      presenceSum += (diffR + diffG + diffB);
    }
  }
}

public void stop() {
  out.close();
  minim.stop();
  video.stop();
  super.stop();
}

class PSaw implements AudioSignal
{
  public void generate(float[] samp)
  {
    // 255 : is the maximum difference per pixel color if every thing changed
    // 3 : three colors per pixel
    // video.width : number or pixel columns
    // video.height : number o fpixel rows

    // gotta scale this stuff!
    int maxPresenseSum = 255 * 3 * video.width * video.height;
    int localPresenceSum = 0;  // make a local version of the presence sum

    if(presenceSum >1000) { // this large number is an arbitrary threshold
      localPresenceSum = presenceSum;
    } 
    else {
      presenceSum = 0;
    }

    float range = map(localPresenceSum, 0, maxPresenseSum, 0, 1);
    float peaks = map(localPresenceSum, 0, maxPresenseSum, 5, 30);

    float inter = PApplet.parseFloat(samp.length) / peaks;
    for ( int i = 0; i < samp.length; i += inter )
    {
      for ( int j = 0; j < inter && (i+j) < samp.length; j++ )
      {
        samp[i + j] = map(j, 0, inter*random(2.8f, 3), -range, range);
      }
    }
  }

  // this is a stricly mono signal
  public void generate(float[] left, float[] right)
  {
    generate(left);
    generate(right);
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--hide-stop", "ns3" });
  }
}
