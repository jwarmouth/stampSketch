// Variables
//PImage handImage, blockImage, redBlockImage;
float currentX, currentY, lastX, lastY, targetX, targetY, redblockX, redblockY;
ArrayList<Block> rootBlocks;
ArrayList<Block> segmentBlocks;
ArrayList<Block> tipBlocks;
Block lastRoot, lastSegment, lastTip;
PVector lastPoint, targetPoint, centerPoint;
float scaleFactor = 2.5;
float lastAngle;
float targetAngle;

// Arm Segment Sprites
PImage[] armSprites, handSprites, handLeftSprites, blockSprites, bigBlockSprites;

float armSegmentDistance;
//boolean isArmStarted;
//int armSpriteIndex;
//float armBlockDistance;
SpriteSet armSpriteSet, handLeftSpriteSet, handRightSpriteSet, blockSpriteSet, bigBlockSpriteSet, eyeSpriteSet, rootSpriteSet, segmentSpriteSet, tipSpriteSet;
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
boolean showUI = true;
boolean showChoice;
boolean showPreview;

// Canvases
PGraphics previewCanvas, uiCanvas, choiceCanvas, debugCanvas, rootCanvas, segmentCanvas, tipCanvas;
PGraphics[] canvasFrames;
int currentCanvas;
int saveCanvasNum;
//boolean uiHide;

//UI
String[] uiItems = new String[] {"[C]hoose", "[S]ave", "[R]ecord", "[D]ebug", "[P]review", "[X]Clear", "[U]I Toggle", "[A]nimating"};
//ChoiceSprite[] choiceBeginSprites = new ChoiceSprite[2];
//ChoiceSprite[] choiceSegmentSprites = new ChoiceSprite[2];
//ChoiceSprite[] choiceEndSprites = new ChoiceSprite[2];

enum State {
  CHOOSING, WAITING, WAITING_TO_ROOT, WAITING_TO_SEGMENT, SEGMENTING, ENDING
};
State state = State.WAITING;


/*************************************************
 TODO
 
 [X] Prepare other options for blocks, arms, etc.
 [ ] A way to select the type of block, line segment, end
 [ ] Store Arms in separate ArrayLists within a larger array. ArrayList of ArrayLists, each is a single arm
 [ ] Undo for a specific arm if it sucks?
 [ ] Record animation as data & play it back procedurally
 [ ] in IsOverlapping method -- rotate the collision detection in its own matrix? Or just keep a sloppy box collider?
 https://joshuawoehlke.com/detecting-clicks-rotated-rectangles/
 Maybe... if simple xy check shows that it's within w+h of center, then do a more specific check
 b = block;
 if (mouseX > b.x-b.w-b.h && mouseX < b.x+b.w+b.h && etc.) {complexCollisionCheck;}
 
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
 [X] Detect overlapCanvas based on pixel color -- honestly not quite sure WHY it works to check if color < 0, but OK...
 [X] Renamed Root, Segment, Tip
 [X] Root only stamps when you let go of mouse -- unpredictable positioning otherwise.
 
 *************************************************/

void setup()
{
  size (1920, 1080);
  background(255);

  canvasSetup();
  loadSpriteSets();
  armSegmentDistance = armSpriteSet.width * 0.8;

  // Reset array lists
  rootBlocks = new ArrayList<Block>();
  segmentBlocks = new ArrayList<Block>();
  tipBlocks = new ArrayList<Block>();
}

void loadSpriteSets()
{
  armSpriteSet = new SpriteSet("arm", 5);
  blockSpriteSet = new SpriteSet("red-block", 3);
  bigBlockSpriteSet = new SpriteSet("big-block", 1);
  eyeSpriteSet = new SpriteSet("eye", 8);
  //eyeSpriteSet.offsetY = eyeSpriteSet.height/2;

  // Hands
  handRightSpriteSet = new SpriteSet("hand-r", 5);
  handRightSpriteSet.offsetX = handRightSpriteSet.width/2;
  handRightSpriteSet.name = "hand";
  handLeftSpriteSet = new SpriteSet("hand-l", 5);
  handLeftSpriteSet.offsetX = handLeftSpriteSet.width/2;
  handLeftSpriteSet.name = "hand";
  handSpriteSets = new SpriteSet[2];
  handSpriteSets[0] = handRightSpriteSet;
  handSpriteSets[1] = handLeftSpriteSet;

  // ACTIVE SPRITES
  rootSpriteSet = bigBlockSpriteSet;
  rootSpriteSet.loadSprites();

  segmentSpriteSet = armSpriteSet;
  segmentSpriteSet.loadSprites();

  tipSpriteSet = eyeSpriteSet;
  tipSpriteSet.loadSprites();

  for (int i=0; i<handSpriteSets.length; i++)
  {
    handSpriteSets[i].loadSprites();
  }
}

