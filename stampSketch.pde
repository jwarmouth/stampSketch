// Variables
//PImage handImage, blockImage, redBlockImage;
float currentX, currentY, lastX, lastY, targetX, targetY, redblockX, redblockY;
ArrayList<Block> centerBlocks;
ArrayList<Block> armBlocks;
PVector lastPoint, targetPoint;
float scaleFactor = 2.5;
float lastAngle;
float targetAngle;

// Arm Segment Sprites
PImage[] armSprites, handSprites, handLeftSprites, blockSprites, bigBlockSprites;

float armSegmentDistance;
boolean isArmStarted;
//int armSpriteIndex;
//float armBlockDistance;
SpriteSet armSpriteSet, handLeftSpriteSet, handRightSpriteSet, blockSpriteSet, bigBlockSpriteSet;
SpriteSet[] handSpriteSets;

// Save Info
String saveFolder = "saved/";
String clipFolder;
String fileName = "stamp";
String tempName;
String saveFormat = ".png";
int frameIndex;

// Screen Info
boolean recording;
boolean debugging;
boolean animating;

// Canvases
PGraphics previewCanvas, uiCanvas;
PGraphics[] canvasFrames;
int currentCanvas;
int saveCanvasNum;
boolean uiHide;


// TODO
// [X] Prepare other options for blocks, arms, etc.
// [ ] A way to select the type of block, line segment, end
// [ ] Store Arms in separate ArrayLists within a larger array.
// [ ] Undo for a specific arm if it sucks?
// [ ] Record animation as data & play it back procedurally
// [ ] in IsOverlapping method -- rotate the collision detection in its own matrix? Or just keep a sloppy box collider?
// [ ] When Animating -- Print 3 frames for Center & Hand but only 1 for Arm Segment

// DONE
// [X] AAAAARGH! *** Hand often draws at crazy angle! -- FIXED - it was in the random scale x
// [X] Store rotations in block data
// [X] Store the time in frames in block data
// [X] Random Selection of hands & blocks
// [X] Random flip of hands (right/left)
// [X] Draw circle at each mouse point for Debug
// [X] Draw connecting lines for debug
// [X] More careful rotation/placement of segments? Rotate from back end?
// [X] Determine rotation in its own method before the stamp method
// [X] Very slight random rotation for middle blocks
// [X] Random sprite selection is now in Stamp
// [X] Added 3 frameCanvases for animation
// [X] Stamp to frameCanvas instead of directly to screen
// [X] UI now displays above animated frames
// [X] Updated UI to display active modes, and to hide itself
// [X] Create & implement SpriteSet class

void setup()
{
  size (1920, 1080);
  background(255);

  canvasSetup();
  loadSpriteSets();
  armSegmentDistance = armSpriteSet.height * 0.8;

  // Reset array lists
  centerBlocks = new ArrayList<Block>();
  armBlocks = new ArrayList<Block>();
}

void loadSpriteSets()
{
  armSpriteSet = new SpriteSet("block", 5);
  handRightSpriteSet = new SpriteSet("hand-right", 5);
  handLeftSpriteSet = new SpriteSet("hand-left", 5);
  blockSpriteSet = new SpriteSet("red-block", 3);
  bigBlockSpriteSet = new SpriteSet("big-block", 1);
  handSpriteSets = new SpriteSet[2];
  handSpriteSets[0] = handRightSpriteSet;
  handSpriteSets[1] = handLeftSpriteSet;
}

void draw()
{
  if (animating)
  {
    currentCanvas = frameCount/3%3;
  }
  image(canvasFrames[currentCanvas], 0, 0);

  if (!uiHide)
  {
    drawUI();
    image(uiCanvas, 0, 1040);
  }
}

void mousePressed()
{
  resetVectorPoints();
  stampCenterBlock();
  //setLastXY();
}

void mouseReleased()
{
  stampEnd();
}

void mouseDragged()
{
  stampArmSegment();
}

void keyReleased()
{
  if (key == 'R' || key == 'r')
  {
    if (!recording)
    {
      startRecording();
    } else
    {
      stopRecording();
    }
  }

  if (key == 'C' || key == 'c')
  {
    background(255);
    setup();
  }

  if (key=='1' || key=='2' || key=='3')
  {
    animating = false;
    currentCanvas = ((int)key) - 1;
  }

  if (key=='S' || key == 's') saveImage();
  if (key=='D' || key == 'd') debugging = !debugging;
  if (key=='A' || key == 'a') animating = !animating;
  if (key=='H' || key == 'h') uiHide = !uiHide;
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
}

void stopRecording()
{
  recording = false;
  drawUI();
}

void saveImage()
{
  String dateTime = nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  canvasFrames[currentCanvas].save(saveFolder + fileName + "-" + dateTime + saveFormat);
}

void saveFrame(int whichCanvas)
{
  canvasFrames[whichCanvas].save(saveFolder + clipFolder + fileName + "_" + tempName + "_" + nf(frameIndex, 4) + saveFormat);
  frameIndex++;
  saveCanvasNum = frameIndex%3;
  print ("Saved frame" + nf(frameIndex, 4) + "\n");
  print ("saveCanvasNum: " + saveCanvasNum + "\n");
}

