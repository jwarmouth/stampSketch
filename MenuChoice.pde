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


void drawChoiceMenu()
{
  //if (!showChoiceMenu) return;
  if (state != State.CHOOSING) return;

  choiceCanvas.beginDraw();
  choiceCanvas.background(255, 255, 255, 0);
  choiceCanvas.fill(255, 255, 255, 200);
  choiceCanvas.rect(choiceX, choiceY, choiceW, choiceH, 3);

  
  choiceCanvas.fill(255, 0, 0);
  choiceCanvas.textFont(headingFont);
  choiceCanvas.textAlign(LEFT);
  choiceCanvas.textSize(36);

  rootHeading.draw();
  segmentHeading.draw();
  tipHeading.draw();

  choiceCanvas.textAlign(CENTER);
  choiceCanvas.noStroke();
  choiceCanvas.textSize(18);

  // DRAW BUTTONS
  for (StampButton button : rootButtons) button.draw();
  for (StampButton button : segmentButtons) button.draw();
  for (StampButton button : tipButtons) button.draw();
   
  //choiceCanvas.textSize(30);
  randomButton.draw();
  eraseButton.draw();
  closeButton.draw();
  
  choiceCanvas.endDraw();
  image(choiceCanvas, 0,0);

}


void choiceMenuSetup()
{
  int menuY = 40;
  int margin = 20;
  int buttonSize = 80;
  int buttonSpacing = 10;
  int offsetY = 140;

  // create Tip menu section
  tipHeading = new Heading("Tip   Punta", margin, menuY);
  menuY += offsetY;
  tipButtons = createButtonsInRows(tipSets, margin, menuY, buttonSize, buttonSpacing);
  menuY = tipButtons[tipButtons.length - 1].y + offsetY;

  // create Segment menu section
  segmentHeading = new Heading("Segment   Segmento", margin, menuY);
  menuY += offsetY;
  segmentButtons = createButtonsInRows(segmentSets, margin, menuY, buttonSize, buttonSpacing);
  menuY = segmentButtons[segmentButtons.length - 1].y + offsetY;
  
  // create Root menu section
  rootHeading = new Heading("Base   Base", margin, menuY); //"Root   Raíz"
  menuY += offsetY;
  rootButtons = createButtonsInRows(rootSets, margin, menuY, buttonSize, buttonSpacing);

  // create TEXT BUTTONS
  textFont(headingFont);  
  textSize(36);
  int buttonX = margin;
  randomButton = new TextButton(buttonX, menuY, 80, "Azar   Random", "randomizeAllStamps");
  buttonX += randomButton.w + margin;
  eraseButton = new TextButton(buttonX, menuY, 80, "Borrar   Erase", "eraseScreen");
  buttonX += eraseButton.w + margin;
  closeButton = new TextButton(buttonX, menuY, 80, "Cerrar   Close", "hideChoiceMenu");
  
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
