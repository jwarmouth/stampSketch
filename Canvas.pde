void createCanvases()
{
  previewCanvas = createGraphics(width, height);
  rootCanvas = createGraphics(width, height);
  segmentCanvas = createGraphics(width, height);
  tipCanvas = createGraphics(width, height);
  debugCanvas = createGraphics(width, height);
  choiceCanvas = createGraphics(width, height-40);
  uiCanvas = createGraphics(1920, 40);

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

void eraseScreen()
{
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
