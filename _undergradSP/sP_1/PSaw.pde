//-------------------------------------------MINIM--------------------------------------
class PSaw implements AudioSignal
{

  int localPresenceSum = 0;  // make a local version of the presence sum

  //------------------------------------------SOUND PROCESSOR-----------------------------
  void generate(float[] samp)
  {
    // gotta scale this stuff!
    int maxPresenceSum = 255 * 3 * 640 *480;

    if(presenceSum > 1000) { // this large number is an arbitrary threshold
      localPresenceSum = presenceSum;
    } 
    else {
      presenceSum = 0;
    }

    float range = map(localPresenceSum, 0, maxPresenceSum, 0, 1);
    float peaks = map(localPresenceSum, 0, maxPresenceSum, 5, 25);

    float inter = float(samp.length) / peaks;
    for ( int i = 0; i < samp.length; i += inter )
    {
      for ( int j = 0; j < inter && (i+j) < samp.length; j++ )
      {
        samp[i + j] = map(j, 0, inter, -range, range*2);
      }
    }
  }

  void generate(float[] left, float[] right) {
    generate(left);
    generate(right);
  }
}

