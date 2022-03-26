class SpriteSet
{
  PImage[] sprites;
  float offsetX, offsetY;
  int length, width, height;
  String name, fileName;
  SpriteSet(String _name, String _file, int _length)
  {
    length = _length;
    fileName = _file;
    name = _name;
    sprites = new PImage[length];
    loadSprite(0);
    if (name.contains("hand"))
    {
      offsetX = width/2;
      loadSprites();
    }
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
