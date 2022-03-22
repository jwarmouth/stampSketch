// Variables
float currentX, currentY, lastX, lastY, targetX, targetY, redblockX, redblockY, lastAngle, targetAngle, armSegmentDistance;
ArrayList<Block> rootBlocks, segmentBlocks, tipBlocks;
Block lastRoot, lastSegment, lastTip;
PVector lastPoint, targetPoint, centerPoint;
float scaleFactor = 2.5;

//PImage[] armSprites, handSprites, handLeftSprites, blockSprites, bigBlockSprites;
SpriteSet armSet, armbSet, handLeftSet, handRightSet, blockSet, bigBlockSet, tipBlockSet, rectSet, eyeSet, rootSet, segmentSet, tipSet;
SpriteSet[] handSets, rootSets, segmentSets, tipSets;
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
//ChoiceSprite[] choiceBeginSprites = new ChoiceSprite[2];
//ChoiceSprite[] choiceSegmentSprites = new ChoiceSprite[2];
//ChoiceSprite[] choiceEndSprites = new ChoiceSprite[2];
Button[] rootButtons, segmentButtons, tipButtons;

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
  armSegmentDistance = armSet.width * 0.8;
  if (showMenu) state = State.CHOOSING;
}


void draw()
{
  if (animating) currentCanvas = frameCount/3%3;
  image(canvasFrames[currentCanvas], 0, 0);

  if (showUI) drawUI();
  if (debugging) image(debugCanvas, 0, 0);
  if (showPreview) image(previewCanvas, 0, 0);
  if (showMenu) drawChoice();

  //image(rootCanvas, 0, 0);
  //image(segmentCanvas, 0, 0);
}


/********************************************************
 ***  INPUT     *****************************************
 *********************************************************/
