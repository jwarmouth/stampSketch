/********************************************************
 ***  STAMPING   *****************************************
 *********************************************************/


/********************************************************
 ***  STAMP ROOT   ***************************************
 *********************************************************/
void stampRoot()
{
  SpriteSet set = rootSets[currentRoot];
  if (set == null) return; // quick fix???

  float stampAngle = angleToMouse(lastPoint) + rootRotation;

  stamp (set, stampAngle, rootFlip);
  previewTo(rootCanvas);
  makeTransparent(previewCanvas);

  lastRoot = new Block(lastPoint.x, lastPoint.y, set.width, set.height, stampAngle + randomRotationNSEW(), lastPoint, targetPoint);
  rootBlocks.add(lastRoot);

  saveFrames(12);
}



/********************************************************
 ***  STAMP SEGMENT   ***********************************
 *********************************************************/
void stampSegment(int frames)
{
  SpriteSet set = segmentSets[currentSegment];
  
  if (set == null) return; // quick fix???

  lastAngle = angleToMouse(lastPoint);

  stamp(set, lastAngle, segmentScale(set));
  previewTo(segmentCanvas);

  lastSegment = new Block(centerPoint.x, centerPoint.y, set.armSegmentDistance, set.armSegmentDistance, lastAngle, lastPoint, targetPoint);
  segmentBlocks.add(lastSegment);

  lastPoint = targetPoint;

  saveFrames(frames);
}

void stampSegment()
{
  stampSegment(1);
}


/********************************************************
 ***  STAMP ARM (full)   ***********************************
 *********************************************************/
//void stampArm()
//{
//  SpriteSet set = segmentSets[currentSegment];
//  if (set == null) return; // quick fix???

//  lastAngle = angleToMouse(lastPoint);

//  stamp(set, lastAngle, 1);
//  previewTo(segmentCanvas);

//  lastSegment = new Block(centerPoint.x, centerPoint.y, segmentSets[currentSegment].armSegmentDistance, segmentSets[currentSegment].armSegmentDistance, lastAngle, lastPoint, targetPoint);
//  segmentBlocks.add(lastSegment);

//  lastPoint = targetPoint;

//  saveFrames(1);
//}




/********************************************************
 ***  STAMP TIP   ***************************************
 *********************************************************/
void stampTip()
{
  stampTip(0);
}

void stampTip(float stampAngle)
{
  SpriteSet set = tipSets[currentTip];
  if (set == null) return; // quick fix???

  saveFrames(1); // Extra delay before drawing tip -- could be 2 for that "pop"

  targetPoint = new PVector (mouseX, mouseY);
  // stamp end with rotation to mouse
  if (stampAngle == 0)
  {
    stampAngle = angleToMouse(lastPoint);
  }

  centerPointMatchesTip(set);
  set = rightOrLeftHand(set);

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


/********************************************************
 ***  STAMP  ********************************************
 *********************************************************/
void stamp(SpriteSet spriteSet, float rotation, float flipX)
{
  if (spriteSet == null) return; // quick fix???
  stampPreview(spriteSet, rotation, flipX);
  int index = (int)random(spriteSet.length);
 
  for (int i=0; i<3; i++)
  {
    stampToCanvas(canvasFrames[i], centerPoint, spriteSet, (index+i)%spriteSet.length, rotation, flipX);
  }
  
  stampToHiRes(spriteSet, index, rotation, flipX);

  if (debugging) 
  {
    drawDebug();
  }

  // https://discourse.processing.org/t/how-do-you-rotate-an-image-without-the-image-being-moved/6579/4
  // https://discourse.processing.org/t/solved-question-about-flipping-images/7391/2
}



void stampToCanvas(PGraphics canvas, PVector location, SpriteSet spriteSet, int index, float rotation, float flipX)
{
  canvas.beginDraw();
  canvas.blendMode(MULTIPLY);
  canvas.imageMode(CENTER); // use image center instead of top left
  canvas.pushMatrix(); // remember current drawing matrix
  canvas.translate(location.x, location.y);
  canvas.rotate(rotation);
  canvas.scale(flipX, 1);
  canvas.image(spriteSet.sprites[index], spriteSet.offsetX * flipX, spriteSet.offsetY);
  canvas.popMatrix();
  canvas.endDraw();
}

void stampToHiRes(SpriteSet spriteSet, int index, float rotation, float flipX)
{
  hiResCanvas.beginDraw();
  hiResCanvas.blendMode(MULTIPLY);
  hiResCanvas.imageMode(CENTER); // use image center instead of top left
  hiResCanvas.pushMatrix(); // remember current drawing matrix
  hiResCanvas.translate(centerPoint.x * scaleFactor, centerPoint.y * scaleFactor);
  hiResCanvas.rotate(rotation);
  hiResCanvas.scale(flipX, 1);
  hiResCanvas.image(spriteSet.hiResSprites[index], spriteSet.offsetX * flipX * scaleFactor, spriteSet.offsetY * scaleFactor);
  hiResCanvas.popMatrix();
  hiResCanvas.endDraw();
}
