// Variables
float currentX, currentY, lastX, lastY, targetX, targetY, redblockX, redblockY, lastAngle, targetAngle, armSegmentDistance;
ArrayList<Block> rootBlocks, segmentBlocks, tipBlocks;
Block lastRoot, lastSegment, lastTip;
PVector lastPoint, targetPoint, centerPoint;
float scaleFactor = 2.5;

//PImage[] armSprites, handSprites, handLeftSprites, blockSprites, bigBlockSprites;
// ROOTS
SpriteSet blockRedSet, blockBlackSet, blockBlack2Set, bigRedSet, bigBlackSet, rectSet;
int rootFlip = 1;
int tipFlip = 0; // left or right
float rootRotation = 0;

// SEGMENTS
SpriteSet armSet, armbSet, armcSet, blocksmSet, armRedSet;

// FULL ARMS
SpriteSet longRedSet, longBlackSet, redLineSet, blackLineSet;

// TIPS
SpriteSet handRedLSet, handRedRSet, handBlackLSet, handBlackRSet, tipBlockRedSet, tipBlockBlackSet, eyeSet, swabBlackSet, swabRedSet;

// CURRENT SET PLACEHOLDERS
SpriteSet rootSet, segmentSet, tipSet;
SpriteSet[] handRedSets, handBlackSets, rootSets, segmentSets, tipSets;
int currentRoot, currentSegment, currentTip;

// Save Info
String clipFolder, tempName;
String saveFolder = "saved/";
String fileName = "stamp";
String saveFormat = ".png";
String saveHiResFormat = ".png"; //.tif
int frameIndex, currentCanvas, saveCanvasNum;

// Screen Info
boolean recording, debugging, animating;
boolean showPreview = true;
boolean showUI = true;
boolean showMenu = true;

// Canvases
PGraphics previewCanvas, uiCanvas, choiceCanvas, debugCanvas, rootCanvas, segmentCanvas, tipCanvas, hiResCanvas;
PGraphics[] canvasFrames;

//UI
String[] uiItems = new String[] {"[C]hoose", "[S]ave", "[R]ecord", "[D]ebug", "[P]review", "[M]ouse Auto", "[Z]Cancel", "[X]Erase", "[U]I Toggle", "[A]nimating"};
Button[] rootButtons, segmentButtons, tipButtons;
Heading menuHeading, rootHeading, segmentHeading, tipHeading;
EnterButton enterButton;

// Mouse Auto
boolean mouseAutoTip = true;

// Screen Size
boolean aotm = false;
int w = 1920;
int h = 1080;
int aotm_w1 = 346;
int aotm_w2 = 106;
int aotm_w3 = 412;
int aotm_h = 1088;
int aotm_guide_y = 864;
int aotm_guide1_w = 402;
int aotm_guide2_x = 505;
float aotm_ScaleFactor =   5;
//int aotm_guide2;

enum State {
  CHOOSING, WAITING, PREVIEWING_ROOT, OVERLAPPING_ROOT, PREVIEWING_TIP, SEGMENTING, PREVIEWING_STRETCHY_SEGMENT, ENDING
};
State state = State.WAITING;

void settings()
{
  if (aotm) {
    w = aotm_w1 + aotm_w2 + aotm_w3;
    h = aotm_h;
    scaleFactor = aotm_ScaleFactor;
    fileName = "aotm";
  }
  size (w, h);
}


void setup()
{
  background(255);

  loadSpriteSets();
  resetArrayLists();
  menuSetup();
  armSegmentDistance = armSet.width * .8;
  createCanvases();
  showMenu = true;
  state = State.CHOOSING;
}

void draw()
{
  drawCanvasFrame();
  drawDebug();
  drawFrame();
  drawAOTM();
  drawMenu();
  drawUI();
  drawPreview();
}


/********************************************************
 ***  INPUT     *****************************************
 *********************************************************/
