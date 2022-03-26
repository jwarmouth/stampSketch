/********************************************************
 ***  STAMPING   *****************************************
 *********************************************************/

void stampRoot()
{
  SpriteSet set = rootSets[currentRoot];
  if (set == null) return; // quick fix???

  float stampAngle = angleToMouse(lastPoint);

  stamp (set, stampAngle, randomSignum());
  previewTo(rootCanvas);

  lastRoot = new Block(lastPoint.x, lastPoint.y, set.width, set.height, stampAngle + randomRotationNSEW(), lastPoint, targetPoint);
  rootBlocks.add(lastRoot);

  saveFrames(12);
}

void stampSegment()
{
  SpriteSet set = segmentSets[currentSegment];
  if (set == null) return; // quick fix???

  lastAngle = angleToMouse(lastPoint);

  stamp(set, lastAngle, 1);
  previewTo(segmentCanvas);

  lastSegment = new Block(centerPoint.x, centerPoint.y, armSegmentDistance, armSegmentDistance, lastAngle, lastPoint, targetPoint);
  segmentBlocks.add(lastSegment);

  lastPoint = targetPoint;

  saveFrames(1);
}

void stampTip()
{
  SpriteSet set = tipSets[currentTip];
  if (set == null) return; // quick fix???

  saveFrames(1); // Extra delay before drawing tip -- could be 2 for that "pop"

  targetPoint = new PVector (mouseX, mouseY);
  // stamp end with rotation to mouse
  float stampAngle = angleToMouse(lastPoint);

  //print(set.name);
  switch(set.name)
  {
  case "hand-red":
    // Left Hand or Right Hand?
    set = handRedSets[(int)random(handRedSets.length)];
    centerPoint = PVector.add(lastPoint, PVector.fromAngle(lastAngle, targetPoint));
    break;
    
  case "hand-black":
    // Left Hand or Right Hand?
    set = handBlackSets[(int)random(handBlackSets.length)];
    centerPoint = PVector.add(lastPoint, PVector.fromAngle(lastAngle, targetPoint));
    break;

  default:
    centerPoint = PVector.add(lastPoint, PVector.mult(PVector.fromAngle(lastAngle), set.width/2));
    break;
  }

  stamp (set, stampAngle, 1);
  previewTo(tipCanvas);

  lastTip = new Block(centerPoint.x, centerPoint.y, set.width, set.height, stampAngle + randomRotationNSEW(), lastPoint, targetPoint);
  tipBlocks.add(lastTip);
  saveFrames(12);

  if (debugging)
  {
    debugCanvas.beginDraw();
    debugCanvas.fill(0, 255, 0);
    debugCanvas.circle(targetPoint.x, targetPoint.y, 10);
    debugCanvas.endDraw();
  }
}

void stamp(SpriteSet spriteSet, float rotation, int flipX)
{
  if (spriteSet == null) return; // quick fix???
  int index = (int)random(spriteSet.length);
  //int howManySaved = 0;

  // Draw to previewCanvas
  previewCanvas.beginDraw();
  previewCanvas.clear();
  //previewCanvas.blendMode(MULTIPLY);
  previewCanvas.imageMode(CENTER); // use image center instead of top left
  previewCanvas.pushMatrix(); // remember current drawing matrix
  previewCanvas.translate(centerPoint.x, centerPoint.y);
  previewCanvas.rotate(rotation);
  previewCanvas.scale(flipX, 1);
  previewCanvas.image(spriteSet.sprites[(index)%spriteSet.length], spriteSet.offsetX * flipX, spriteSet.offsetY);
  previewCanvas.popMatrix();
  previewCanvas.endDraw();

  for (int i=0; i<3; i++)
  {
    canvasFrames[i].beginDraw();
    canvasFrames[i].blendMode(MULTIPLY); // change blend mode
    canvasFrames[i].imageMode(CENTER); // use image center instead of top left
    canvasFrames[i].pushMatrix(); // remember current drawing matrix
    canvasFrames[i].translate(centerPoint.x, centerPoint.y);
    canvasFrames[i].rotate(rotation);
    canvasFrames[i].scale(flipX, 1);
    canvasFrames[i].image(spriteSet.sprites[(index+i)%spriteSet.length], spriteSet.offsetX * flipX, spriteSet.offsetY);
    //canvasFrames[i].image(previewCanvas, 0, 0);
    canvasFrames[i].popMatrix();
    canvasFrames[i].endDraw();
  }

  if (debugging) drawDebug();

  // https://discourse.processing.org/t/how-do-you-rotate-an-image-without-the-image-being-moved/6579/4
  // https://discourse.processing.org/t/solved-question-about-flipping-images/7391/2
}
