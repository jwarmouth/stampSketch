/*********************************************************
 ***  CHOICE MENU  ***************************************
 *********************************************************/

boolean overChoiceMenu()
{
  return (mouseX > cornerW && mouseX < cornerW + choiceW &&
          mouseY > choiceY && mouseY < choiceY + choiceH);
}

void toggleChoiceMenu()
{
  showChoiceMenu = !showChoiceMenu;
  if (showChoiceMenu)
  {
    state = State.CHOOSING;
    //println(state);
  } else
  {
    hideChoiceMenu();
  }
}

void showChoiceMenu()
{
  showChoiceMenu = true;
  state = State.CHOOSING;
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
  int menuY = 40;
  int margin = 20;
  int buttonSize = 80;
  int buttonSpacing = 10;
  int offsetY = 140;

  // create Menu Heading
  //menuHeading = new Heading("Choose Stamps", margin, menuY);
  //menuY += 60;
  

  // create Root menu section
  rootHeading = new Heading("Root", margin, menuY);
  menuY += offsetY;
  rootButtons = createButtonsInRows(rootSets, margin, menuY, buttonSize, buttonSpacing);
  menuY = rootButtons[rootButtons.length - 1].y + offsetY;
  //menuY += nextSectionOffsetY;

  // create Segment menu section
  segmentHeading = new Heading("Segment", margin, menuY);
  menuY += offsetY;
  segmentButtons = createButtonsInRows(segmentSets, margin, menuY, buttonSize, buttonSpacing);
  menuY = segmentButtons[segmentButtons.length - 1].y + offsetY;
  // menuY += nextSectionOffsetY;

  // create Tip menu section
  tipHeading = new Heading("Tip", margin, menuY);
  menuY += offsetY;
  tipButtons = createButtonsInRows(tipSets, margin, menuY, buttonSize, buttonSpacing);
  
  

  // create Enter button
  
  textFont(fjordFont);  
  textSize(48);
  
  int buttonX = margin;
  int buttonW = (int)textWidth("Random");
  randomButton = new TextButton(buttonX, menuY, buttonW, 80, "Random", "randomizeAllStamps");
  buttonX += buttonW + margin;
  buttonW = (int)textWidth("Erase Screen");
  eraseButton = new TextButton(buttonX, menuY, buttonW, 80, "Erase Screen", "eraseScreen");
  buttonX += buttonW + margin;
  buttonW = (int)textWidth("Close");
  closeButton = new TextButton(buttonX, menuY, buttonW, 80, "Close", "hideChoiceMenu");
  //menuY += offsetY;
  
  choiceW = max(rootButtons.length, segmentButtons.length, tipButtons.length) * (buttonSize + buttonSpacing) + margin * 2;
  choiceH = menuY + buttonSize + margin;
  
}

// To replace createButtonsInColumns???
StampButton[] createButtonsInRows(SpriteSet[] sets, int startX, int startY, int buttonSize, int buttonSpacing)
{
  //PImage buttonImage;
  String buttonText;
  int maxWidth = buttonSize;
  int maxHeight = buttonSize;
  int buttonWidth = buttonSize;
  int buttonHeight = buttonSize;
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

    x += buttonWidth + buttonSpacing;
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

void drawChoiceMenu()
{
  //if (!showChoiceMenu) return;
  if (state != State.CHOOSING) return;
  //int menuTopY = 100;
  //int categoryTopY = 150;
  //int currentY = 200;

  choiceCanvas.beginDraw();
  choiceCanvas.background(255, 255, 255, 0);
  choiceCanvas.fill(255, 255, 255, 200);
  choiceCanvas.rect(choiceX, choiceY, choiceW, choiceH, 3);
  
  randomButton.draw();
  eraseButton.draw();
  closeButton.draw();
  
  choiceCanvas.fill(255, 0, 0);
  choiceCanvas.textFont(fjordFont);  
  choiceCanvas.textSize(48);
  choiceCanvas.textAlign(LEFT);
  //choiceCanvas.text("Choose Stamps", width/2, menuTopY);
  //menuHeading.draw();

  // LEFT -- CENTER PIECES
  //choiceCanvas.textAlign(LEFT);
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
  choiceCanvas.textSize(18);

  // DRAW BUTTONS
  for (StampButton button : rootButtons) button.draw();
  for (StampButton button : segmentButtons) button.draw();
  for (StampButton button : tipButtons) button.draw();
  
  choiceCanvas.endDraw();
  image(choiceCanvas, 0,0);

}
