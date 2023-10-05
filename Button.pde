/*********************************************************
 ***  BUTTONS   ******************************************
 *********************************************************/

class StampButton
{
  PImage image, pupil;
  SpriteSet[] sets;
  int index, x, y, w, h, margin;
  String text;
  color bgColor, selectedColor, textColor, overColor, invisible;
  boolean selected;
  boolean active;
  boolean hover;
  String methodToCall;

  StampButton(SpriteSet[] iSets, int _index, int _x, int _y, int _w, int _h, String _text, PImage _image)
  {
    sets = iSets;
    index = _index;
    x = _x + cornerW;
    y = _y + choiceMenuOffsetY;
    w = _w;
    h = _h;
    text = _text;
    image = _image;
    margin = 3;
    bgColor = color(200);
    textColor = color(0);
    selectedColor = color(0);
    overColor = color(255, 0, 0);
    invisible = color(255, 255, 255, 0);
    if (text=="eye black" || text=="eye red")
    {
      pupil = loadImage("images/black-eyeball-0.png");
    }
  }

  void draw()
  {
    choiceCanvas.strokeWeight(3);
    
    if (!touchMode)
    {
      hover = isOver();
    }
    
    if (image == null)
    {
      choiceCanvas.fill(bgColor);
    }
    else
    {
      choiceCanvas.noFill();
    }
    
    if (isSelected())
    {
      choiceCanvas.stroke(selectedColor);
      choiceCanvas.rect(x-margin, y-margin, w+margin*2, h+margin*2, 3);
    }
    
    else if (hover)
    {
      choiceCanvas.stroke(overColor);
      choiceCanvas.rect(x-margin, y-margin, w+margin*2, h+margin*2, 3);
    }
    else if (image == null)
    {
      choiceCanvas.noStroke();
      choiceCanvas.fill(bgColor);
      choiceCanvas.rect(x-margin, y-margin, w+margin*2, h+margin*2, 3);
    }
    
    
    float textHeight = 18;
    float textY;
    
    if (image != null)
    {
      choiceCanvas.imageMode(CENTER);
      choiceCanvas.image(image, x+w/2, y+h/2, image.width, image.height);
      
      //choiceCanvas.image(image, x, y+h-image.height, image.width, image.height);
      if (pupil != null)
      {
        choiceCanvas.image(pupil, x+w/2, y+h/2, pupil.width/4, pupil.height/4);
      }
      
      choiceCanvas.imageMode(CORNER);
      //choiceCanvas.rect(x, y+h-20, w, textHeight);
      textY = y+h+textHeight+margin;
    } 
    else
    {
      //choiceCanvas.rect(x, y, w, h, 3);
      //choiceCanvas.rect(x-margin, y-margin, w+margin*2, h+margin*2, 3);
      textY = y+h/1.75;
    }
    
    choiceCanvas.fill(textColor);
    choiceCanvas.text(text, x+w/2, textY);
  }

  void hover()
  {
    hover = isOver();
  }

  void select()
  {
    if (!isOver()) return;
    
    
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
      //if (sets[index].name == "eye block")
      //{
      //  eyeballSet.loadSprites();
      //}
    }
    savePrefs();
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
    return (mouseX > x-margin && mouseX < x+w+margin*2 && mouseY > y-margin && mouseY < y+h+margin*2);
  }
}



// Should be optimized better, but this is OK for now...
class TextButton
{
  PImage image;
  int index, x, y, w, h;
  int margin = 10;
  String text, method;
  color bgColor, selectedColor, textColor, overColor;
  boolean selected;
  boolean active;
  boolean hover;

  TextButton(int _x, int _y, int _w, int _h, String _text, String _method)
  {
    x = _x + cornerW;
    y = _y + choiceMenuOffsetY;
    w = _w;
    h = _h;
    text = _text;
    method = _method;
    bgColor = color(200);
    textColor = color(0);
    selectedColor = color(0);
    overColor = color(255, 0, 0);
    //print ("\n creating button: " + text);
  }

  void draw()
  {
    choiceCanvas.strokeWeight(3);
    choiceCanvas.fill(bgColor);
    
    if (!touchMode)
    {
      hover = isOver();
    }
    
    if (hover)
    {
      choiceCanvas.stroke(overColor);
      choiceCanvas.rect(x, y, w, h, 3);
      choiceCanvas.stroke(textColor);
      //choiceCanvas.rect(x-margin, y-margin, w+margin*2, h+margin*2);
    }
    else
    {
      choiceCanvas.stroke(textColor); // bg color
      choiceCanvas.rect(x, y, w, h, 3);
    }
    //choiceCanvas.fill(bgColor);
    //choiceCanvas.rect(x, y+h-margin*3, w, margin*3);
    choiceCanvas.fill(textColor);
    choiceCanvas.text(text, x+w/2, y+h/1.5);
  }
  
  void hover()
  {
    hover = isOver();
  }

  void select()
  {
    if (!isOver()) return;
    method(method);
    //hideChoiceMenu();
  }
  
  boolean isOver()
  {
    return (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h);
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
    x = _x + cornerW;
    y = _y + choiceMenuOffsetY;
  }
  
  void draw()
  {
     choiceCanvas.text(text, x, y); 
  }
}



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
