/*********************************************************
 ***  CHOICE MENU  ***************************************
 *********************************************************/

void toggleChoiceMenu()
{
  showChoiceMenu = !showChoiceMenu;
  if (showChoiceMenu)
  {
    state = State.CHOOSING;
    print(state);
  } else
  {
    hideChoiceMenu();
  }
}

void hideChoiceMenu()
{
  showChoiceMenu = false;
  state = State.WAITING;
}

int scaleUI (int input)
{
  float output = input / refScale;
  return (int)output;
}


void choiceMenuSetup()
{
  int menuY = 50;
  int leftMargin = 20;
  int buttonsOffsetY = 160;
  int nextSectionOffsetY = 160;

  // create Menu Heading
  menuHeading = new Heading("Choose Stamps", width/2, menuY);
  menuY += 60;

  // create Root menu section
  rootHeading = new Heading("Root", leftMargin, menuY);
  menuY += buttonsOffsetY;
  rootButtons = createButtonsInRows(rootSets, leftMargin, menuY);
  menuY = rootButtons[rootButtons.length - 1].y + nextSectionOffsetY;
  //menuY += nextSectionOffsetY;

  // create Segment menu section
  segmentHeading = new Heading("Segment", leftMargin, menuY);
  menuY += buttonsOffsetY;
  segmentButtons = createButtonsInRows(segmentSets, leftMargin, menuY);
  menuY = segmentButtons[segmentButtons.length - 1].y + nextSectionOffsetY;
  // menuY += nextSectionOffsetY;

  // create Tip menu section
  tipHeading = new Heading("Tip", leftMargin, menuY);
  menuY += buttonsOffsetY;
  tipButtons = createButtonsInRows(tipSets, leftMargin, menuY);

  // create Enter button
  menuY += 120;
  enterButton = new EnterButton(leftMargin, menuY, 120, 80, "Enter");
  
  // create bottom buttons
  
}

// To replace createButtonsInColumns???
StampButton[] createButtonsInRows(SpriteSet[] sets, int startX, int startY)
{
  //PImage buttonImage;
  String buttonText;
  int maxWidth = 100;
  int maxHeight = 100;
  int buttonWidth = 100;
  int buttonHeight = 100;
  int buttonHorizSpacing = 10;
  int x = startX;
  int y = startY - buttonWidth/2;


  StampButton[] buttons = new StampButton[sets.length];

  for (int i=0; i<buttons.length; i++)
  {
    SpriteSet set = sets[i];

    PImage buttonImage;
    //int y = 200+i*(buttonHeight+buttonVertSpacing);
    if (set != null)
    {

      buttonImage = loadImage("images/" + set.fileName + "-0.png");
      buttonText = sets[i].name;
    } 
    else
    {
      buttonImage = null;
      buttonText = "none";
    }

    // Uh oh, this kinda breaks shit -- it's resizing the actual stamp image, whoops!
    if (buttonImage != null)
    {
      if (buttonImage.width > maxWidth)
      {
        buttonImage.resize(maxWidth, 0);
      }
      if (buttonImage.height > maxHeight)
      {
        buttonImage.resize(0, maxHeight);
      }
      buttonWidth = buttonImage.width;
      buttonHeight = maxHeight;
    }



    buttons[i] = new StampButton(sets, i, x, y-buttonHeight, buttonWidth, buttonHeight, buttonText, buttonImage);

    x += buttonWidth + buttonHorizSpacing;
    if (x + maxWidth > w)
    {
      x = startX;
      y += maxHeight + 20;
    }
    //drawButton(width/6, 200+i*(buttonHeight+buttonVertSpacing), rootSets[i]);
  }

  return buttons;
}


//Button[] createButtonsInColumns(SpriteSet[] sets, int x)
//{
//  int buttonWidth = 200;
//  int buttonHeight = 120;
//  int buttonVertSpacing = 20;
//  x -= buttonWidth/2;

//  Button[] buttons = new Button[sets.length];