void draw()
{
  if (animating) currentCanvas = frameCount/3%3;
  image(canvasFrames[currentCanvas], 0, 0);

  if (showUI) drawUI();
  if (debugging) image(debugCanvas, 0, 0);
  if (showPreview) image(previewCanvas, 0, 0);
  if (showChoice) drawChoice();

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

    // IF we click on an existing CENTER block, then move directly into WAITING_TO_SEGMENT
    if (overlaps(rootCanvas))
    {
      //lastRoot = findOverlappingBlock(rootBlocks, 1);
      lastRoot = findNearest(rootBlocks);
      if (lastRoot != null)
      {
        lastPoint = new PVector (lastRoot.x, lastRoot.y);
        state = State.WAITING_TO_SEGMENT;
      }

      return;
    } else if (overlaps(segmentCanvas))
    {
      lastSegment = findNearest(segmentBlocks);

      if (lastSegment != null)
      {
        // Better if it could figure out the angle, and base position on first or last point?????
        lastPoint = lastSegment.nextPoint; // set LAST POINT to the center of that block?
        state = State.SEGMENTING;
        return;
      }
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

    // Getting unexpected location of targetPoint, so now we just wait until mouseReleased to stamp Root
    //case WAITING_TO_ROOT:
    //  // LOGIC -- if we're dragging the center piece, then maybe we should ?

    //  if (findTargetPoint(rootSpriteSet.width/2))
    //  {
    //    // BETTER METHOD FOR THIS -- use pixel check on canvases :)
    //    //if (!isOverlappingBlocks(rootBlocks, 1) && !isOverlappingBlocks(segmentBlocks, 1))
    //    if (!overlaps(rootCanvas))
    //    {
    //      stampRoot();
    //      state = State.WAITING_TO_SEGMENT;
    //    }
    //  }
    //  break;

  case WAITING_TO_SEGMENT:
    // UPDATE -- First Segment shouldn't be drawn until mouse is outside all blocks. And that will be the lastPoint...

    if (!overlaps(rootCanvas))
    {
      // You could have it start a TEENY bit back toward the center to be a bit cleaner, but this is pretty dang close!
      targetPoint = new PVector(mouseX, mouseY);
      PVector toCenter = PVector.sub(lastPoint, targetPoint);
      toCenter.limit(5);
      lastPoint = PVector.add(targetPoint, toCenter); 
      lastAngle = angleToMouse();
      state = State.SEGMENTING;
    }

    //// for FIRST SEGMENT, lastPoint based on lastCenterBlock -- from center to mouse, calc lastPoint
    ////lastPoint = new PVector (lastCenterBlock.x, lastCenterBlock.y);
    ////lastAngle = angleToMouse();

    //PVector toTarget = new PVector(mouseX - lastPoint.x, mouseY - lastPoint.y);

    //// if mouse is far enough from block //
    ////float blockWidthSq = lastCenterBlock.width/2 * lastCenterBlock.width/2;
    ////float armDistSq = armSegmentDistance * armSegmentDistance;
    ////if (toTarget.magSq() > blockWidthSq + armDistSq)
    //Block block = lastRoot;
    //float minX = block.x - block.width/2;
    //float maxX = block.x + block.width/2;
    //float minY = block.y - block.height/2;
    //float maxY = block.y + block.height/2;

    //if (mouseX > minX && mouseX < maxX && mouseY > minY && mouseY < maxY)
    //{
    //  return;
    //} else
    //{
    //  toTarget.limit(rootSpriteSet.width/2);
    //  targetPoint = PVector.add(lastPoint, toTarget);
    //  lastRoot.nextPoint = targetPoint;
    //  lastPoint = lastRoot.nextPoint;
    //  state = State.SEGMENTING;
    //}

    break;

  case SEGMENTING:
    //if (!isOverlappingBlocks(rootBlocks, 1))// && findOverlappingBlock(armBlocks, 2) == null)
    if (!overlaps(rootCanvas))
      lastAngle = angleToMouse();
    stampSegment();
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
    //if (!isOverlappingBlocks(rootBlocks, 2) && !isOverlappingBlocks(segmentBlocks, 2))
    if (!overlaps(rootCanvas) && !overlaps(segmentCanvas))
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
  //if (isOverlappingBlocks(centerBlocks, 2)) return;
  //if (isOverlappingBlocks(armBlocks, 2)) return;
  float angle = angleToMouse();

  stamp (rootSpriteSet, angle, randomSignum());
  previewTo(rootCanvas);

  lastRoot = new Block(lastPoint.x, lastPoint.y, rootSpriteSet.width, rootSpriteSet.height, angle + randomRotation(), targetPoint);
  rootBlocks.add(lastRoot);

  saveFrames(12);
}

void stampSegment()
{
  if (!findTargetPoint(armSegmentDistance)) return;
  stamp(segmentSpriteSet, lastAngle, 1);
  previewTo(segmentCanvas);
  lastSegment = new Block(centerPoint.x, centerPoint.y, armSegmentDistance, armSegmentDistance, lastAngle, targetPoint);
  segmentBlocks.add(lastSegment);

  lastPoint = targetPoint;

  saveFrames(1);
}

void stampTip()
{
  // REPLACE WITH BETTER VERSION
  if (isOverlappingBlocks(rootBlocks, 1)) return;
  if (isOverlappingBlocks(segmentBlocks, 1)) return;

  saveFrames(1); // Extra delay before drawing tip -- could be 2 for that "pop"

  targetPoint = new PVector (mouseX, mouseY);
  // stamp end with rotation to mouse
  float stampAngle = angleToMouse();
  float centerAngle = lastAngle;

  switch(tipSpriteSet.name)
  {
  case "eye":
    centerPoint = lastPoint.add(PVector.mult(PVector.fromAngle(centerAngle), tipSpriteSet.width/2)); // push centerPoint forward if using Eyeball
    break;

  case "hand":
    // Left Hand or Right Hand?
    tipSpriteSet = handSpriteSets[(int)random(handSpriteSets.length)];
    centerPoint = lastPoint.add(PVector.fromAngle(centerAngle, targetPoint));
    break;
  }

  stamp (tipSpriteSet, stampAngle, 1);
  previewTo(tipCanvas);
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
  int index = (int)random(spriteSet.length);
  //int howManySaved = 0;

  // Draw to previewCanvas
  previewCanvas.beginDraw();
  previewCanvas.clear();
  //previewCanvas.blendMode(MULTIPLY);
  previewCanvas.imageMode(CENTER); // use image center instead of top left
  previewCanvas.pushMatrix(); // remember current drawing matrix
  previewCanvas.translate(centerPoint.x, centerPoint.y);
  previewCanvas.scale(flipX, 1);
  previewCanvas.rotate(rotation);
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
    canvasFrames[i].scale(flipX, 1);
    canvasFrames[i].rotate(rotation);
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

boolean overlaps(PGraphics canvas)
{
  //canvas.loadPixels();
  //color mouseColor = canvas.pixels[mouseY*width+mouseX]; //
  //PImage img = createImage(width, height, ARGB);
  //PImage img = canvas;
  color mouseColor = canvas.get(mouseX, mouseY);
  //print ("color: " + mouseColor + "\n");
  boolean overlapping = mouseColor < 0;
  //print (overlapping + "\n");
  return overlapping;
  //return mouseColor > 128;
}

Block findNearest(ArrayList<Block> blocks)
{
  //if (blocks.size() == 0)
  //{
  //  //print("No Blocks \n");
  //  return null; // if no blocks exist, return null
  //}

  Block returnBlock = null;
  float distSq = width * width;

  for (int i = 0; i < blocks.size(); i++)
  {
    Block block = blocks.get(i);
    // Calculate DistSq X2 + Y2
    float xDist = abs(mouseX - block.x);
    float yDist = abs(mouseY - block.y);
    float newDistSq =  xDist * xDist + yDist * yDist;
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
  //print ("Checking for overlapping blocks... \n");
  //print ("Mouse: (" + mouseX + ", " + mouseY + ") \n");
  //https://processing.org/reference/ArrayList.html

  if (blocks.size() == 0)
  {
    //print("No Blocks \n");
    return null; // if no blocks exist, return null
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
boolean findTargetPoint(float distance)
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

    //toTarget.setMag(armSegmentDistance);
    //targetPoint = lastPoint.add(toTarget);
    //toTarget.limit(armSegmentDistance/2);
    //centerPoint = lastPoint.add(toTarget);

    //targetAngle = (targetPoint.sub(lastPoint)).heading();
    //targetAngle = PVector.angleBetween(lastPoint, targetPoint);
    targetAngle = angleToTarget();
    return true;
  }
  return false;
  // targetXY is stampLength distance along that vector
}

float angleToMouse()
{
  //return atan2(mouseY - lastPoint.y, mouseX - lastPoint.x) + radians(90);
  return atan2(mouseY - lastPoint.y, mouseX - lastPoint.x);
}

float angleToTarget()
{
  //return (targetPoint.sub(lastPoint)).heading();
  //return atan2(targetPoint.y - lastPoint.y, targetPoint.x - lastPoint.x) + radians(90);
  return atan2(targetPoint.y - lastPoint.y, targetPoint.x - lastPoint.x);
}

float randomRotation()
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
  showChoice = !showChoice;
  if (showChoice)
  {
    //prevState = state;
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
  uiCanvas.beginDraw();
  uiCanvas.background(200);
  uiCanvas.rectMode(CORNER);
  uiCanvas.noStroke();
  uiCanvas.fill (255, 0, 0); // RED

  if (recording)
  {
    uiCanvas.rect(100, 0, 100, 40);
    uiCanvas.text("RECORDING", 900, 25);
  }

  //uiCanvas.fill(128);
  if (showChoice) uiCanvas.rect(0, 0, 120, 40);
  if (debugging) uiCanvas.rect(3*100, 0, 120, 40);
  if (animating) uiCanvas.rect(7*100, 0, 120, 40);
  uiCanvas.rect(uiItems.length*120+currentCanvas*60, 0, 40, 40);
  //if (currentCanvas == 1) uiCanvas.rect(uiItems.length*120+60, 0, 40, 40);
  //if (currentCanvas == 2) uiCanvas.rect(uiItems.length*120+120, 0, 40, 40);

  // Draw Menu Items
  uiCanvas.fill(64); // GRAY
  uiCanvas.textSize(18);
  for (int i=0; i<uiItems.length; i++)
  {
    uiCanvas.text(uiItems[i], i*110+10, 25);
  }

  // Draw "Animating" frames
  for (int i=0; i<3; i++)
  {
    uiCanvas.text(i+1, uiItems.length*120+i*85+10, 25);
  }

  uiCanvas.text("State." + state, 1200, 25);
  uiCanvas.endDraw();
  image(uiCanvas, 0, 1040);
}

//void choiceSetup()
//{
//  //choiceBeginSprites = new ChoiceSprite[3];
//  choiceBeginSprites[0] = new ChoiceSprite(blockSpriteSet, beginSpriteSet);
//  choiceBeginSprites[1] = new ChoiceSprite(bigBlockSpriteSet, beginSpriteSet);
//}

void drawChoice()
{
  choiceCanvas.beginDraw();
  choiceCanvas.background(255);
  choiceCanvas.fill(255, 0, 0);
  choiceCanvas.textSize(48);
  choiceCanvas.textAlign(CENTER);
  choiceCanvas.text("Choose Stamps", width/2, 50);

  // LEFT -- CENTER PIECES
  choiceCanvas.textSize(36);
  choiceCanvas.text("Center", 300, 100);
  choiceCanvas.fill(0); // RED
  choiceCanvas.rect(100, 150, 400, 100);
  choiceCanvas.fill(255);
  choiceCanvas.text("NONE", 300, 200);
  //PImage[] centerSprites = blockSpriteSet.sprites[0];
  //choiceCanvas.image(sprite, 300 - sprite.width/2, 300, sprite.width, sprite.height);
  //sprite = blockSpriteSet.sprites[0];

  //choiceCanvas.image(sprite, 300 - sprite.width/2, 300, sprite.width, sprite.height);

  // ARM SEGMENT
  choiceCanvas.text("Arm Segment", width/2, 200);

  // END PIECES
  choiceCanvas.text("End", width*5/6, 200);

  choiceCanvas.endDraw();
  image(choiceCanvas, 0, 0);
}

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
  PVector nextPoint;
  Block(float inputX, float inputY, float inputW, float inputH, float inputAngle, PVector lastPoint)
  {
    x = inputX;
    y = inputY;
    width = inputW;
    height = inputH;
    angle = inputAngle;
    frame = frameCount;
    nextPoint = lastPoint;
    //print ("Block " + redBlocks.size() + ": (" + x + ", " + y + ") \n");
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
  SpriteSet(String inputName, int inputLength)
  {
    length = inputLength;
    fileName = inputName;
    name = fileName;
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
