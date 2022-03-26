class Block
{
  float x, y, width, height, angle;
  int frame;
  PVector beginPoint, endPoint;
  Block(float _x, float _y, float _w, float _h, float _angle, PVector _beginPoint, PVector _endPoint)
  {
    x = _x;
    y = _y;
    width = _w;
    height = _h;
    angle = _angle;
    frame = frameCount;
    beginPoint = _beginPoint;
    endPoint = _endPoint;
    //print ("Block " + redBlocks.size() + ": (" + x + ", " + y + ") \n");
  }
}