/********************************************************
 ***  STAMPING   *****************************************
 *********************************************************/
// Stamp Center Block
void stampCenterBlock()
{
  if (isOverlappingBlocks(centerBlocks, 2)) return;
  if (isOverlappingBlocks(armBlocks, 2)) return;

  float angle = randomRotation();
  stamp (blockSpriteSet, angle, 0, 0, randomSignum(), 3);
  centerBlocks.add(new Block(lastPoint.x, lastPoint.y, blockSpriteSet.width, blockSpriteSet.height, angle));
}

void stampArmSegment()
{
  if (!isArmStarted)
  {
    if (isOverlappingBlocks(centerBlocks, 1)) return;
    lastPoint = new PVector(mouseX, mouseY);
    isArmStarted = true;
    return;
  }

  if (!findTargetPoint()) return;

  lastAngle = angleToMouse();
  stamp(armSpriteSet, lastAngle, 0, armSpriteSet.height/2, 1, 1);
  //stamp(sprite, angleToTarget(), 0, -sprite.height/2, 1);

  // Add new block to blackBlocks ArrayList
  // [] TODO Make ArrayList of ArrayLists, each is a single arm
  armBlocks.add(new Block(lastPoint.x, lastPoint.y, armSegmentDistance, armSegmentDistance, lastAngle));

  lastPoint = targetPoint;
}

void stampEnd()
{
  isArmStarted = false;
  if (isOverlappingBlocks(centerBlocks, 1)) return;
  //if (isOverlappingBlocks(armBlocks, 0.1)) return;

  targetPoint = new PVector (mouseX, mouseY);
  // stamp end (hand) with rotation to mouse
  SpriteSet handSpriteSet = handSpriteSets[(int)random(handSpriteSets.length)];
  stamp (handSpriteSet, lastAngle, 0, -handSpriteSet.height/2.4, 1, 3);

  if (debugging)
  {
    fill(0, 255, 0);
    //circle(mouseX, mouseY, 10);
    circle(targetPoint.x, targetPoint.y, 10);
  }
}

void stamp(SpriteSet spriteSet, float rotation, float offsetX, float offsetY, int flipX, int maxToSave)
{
  int index = (int)random(spriteSet.length);
  int howManySaved = 0;

  for (int i=0; i<3; i++)
  {
    canvasFrames[i].beginDraw();
    canvasFrames[i].blendMode(MULTIPLY); // change blend mode
    canvasFrames[i].imageMode(CENTER); // use image center instead of top left
    canvasFrames[i].pushMatrix(); // remember current drawing matrix
    canvasFrames[i].translate(lastPoint.x, lastPoint.y);
    canvasFrames[i].scale(flipX, 1);
    canvasFrames[i].rotate(rotation);
    canvasFrames[i].image(spriteSet.sprites[(index+i)%spriteSet.length], offsetX * flipX, offsetY);
    //canvas1.image(previewCanvas, 0, 0);
    canvasFrames[i].popMatrix();
    canvasFrames[i].endDraw();

    //if (recording && (animating || i == currentCanvas))
    //{
    //  saveFrame(i);
    //}

    // Save 3 frames for MIDDLE & END but only 1 frame for ARM SEGMENT
    if (recording && howManySaved < maxToSave)
    {
      if (maxToSave == 3 || i == saveCanvasNum)
      {
        saveFrame(i);
        howManySaved ++;
      }
    }
  }

  if (debugging) drawDebug();

  // https://discourse.processing.org/t/how-do-you-rotate-an-image-without-the-image-being-moved/6579/4
  // https://discourse.processing.org/t/solved-question-about-flipping-images/7391/2
}


/********************************************************
 ***  UTILITY  *****************************************
 *********************************************************/

void resetVectorPoints()
{
  // Reset Vector Points
  lastPoint = new PVector(mouseX, mouseY);
  targetPoint = new PVector (mouseX, mouseY);
}

// Find TargetPoint if mouse is far enough from LastPoint
boolean findTargetPoint()
{
  // Check to see if current x,y is beyond threshold distance away from lastX, lastY
  //if (abs(lastX - mouseX) + abs(lastY - mouseY) < armSegmentDistance) return;

  // find vector from lastXY to mouseXY
  PVector toTarget = new PVector(mouseX - lastPoint.x, mouseY - lastPoint.y);
  if (toTarget.magSq() > sq(armSegmentDistance))
  {
    toTarget.setMag(armSegmentDistance);
    targetPoint = lastPoint.add(toTarget);
    //targetAngle = (targetPoint.sub(lastPoint)).heading();
    //targetAngle = PVector.angleBetween(lastPoint, targetPoint);
    targetAngle = atan2(mouseY - lastPoint.y, mouseX - lastPoint.x) + radians(90);
    return true;
  }
  return false;
  // targetXY is stampLength distance along that vector
}

float angleToMouse()
{
  return atan2(mouseY - lastPoint.y, mouseX - lastPoint.x) + radians(90);
}

float angleToTarget()
{
  //return (targetPoint.sub(lastPoint)).heading();
  return atan2(targetPoint.y - lastPoint.y, targetPoint.x - lastPoint.x) + radians(90);
}

