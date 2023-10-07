/*********************************************************
 ***  ATTRACT MODE   *************************************
 *********************************************************/
 
void drawAttract()
{
  if (state != State.ATTRACTING) return;
  
  image(attractCanvas, 0, 0);
}

void attractSetup()
{
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
}

void exitAttractMode()
{
  attractTimerReset();
}

void attractTimerReset()
{
  attractTimerStart = millis();
}
