/*********************************************************
 ***  MENU BAR  ******************************************
 *********************************************************/

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
  
void drawMenuBar()
{
  if (!showMenuBar) return;

  //float buttonWidth = 100;
  menuBarCanvas.beginDraw();
  menuBarCanvas.background(200, 200, 200, 200);
  menuBarCanvas.rectMode(CORNER);
  menuBarCanvas.noStroke();
  menuBarCanvas.fill (255, 0, 0); // RED
  menuBarCanvas.textSize(16);
  //menuBarCanvas.textFont(fjordFont);
  
  // DRAW MENU BAR BUTTONS
  for (MenuBarButton button : menuBarButtons) button.draw();
  
  // Draw animFrameCount
  menuBarCanvas.text("Anim " + animFrameCount%animationRate, menuBarWidth + 20 + cornerW, 27);
  
  // Draw Frame Rate
  menuBarCanvas.text("FPS: " + nf(frameRate, 0, 2), menuBarWidth + 100 + cornerW, 27);

  // Draw STATE
  menuBarCanvas.text("State." + state, menuBarWidth + 200 + cornerW, 27);

  menuBarCanvas.endDraw();
  image(menuBarCanvas, 0, 0, scaleUI(menuBarCanvas.width), scaleUI(menuBarCanvas.height)); //h-scaleUI(40)
}

void menuBarSetup()
{
  menuBarButtons = new MenuBarButton[menuBarItems.length];
  int buttonX = 0;
  
  for (int i=0; i<menuBarItems.length; i++)
  {
    menuBarButtons[i] = new MenuBarButton(menuBarItems[i], menuBarMethods[i], menuBarVars[i], buttonX, 0);
    buttonX += menuBarButtons[i].w;
  }
  
  menuBarWidth = buttonX;
}

void menuBarToggle()
{
  showMenuBar = !showMenuBar;
}

class MenuBarButton
{
  int index;
  float x, y, w, h;
  float margin = 10;
  String text;
  color activeColor, bgColor, textColor, overColor;
  boolean active;
  boolean hover;
  boolean pressed;
  String method;
  String activeVar;

  MenuBarButton(String _text, String _method, String _activeVar, float _x, float _y)
  {
    text = _text;
    method = _method;
    activeVar = _activeVar;
    x = _x + cornerW;
    y = _y;
    //w = text.length() * 10;
    textSize(16);
    w = (int)textWidth(text) + margin; //* 4;
    h = 40;
    bgColor = color(200);
    textColor = color(0);
    activeColor = color(255, 0, 0);
    overColor = color(255, 125, 125);
    //print ("\n creating button: " + text);
  }

  void draw()
  {
    if (!touchMode)
    {
      hover = isOver();
    }
    
    if (hover)
    {
      menuBarCanvas.fill(overColor);
      menuBarCanvas.rect(x, y, w, h);
    }
    
    if (isActive())
    {
      menuBarCanvas.fill(activeColor); // bg color
      menuBarCanvas.rect(x, y, w, h);
    }
    
    menuBarCanvas.fill(textColor);
    menuBarCanvas.text(text, x+margin, y+h/1.5);
  }
  
  void hover()
  {
    hover = isOver();
  }

  void select()
  {
    if (!isOver()) return;
    
    method(method);
    hover = false;
    println("selecting" + text);
  }
  
  boolean isOver()
  {
    return (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h);
  }
  
  boolean isActive()
  {
   return isButtonActive(activeVar);
   //return method(activeMethod);
  }
}

boolean isButtonActive(String varToCheck)
{
  if (varToCheck == "showChoiceMenu") return showChoiceMenu;
  if (varToCheck == "recording") return recording;
  if (varToCheck == "debugging") return debugging;
  if (varToCheck == "showPreview") return showPreview;
  if (varToCheck == "mouseAutoTip") return mouseAutoTip;
  if (varToCheck == "showRootCanvas") return showRootCanvas;
  if (varToCheck == "showSegmentCanvas") return showSegmentCanvas;
  if (varToCheck == "showTipCanvas") return showTipCanvas;
  if (varToCheck == "animating") return animating;
  if (varToCheck == "isOneActive") return isOneActive();
  if (varToCheck == "isTwoActive") return isTwoActive();
  if (varToCheck == "isThreeActive") return isThreeActive();
  else return false;
}

boolean isOneActive()
{
  return (currentCanvas == 0);
}

boolean isTwoActive()
{
  return (currentCanvas == 1);
}

boolean isThreeActive()
{
  return (currentCanvas == 2);
}

/*
void drawMenuBarOld()
{
  if (!showMenuBar)
  {
    return;
  }

  float buttonWidth = 100;
  menuBarCanvas.beginDraw();
  menuBarCanvas.background(200, 200, 200, 200);
  menuBarCanvas.rectMode(CORNER);
  menuBarCanvas.noStroke();
  menuBarCanvas.fill (255, 0, 0); // RED

  if (recording)
  {
    menuBarCanvas.rect(200, 0, 100, 40);
    menuBarCanvas.text("RECORDING", 1500, 25);
  }

  //uiCanvas.fill(128);
  if (showChoiceMenu) menuBarCanvas.rect(0, 0, buttonWidth, 40);
  if (debugging) menuBarCanvas.rect(300, 0, buttonWidth, 40);
  if (showPreview) menuBarCanvas.rect(400, 0, buttonWidth, 40);
  if (mouseAutoTip) menuBarCanvas.rect(500, 0, buttonWidth, 40);
  if (animating) menuBarCanvas.rect(900, 0, buttonWidth, 40);
  menuBarCanvas.rect(uiItems.length*100+currentCanvas*60, 0, 40, 40);
  //if (currentCanvas == 1) uiCanvas.rect(uiItems.length*120+60, 0, 40, 40);
  //if (currentCanvas == 2) uiCanvas.rect(uiItems.length*120+120, 0, 40, 40);

  // Draw Menu Items
  menuBarCanvas.fill(64); // GRAY
  menuBarCanvas.textSize(16);
  for (int i=0; i<uiItems.length; i++)
  {
    menuBarCanvas.text(uiItems[i], i*buttonWidth + 10, 25);
  }

  // Draw "Animating" frames
  for (int i=0; i<canvasFramesCount; i++)
  {
    menuBarCanvas.text(i+1, uiItems.length*buttonWidth + i*60 +10, 25);
  }
  
  // Draw STATE
  menuBarCanvas.text("State." + state, buttonWidth*12, 25);
  
  // Draw Frame Rate
  menuBarCanvas.text(frameRate + " FPS", buttonWidth*14, 25);
  
  // Draw animFrameCount
  menuBarCanvas.text("Anim " + animFrameCount%animationRate, buttonWidth*16, 25);
  
  menuBarCanvas.endDraw();
  image(menuBarCanvas, 0, 0, scaleUI(menuBarCanvas.width), scaleUI(menuBarCanvas.height)); //h-scaleUI(40)
}
*/
