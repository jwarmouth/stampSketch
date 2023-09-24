/*********************************************************
 ***  SOUND   ********************************************
 *********************************************************/

void playRootSound()
{
  playSound(rootSound, mouseX, mouseY);
}

void playSegmentSound()
{
  playSound(segmentSound, mouseX, mouseY);
}

void playTipSound()
{
  playSound(tipSound, mouseX, mouseY);
}

// PROCESSING SOUND
void soundSetup()
{
  //rootSounds = new SoundFile[1];
  //segmentSounds = new SoundFile[1];
  //tipSounds = new SoundFile[1];
  
  rootSound = new SoundFile(this, "sounds/root-1.wav");
  segmentSound = new SoundFile(this, "sounds/segment-1.wav");
  tipSound = new SoundFile(this, "sounds/tip-1.wav");
}

void playSound(SoundFile soundFile, float x, float y)
{
  //float rate = 1 + (-y/height + 0.5)/2;//(y-height/2)/height/2;
  //float pan = 1 - (-x/width + 0.5)/2;
  x = constrain(x, 0, width);
  y = constrain(y, 0, height);
  
  float rate = map(y, height, 0, 0.75, 1.25);
  float pan = map(x, 0, width, -.75, .75);
  soundFile.play(rate, pan, 1.0);
  //soundFile.pan(pan);
  print ("\nPlaying sound. Rate: " + rate + " Pan: " + pan);
}

// BEADS SOUND
//void soundSetup()
//{
//  audioContext = AudioContext.getDefaultContext();
//  //audioContext = new AudioContext();
//  //audioContext.out.addInput(gain);
//  //panner.setPos(0);
//  panner.addInput(gain);
//  audioContext.out.addInput(panner);
//  audioContext.start();
//  //rootSounds = new SamplePlayer[1];
//  //segmentSounds = new SamplePlayer[1];
//  //tipSounds = new SamplePlayer[1];
  
//  //rootSounds[0] = new SamplePlayer(SampleManager.sample("sounds/root-1.wav"));
//  //segmentSounds[0] = new SamplePlayer(SampleManager.sample("sounds/segment-1.wav"));
//  //tipSounds[0] = new SamplePlayer(SampleManager.sample("sounds/tip-1.wav"));
  
//  rootSound = new SamplePlayer(SampleManager.sample(sketchPath("sounds/root-1.wav")));
//  segmentSound = new SamplePlayer(SampleManager.sample(sketchPath("sounds/segment-1.wav")));
//  tipSound = new SamplePlayer(SampleManager.sample(sketchPath("sounds/tip-1.wav")));
  
//  rootSound.setKillOnEnd(false);
//  segmentSound.setKillOnEnd(false);
//  tipSound.setKillOnEnd(false);
//}

//void playSound(SamplePlayer sound, float x, float y)
//{
//  x = constrain(x, 0, width);
//  y = constrain(y, 0, height);
  
//  float rate = map(y, height, 0, 0.75, 1.25);
//  float pan = map(x, 0, width, -0.75, 0.75);
  
//  //SamplePlayer sp = sound;
  
//  sound.setPosition(0);
//  sound.setRate(new Glide(rate));
//  sound.setKillOnEnd(false);
//  panner.setPos(pan);
//  gain.addInput(sound);
//  //panner.addInput(gain);
//  //audioContext.out.addInput(panner);
//  sound.start();
//  //audioContext.start();
//}


// MINIM SOUND
//void soundSetup()
//{
//  minim = new Minim(this);
//  rootSounds = new AudioPlayer[1];
//  segmentSounds = new AudioPlayer[1];
//  tipSounds = new AudioPlayer[1];
  
//  rootSounds[0] = minim.loadFile("sounds/root-1.wav", 1024);
//  segmentSounds[0] = minim.loadFile("sounds/segment-1.wav", 1024);
//  tipSounds[0] = minim.loadFile("sounds/tip-1.wav", 1024);
//}

//void playSound(AudioPlayer soundFile, float x, float y)
//{
//  float rate = map(y, height, 0, 0.75, 1.25);
//  float pan = map(x, 0, width, -1.0, 1.0);
//  soundFile.play();
//  soundFile.setPan(pan);
//}
