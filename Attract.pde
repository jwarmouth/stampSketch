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
  currentRoot = (int)random(1, rootSets.length);
  rootSets[currentRoot].loadSprites();
  
  
  currentSegment = (int)random(1, segmentSets.length);
  segmentSets[currentSegment].loadSprites();
  
  currentTip = (int)random(1, tipSets.length);
  tipSets[currentTip].loadSprites();
  
  savePrefs();
}

void attractTimerTick()
{
  if (millis() > attractTimerStart + attractModeDelay * 1000)
  {
    eraseScreen();
    state = State.ATTRACTING;
  }
}

void attractTimerReset()
{
  attractTimerStart = millis();
}
