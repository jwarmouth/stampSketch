/*********************************************************
 ***  MENU BAR  ******************************************
 *********************************************************/

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
  
  for (int i=0; i<menuBarButtons.length; i++)
  {
    menuBarButtons[i].draw();
  }

  /*
  // Draw STATE
  menuBarCanvas.text("State." + state, buttonWidth*12, 25);
  
  // Draw Frame Rate
  menuBarCanvas.text(frameRate + " FPS", buttonWidth*14, 25);
  
  // Draw animFrameCount
  menuBarCanvas.text("Anim " + animFrameCount%animationRate, buttonWidth*16, 25);
  */
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
}

void menuBarToggle()
{
  showMenuBar = !showMenuBar;
}

class MenuBarButton
{
  int index, x, y, w, h;
  int margin = 10;
  String text;
  color activeColor, bgColor, textColor, overColor;
  boolean active;
  boolean over;
  boolean pressed;
  String method;
  String activeVar;

  MenuBarButton(String _text, String _method, String _activeVar, int _x, int _y)
  {
    text = _text;
    method = _method;
    activeVar = _activeVar;
    x = _x;
    y = _y;
    w = text.length() * 10;
    h = 40;
    //w = _w;
    //h = _h;
    bgColor = color(200);
    textColor = color(0);
    activeColor = color(255, 0, 0);
    overColor = color(255, 125, 125);
    //print ("\n creating button: " + text);
  }

  void draw()
  {
    if (isOver())
    {
      print ("\n" + text + " is over");
      menuBarCanvas.fill(overColor);
      menuBarCanvas.rect(x, y, w, h);
      
      
      if (!pressed && mouseIsPressed)
      {
        pressed = true;
        print ("\n" + text + " is pressed");
      }
      if (pressed && !mouseIsPressed)
      {
        pressed = false;
        print ("\n" + text + " is released");
        select();
      }
    }
    //else
    //{
    //  pressed = false;
    //}
    
    if (isActive())
    {
      menuBarCanvas.fill(activeColor); // bg color
      menuBarCanvas.rect(x, y, w, h);
    }
    menuBarCanvas.fill(textColor);
    menuBarCanvas.text(text, x+margin, y+h/1.5);
  }


  boolean isOver()
  {
    return (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h);
  }

  void select()
  {
    method(method);
    print ("\nselecting" + text);
    //hideChoiceMenu();
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
  return (currentCanvas == 1);
}

boolean isTwoActive()
{
  return (currentCanvas == 2);
}

boolean isThreeActive()
{
  return (currentCanvas == 3);
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
