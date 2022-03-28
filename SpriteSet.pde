class SpriteSet
{
  PImage[] sprites;
  float offsetX, offsetY, armSegmentDistance;
  int length, width, height;
  String name, fileName;
  SpriteSet(String _name, String _fileName, int _length, float _armSegmentMultiplier)
  {
    name = _name;
    fileName = _fileName;
    length = _length;
    sprites = new PImage[length];
    loadSprite(0);
    if (name.contains("hand"))
    {
      offsetX = width/2;
      loadSprites();
    }
    armSegmentDistance = width * _armSegmentMultiplier;
    //loadSprites();
    //width = sprites[0].width;
    //height = sprites[0].height;
    //offsetX = 0;
    //offsetY = 0;
    print("SpriteSet " + name + ": w" + width + ", h " + height + "\n");
  }

  void loadSprites()
  {
    for (int i = 0; i < length; i++)
    {
      if (sprites[i] == null) loadSprite(i);
    }
  }

  void unloadSprites()
  {
    for (int i = 1; i < length; i++)
    {
      sprites[i] = null;
    }
  }

  void loadSprite(int index)
  {
    sprites[index] = loadImage("images/" + fileName + "-" + (index) + ".png");
    if (width == 0)
    {
      width = (int)(sprites[index].width/scaleFactor);
      height = (int)(sprites[index].height/scaleFactor);
    }
    sprites[index].resize (width, height);
  }
}
