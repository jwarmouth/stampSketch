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
int handSpritesLength = 10;
String handSpriteName = "hand";

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


// TODO
// [X] Prepare other options for blocks, arms, etc.
// [ ] A way to select the type of block, line segment, end
// [ ] Store Arms in separate ArrayLists within a larger array.
// [ ] Undo for a specific arm if it sucks?
// [ ] Might be able to record & play back the animation itself
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

void setup()
{
  size (1920, 1080);
  background(255);

  loadImages();
  armSegmentDistance = armSprites[0].height * 0.8;

  // Reset array lists
  centerBlocks = new ArrayList<Block>();
  armBlocks = new ArrayList<Block>();

  //drawUI();
}

void draw()
{
  if (mousePressed)
  {
    stampArmSegment();
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
  save(saveFolder + fileName + "-" + dateTime + saveFormat);
}

void saveFrame()
{
  save(saveFolder + clipFolder + fileName + "-" + nf(frameIndex, 4) + saveFormat);
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

  PImage sprite = blockSprites[(int)random(blockSpritesLength)];
  float angle = randomRotation();
  stamp (sprite, angle, 0, 0, randomSignum());
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

  // Stamp Arm Segment with rotation
  PImage sprite = armSprites[(int)random(armSpritesLength)];
  //stamp(sprite, angleToTarget(), 0, -sprite.height/2, 1);
  lastAngle = angleToMouse();
  stamp(sprite, lastAngle, 0, sprite.height/2, 1);

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
  PImage sprite = handSprites[(int)random(handSpritesLength)];
  stamp (sprite, lastAngle, 0, -sprite.height/2.4, 1);

  if (debugging)
  {
    fill(0, 255, 0);
    //circle(mouseX, mouseY, 10);
    circle(targetPoint.x, targetPoint.y, 10);
  }
}


void stamp(PImage stampedImage, float rotation, float offsetX, float offsetY, int flipX)
{
  blendMode(MULTIPLY); // change blend mode
  imageMode(CENTER); // use image center instead of top left
  pushMatrix(); // remember current drawing matrix
  translate(lastPoint.x, lastPoint.y);
  scale(flipX, 1);
  rotate(rotation);
  image(stampedImage, offsetX * flipX, offsetY);
  popMatrix();
  
  if (recording)
  {
    saveFrame();
  }

  if (debugging)
  {
    drawDebug();
  }

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
  fill(64);
  textSize(14);
  text("[S]ave  [R]ecord   [D]ebug   [C]lear", 10, 1070);
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

  blockSprites = new PImage[blockSpritesLength];
  loadSprites(blockSprites, blockSpriteName);
}

void loadSprites(PImage[] array, String fileName)
{
  //array = new PImage[length];
  for (int i = 0; i < array.length; i++)
  {
    array[i] = loadImage("images/" + fileName + "-" + (i+1) + ".png");
    float targetWidth = array[i].width/scaleFactor;
    float targetHeight = array[i].height/scaleFactor;
    array[i].resize ((int)targetWidth, (int)targetHeight);
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
