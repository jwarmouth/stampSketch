/*********************************************************
 ***  STAMP QUEUE   **************************************
 *********************************************************/



class QueuedStamp
{
  PGraphics canvas;
  PVector location;
  SpriteSet spriteSet;
  int index;
  float rotation;
  float flipX;
  PGraphics previewToCanvas;
  
  QueuedStamp(PGraphics _canvas, PVector _location, SpriteSet _spriteSet, int _index, float _rotation, float _flipX, PGraphics _previewToCanvas)
  {
    canvas = _canvas;
    location = _location;
    spriteSet = _spriteSet;
    index = _index;
    rotation = _rotation;
    flipX = _flipX;
    previewToCanvas = _previewToCanvas;
  }
}

void stampThread()
{
  print ("\nstampThread initializing");
  //while(true)
  for (;; delay(0)) //
  {
    //print ("\nstampThread looping");
    QueuedStamp qs = queuedStamps.poll();
    if (qs != null)
    {
      if (qs.spriteSet == null)
      {
        qs.spriteSet.loadSprites();
      }
      stampFromQueue(qs.canvas, qs.location, qs.spriteSet, qs.index, qs.rotation, qs.flipX, qs.previewToCanvas);
      print ("\nstamping from queue");
    }
  }
}
