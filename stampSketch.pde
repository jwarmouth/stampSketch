/*********************************************************
 ***  STAMP SKETCH   *************************************
 *********************************************************/

void setup()
{
  //fullScreen(FX2D, 1);
  fullScreen();
  //size(1920, 1080);
  background(255);
  frameRate(48);
  
  scaleFactor = 3.25;
  cornerScale = 0.5;
  spanish = false;
  //noCursor();
  
  loadFonts();
  eyeballRandomLook();
  
  //refScale = refH / displayHeight;
  //scaleFactor *= refScale;

  loadPrefs();
  //resetChoices();
  loadSpriteSets();
  resetArrayLists();
  cornerMenuSetup();
  choiceMenuSetup();
  menuBarSetup();
  armSegmentDistance = armSet.width * .9; //.8;
  createCanvases();
  soundSetup();
  attractSetup();
  //showMenu = true;
  //state = State.ATTRACTING;
  //savePrefs();
}

void draw()
{
  //thread("ifMouseDragged");
  ifMouseDragged();
  attractTimerTick();
  
  drawCanvasFrame();
  //drawFrame();
  drawAOTM();
  drawPreview();
  drawRootCanvas();
  drawSegmentCanvas();
  drawTipCanvas();
  drawDebug();
  drawAttract();
  
  // Menus
  drawChoiceMenu();
  drawMenuBar();
  drawCornerMenu();
}

void moveSpriteWithSpace()
{
  if (!(keyPressed && key == ' ')) return;   // if (mouseButton == RIGHT && mouseButton == LEFT)
  float dmouseX = mouseX - pmouseX;
  float dmouseY = mouseY - pmouseY;

  lastPoint.x += dmouseX;
  lastPoint.y += dmouseY;

  targetPoint.x += dmouseX;
  targetPoint.y += dmouseY;

  centerPoint.x += dmouseX;
  centerPoint.y += dmouseY;
}

/*
void settings()
{
  refScale = refW / w;
  scaleFactor *= refScale;

  // only if AOTM project
  if (aotm) {
    w = aotm_w1 + aotm_w2 + aotm_w3;
    h = aotm_h;
    scaleFactor = aotm_ScaleFactor;
    fileName = "aotm";
  }
  size (w, h);
}
*/
