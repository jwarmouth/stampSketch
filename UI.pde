/********************************************************
 ***  MENU, UI & DEBUG  **********************************
 *********************************************************/

void toggleMenu()
{
  showMenu = !showMenu;
  if (showMenu)
  {
    state = State.CHOOSING;
    print(state);
  } else
  {
    state = State.WAITING;
    print(state);
  }
}


void menuSetup()
{
  rootButtons = createButtonsInRows(rootSets, 400);
  segmentButtons = createButtonsInRows(segmentSets, 600);
  tipButtons = createButtonsInRows(tipSets, 800);
  //okButton = new Button();
}

// To replace createButtonsInColumns???
Button[] createButtonsInRows(SpriteSet[] sets, int y)
{
  int buttonWidth = 200;
  int buttonHeight = 120;
  int buttonHorizSpacing = 20;
  y -= buttonWidth/2;

  Button[] buttons = new Button[sets.length];

  for (int i=0; i<buttons.length; i++)
  {
    int x = 200+i*(buttonWidth+buttonHorizSpacing);
    //int y = 200+i*(buttonHeight+buttonVertSpacing);
    PImage image = null;
    String text = "NONE";
    if (sets[i] != null)
    {
      image = sets[i].sprites[0];
      text = sets[i].name;
    }
    buttons[i] = new Button(sets, i, x, y, buttonWidth, buttonHeight, text, image);
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
  if (!showMenu)
  {
    return;
  }
  
  int menuTopY = 75;
  //int categoryTopY = 150;
  int leftMargin = 20;
  //int currentY = 200;

  choiceCanvas.beginDraw();
  choiceCanvas.background(255);
  choiceCanvas.fill(255, 0, 0);
  choiceCanvas.textSize(48);
  choiceCanvas.textAlign(CENTER);
  choiceCanvas.text("Choose Stamps", width/2, menuTopY);

  // LEFT -- CENTER PIECES
  choiceCanvas.textAlign(LEFT);
  choiceCanvas.textSize(36);
  choiceCanvas.text("ROOT", leftMargin, 400);
  choiceCanvas.text("SEGMENT", leftMargin, 600);
  choiceCanvas.text("TIP", leftMargin, 800);
  //choiceCanvas.text("ROOT", width/6, categoryTopY);
  //choiceCanvas.text("SEGMENT", width/2, categoryTopY);
  //choiceCanvas.text("TIP", width*5/6, categoryTopY);

  
  choiceCanvas.textAlign(CENTER);
  choiceCanvas.noStroke();

  for (Button button : rootButtons)
    button.draw();

  for (Button button : segmentButtons)
    button.draw();

  for (Button button : tipButtons)
    button.draw();

  choiceCanvas.endDraw();
  image(choiceCanvas, 0, 0);
}


void drawUI()
{
  if (!showUI)
  {
    return;
  }
  
  float buttonWidth = 100;
  uiCanvas.beginDraw();
  uiCanvas.background(200);
  uiCanvas.rectMode(CORNER);
  uiCanvas.noStroke();
  uiCanvas.fill (255, 0, 0); // RED

  if (recording)
  {
    uiCanvas.rect(200, 0, 100, 40);
    uiCanvas.text("RECORDING", 1500, 25);
  }

  //uiCanvas.fill(128);
  if (showMenu) uiCanvas.rect(0, 0, buttonWidth, 40);
  if (debugging) uiCanvas.rect(300, 0, buttonWidth, 40);
  if (showPreview) uiCanvas.rect(400, 0, buttonWidth, 40);
  if (animating) uiCanvas.rect(700, 0, buttonWidth, 40);
  uiCanvas.rect(uiItems.length*100+currentCanvas*60, 0, 40, 40);
  //if (currentCanvas == 1) uiCanvas.rect(uiItems.length*120+60, 0, 40, 40);
  //if (currentCanvas == 2) uiCanvas.rect(uiItems.length*120+120, 0, 40, 40);

  // Draw Menu Items
  uiCanvas.fill(64); // GRAY
  uiCanvas.textSize(16);
  for (int i=0; i<uiItems.length; i++)
  {
    uiCanvas.text(uiItems[i], i*buttonWidth + 10, 25);
  }

  // Draw "Animating" frames
  for (int i=0; i<3; i++)
  {
    uiCanvas.text(i+1, uiItems.length*buttonWidth + i*60 +10, 25);
  }

  uiCanvas.text("State." + state, buttonWidth*12, 25);
  uiCanvas.endDraw();
  image(uiCanvas, 0, 1040);
}

void stampToDebug()
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


void drawDebug()
{
  if (debugging)
  {
    image(debugCanvas, 0, 0);
  }
}


void drawPreview()
{
  if (showPreview)
  {
    image(previewCanvas, 0, 0);
  } 
}