void keyReleased()
{
  switch(key) {
  case 'C':
  case 'c':
    toggleMenu();
    break;

  case ENTER:
  case RETURN:
    hideMenu();
    break;

  case 'S':
  case 's':
    saveHiResImage();
    break;

  case 'R':
  case 'r':
    toggleRecording();
    break;

  case 'D':
  case 'd':
    debugging = !debugging;
    break;

  case 'P':
  case 'p':
    showPreview = !showPreview;
    break;

  case 'M':
  case 'm':
    mouseAutoTip = !mouseAutoTip;
    break;

  case 'Z':
  case 'z':
    clearPreview();
    state = State.WAITING;
    break;

  case 'X':
  case 'x':
    eraseScreen();
    break;

  case 'U':
  case 'u':
    showUI = !showUI;
    break;

  case 'A':
  case 'a':
    animating = !animating;
    break;

  case '1':
  case '2':
  case '3':
    selectCanvasFrame((int)key - 1);
    break;

  default:
    break;
  }
  //if (key == 'C' || key == 'c') toggleMenu();
  //if (key == 'S' || key == 's') saveImage();
  //if (key == 'R' || key == 'r') toggleRecording();
  //if (key == 'D' || key == 'd') debugging = !debugging;
  //if (key == 'P' || key == 'p') showPreview = !showPreview;
  //if (key == 'X' || key == 'x') setup();
  //if (key == 'U' || key == 'u') showUI = !showUI;
  //if (key == 'A' || key == 'a') animating = !animating;
  //if (key == '1' || key == '2' || key == '3') displayCanvasFrame((int)key - 1);
}

void mousePressed()
{
  switch(state) {
  case WAITING:
    resetVectorPoints();
    Block overlapBlock = findOverlappingBlock();
    tipFlip = (int)random(2);

    if (overlapBlock != null) {
      lastPoint = new PVector (overlapBlock.x, overlapBlock.y);
      state = State.OVERLAPPING_ROOT;
    } else if (rootSets[currentRoot] == null) {
      state = State.OVERLAPPING_ROOT;
    } else {
      state = State.PREVIEWING_ROOT;
      rootFlip = randomSignum();
      rootRotation = randomRotationNSEW();
    }
    break;

  default:
    break;
  }
}


void mouseDragged()
{
  SpriteSet currentSegmentSet = segmentSets[currentSegment];
  float maxDistance;

  if (keyPressed && key == ' ') {
    moveSpriteWithSpace();
  }

  switch(state) {
  case PREVIEWING_ROOT:
    previewRoot();
    break;

  case OVERLAPPING_ROOT:
    // UPDATE -- First Segment shouldn't be drawn until mouse is outside all blocks. And that will be the lastPoint...
    if (!overlaps(rootCanvas) && !overlaps(tipCanvas)) {
      findPointsOutsideBlock();
      if (mouseButton == RIGHT || currentSegmentSet == null) {
        state = State.PREVIEWING_TIP;
      } else if (currentSegmentSet.stretchy) {
        state = State.PREVIEWING_STRETCHY_SEGMENT;
      } else {
        state = State.SEGMENTING;
      }
    }
    break;

  case SEGMENTING:
    maxDistance = currentSegmentSet.armSegmentDistance;
    calculateCenterAndTarget(maxDistance);
    if (isSegmentFarEnough(maxDistance)) {
      stampSegment();
    } else {
      previewSegment();
    }

    break;

  case PREVIEWING_STRETCHY_SEGMENT:
    maxDistance = currentSegmentSet.armSegmentDistance;
    calculateCenterAndTarget(maxDistance);
    previewSegment();
    break;

  case PREVIEWING_TIP:
    previewTip();
    break;

  default:
    break;
  }
}

void mouseReleased()
{
  lastRoot = null;

  switch(state) {
  case CHOOSING:
    // let player choose stamps
    break;

  case PREVIEWING_ROOT:
    stampRoot(); // rotateToMouse() then stamp center block
    state = State.WAITING;
    break;

  case SEGMENTING:
    if (mouseAutoTip && !overlaps()) {
      stampTip();
    }
    state = State.WAITING;
    break;

  case PREVIEWING_STRETCHY_SEGMENT:
    if (!overlaps()) {
      stampSegment(6);
      if (mouseAutoTip)
      {
        stampTip(lastAngle);
      }
    }
    state = State.WAITING;
    break;

  case PREVIEWING_TIP:
    stampTip();
    state = State.WAITING;
    break;

  default:
    state = State.WAITING;
    break;
  }

  clearPreview();
}


void drawCanvasFrame()
{
  if (animating)
  {
    currentCanvas = frameCount/3%3;
  }
  image(canvasFrames[currentCanvas], 0, 0);
}

void selectCanvasFrame(int which)
{
  animating = false;
  currentCanvas = which;
}

void moveSpriteWithSpace()
{
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