//  for (int i=0; i<buttons.length; i++)
//  {
//    int y = 200+i*(buttonHeight+buttonVertSpacing);
//    PImage image = null;
//    String text = "NONE";
//    if (sets[i] != null)
//    {
//      image = sets[i].sprites[0];
//      text = sets[i].name;
//    }
//    buttons[i] = new Button(sets, i, x, y, buttonWidth, buttonHeight, text, image);
//    //drawButton(width/6, 200+i*(buttonHeight+buttonVertSpacing), rootSets[i]);
//  }

//  return buttons;
//}

void drawMenu()
{
  if (!showChoiceMenu)
  {
    return;
  }

  //int menuTopY = 100;
  //int categoryTopY = 150;
  //int currentY = 200;

  choiceCanvas.beginDraw();
  choiceCanvas.background(255);
  choiceCanvas.fill(255, 0, 0);
  choiceCanvas.textSize(48);
  choiceCanvas.textAlign(CENTER);
  //choiceCanvas.text("Choose Stamps", width/2, menuTopY);
  menuHeading.draw();

  // LEFT -- CENTER PIECES
  choiceCanvas.textAlign(LEFT);
  choiceCanvas.textSize(36);

  rootHeading.draw();
  segmentHeading.draw();
  tipHeading.draw();

  //choiceCanvas.text("ROOT", leftMargin, 400);
  //choiceCanvas.text("SEGMENT", leftMargin, 600);
  //choiceCanvas.text("TIP", leftMargin, 800);
  //choiceCanvas.text("ROOT", width/6, categoryTopY);
  //choiceCanvas.text("SEGMENT", width/2, categoryTopY);
  //choiceCanvas.text("TIP", width*5/6, categoryTopY);


  choiceCanvas.textAlign(CENTER);
  choiceCanvas.noStroke();


  choiceCanvas.textSize(20);

  for (StampButton button : rootButtons)
    button.draw();

  for (StampButton button : segmentButtons)
    button.draw();

  for (StampButton button : tipButtons)
    button.draw();

  enterButton.draw();
  choiceCanvas.endDraw();
  image(choiceCanvas, 0, 40, scaleUI(choiceCanvas.width), scaleUI(choiceCanvas.height));


  // Draw preview of root/segment/tip
  previewCanvas.beginDraw();
  previewCanvas.background(255, 255, 255, 0);

  PVector previewMargin = new PVector (50, 50);
  PVector location = new PVector(width - previewMargin.x, height-previewMargin.y); // margin

  SpriteSet set = rootSets[currentRoot];
  if (set != null) {
    location.y -= set.height/2;
    location.x -= set.width/2;
    drawCurrentTools(set, location);
    location.x -= set.width/2;
  }

  set = segmentSets[currentSegment];
  if (set != null) {
    int loops = 3;
    if (set.stretchy) {
      loops = 1;
    }
    for (int i=0; i<loops; i++) {
      location.x -= set.armSegmentDistance/2;
      drawCurrentTools(set, location);
      location.x -= set.armSegmentDistance/2;
    }
  }

  set = tipSets[currentTip];
  if (set != null) {
    if (!set.name.contains("hand")) {
    location.x -= set.width/2;
    }
    drawCurrentTools(set, location);
    //location.y -= set.width/2;
  }


  //for (int i=0; i<sets.length; i++) {
  //  SpriteSet set = sets[i];
  //  if (set != null) {
  //    if (i==0) {
  //      location.x -= set.height/2;
  //    }
  //    location.y -= set.width/2;
  //    //stampToCanvas(choiceCanvas, location, sets[i], 0, 0, 1);
  //    // WTF -- this is causing buttons to shift?
  //    drawCurrentTools(set, location);

  //    location.y -= sets[i].width/2;
  //  }
  //}
 

  previewCanvas.endDraw();


  //image(previewCanvas, 0, 0);
}

void drawCurrentTools(SpriteSet set, PVector location)
{
  PGraphics canvas = previewCanvas;
  canvas.blendMode(MULTIPLY);
  canvas.imageMode(CENTER); // use image center instead of top left
  canvas.pushMatrix(); // remember current drawing matrix
  canvas.translate(location.x, location.y);
  canvas.rotate(radians(180));
  canvas.image(set.sprites[0], set.offsetX, set.offsetY);
  canvas.popMatrix();
}