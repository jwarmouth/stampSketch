/********************************************************
 ***  SETUP  *****************************************
 *********************************************************/

void loadSpriteSets()
{
  // name, filename, length(how many files)
  // SEGMENTS
  armSet = new SpriteSet("arm segment", "arm", 5, .85);
  armRedSet = new SpriteSet("arm red", "arm-red", 5, .9);
  armbSet = new SpriteSet("arm b", "armb", 5, .8);

  // ROOTS
  blockRedSet = new SpriteSet("red block", "red-block", 3, 1);
  blockBlackSet = new SpriteSet("black block", "black-block", 3, 1);
  bigBlockSet = new SpriteSet("big block", "big-block", 1, 1);
  rectSet = new SpriteSet("rect", "red-rect", 4, 1);

  // TIPS
  tipBlockRedSet = new SpriteSet("red block", "red-block", 3, 1);
  tipBlockBlackSet = new SpriteSet("black block", "black-block", 3, 1);
  eyeSet = new SpriteSet("eye", "eye", 8, 1);

  // Hands
  handRedRSet = new SpriteSet("hand-red", "hand-red-r", 5, 1);
  handRedLSet = new SpriteSet("hand-red", "hand-red-l", 5, 1);
  handRedSets = new SpriteSet[] {handRedRSet, handRedLSet};

  handBlackRSet = new SpriteSet("hand-black", "hand-black-r", 5, 1);
  handBlackLSet = new SpriteSet("hand-black", "hand-black-l", 5, 1);
  handBlackSets = new SpriteSet[] {handBlackRSet, handBlackLSet};

  // Full Sets
  rootSets = new SpriteSet[] {null, blockRedSet, blockBlackSet, bigBlockSet, rectSet};
  segmentSets = new SpriteSet[] {null, armSet, armRedSet, armbSet};
  tipSets = new SpriteSet[] {null, handRedRSet, handBlackRSet, eyeSet, tipBlockRedSet, tipBlockBlackSet};
  currentRoot = 1;
  currentSegment = 1;
  currentTip = 1;

  // ACTIVE SPRITES
  setSpriteSet(rootSet, rootSets, currentRoot);
  setSpriteSet(segmentSet, segmentSets, currentSegment);
  setSpriteSet(tipSet, tipSets, currentTip);
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



void resetArrayLists()
{
  // Reset array lists
  rootBlocks = new ArrayList<Block>();
  segmentBlocks = new ArrayList<Block>();
  tipBlocks = new ArrayList<Block>();
}

void resetVectorPoints()
{
  // Reset Vector Points
  lastPoint = new PVector(mouseX, mouseY);
  targetPoint = new PVector (mouseX, mouseY);
  centerPoint = new PVector (mouseX, mouseY);
}