float randomRotation()
{
  // Calculate random NSEW rotation
  float randomRotation = floor(random(4)) * 90 + random(10) - 5;
  return radians(randomRotation);
  //print ("Random Rotation: " + randomRotation + "\n");
}

int randomSignum() {
  // randomize either -1 or 1
  return (int) random(2) * 2 - 1;
}


boolean isOverlappingBlocks(ArrayList<Block> blocks, float safeZone)
{
  //print ("Checking for overlapping blocks... \n");
  //print ("Mouse: (" + mouseX + ", " + mouseY + ") \n");
  //https://processing.org/reference/ArrayList.html

  if (blocks.size() == 0)
  {
    //print("No Blocks \n");
    return false; // if no blocks exist, return false
  }

  for (int i = 0; i < blocks.size(); i++)
  {
    Block block = blocks.get(i);
    float minX = block.x - block.width/scaleFactor * safeZone;
    float maxX = block.x + block.width/scaleFactor * safeZone;
    float minY = block.y - block.height/scaleFactor * safeZone;
    float maxY = block.y + block.height/scaleFactor * safeZone;
    //print ("Block " + i + " x(" + minX + ", " + maxX + "), y(" + minY + ", " + maxY + ") \n");

    if (mouseX > minX && mouseX < maxX && mouseY > minY && mouseY < maxY)
    {
      //print ("Trying to draw within a block \n");
      return true;
    }
  }
  //print ("Not inside a block \n");
  return false;
}

/********************************************************
 ***  DEBUG & UI  ***************************************
 *********************************************************/

void drawDebug()
{
  fill(0, 0, 255);
  //circle(mouseX, mouseY, 10);
  circle(lastPoint.x, lastPoint.y, 10);

  fill(255, 0, 0);
  //circle(targetPoint.x, targetPoint.y, 5);
  line(lastPoint.x, lastPoint.y, targetPoint.x, targetPoint.y);
}

void drawUI()
{
  uiCanvas.beginDraw();
  uiCanvas.background(200);
  uiCanvas.rectMode(CORNER);
  uiCanvas.noStroke();
  uiCanvas.fill (255, 0, 0);

  if (recording)
  {
    uiCanvas.rect(100, 0, 100, 40);
    uiCanvas.text("RECORDING", 900, 25);
  }

  //uiCanvas.fill(128);
  if (debugging) uiCanvas.rect(200, 0, 100, 40);
  if (animating) uiCanvas.rect(500, 0, 120, 40);
  if (currentCanvas == 0) uiCanvas.rect(640, 0, 40, 40);
  if (currentCanvas == 1) uiCanvas.rect(690, 0, 40, 40);
  if (currentCanvas == 2) uiCanvas.rect(740, 0, 40, 40);

  uiCanvas.fill(64);
  uiCanvas.textSize(18);
  uiCanvas.text("[S]ave", 10, 25);
  uiCanvas.text("[R]ecord", 110, 25);
  uiCanvas.text("[D]ebug", 210, 25);
  uiCanvas.text("[C]lear", 310, 25);
  uiCanvas.text("[H]ide UI", 410, 25);
  uiCanvas.text("[A]nimating", 510, 25);
  uiCanvas.text("[1]", 650, 25);
  uiCanvas.text("[2]", 700, 25);
  uiCanvas.text("[3]", 750, 25);

  uiCanvas.endDraw();
}


/********************************************************
 ***  LOAD IMAGES  ***************************************
 *********************************************************/
void canvasSetup()
{
  previewCanvas = createGraphics(1920, 1080);
  uiCanvas = createGraphics(1920, 40);

  canvasFrames = new PGraphics[3];
  for (int i=0; i<canvasFrames.length; i++)
  {
    canvasFrames[i] = createGraphics(width, height);
    canvasFrames[i].beginDraw();
    canvasFrames[i].background(255);
    canvasFrames[i].endDraw();
  }
}

/********************************************************
 ***  CLASSES  *******************************************
 *********************************************************/
class Block
{
  float x, y, width, height, angle;
  int frame;
  Block(float inputX, float inputY, float inputW, float inputH, float inputAngle)
  {
    x = inputX;
    y = inputY;
    width = inputW;
    height = inputH;
    angle = inputAngle;
    frame = frameCount;
    //print ("Block " + redBlocks.size() + ": (" + x + ", " + y + ") \n");
  }
}

class SpriteSet
{
  PImage[] sprites;
  float width, height;
  int length;
  String fileName;
  SpriteSet(String inputFilename, int inputLength)
  {
    length = inputLength;
    fileName = inputFilename;
    sprites = new PImage[length];
    //loadSprites(armSprites, armSpriteName);
    for (int i = 0; i < length; i++)
    {
      sprites[i] = loadImage("images/" + fileName + "-" + (i) + ".png");
      float targetWidth = sprites[i].width/scaleFactor;
      float targetHeight = sprites[i].height/scaleFactor;
      sprites[i].resize ((int)targetWidth, (int)targetHeight);
    }
    width = sprites[0].width;
    height = sprites[0].height;
  }
}
