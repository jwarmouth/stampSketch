/*********************************************************
 ***  VARIABLES   ****************************************
 *********************************************************/

// Variables
float currentX, currentY, lastX, lastY, targetX, targetY, redblockX, redblockY, lastAngle, targetAngle, armSegmentDistance;
ArrayList<Block> rootBlocks, segmentBlocks, tipBlocks;
Block lastRoot, lastSegment, lastTip;
PVector lastPoint = new PVector(0, 0);
PVector targetPoint = new PVector(0, 0);
PVector centerPoint = new PVector(0, 0);
PVector eyeballPoint = new PVector(0, 0);
float eyeballX, eyeballY;
float scaleFactor = 7; //2.0 - 8.0, default 2.5;

//PImage[] armSprites, handSprites, handLeftSprites, blockSprites, bigBlockSprites;
// ROOTS
SpriteSet blockRedSet, blockBlackSet, bigRedSet, bigBlackSet, rectSet, rectRedSet, blockBlack2Set, malletRedSet; //eyeBlockSet;
int rootFlip = 1;
int tipFlip = 0; // left or right
float rootRotation = 0;

// SEGMENTS
SpriteSet armSet, armRedSet, armbSet, armbRedSet, armcSet, armcRedSet, blocksmSet, blocksmRedSet, armdSet, armdRedSet;

// FULL ARMS
SpriteSet longRedSet, longBlackSet, redLineSet, blackLineSet;

// TIPS
SpriteSet handRedLSet, handRedRSet, handBlackLSet, handBlackRSet, tipBlockRedSet, tipBlockBlackSet, tipEyeBlockSet, tipEyeBlockBlackSet, eyeballSet, hornSet, hornRedSet;
// , eyeSet, swabBlackSet, swabRedSet

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
boolean showMenuBar = false;
boolean showChoiceMenu = false;
boolean allowOverlap = true;
boolean showRootCanvas, showSegmentCanvas, showTipCanvas;

// Canvases
PGraphics previewCanvas, menuBarCanvas, choiceCanvas, cornerMenuCanvas, debugCanvas, rootCanvas, segmentCanvas, tipCanvas, hiResCanvas, attractCanvas;
PGraphics[] canvasFrames;
int canvasFramesCount = 3; // how many looping canvases? Default = 3
int animationRate = 12;
int animFrameCount;


MenuBarButton[] menuBarButtons;
float menuBarWidth;
int choiceX;
int choiceY;
int choiceW;
int choiceH;

int cornerX;
int cornerY;
int cornerW;
int cornerH;
int cornerOffsetX;
int cornerOffsetY;

StampButton[] rootButtons, segmentButtons, tipButtons;
Heading menuHeading, rootHeading, segmentHeading, tipHeading;
TextButton eraseButton;

// Mouse Auto
boolean mouseAutoTip = true;
boolean autoEyeball = true;
boolean mouseIsPressed;
boolean touchMode = true;

// Attract Mode
float attractModeDelay; // seconds until Attract Mode starts
float attractTimerStart;

// Sound
boolean soundEnabled = true;
import processing.sound.*;
SoundFile[] rootSounds;
SoundFile[] segmentSounds;
SoundFile[] tipSounds;
SoundFile rootSound, segmentSound, tipSound;


// Font
PFont fjordFont, frescoFont;


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
  CHOOSING, WAITING, PREVIEWING_ROOT, OVERLAPPING_ROOT, PREVIEWING_TIP, SEGMENTING, 
  PREVIEWING_STRETCHY_SEGMENT, ENDING, ATTRACTING, DRAGGING
};
State state = State.ATTRACTING;
