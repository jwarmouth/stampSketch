/*********************************************************
 ***  STAMP SKETCH   *************************************
 *********************************************************/



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

void setup()
{
  //fullScreen(FX2D, 1);
  size(1920, 1080);
  //fullScreen();
  background(255);
  frameRate(48);
  
  loadFonts();
  eyeballRandomLook();
  
  //refScale = refH / displayHeight;
  //scaleFactor *= refScale;

  loadPrefs();
  resetChoices();
  loadSpriteSets();
  resetArrayLists();
  cornerMenuSetup();
  choiceMenuSetup();
  menuBarSetup();
  armSegmentDistance = armSet.width * .9; //.8;
  createCanvases();
  soundSetup();
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



/********************************************************
 ***  CLASSES  *******************************************
 *********************************************************/
