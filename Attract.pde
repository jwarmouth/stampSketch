/*********************************************************
 ***  ATTRACT MODE   *************************************
 *********************************************************/

import com.hirschandmann.image.*;
ISPlayer attractPlayer;

// Attract Mode
float attractModeDelay; // seconds until Attract Mode starts
float attractTimerStart;

void firstFrameLoaded(ISPlayer player) {
  println(player+" first frame loaded");
}

void onSequenceLoaded(ISPlayer player) {
  //println(player+" sequence fully loaded");
  player.setDelay(1000/12);
  player.play();
}

// triggered when an sequence finished playing
void onSequencePlayed(ISPlayer player) {
  //player.clean();
  player.dispose();
  //println(player+" sequence played");
  //player.jump(player.currentFrame()-2);
  //player.play();
}

void drawAttract()
{
  if (state != State.ATTRACTING) return;

  if (attractPlayer.isPlaying())
  {
    image(attractPlayer, 0, 0);
    blendMode(MULTIPLY);
  }
  image(attractCanvas, 0, 0);
  blendMode(BLEND);
}

void attractSetup()
{
  
  //randomizeAllStamps();
  attractPlayer = new ISPlayer(this);
  startAttractPlayer();
  //attractPlayer = new ISPlayer(this, dataPath("attract/attract" + (int)random(1, 4)));
  //attractPlayer.setDelay(1000/12);
  attractCanvas.beginDraw();
  attractCanvas.background(255);
  attractCanvas.fill(255, 0, 0);
  attractCanvas.textAlign(CENTER);
  attractCanvas.textFont(headingFont);
  int y = 300;
  //int lineHeight = 144;

  // BIG TITLE
  attractCanvas.textSize(96);
  attractCanvas.text("SelloBoceto", width/2, y);
  y += 132;
  attractCanvas.text("StampSketch", width/2, y);
  y += 220;

  // SUBTITLE
  attractCanvas.textSize(48);
  //attractCanvas.text("Press Screen with finger to draw", width/2, height/2);
  attractCanvas.text("dibuja con tu dedo", width/2, y);
  y += 72;
  attractCanvas.text("draw with your finger", width/2, y);

  attractCanvas.endDraw();
}

void randomizeAllStamps()
{
  println("RANDOMIZING ALL STAMPS");
  int ranRoot, ranSeg, ranTip;
  ranRoot = (int)random(1, rootSets.length);
  ranSeg = (int)random(1, segmentSets.length);
  ranTip = (int)random(1, tipSets.length);

  currentRoot = ranRoot;
  currentSegment = ranSeg;
  currentTip = ranTip;

  rootSets[currentRoot].loadSprites();
  segmentSets[currentSegment].loadSprites();
  tipSets[currentTip].loadSprites();
  if (tipSets[currentTip].name == "eye block") eyeballSet.loadSprites();

  savePrefs();
}

void attractTimerTick()
{
  if (millis() > attractTimerStart + attractModeDelay * 1000)
  {
    enterAttractMode();
  }
}

void enterAttractMode()
{
  attractTimerReset();
  startAttractPlayer();
  if (state == State.ATTRACTING) return;
  
  saveHiResImage();
  saveThreeFrames();
  eraseScreen();
  state = State.ATTRACTING;
  showChoiceMenu = false;
  randomizeAllStamps();
}

void exitAttractMode()
{
  attractPlayer.clean();
  attractTimerReset();
}

void attractTimerReset()
{
  attractTimerStart = millis();
}

void startAttractPlayer()
{
  int i = (int)random(1, 4);
  attractPlayer.init(dataPath("attract/attract" + i));
  attractPlayer.setDelay(1000/12);
  if (i == 1)
  {
    currentRoot = 3;
    currentSegment = 1;
    currentTip = 1;
  }
  if (i == 2)
  {
    currentRoot = 6;
    currentSegment = 4;
    currentTip = 8;
  }
  if (i == 3)
  {
    currentRoot = 5;
    currentSegment = 9;
    currentTip = 5;
  }
  savePrefs();
}
