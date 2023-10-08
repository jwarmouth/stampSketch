/*********************************************************
 ***  ATTRACT MODE   *************************************
 *********************************************************/

//import com.hirschandmann.image.*;
//ISPlayer attractPlayer;

//void firstFrameLoaded(ISPlayer player){
//  println(player+" first frame loaded");
//}

//void onSequenceLoaded(ISPlayer player){
//  println(player+" sequence fully loaded");
//  player.loop();
//}

//// triggered when an sequence finished playing
//void onSequencePlayed(ISPlayer player){
//  println(player+" sequence played");
//}

void drawAttract()
{
  //if (state != State.ATTRACTING) return;
  //image(attractPlayer, 0, 0);
  //blendMode(MULTIPLY);
  image(attractCanvas, 0, 0);
  //blendMode(BLEND);
}

void attractSetup()
{
  //attractPlayer = new ISPlayer(this,dataPath("attract/attract" + (int)random(1,4)));
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
  if (state == State.ATTRACTING) return;
  
  if (millis() > attractTimerStart + attractModeDelay * 1000)
  {
    enterAttractMode();
  }
}

void enterAttractMode()
{
  saveHiResImage();
  saveThreeFrames();
  eraseScreen();
  state = State.ATTRACTING;
  showChoiceMenu = false;
  randomizeAllStamps();
  attractTimerReset();
  
  //attractPlayer = new ISPlayer(this,dataPath("attract/attract1"));
  //attractPlayer.setDelay(1000/12);
}

void exitAttractMode()
{
  //attractPlayer = null; // hopefully this will clear the RAM
  attractTimerReset();
}

void attractTimerReset()
{
  attractTimerStart = millis();
}
