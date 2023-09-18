/*********************************************************
 ***  SOUND   ********************************************
 *********************************************************/

void soundSetup()
{
  rootSounds = new SoundFile[1];
  segmentSounds = new SoundFile[1];
  tipSounds = new SoundFile[1];
  
  rootSounds[0] = new SoundFile(this, "sounds/root-1.wav");
  segmentSounds[0] = new SoundFile(this, "sounds/segment-1.wav");
  tipSounds[0] = new SoundFile(this, "sounds/tip-1.wav");
}


void playSound(SoundFile soundFile, float x, float y)
{
  //float rate = 1 + (-y/height + 0.5)/2;//(y-height/2)/height/2;
  //float pan = 1 - (-x/width + 0.5)/2;
  float rate = map(y, height, 0, 0.75, 1.25);
  float pan = map(x, 0, width, -1.0, 1.0);
  soundFile.play(rate, pan, 1.0);
  //soundFile.pan(pan);
  print ("\nPlaying sound. Rate: " + rate + " Pan: " + pan);
}
