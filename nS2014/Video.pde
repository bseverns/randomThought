//switch from a video-sound interface to a video-graphic one

class PSaw
{
  void generate(float[] samp)
  {
    // 255 : is the maximum difference per pixel color if every thing changed
    // 3 : three colors per pixel
    // video.width : number or pixel columns
    // video.height : number o fpixel rows

    // gotta scale this stuff!
    int maxPresenseSum = 255 * 3 * video.width * video.height;
    int localPresenceSum = 0;  // make a local version of the presence sum

    if(presenceSum > 1000) { // this large number is an arbitrary threshold
      localPresenceSum = presenceSum;
    } 
    else {
      presenceSum = 0;
    }

    float range = map(localPresenceSum, 0, maxPresenseSum, 0, 1);
    float peaks = map(localPresenceSum, 0, maxPresenseSum, 0, 30);

    float inter = float(samp.length) / peaks;
    for ( int i = 0; i < samp.length; i += inter )
    {
      for ( int j = 0; j < inter && (i+j) < samp.length; j++ )
      {
        samp[i + j] = map(j, 0, inter*random(2.8, 3), -range, range);
      }
    }
  }
  
  //decides color
  //
  //write a sort of fail-safe re: arduino signal/list state
  //
  //
void colorShift() {
  //black
  stroke(0);
  //reset lines/colors
  s = 0;

  //change value to make more/less black/white lines appear based on input value
  if (in > 25) {
    s = 1;
    if (s == 1) {
      stroke (255);
    }
  }
}

}

