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
PImage[] handSprites;
int handSpritesLength = 5;
String handSpriteName = "hand-right";

// Arm Segment Sprites
PImage[] handLeftSprites;
int handLeftSpritesLength = 5;
String handLeftSpriteName = "hand-left";

// Block Sprites
PImage[] blockSprites;
int blockSpritesLength = 3;
String blockSpriteName = "red-block";

// Arm Segment Sprites
PImage[] armSprites;
int armSpritesLength = 5;
String armSpriteName = "block";
float armSegmentDistance;
boolean isArmStarted;
//int armSpriteIndex;
//float armBlockDistance;

// Save Info
String saveFolder = "saved/";
String clipFolder;
String fileName = "stamp";
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
boolean uiHide;


// TODO
// [X] Prepare other options for blocks, arms, etc.
// [ ] A way to select the type of block, line segment, end
// [ ] Store Arms in separate ArrayLists within a larger array.
// [ ] Undo for a specific arm if it sucks?
// [ ] Record animation as data & play it back procedurally
// [ ] in IsOverlapping method -- rotate the collision detection in its own matrix? Or just keep a sloppy box collider?

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

void setup()
{
  size (1920, 1080);
  background(255);

  loadImages();
  armSegmentDistance = armSprites[0].height * 0.8;

  // Reset array lists
  centerBlocks = new ArrayList<Block>();
  armBlocks = new ArrayList<Block>();

  canvasSetup();
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

  //if (mousePressed)
  //{
  //}
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

  if (key=='S' || key == 's')
  {
    saveImage();
  }

  if (key=='D' || key == 'd')
  {
    debugging = !debugging;
  }

  if (key=='A' || key == 'a')
  {
    animating = !animating;
  }

  if (key=='H' || key == 'h')
  {
    uiHide = !uiHide;
  }

  if (key=='2')
  {
    animating = false;
    currentCanvas = 1;
  }

  if (key=='3')
  {
    animating = false;
    currentCanvas = 2;
  }

  if (key=='1')
  {
    animating = false;
    currentCanvas = 0;
  }
}



/********************************************************
 ***  RECORDING  *****************************************
 *********************************************************/
void startRecording()
{
  background(255);
  recording = true;
  String dateTime = nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + nf(hour(), 2) + "-" + nf(minute(), 2) + nf(second(), 2);
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
  canvasFrames[whichCanvas].save(saveFolder + clipFolder + fileName + "-" + nf(frameIndex, 4) + saveFormat);
  frameIndex++;
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
  PImage sprite = blockSprites[0];
  stamp (blockSprites, angle, 0, 0, randomSignum());
  centerBlocks.add(new Block(lastPoint.x, lastPoint.y, sprite.width, sprite.height, angle));
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
  PImage sprite = armSprites[0];
  stamp(armSprites, lastAngle, 0, sprite.height/2, 1);
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
  PImage sprite = handSprites[0];
  stamp (handSprites, lastAngle, 0, -sprite.height/2.4, 1);

  if (debugging)
  {
    fill(0, 255, 0);
    //circle(mouseX, mouseY, 10);
    circle(targetPoint.x, targetPoint.y, 10);
  }
}


void stamp(PImage[] spriteSheet, float rotation, float offsetX, float offsetY, int flipX)
{
  //int max = ;
  int index = (int)random(spriteSheet.length);
  //PImage stampedImage = spriteSheet[index];

  // STAMP ONTO CANVAS
  //previewCanvas.beginDraw();
  ////background(255);
  //previewCanvas.blendMode(MULTIPLY); // change blend mode
  //previewCanvas.imageMode(CENTER); // use image center instead of top left
  //previewCanvas.pushMatrix(); // remember current drawing matrix
  //previewCanvas.translate(lastPoint.x, lastPoint.y);
  //previewCanvas.scale(flipX, 1);
  //previewCanvas.rotate(rotation);
  //previewCanvas.image(stampedImage, offsetX * flipX, offsetY);
  //previewCanvas.popMatrix();
  //previewCanvas.endDraw();

  for (int i=0; i<3; i++)
  {
    stampToCanvas(i, index, spriteSheet, rotation, offsetX, offsetY, flipX);

    if (recording && (animating || i == currentCanvas))
    {
      saveFrame(i);
    }
  }

  // STAMP DIRECTLY ONTO WINDOW
  //blendMode(MULTIPLY); // change blend mode
  //imageMode(CENTER); // use image center instead of top left
  //pushMatrix(); // remember current drawing matrix
  //translate(lastPoint.x, lastPoint.y);
  //scale(flipX, 1);
  //rotate(rotation);
  //image(stampedImage, offsetX * flipX, offsetY);
  //popMatrix();

  //if (recording)
  //{
  //  saveFrame();
  //}

  if (debugging)
  {
    drawDebug();
  }

  // https://discourse.processing.org/t/how-do-you-rotate-an-image-without-the-image-being-moved/6579/4
  // https://discourse.processing.org/t/solved-question-about-flipping-images/7391/2
}

void stampToCanvas(int whichCanvas, int index, PImage[] spriteSheet, float rotation, float offsetX, float offsetY, int flipX)
{
  canvasFrames[whichCanvas].beginDraw();
  canvasFrames[whichCanvas].blendMode(MULTIPLY); // change blend mode
  canvasFrames[whichCanvas].imageMode(CENTER); // use image center instead of top left
  canvasFrames[whichCanvas].pushMatrix(); // remember current drawing matrix
  canvasFrames[whichCanvas].translate(lastPoint.x, lastPoint.y);
  canvasFrames[whichCanvas].scale(flipX, 1);
  canvasFrames[whichCanvas].rotate(rotation);
  canvasFrames[whichCanvas].image(spriteSheet[(index+whichCanvas)%spriteSheet.length], offsetX * flipX, offsetY);
  //canvas1.image(previewCanvas, 0, 0);
  canvasFrames[whichCanvas].popMatrix();
  canvasFrames[whichCanvas].endDraw();
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


  uiCanvas.fill(128);

  if (debugging)
  {
    uiCanvas.rect(200, 0, 100, 40);
  }

  if (animating)
  {
    uiCanvas.rect(500, 0, 120, 40);
  }

  if (currentCanvas == 0)
  {
    uiCanvas.rect(640, 0, 40, 40);
  }

  if (currentCanvas == 1)
  {
    uiCanvas.rect(690, 0, 40, 40);
  }

  if (currentCanvas == 2)
  {
    uiCanvas.rect(740, 0, 40, 40);
  }


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
void loadImages()
{
  armSprites = new PImage[armSpritesLength];
  loadSprites(armSprites, armSpriteName);

  handSprites = new PImage[handSpritesLength];
  loadSprites(handSprites, handSpriteName);

  handLeftSprites = new PImage[handLeftSpritesLength];
  loadSprites(handLeftSprites, handLeftSpriteName);

  blockSprites = new PImage[blockSpritesLength];
  loadSprites(blockSprites, blockSpriteName);
}

void loadSprites(PImage[] array, String fileName)
{
  //array = new PImage[length];
  for (int i = 0; i < array.length; i++)
  {
    array[i] = loadImage("images/" + fileName + "-" + (i) + ".png");
    float targetWidth = array[i].width/scaleFactor;
    float targetHeight = array[i].height/scaleFactor;
    array[i].resize ((int)targetWidth, (int)targetHeight);
  }
}

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
  //canvas1 = createGraphics(1920, 1080);
  //canvas1 = createGraphics(1920, 1080);
  //canvas1 = createGraphics(1920, 1080);
  //canvas1.beginDraw();
  //canvas1.background(255);
  //canvas1.endDraw();
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
