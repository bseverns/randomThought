class PSaw implements AudioSignal
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

    if(presenceSum >1000) { // this large number is an arbitrary threshold
      localPresenceSum = presenceSum;
    } 
    else {
      presenceSum = 0;
    }

    float range = map(localPresenceSum, 0, maxPresenseSum, 0, 1);
    float peaks = map(localPresenceSum, 0, maxPresenseSum, 5, 30);

    float inter = float(samp.length) / peaks;
    for ( int i = 0; i < samp.length; i += inter )
    {
      for ( int j = 0; j < inter && (i+j) < samp.length; j++ )
      {
        samp[i + j] = map(j, 0, inter*random(2.8, 3), -range, range);
      }
    }
  }

  // this is a stricly mono signal
  void generate(float[] left, float[] right)
  {
    generate(left);
    generate(right);
  }
}

