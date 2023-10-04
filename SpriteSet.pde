/*********************************************************
 ***  SPRITE SET   ***************************************
 *********************************************************/
 
class SpriteSet
{
  PImage[] sprites;
  PImage[] hiResSprites;
  float offsetX, offsetY, armSegmentDistance;
  int length, width, height;
  boolean stretchy = false;
  String name, fileName;
  SpriteSet(String _name, String _fileName, int _length, float _armSegmentMultiplier, boolean _stretchy)
  {
    name = _name;
    fileName = _fileName;
    length = _length;
    stretchy = _stretchy;
    sprites = new PImage[length];
    if (hiResEnabled)
    {
      hiResSprites = new PImage[length];
    }
    loadSprite(0);
    if (name.contains("hand"))
    {
      offsetX = width/2;
      loadSprites();
    }
    armSegmentDistance = width * _armSegmentMultiplier;
    println("SpriteSet " + name + ": w" + width + ", h " + height);
  }

  SpriteSet(String _name, String _fileName, int _length, float _armSegmentMultiplier)
  {
    this (_name, _fileName, _length, _armSegmentMultiplier, false);
    // https://discourse.processing.org/t/multiple-constructors-in-a-class/3356
    // you can have just one main constructor and call it from the others using this
  }

  SpriteSet(String _name, String _fileName, int _length)
  {
    this (_name, _fileName, _length, 1, false);
  }

  void loadSprites()
  {
    for (int i = 0; i < length; i++)
    {
      if (sprites[i] == null) {
        loadSprite(i);
      }
    }
    if (name == "eye block" || name == "eye block black")
      {
        eyeballSet.loadSprites();
      }
    println(name + " sprites loaded");
  }

  void unloadSprites()
  {
    for (int i = 1; i < length; i++)
    {
      sprites[i] = null;
      if (hiResEnabled)
      {
        hiResSprites[i] = null;
      }
    }
    println(name + " sprites unloaded");
  }

  void loadSprite(int index)
  {
    sprites[index] = loadImage("images/" + fileName + "-" + (index) + ".png");
    if (hiResEnabled)
    {
      hiResSprites[index] = loadImage("images/" + fileName + "-" + (index) + ".png");
    }
    if (width == 0)
    {
      width = (int)(sprites[index].width/scaleFactor);
      height = (int)(sprites[index].height/scaleFactor);
    }
    sprites[index].resize (width, height);
  }
}