void keyReleased()
{
  if (key == 'C' || key == 'c') toggleChoosing();
  if (key == 'S' || key == 's') saveImage();
  if (key == 'R' || key == 'r') toggleRecording();
  if (key == 'D' || key == 'd') debugging = !debugging;
  if (key == 'P' || key == 'p') showPreview = !showPreview;
  if (key == 'X' || key == 'x') setup();
  if (key == 'U' || key == 'u') showUI = !showUI;
  if (key == 'A' || key == 'a') animating = !animating;
  if (key == '1' || key == '2' || key == '3') displayCanvas((int)key - 1);
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
      lastRoot = findNearest(rootBlocks);
      if (lastRoot != null)
      {
        lastPoint = new PVector (lastRoot.x, lastRoot.y);
        state = State.WAITING_TO_SEGMENT;
      }

      return;
    } else if (overlaps(tipCanvas))
    {
      lastTip = findNearest(tipBlocks);
      if (lastTip != null)
      {
        lastPoint = new PVector (lastTip.x, lastTip.y);
        state = State.WAITING_TO_SEGMENT;
      }

      return;
    } else if (overlaps(segmentCanvas))
    {
      lastSegment = findNearest(segmentBlocks);

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
    if (findTargetCenterPoints(armSegmentDistance))
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



/********************************************************
 ***  STAMPING   *****************************************
 *********************************************************/

void stampRoot()
{
  SpriteSet set = rootSets[currentRoot];
  if (set == null) return; // quick fix???

  float stampAngle = angleToMouse(lastPoint);

  stamp (set, stampAngle, randomSignum());
  previewTo(rootCanvas);

  lastRoot = new Block(lastPoint.x, lastPoint.y, set.width, set.height, stampAngle + randomRotationNSEW(), lastPoint, targetPoint);
  rootBlocks.add(lastRoot);

  saveFrames(12);
}

void stampSegment()
{
  SpriteSet set = segmentSets[currentSegment];
  if (set == null) return; // quick fix???

  lastAngle = angleToMouse(lastPoint);

  stamp(set, lastAngle, 1);
  previewTo(segmentCanvas);

  lastSegment = new Block(centerPoint.x, centerPoint.y, armSegmentDistance, armSegmentDistance, lastAngle, lastPoint, targetPoint);
  segmentBlocks.add(lastSegment);

  lastPoint = targetPoint;

  saveFrames(1);
}

void stampTip()
{
  SpriteSet set = tipSets[currentTip];
  if (set == null) return; // quick fix???

  saveFrames(1); // Extra delay before drawing tip -- could be 2 for that "pop"

  targetPoint = new PVector (mouseX, mouseY);
  // stamp end with rotation to mouse
  float stampAngle = angleToMouse(lastPoint);

  //print(set.name);
  switch(set.name)
  {
  case "hand":
    // Left Hand or Right Hand?
    set = handSets[(int)random(handSets.length)];
    centerPoint = PVector.add(lastPoint, PVector.fromAngle(lastAngle, targetPoint));
    break;

  default:
    centerPoint = PVector.add(lastPoint, PVector.mult(PVector.fromAngle(lastAngle), set.width/2));
    break;
  }

  stamp (set, stampAngle, 1);
  previewTo(tipCanvas);

  lastTip = new Block(centerPoint.x, centerPoint.y, set.width, set.height, stampAngle + randomRotationNSEW(), lastPoint, targetPoint);
  tipBlocks.add(lastTip);
  saveFrames(12);

  if (debugging)
  {
    debugCanvas.beginDraw();
    debugCanvas.fill(0, 255, 0);
    debugCanvas.circle(targetPoint.x, targetPoint.y, 10);
    debugCanvas.endDraw();
  }
}

void previewTo(PGraphics canvas)
{
  canvas.beginDraw();
  canvas.blendMode(MULTIPLY);
  canvas.image(previewCanvas, 0, 0);
  canvas.endDraw();
}

void stamp(SpriteSet spriteSet, float rotation, int flipX)
{
  if (spriteSet == null) return; // quick fix???
  int index = (int)random(spriteSet.length);
  //int howManySaved = 0;

  // Draw to previewCanvas
  previewCanvas.beginDraw();
  previewCanvas.clear();
  //previewCanvas.blendMode(MULTIPLY);
  previewCanvas.imageMode(CENTER); // use image center instead of top left
  previewCanvas.pushMatrix(); // remember current drawing matrix
  previewCanvas.translate(centerPoint.x, centerPoint.y);
  previewCanvas.rotate(rotation);
  previewCanvas.scale(flipX, 1);
  previewCanvas.image(spriteSet.sprites[(index)%spriteSet.length], spriteSet.offsetX * flipX, spriteSet.offsetY);
  previewCanvas.popMatrix();
  previewCanvas.endDraw();

  for (int i=0; i<3; i++)
  {
    canvasFrames[i].beginDraw();
    canvasFrames[i].blendMode(MULTIPLY); // change blend mode
    canvasFrames[i].imageMode(CENTER); // use image center instead of top left
    canvasFrames[i].pushMatrix(); // remember current drawing matrix
    canvasFrames[i].translate(centerPoint.x, centerPoint.y);
    canvasFrames[i].rotate(rotation);
    canvasFrames[i].scale(flipX, 1);
    canvasFrames[i].image(spriteSet.sprites[(index+i)%spriteSet.length], spriteSet.offsetX * flipX, spriteSet.offsetY);
    //canvasFrames[i].image(previewCanvas, 0, 0);
    canvasFrames[i].popMatrix();
    canvasFrames[i].endDraw();
  }

  if (debugging) drawDebug();

  // https://discourse.processing.org/t/how-do-you-rotate-an-image-without-the-image-being-moved/6579/4
  // https://discourse.processing.org/t/solved-question-about-flipping-images/7391/2
}


/********************************************************
 ***  OVERLAP / COLLISION  ******************************
 *********************************************************/

boolean overlaps(PGraphics canvas, int x, int y)
{
  color mouseColor = canvas.get(x, y);
  return (mouseColor < 0);
}

boolean overlaps(PGraphics canvas)
{
  return overlaps(canvas, mouseX, mouseY);
}

boolean overlaps(PGraphics canvas, PVector v)
{
  return overlaps(canvas, (int)v.x, (int)v.y);
}

float findDistSq(float x1, float y1, float x2, float y2)
{
  float xDist = abs(x1-x2);
  float yDist = abs(y1-y2);
  return (xDist * xDist + yDist * yDist);
}

float findDistSq(PVector v1, PVector v2)
{
  return findDistSq(v1.x, v1.y, v2.y, v2.y);
}

float findDistSq(PVector v)
{
  return findDistSq(mouseX, mouseY, v.x, v.y);
}

float findDistSq(float x, float y)
{
  return findDistSq(mouseX, mouseY, x, y);
}

Block findNearest(ArrayList<Block> blocks)
{
  Block returnBlock = null;
  float distSq = width * width;

  for (Block block : blocks)
  {
    float newDistSq = findDistSq(mouseX, mouseY, block.y, block.y);
    if (newDistSq < distSq)
    {
      distSq = newDistSq;
      returnBlock = block;
    }
  }
  return returnBlock;
}

Block findOverlappingBlock(ArrayList<Block> blocks, float safeZone)
{
  // safeZone is a multiplier to the block's width & height
  for (Block block : blocks)
  {
    float minX = block.x - block.width/scaleFactor * safeZone;
    float maxX = block.x + block.width/scaleFactor * safeZone;
    float minY = block.y - block.height/scaleFactor * safeZone;
    float maxY = block.y + block.height/scaleFactor * safeZone;
    //print ("Block " + i + " x(" + minX + ", " + maxX + "), y(" + minY + ", " + maxY + ") \n");

    if (mouseX > minX && mouseX < maxX && mouseY > minY && mouseY < maxY)
    {
      //print ("Trying to draw within a block \n");
      return block;
    }
  }
  //print ("Not inside a block \n");
  return null;
}


boolean isOverlappingBlocks(ArrayList<Block> blocks, float safeZone)
{
  Block block = findOverlappingBlock(blocks, safeZone);
  if (block == null)
    return false;
  else
    return true;
}



/********************************************************
 ***  RECORDING  *****************************************
 *********************************************************/
void startRecording()
{
  background(255);
  recording = true;
  tempName = nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  String dateTime = nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + "_" + tempName;
  clipFolder = fileName + "-" + dateTime + "/";
  frameIndex = 0;
  //saveFrames(6); // No need for white frames at beginning.
}

void stopRecording()
{
  saveFrames(36);
  recording = false;
  drawUI();
}

void saveImage()
{
  String dateTime = nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  canvasFrames[currentCanvas].save(saveFolder + fileName + "-" + dateTime + saveFormat);
}

void saveFrames(int howManyFrames)
{
  if (!recording) return;

  for (int i=0; i < howManyFrames; i++)
  {
    canvasFrames[frameIndex%3].save(saveFolder + clipFolder + fileName + "_" + tempName + "_" + nf(frameIndex, 4) + saveFormat);
    frameIndex++;
    //saveCanvasNum = frameIndex%3;
    print ("Saved frame" + nf(frameIndex, 4) + "\n");
    print ("saveCanvasNum: " + saveCanvasNum + "\n");
  }
}

/********************************************************
 ***  SETUP  *****************************************
 *********************************************************/

void loadSpriteSets()
{
  armSet = new SpriteSet("arm segment", "arm", 5);
  armbSet = new SpriteSet("armb", "armb", 5);
  blockSet = new SpriteSet("block", "red-block", 3);
  tipBlockSet = new SpriteSet("block", "red-block", 3);
  bigBlockSet = new SpriteSet("big block", "big-block", 1);
  rectSet = new SpriteSet("rect", "red-rect", 4);
  eyeSet = new SpriteSet("eye", "eye", 8);
  //eyeSpriteSet.offsetX = eyeSpriteSet.width/2;

  // Hands
  handRightSet = new SpriteSet("hand", "hand-r", 5);
  handRightSet.offsetX = handRightSet.width/2;
  handLeftSet = new SpriteSet("hand", "hand-l", 5);
  handLeftSet.offsetX = handLeftSet.width/2;
  handSets = new SpriteSet[2];
  handSets[0] = handRightSet;
  handSets[1] = handLeftSet;

  rootSets = new SpriteSet[] {null, blockSet, bigBlockSet, rectSet};
  segmentSets = new SpriteSet[] {null, armSet, armbSet};
  tipSets = new SpriteSet[] {null, handRightSet, eyeSet, tipBlockSet};
  currentRoot = 1;
  currentSegment = 1;
  currentTip = 1;

  // ACTIVE SPRITES
  setSpriteSet(rootSet, rootSets, currentRoot);
  setSpriteSet(segmentSet, segmentSets, currentSegment);
  setSpriteSet(tipSet, tipSets, currentTip);

  for (int i=0; i<handSets.length; i++)
  {
    handSets[i].loadSprites();
  }
}

void setSpriteSet(SpriteSet set, SpriteSet[] sets, int index)
{
  set = sets[index];
  set.loadSprites();
  for (int i=1; i<sets.length; i++)
  {
    if (i!=index)
    {
      sets[i].unloadSprites();
    } else
    {
      sets[i].loadSprites();
    }
  }

  print (set.name + " loaded. \n");
}

void resetArrayLists()
{
  // Reset array lists
  rootBlocks = new ArrayList<Block>();
  segmentBlocks = new ArrayList<Block>();
  tipBlocks = new ArrayList<Block>();
}



/********************************************************
 ***  UTILITY  *****************************************
 *********************************************************/

void resetVectorPoints()
{
  // Reset Vector Points
  lastPoint = new PVector(mouseX, mouseY);
  targetPoint = new PVector (mouseX, mouseY);
  centerPoint = new PVector (mouseX, mouseY);
}

// Find TargetPoint if mouse is far enough from LastPoint
boolean findTargetCenterPoints(float distance)
{
  // Check to see if current x,y is beyond threshold distance away from lastX, lastY
  //if (abs(lastX - mouseX) + abs(lastY - mouseY) < armSegmentDistance) return;

  // find vector from lastXY to mouseXY
  PVector toTarget = new PVector(mouseX - lastPoint.x, mouseY - lastPoint.y);
  if (toTarget.magSq() > sq(distance))
  {
    toTarget.limit(distance/2);
    centerPoint = PVector.add(lastPoint, toTarget);
    targetPoint = PVector.add(centerPoint, toTarget);
    targetAngle = angleLastToTarget();
    return true;
  }
  return false;
  // targetXY is stampLength distance along that vector
}

float angleToMouse(PVector vector)
{
  return atan2(mouseY - vector.y, mouseX - vector.x);
}

float angleLastToTarget()
{
  return atan2(targetPoint.y - lastPoint.y, targetPoint.x - lastPoint.x);
}

float randomRotationNSEW()
{
  // Calculate random NSEW rotation
  float randomRotation = floor(random(4)) * 90; // + random(10) - 5;
  return radians(randomRotation);
  //print ("Random Rotation: " + randomRotation + "\n");
}

int randomSignum() {
  // randomize either -1 or 1
  return (int) random(2) * 2 - 1;
}

void toggleChoosing()
{
  showMenu = !showMenu;
  if (showMenu)
  {
    state = State.CHOOSING;
    print(state);
  } else
  {
    state = State.WAITING;
    print(state);
  }
}

void toggleRecording()
{
  if (!recording)
    startRecording();
  else
    stopRecording();
}

void displayCanvas(int which)
{
  animating = false;
  currentCanvas = which;
}

/********************************************************
 ***  DEBUG & UI  ***************************************
 *********************************************************/

void canvasSetup()
{
  previewCanvas = createGraphics(width, height);
  rootCanvas = createGraphics(width, height);
  segmentCanvas = createGraphics(width, height);
  tipCanvas = createGraphics(width, height);
  debugCanvas = createGraphics(width, height);
  choiceCanvas = createGraphics(width, height-40);
  uiCanvas = createGraphics(1920, 40);

  canvasFrames = new PGraphics[3];
  for (int i=0; i<canvasFrames.length; i++)
  {
    canvasFrames[i] = createGraphics(width, height);
    canvasFrames[i].beginDraw();
    canvasFrames[i].background(255);
    canvasFrames[i].endDraw();
  }

  makeTransparent(rootCanvas);
  makeTransparent(segmentCanvas);
  makeTransparent(tipCanvas);
}

void makeTransparent(PGraphics canvas)
{
  canvas.beginDraw();
  canvas.background(255, 255, 255, 0);
  canvas.endDraw();
}

void drawUI()
{
  float buttonWidth = 100;
  uiCanvas.beginDraw();
  uiCanvas.background(200);
  uiCanvas.rectMode(CORNER);
  uiCanvas.noStroke();
  uiCanvas.fill (255, 0, 0); // RED

  if (recording)
  {
    uiCanvas.rect(200, 0, 100, 40);
    uiCanvas.text("RECORDING", 1500, 25);
  }

  //uiCanvas.fill(128);
  if (showMenu) uiCanvas.rect(0, 0, buttonWidth, 40);
  if (debugging) uiCanvas.rect(300, 0, buttonWidth, 40);
  if (showPreview) uiCanvas.rect(400, 0, buttonWidth, 40);
  if (animating) uiCanvas.rect(700, 0, buttonWidth, 40);
  uiCanvas.rect(uiItems.length*100+currentCanvas*60, 0, 40, 40);
  //if (currentCanvas == 1) uiCanvas.rect(uiItems.length*120+60, 0, 40, 40);
  //if (currentCanvas == 2) uiCanvas.rect(uiItems.length*120+120, 0, 40, 40);

  // Draw Menu Items
  uiCanvas.fill(64); // GRAY
  uiCanvas.textSize(16);
  for (int i=0; i<uiItems.length; i++)
  {
    uiCanvas.text(uiItems[i], i*buttonWidth + 10, 25);
  }

  // Draw "Animating" frames
  for (int i=0; i<3; i++)
  {
    uiCanvas.text(i+1, uiItems.length*buttonWidth + i*60 +10, 25);
  }

  uiCanvas.text("State." + state, buttonWidth*12, 25);
  uiCanvas.endDraw();
  image(uiCanvas, 0, 1040);
}


void menuSetup()
{
  rootButtons = createButtons(rootSets, width/6);
  segmentButtons = createButtons(segmentSets, width/2);
  tipButtons = createButtons(tipSets, width*5/6);
}


Button[] createButtons(SpriteSet[] sets, int x)
{
  int buttonWidth = 200;
  int buttonHeight = 120;
  int buttonVertSpacing = 20;
  x -= buttonWidth/2;

  Button[] buttons = new Button[sets.length];

  for (int i=0; i<buttons.length; i++)
  {
    int y = 200+i*(buttonHeight+buttonVertSpacing);
    PImage image = null;
    String text = "NONE";
    if (sets[i] != null)
    {
      image = sets[i].sprites[0];
      text = sets[i].name;
    }
    buttons[i] = new Button(sets, i, x, y, buttonWidth, buttonHeight, text, image);
    //drawButton(width/6, 200+i*(buttonHeight+buttonVertSpacing), rootSets[i]);
  }

  return buttons;
}

void drawChoice()
{
  int menuTopY = 75;
  int categoryTopY = 150;

  choiceCanvas.beginDraw();
  choiceCanvas.background(255);
  choiceCanvas.fill(255, 0, 0);
  choiceCanvas.textSize(48);
  choiceCanvas.textAlign(CENTER);
  choiceCanvas.text("Choose Stamps", width/2, menuTopY);

  // LEFT -- CENTER PIECES
  choiceCanvas.textSize(36);
  choiceCanvas.text("ROOT", width/6, categoryTopY);
  choiceCanvas.text("SEGMENT", width/2, categoryTopY);
  choiceCanvas.text("TIP", width*5/6, categoryTopY);

  choiceCanvas.noStroke();


  for (Button button : rootButtons)
    button.draw();

  for (Button button : segmentButtons)
    button.draw();

  for (Button button : tipButtons)
    button.draw();

  choiceCanvas.endDraw();
  image(choiceCanvas, 0, 0);

  if (keyPressed)
  {
  }
}

// Make draw method of Button class -- much better
//void drawButton(float buttonX, float buttonY, SpriteSet spriteSet)
//{
//  float buttonWidth = 200;
//  float buttonHeight = 80;
//  float buttonTextSize = 24;
//  //float buttonVertSpacing = 100;
//  color buttonColor = color(160);
//  color buttonSelectedColor = color(255, 0, 0);
//  color buttonTextColor = color(0);


//  if (spriteSet != null)
//  {
//    PImage sprite = spriteSet.sprites[0];
//    choiceCanvas.image(sprite, buttonX - buttonWidth/2, buttonY, buttonWidth, buttonHeight);
//  } else {
//    choiceCanvas.fill(buttonColor); // RED
//    choiceCanvas.rect(buttonX-buttonWidth/2, buttonY, buttonWidth, buttonHeight);
//  }
//  choiceCanvas.fill(buttonTextColor);
//  choiceCanvas.text("NONE", buttonX, buttonY+48);
//}

void drawDebug()
{
  debugCanvas.beginDraw();
  debugCanvas.fill(255, 255, 0);
  debugCanvas.line(lastPoint.x, lastPoint.y, targetPoint.x, targetPoint.y);

  //circle(mouseX, mouseY, 10);

  debugCanvas.fill(255, 0, 0); // Red
  debugCanvas.circle(lastPoint.x, lastPoint.y, 10);
  //circle(targetPoint.x, targetPoint.y, 5);

  debugCanvas.fill(0, 255, 0); // Green
  debugCanvas.circle(centerPoint.x, centerPoint.y, 10);

  debugCanvas.fill(0, 0, 255); // Blue
  debugCanvas.circle(targetPoint.x, targetPoint.y, 10);

  debugCanvas.endDraw();
}




/********************************************************
 ***  CLASSES  *******************************************
 *********************************************************/
class Block
{
  float x, y, width, height, angle;
  int frame;
  PVector beginPoint, endPoint;
  Block(float _x, float _y, float _w, float _h, float _angle, PVector _beginPoint, PVector _endPoint)
  {
    x = _x;
    y = _y;
    width = _w;
    height = _h;
    angle = _angle;
    frame = frameCount;
    beginPoint = _beginPoint;
    endPoint = _endPoint;
    //print ("Block " + redBlocks.size() + ": (" + x + ", " + y + ") \n");
  }
}

class Button
{
  PImage image;
  SpriteSet[] sets;
  int index, x, y, w, h;
  String text;
  color bgColor, selectedColor, textColor, overColor;
  boolean selected;

  Button(SpriteSet[] iSets, int _index, int _x, int _y, int _w, int _h, String _text, PImage _image)
  {
    sets = iSets;
    index = _index;
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    text = _text;
    image = _image;
    bgColor = color(200);
    textColor = color(0);
    selectedColor = color(0);
    overColor = color(255, 0, 0);
    //print ("\n creating button: " + text);
  }

  void draw()
  {
    int margin = 10;
    if (isSelected())
    {
      choiceCanvas.fill(selectedColor);
      choiceCanvas.rect(x-margin, y-margin, w+margin*2, h+margin*2);
    }
    if (isOver())
    {
      choiceCanvas.fill(overColor);
      choiceCanvas.rect(x-margin, y-margin, w+margin*2, h+margin*2);
      if (mousePressed)
      {
        select();
      }
    }
    if (image != null)
    {
      choiceCanvas.image(image, x, y, w, h);
    } else
    {
      choiceCanvas.fill(bgColor); // bg color
      choiceCanvas.rect(x, y, w, h);
    }
    choiceCanvas.fill(bgColor);
    choiceCanvas.rect(x, y+h-margin*3, w, margin*3);
    choiceCanvas.fill(textColor);
    choiceCanvas.text(text, x+w/2, y+h);
  }

  boolean isSelected()
  {
    int checkIndex = -1;
    if (sets == rootSets)
      checkIndex = currentRoot;
    if (sets == segmentSets)
      checkIndex = currentSegment;
    if (sets == tipSets)
      checkIndex = currentTip;

    return (index == checkIndex);
  }

  boolean isOver()
  {
    return (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h);
  }

  void select()
  {
    if (sets == rootSets)
      currentRoot = index;
    if (sets == segmentSets)
      currentSegment = index;
    if (sets == tipSets)
      currentTip = index;
    if (sets[index] != null)
      sets[index].loadSprites();
  }
}

//class ChoiceSprite
//{
//  PImage sprite;
//  SpriteSet spriteSet;
//  SpriteSet category;
//  int x, y, width, height;

//  ChoiceSprite(SpriteSet ispriteSet, SpriteSet icategory)
//  {
//   spriteSet = ispriteSet;
//   sprite = spriteSet[0];
//   category = icategory;
//   width = sprite.width;
//   height = sprite.height;
//  }

//  void setCategory()
//  {
//    category = spriteSet;
//  }
//}

class SpriteSet
{
  PImage[] sprites;
  float offsetX, offsetY;
  int length, width, height;
  String name, fileName;
  SpriteSet(String _name, String _file, int _length)
  {
    length = _length;
    fileName = _file;
    name = _name;
    sprites = new PImage[length];
    loadSprite(0);
    //loadSprites();
    //width = sprites[0].width;
    //height = sprites[0].height;
    offsetX = 0;
    offsetY = 0;
    print("SpriteSet " + name + ": w" + width + ", h " + height + "\n");
  }

  void loadSprites()
  {
    for (int i = 0; i < length; i++)
    {
      if (sprites[i] == null) loadSprite(i);
    }
  }

  void unloadSprites()
  {
    for (int i = 1; i < length; i++)
    {
      sprites[i] = null;
    }
  }

  void loadSprite(int index)
  {
    sprites[index] = loadImage("images/" + fileName + "-" + (index) + ".png");
    if (width == 0)
    {
      width = (int)(sprites[index].width/scaleFactor);
      height = (int)(sprites[index].height/scaleFactor);
    }
    sprites[index].resize (width, height);
  }
}



/*************************************************
 TODO
 [ ] Store Arms in separate ArrayLists within a larger array. ArrayList of ArrayLists, each is a single arm
 [ ] Undo for a specific arm if it sucks?
 [ ] Record animation as data & play it back procedurally
 
 DONE
 [X] AAAAARGH! *** Hand often draws at crazy angle! -- FIXED - it was in the random scale x
 [X] Store rotations in block data
 [X] Store the time in frames in block data
 [X] Random Selection of hands & blocks
 [X] Random flip of hands (right/left)
 [X] Draw circle at each mouse point for Debug
 [X] Draw connecting lines for debug
 [X] More careful rotation/placement of segments? Rotate from back end?
 [X] Determine rotation in its own method before the stamp method
 [X] Very slight random rotation for middle blocks
 [X] Random sprite selection is now in Stamp
 [X] Added 3 frameCanvases for animation
 [X] Stamp to frameCanvas instead of directly to screen
 [X] UI now displays above animated frames
 [X] Updated UI to display active modes, and to hide itself
 [X] Create & implement SpriteSet class
 [X] When Animating -- Print 3 frames for Center & Hand but only 1 for Arm Segment
 [X] Animation - more efficient way to stamp multiple frames
 [X] Fix animation timing - 12 frames at beginning, end, and hand stamp
 [X] For arms, calculate a centerPoint for storage in array
 [X] Added eyes as possible end -- and calculated angle & placement
 [X] Added "name" attribute to spriteSet to help determine placement
 [X] Optimized SpriteSet.loadSprites for later use
 [X] Add beginSpriteSet, segmentSpriteSet, endSpriteSet as references - to prepare for selection menu
 [X] Add choiceCanvas - to contain choices for Begin, Middle, End
 [X] Added State enum to track what the mouse is actually doing
 [X] Renamed Root, Segment, Tip
 [X] Root only stamps when you let go of mouse -- unpredictable positioning otherwise.
 [-] When extending segment, figure out if it's closer to beginning or end -- nope
 [X] Prepare other options for blocks, arms, etc.
 [X] A bunch of methods are modifying lastPoint, centerPoint, targetPoint. Gotta fix that!
 [X] A way to select the type of block, line segment, end
 [X] Detect overlapCanvas based on pixel color -- honestly not quite sure WHY it works to check if color < 0, but OK...
 [X] in IsOverlapping method -- rotate the collision detection in its own matrix? Or just keep a sloppy box collider?
 https://joshuawoehlke.com/detecting-clicks-rotated-rectangles/
 Maybe... if simple xy check shows that it's within w+h of center, then do a more specific check
 b = block;
 if (mouseX > b.x-b.w-b.h && mouseX < b.x+b.w+b.h && etc.) {complexCollisionCheck;}
 
 *************************************************/
