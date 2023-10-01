/*********************************************************
 ***  SETUP  *********************************************
 *********************************************************/

void loadSpriteSets()
{
  // name, filename, length(how many files)
  // ROOTS
  blockRedSet = new SpriteSet("block r", "red-block", 3, .8);
  blockBlackSet = new SpriteSet("block b", "black-block", 3, .8);
  bigRedSet = new SpriteSet("big red", "big-block", 2, .8);
  bigBlackSet = new SpriteSet("big black", "big-block-black", 2, .8);
  rectSet = new SpriteSet("rect", "red-rect", 4);
  blockBlack2Set = new SpriteSet("block b", "block-b", 5, .9);
  //eyeBlockSet = new SpriteSet("eye block", "eye-block", 5);

  // SEGMENTS
  armSet = new SpriteSet("arm", "arm", 5, .85);
  armRedSet = new SpriteSet("arm r", "arm-red", 5, .9);
  armbSet = new SpriteSet("arm b", "armb", 5, .8);
  armbRedSet = new SpriteSet("arm b red", "armb-red", 5, .8);
  armcSet = new SpriteSet("arm c", "armc", 5, .8);
  armcRedSet = new SpriteSet("arm c red", "armc-red", 5, .8);
  armdSet = new SpriteSet("arm d", "armd", 4, .8);
  armdRedSet = new SpriteSet("arm d red", "armd-red", 4, .8);
  blocksmSet = new SpriteSet("block", "blocksm", 5, .8);
  blocksmRedSet = new SpriteSet("block red", "blocksm-red", 5, .8);

  // SEGMENTS -- STICKY
  /*
  longRedSet = new SpriteSet("long r", "long-r", 5, .85, true);
  longBlackSet = new SpriteSet("long b", "long-b", 5, .85, true);
  redLineSet = new SpriteSet("red line", "red-line", 6, .85, true);
  blackLineSet = new SpriteSet("black line", "black-line", 6, .85, true);
  */

  // TIPS
  // Hand Tips
  handRedRSet = new SpriteSet("hand-red", "hand-red-r", 5);
  handRedLSet = new SpriteSet("hand-red", "hand-red-l", 5);
  handRedSets = new SpriteSet[] {handRedRSet, handRedLSet};

  handBlackRSet = new SpriteSet("hand-black", "hand-black-r", 5);
  handBlackLSet = new SpriteSet("hand-black", "hand-black-l", 5);
  handBlackSets = new SpriteSet[] {handBlackRSet, handBlackLSet};
  
  // Block Tips
  tipBlockRedSet = new SpriteSet("block r", "red-block", 3);
  tipBlockBlackSet = new SpriteSet("block b", "black-block", 3);
  tipEyeBlockSet = new SpriteSet("eye block", "eye-block", 5);
  eyeballSet = new SpriteSet("eyeball", "black-eyeball", 5);
  hornSet = new SpriteSet("horn", "horn", 5);
  hornRedSet = new SpriteSet("horn red", "horn-red", 5);
  //eyeSet = new SpriteSet("eye", "eye", 8);
  //swabBlackSet = new SpriteSet("swab b", "swab", 4);
  //swabRedSet = new SpriteSet("swab r", "swab-red", 4);

  // Full Sets
  rootSets = new SpriteSet[] {null, blockRedSet, blockBlackSet, bigRedSet, bigBlackSet, rectSet, blockBlack2Set};
  segmentSets = new SpriteSet[] {null, armSet, armRedSet, armcSet, armcRedSet, armbSet, armbRedSet, blocksmSet, blocksmRedSet, armdSet, armdRedSet}; //, longRedSet, longBlackSet, redLineSet, blackLineSet};
  tipSets = new SpriteSet[] {null, handRedRSet, handBlackRSet, tipBlockRedSet, tipBlockBlackSet, tipEyeBlockSet, hornSet, hornRedSet};
  //currentRoot = 1;
  //currentSegment = 1;
  //currentTip = 1;

  // ACTIVE SPRITES
  setSpriteSet(rootSet, rootSets, currentRoot);
  setSpriteSet(segmentSet, segmentSets, currentSegment);
  setSpriteSet(tipSet, tipSets, currentTip);
}

void setSpriteSet(SpriteSet set, SpriteSet[] sets, int index)
{
  set = sets[index];
  if (set == null) return;

  set.loadSprites();
  for (int i=1; i<sets.length; i++)
  {
    //if (i!=index)
    //{
    //  sets[i].unloadSprites();
    //} else
    //{
      sets[i].loadSprites();
    //}
  }

  print (set.name + " loaded. \n");
}

void resetChoices()
{
  currentRoot = 1;
  currentSegment = 1;
  currentTip = 1;
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
