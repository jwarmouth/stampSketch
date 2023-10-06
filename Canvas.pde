/*********************************************************
 ***  CANVAS   *******************************************
 *********************************************************/

void createCanvases()
{
  previewCanvas = createGraphics(width, height);
  rootCanvas = createGraphics(width, height);
  segmentCanvas = createGraphics(width, height);
  tipCanvas = createGraphics(width, height);
  debugCanvas = createGraphics(width, height);
  attractCanvas = createGraphics(width, height);
  choiceCanvas = createGraphics(width, height);
  cornerMenuCanvas = createGraphics(cornerW, cornerH);
  menuBarCanvas = createGraphics(1920, 40);

  canvasFrames = new PGraphics[canvasFramesCount]; // default = 3
  for (int i=0; i<canvasFrames.length; i++)
  {
    canvasFrames[i] = createGraphics(width, height);
  }

  // Only if drawToHiRes is turned on???
  clearHiResCanvas();
  clearAllCanvases();
}

void drawCanvasFrame()
{
  setCurrentCanvas();
  image(canvasFrames[currentCanvas], 0, 0);
}

void setCurrentCanvas()
{
  if (animating)
  {
    animFrameCount = millis()*animationRate/1000;
    currentCanvas = animFrameCount%canvasFramesCount;
    // get current animation frame = 12fps how many millis? millis()/12/1000 = animFrameCount
  }
}

void selectCanvasFrame(int which)
{
  animating = false;
  if (canvasFramesCount >= which)
  {
    currentCanvas = which;
  }
}

void showOne()
{
  selectCanvasFrame(0);
}

void showTwo()
{
  selectCanvasFrame(1);
}

void showThree()
{
  selectCanvasFrame(2);
}

void toggleRootCanvas()
{
  showRootCanvas = !showRootCanvas;
}

void drawRootCanvas()
{
  if (!showRootCanvas) return;
  image(rootCanvas, 0, 0);
}

void toggleSegmentCanvas()
{
  showSegmentCanvas = !showSegmentCanvas;
}

void drawSegmentCanvas()
{
 if (!showSegmentCanvas) return;
 image(segmentCanvas, 0, 0);
}

void toggleTipCanvas()
{
  showTipCanvas = !showTipCanvas;
}

void drawTipCanvas()
{
  if (!showTipCanvas) return;
  image(tipCanvas, 0, 0);
}

void eraseScreen()
{
  //createCanvases();
  clearAllCanvases();
  //showMenu = true;
  //state = State.CHOOSING;
}

void clearAllCanvases()
{
  clearPreview();
  makeTransparent(rootCanvas);
  makeTransparent(segmentCanvas);
  makeTransparent(tipCanvas);
  makeTransparent(debugCanvas);

  for (int i=0; i<canvasFrames.length; i++)
  {
    makeWhite(canvasFrames[i]);
  }
  if (hiResEnabled) clearHiResCanvas(); // only if enabled
}

void clearHiResCanvas()
{
  if (hiResEnabled)
  {
    int scaledWidth = (int)((float)width*scaleFactor);
    int scaledHeight = (int)((float)height*scaleFactor);
    hiResCanvas = createGraphics(scaledWidth, scaledHeight);
    makeWhite(hiResCanvas);
  }
}

void makeTransparent(PGraphics canvas)
{
  canvas.beginDraw();
  canvas.background(255, 255, 255, 0);
  canvas.endDraw();
}

void makeWhite(PGraphics canvas)
{
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
}

void drawFrame()
{
  if (aotm || state == State.CHOOSING) return;

  noStroke();
  if (recording)
  {
    fill (0, 0, 0, 200);
  } else
  {
    fill (200, 200, 200, 200);
  }
  //rect(0, 0, width, 40); // TOP
  rect(0, 40, 40, height-80); // LEFT
  rect(width-40, 40, 40, height-80); // RIGHT
  rect (0, height-40, width, 40); // BOTTOM
}

void drawAOTM()
{
  if (state == State.CHOOSING) return;
  if (aotm)
  {
    // draw spine
    noStroke();
    fill (200, 200, 200, 200);
    rect (aotm_w1, 0, aotm_w2, h); // spine
    rect (0, aotm_guide_y, aotm_guide1_w, h - aotm_guide_y); // left overlap
    rect (aotm_guide2_x, aotm_guide_y, w - aotm_guide2_x, h - aotm_guide_y); // right overlap
    //strokeWeight(1);
    //stroke(200, 200, 200, 200);
    //line(aotm_w1, 0, aotm_w1, h);
    //line(aotm_w1 + aotm_w2, 0, aotm_w1 + aotm_w2, h);
    //noStroke();
    //stroke(255);
  }
}
