// Variables
float currentX, currentY, lastX, lastY, targetX, targetY, redblockX, redblockY, lastAngle, targetAngle, armSegmentDistance;
ArrayList<Block> rootBlocks, segmentBlocks, tipBlocks;
Block lastRoot, lastSegment, lastTip;
PVector lastPoint, targetPoint, centerPoint;
float scaleFactor = 2.5;

//PImage[] armSprites, handSprites, handLeftSprites, blockSprites, bigBlockSprites;
SpriteSet armSet, armbSet, armRedSet, handRedLSet, handRedRSet, handBlackLSet, handBlackRSet, blockRedSet, blockBlackSet, bigBlockSet, tipBlockRedSet, tipBlockBlackSet, rectSet, eyeSet, rootSet, segmentSet, tipSet;
SpriteSet[] handRedSets, handBlackSets, rootSets, segmentSets, tipSets;
int currentRoot, currentSegment, currentTip;

// Save Info
String clipFolder, tempName;
String saveFolder = "saved/";
String fileName = "stamp";
String saveFormat = ".png";
int frameIndex, currentCanvas, saveCanvasNum;

// Screen Info
boolean recording, debugging, animating, showPreview;
boolean showUI = true;
boolean showMenu = true;

// Canvases
PGraphics previewCanvas, uiCanvas, choiceCanvas, debugCanvas, rootCanvas, segmentCanvas, tipCanvas;
PGraphics[] canvasFrames;

//UI
String[] uiItems = new String[] {"[C]hoose", "[S]ave", "[R]ecord", "[D]ebug", "[P]review", "[X]Clear", "[U]I Toggle", "[A]nimating"};
Button[] rootButtons, segmentButtons, tipButtons;
EnterButton enterButton;

enum State {
  CHOOSING, WAITING, WAITING_TO_ROOT, WAITING_TO_SEGMENT, SEGMENTING, ENDING
};
State state = State.WAITING;


void setup()
{
  size (1920, 1080);
  background(255);

  canvasSetup();
  loadSpriteSets();
  resetArrayLists();
  menuSetup();
  armSegmentDistance = armSet.width * .8;
  showMenu = true;
  state = State.CHOOSING;
}

void draw()
{
  drawCanvasFrame();
  drawDebug();
  drawPreview();
  drawMenu();
  drawUI();
}


/********************************************************
 ***  INPUT     *****************************************
 *********************************************************/
void keyReleased()
{
  switch(key)
  {
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
      saveImage();
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
      
    case 'X':
    case 'x':
      setup();
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
  switch(state)
  {
  case WAITING:
    resetVectorPoints();

    // IF we click on an existing CENTER block, then change state to WAITING_TO_SEGMENT
    if (overlaps(rootCanvas))
    {
      lastRoot = nearestBlock(rootBlocks);
      if (lastRoot != null)
      {
        lastPoint = new PVector (lastRoot.x, lastRoot.y);
        state = State.WAITING_TO_SEGMENT;
      }

      return;
    } else if (overlaps(tipCanvas))
    {
      lastTip = nearestBlock(tipBlocks);
      if (lastTip != null)
      {
        lastPoint = new PVector (lastTip.x, lastTip.y);
        state = State.WAITING_TO_SEGMENT;
      }

      return;
    } else if (overlaps(segmentCanvas))
    {
      lastSegment = nearestBlock(segmentBlocks);

      if (lastSegment != null)
      {
        // Better if it could figure out the angle, and base position on first or last point?????
        //if (findDistSq(lastSegment.beginPoint) < findDistSq(lastSegment.endPoint)){
        //  lastPoint = lastSegment.beginPoint;
        //} else {
        //  lastPoint = lastSegment.endPoint;
        //}

        lastPoint = new PVector(lastSegment.x, lastSegment.y);
        state = State.WAITING_TO_SEGMENT;
        return;
      }
    } else if (rootSets[currentRoot] == null)
    {
      resetVectorPoints();
      state = State.WAITING_TO_SEGMENT;
    } else
    {
      resetVectorPoints();
      state = State.WAITING_TO_ROOT;
    }
    break;
  default:
    break;
  }
}

void mouseDragged()
{
  switch(state)
  {
  case WAITING_TO_SEGMENT:
    // UPDATE -- First Segment shouldn't be drawn until mouse is outside all blocks. And that will be the lastPoint...
    if (!overlaps(rootCanvas) && !overlaps(tipCanvas))
    {
      targetPoint = new PVector(mouseX, mouseY);
      PVector toCenter = PVector.sub(lastPoint, targetPoint);
      toCenter.limit(10);    // Start a TEENY bit back toward the center of lastRoot
      lastPoint = PVector.add(targetPoint, toCenter);
      lastAngle = angleToMouse(lastPoint);
      state = State.SEGMENTING;
    }
    break;

  case SEGMENTING:
    // Calculate Center Point first -- then check to see if it overlaps
    if (findTargetCenterPoints(segmentSets[currentSegment].armSegmentDistance))
    {
      if (overlaps(rootCanvas, centerPoint))
      {
        state = State.WAITING;
        return;
      }
      stampSegment();
    }
    break;
  default:
    break;
  }
}

void mouseReleased()
{
  lastRoot = null;
  switch(state)
  {
  case CHOOSING:
    // let player choose stamps
    break;

  case WAITING_TO_ROOT:
    stampRoot(); // rotateToMouse() then stamp center block
    state = State.WAITING;
    break;

  case SEGMENTING:
    if (!overlaps(rootCanvas) && !overlaps(segmentCanvas) && !overlaps(tipCanvas))
    {
      stampTip();
    }
    state = State.WAITING;
    break;

  default:
    state = State.WAITING;
    break;
  }
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

void previewTo(PGraphics canvas)
{
  canvas.beginDraw();
  canvas.blendMode(MULTIPLY);
  canvas.image(previewCanvas, 0, 0);
  canvas.endDraw();
}

/********************************************************
 ***  CLASSES  *******************************************
 *********************************************************/
