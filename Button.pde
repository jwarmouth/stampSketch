class Button
{
  PImage image;
  SpriteSet[] sets;
  int index, x, y, w, h;
  String text;
  color bgColor, selectedColor, textColor, overColor;
  boolean selected;
  boolean doubled = false;
  String methodToCall;

  Button(SpriteSet[] iSets, int _index, int _x, int _y, int _w, int _h, String _text, PImage _image)
  {
    sets = iSets;
    index = _index;
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    text = _text;
    image = _image;
    bgColor = color(200);
    textColor = color(0);
    selectedColor = color(0);
    overColor = color(255, 0, 0);
    //if (w < 100)
    //{
    // w *= 2;
    // doubled = true;
    //}
    //print ("\n creating button: " + text);
  }

  void draw()
  {
    int margin = 5;
    if (isSelected())
    {
      choiceCanvas.fill(selectedColor);
      choiceCanvas.rect(x-margin, y-margin, w+margin*2, h+margin*2);
    }
    if (isOver())
    {
      choiceCanvas.fill(overColor);
      choiceCanvas.rect(x-margin, y-margin, w+margin*2, h+margin*2);
      if (mousePressed)
      {
        select();
      }
    }
    
    choiceCanvas.fill(bgColor);
    float textHeight = 20;
    float textY;
    
    if (image != null)
    {
      choiceCanvas.image(image, x, y, image.width, image.height);
      //if (doubled)
      //{
      // choiceCanvas.image(image, x+image.width, y, image.width, image.height);
      //}
      //choiceCanvas.rect(x, y+h-margin*3, w, margin*3);
    
      choiceCanvas.rect(x, y+h-20, w, textHeight);
      textY = y+h;
    } 
    else
    {
      choiceCanvas.rect(x, y, w, h);
      textY = y+h/1.75;
    }
    
    choiceCanvas.fill(textColor);
    choiceCanvas.text(text, x+w/2, textY);
  }

  boolean isSelected()
  {
    int checkIndex = -1;
    if (sets == rootSets)
      checkIndex = currentRoot;
    if (sets == segmentSets)
      checkIndex = currentSegment;
    if (sets == tipSets)
      checkIndex = currentTip;

    return (index == checkIndex);
  }

  boolean isOver()
  {
    return (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h);
  }

  void select()
  {
    if (methodToCall != null)
    {
      method(methodToCall);
    }
    if (sets == rootSets)
    {
      currentRoot = index;
    }
    if (sets == segmentSets)
    {
      currentSegment = index;
    }
    if (sets == tipSets)
    {
      currentTip = index;
    }
    if (sets[index] != null)
    {
      sets[index].loadSprites();
    }
    savePrefs();
  }
}



// Should be optimized better, but this is OK for now...
class EnterButton
{
  PImage image;
  int index, x, y, w, h;
  String text;
  color bgColor, selectedColor, textColor, overColor;
  boolean selected;

  EnterButton(int _x, int _y, int _w, int _h, String _text)
  {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    text = _text;
    bgColor = color(200);
    textColor = color(0);
    selectedColor = color(0);
    overColor = color(255, 0, 0);
    //print ("\n creating button: " + text);
  }

  void draw()
  {
    int margin = 10;
    if (isOver())
    {
      choiceCanvas.fill(overColor);
      choiceCanvas.rect(x-margin, y-margin, w+margin*2, h+margin*2);
      if (mousePressed)
      {
        select();
      }
    }
    choiceCanvas.fill(bgColor); // bg color
    choiceCanvas.rect(x, y, w, h);
    choiceCanvas.fill(bgColor);
    choiceCanvas.rect(x, y+h-margin*3, w, margin*3);
    choiceCanvas.fill(textColor);
    choiceCanvas.text(text, x+w/2, y+h/1.5);
  }


  boolean isOver()
  {
    return (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h);
  }

  void select()
  {
    hideMenu();
  }
}


class Heading
{
  String text;
  int x;
  int y;
  
  Heading(String _text, int _x, int _y)
  {
    text = _text;
    x = _x;
    y = _y;
  }
  
  void draw()
  {
     choiceCanvas.text(text, x, y); 
  }
}



// Make draw method of Button class -- much better
//void drawButton(float buttonX, float buttonY, SpriteSet spriteSet)
//{
//  float buttonWidth = 200;
//  float buttonHeight = 80;
//  float buttonTextSize = 24;
//  //float buttonVertSpacing = 100;
//  color buttonColor = color(160);
//  color buttonSelectedColor = color(255, 0, 0);
//  color buttonTextColor = color(0);


//  if (spriteSet != null)
//  {
//    PImage sprite = spriteSet.sprites[0];
//    choiceCanvas.image(sprite, buttonX - buttonWidth/2, buttonY, buttonWidth, buttonHeight);
//  } else {
//    choiceCanvas.fill(buttonColor); // RED
//    choiceCanvas.rect(buttonX-buttonWidth/2, buttonY, buttonWidth, buttonHeight);
//  }
//  choiceCanvas.fill(buttonTextColor);
//  choiceCanvas.text("NONE", buttonX, buttonY+48);
//}


//ChoiceSprite[] choiceBeginSprites = new ChoiceSprite[2];
//ChoiceSprite[] choiceSegmentSprites = new ChoiceSprite[2];
//ChoiceSprite[] choiceEndSprites = new ChoiceSprite[2];


//class ChoiceSprite
//{
//  PImage sprite;
//  SpriteSet spriteSet;
//  SpriteSet category;
//  int x, y, width, height;

//  ChoiceSprite(SpriteSet ispriteSet, SpriteSet icategory)
//  {
//   spriteSet = ispriteSet;
//   sprite = spriteSet[0];
//   category = icategory;
//   width = sprite.width;
//   height = sprite.height;
//  }

//  void setCategory()
//  {
//    category = spriteSet;
//  }
//}
