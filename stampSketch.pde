/*********************************************************
 ***  STAMP SKETCH   *************************************
 *********************************************************/

// Variables
float currentX, currentY, lastX, lastY, targetX, targetY, redblockX, redblockY, lastAngle, targetAngle, armSegmentDistance;
ArrayList<Block> rootBlocks, segmentBlocks, tipBlocks;
Block lastRoot, lastSegment, lastTip;
PVector lastPoint, targetPoint, centerPoint;
float scaleFactor = 5; //2.0 - 8.0, default 2.5;

//PImage[] armSprites, handSprites, handLeftSprites, blockSprites, bigBlockSprites;
// ROOTS
SpriteSet blockRedSet, blockBlackSet, blockBlack2Set, bigRedSet, bigBlackSet, rectSet, eyeBlockSet;
int rootFlip = 1;
int tipFlip = 0; // left or right
float rootRotation = 0;

// SEGMENTS
SpriteSet armSet, armbSet, armcSet, armcRedSet, blocksmSet, armRedSet;

// FULL ARMS
SpriteSet longRedSet, longBlackSet, redLineSet, blackLineSet;

// TIPS
SpriteSet handRedLSet, handRedRSet, handBlackLSet, handBlackRSet, tipBlockRedSet, tipBlockBlackSet, eyeSet, swabBlackSet, swabRedSet, tipEyeBlockSet, eyeballSet;

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
boolean hiResEnabled = false;
int frameIndex, currentCanvas, saveCanvasNum;

// Screen Info
boolean recording;
boolean debugging;
boolean animating = true;
boolean showPreview = true;
boolean showMenuBar = true;
boolean showChoiceMenu = false;
boolean allowOverlap = true;
boolean showRootCanvas, showSegmentCanvas, showTipCanvas;

// Canvases
PGraphics previewCanvas, menuBarCanvas, choiceCanvas, debugCanvas, rootCanvas, segmentCanvas, tipCanvas, hiResCanvas, attractCanvas;
PGraphics[] canvasFrames;
int canvasFramesCount = 3; // how many looping canvases? Default = 3
int animationRate = 12;
int animFrameCount;

//Menu Bar
String[] menuBarItems = new String[] {
  "[C]hoose", "[S]ave", "[R]ecording", "[D]ebug", "[P]review", "[M]ouse Auto", 
  "[Z]Cancel", "[X]Erase", "[U]I Toggle", "r[O]ot", "s[E]gment", "[T]ip",
  "[A]nimating", "[1]", "[2]", "[3]"
  };
String[] menuBarMethods = new String[] {
  "toggleChoiceMenu", "saveHiResImage", "toggleRecording", "toggleDebug", "togglePreview", "toggleMouseAuto", 
  "cancel", "eraseScreen", "menuBarToggle", "toggleRootCanvas", "toggleSegmentCanvas", "toggleTipCanvas",
  "toggleAnimating", "showOne", "showTwo", "showThree"
  };
String[] menuBarVars = new String[] {
  "showChoiceMenu", "null", "recording", "debugging", "showPreview", "mouseAutoTip",
  "null", "null", "null", "showRootCanvas", "showSegmentCanvas", "showTipCanvas",
  "animating", "isOneActive", "isTwoActive", "isThreeActive"
  };
  
/*
String[] uiActiveMethods = new String[] {
  "isChooseActive", "isNullActive", "isRecordingActive", "isDebugActive", "isPreviewActive", "isMouseAutoActive",
  "isNullActive", "isNullActive", "isNullActive", "isRootActive", "isSegmentActive", "isTipActive",
  "isAnimatingActive", "isOneActive", "isTwoActive", "isThreeActive"
  };
*/
MenuBarButton[] menuBarButtons;
float menuBarWidth;

StampButton[] rootButtons, segmentButtons, tipButtons;
Heading menuHeading, rootHeading, segmentHeading, tipHeading;
EnterButton enterButton;

// Mouse Auto
boolean mouseAutoTip = true;
boolean autoEyeball = true;
boolean mouseIsPressed;
boolean touchMode = true;

// Attract Mode
float attractModeDelay = 10; // seconds until Attract Mode starts
float attractTimerStart;

// Sound
import processing.sound.*;
SoundFile[] rootSounds;
SoundFile[] segmentSounds;
SoundFile[] tipSounds;
SoundFile rootSound, segmentSound, tipSound;

// Touch
import processing.javafx.*;




// Beads Audio
//import beads.*;
//import java.util.Arrays; 
//AudioContext audioContext;
//SamplePlayer[] rootSounds;
//SamplePlayer[] segmentSounds;
//SamplePlayer[] tipSounds;
//SamplePlayer rootSound, segmentSound, tipSound;
//Gain gain = new Gain(2, 0.5);
//Panner panner = new Panner(0);


// Minim Audio
//import ddf.minim.*;
//import ddf.minim.analysis.*;
//import ddf.minim.effects.*;
//import ddf.minim.signals.*;
//import ddf.minim.spi.*;
//import ddf.minim.ugens.*;
//Minim minim;
//AudioOutput audioOutput;
//AudioPlayer[] rootSounds;
//AudioPlayer[] segmentSounds;
//AudioPlayer[] tipSounds;

// Screen Size
boolean aotm = false;
int w = 1920;
int h = 1080;
int refW = 1920;
int refH = 1080;
float refScale = 1;

// Art on the Marquee
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
  CHOOSING, WAITING, PREVIEWING_ROOT, OVERLAPPING_ROOT, PREVIEWING_TIP, SEGMENTING, PREVIEWING_STRETCHY_SEGMENT, ENDING, ATTRACTING
};
State state = State.ATTRACTING;

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
  size(1920, 1080, FX2D);
  background(255);
  frameRate(60);  
  
  //refScale = refH / displayHeight;
  //scaleFactor *= refScale;

  loadPrefs();
  resetChoices();
  loadSpriteSets();
  resetArrayLists();
  choiceMenuSetup();
  armSegmentDistance = armSet.width * .9; //.8;
  createCanvases();
  soundSetup();
  menuBarSetup();
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
  drawFrame();
  drawAOTM();
  drawMenu();
  drawMenuBar();
  drawPreview();
  drawDebug();
  drawRootCanvas();
  drawSegmentCanvas();
  drawTipCanvas();
  drawAttract();
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
