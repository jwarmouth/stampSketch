/*********************************************************
 ***  ATTRACT MODE   *************************************
 *********************************************************/
 
void drawAttract()
{
  if (state != State.ATTRACTING) return;
  
  attractCanvas.beginDraw();
  attractCanvas.background(255);
  attractCanvas.fill(255, 0, 0);
  attractCanvas.textAlign(CENTER);
  attractCanvas.textSize(96);
  attractCanvas.text("StampSketch", width/2, height/3);
  attractCanvas.textSize(48);
  attractCanvas.text("(attract mode)", width/2, height/2);
  attractCanvas.textSize(24);
  attractCanvas.text("Press Screen with finger to draw", width/2, height*2/3);
  attractCanvas.endDraw();
  image(attractCanvas, 0, 0);
  
}

void randomizeAllStamps()
{
  print("\nRANDOMIZING ALL STAMPS");
  currentRoot = (int)random(1, rootSets.length);
  currentSegment = (int)random(1, segmentSets.length);
  currentTip = (int)random(1, tipSets.length);
  
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
  saveThreeFrames();
  eraseScreen();
  state = State.ATTRACTING;
  attractTimerReset();
}

void exitAttractMode()
{
  randomizeAllStamps();
  attractTimerReset();
}

void attractTimerReset()
{
  attractTimerStart = millis();
}
