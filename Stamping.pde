/********************************************************
 ***  STAMPING   *****************************************
 *********************************************************/


/*********************************************************
 ***  STAMP ROOT   ***************************************
 *********************************************************/

void stampRoot()
{
  if (overlaps(rootCanvas)) return;

  SpriteSet set = rootSets[currentRoot];
  if (set == null) return; // quick fix???
  
  //playSound(rootSound, mouseX, mouseY);
  thread("playRootSound");

  float stampAngle = angleToMouse(lastPoint) + rootRotation;

  stamp (set, centerPoint, stampAngle, rootFlip, rootCanvas);
  makeTransparent(previewCanvas);

  lastRoot = new Block(lastPoint.x, lastPoint.y, set.width, set.height, stampAngle + randomRotationNSEW(), lastPoint, targetPoint);
  rootBlocks.add(lastRoot);

  saveFrames(12); // only if recording
}



/********************************************************
 ***  STAMP SEGMENT   ***********************************
 *********************************************************/
void stampSegment(int frames)
{
  SpriteSet set = segmentSets[currentSegment];
  if (set == null) return; // quick fix???
  
  thread("playSegmentSound");
  lastAngle = angleToMouse(lastPoint);
  stamp(set, centerPoint, lastAngle, segmentScale(set), segmentCanvas);
  lastSegment = new Block(centerPoint.x, centerPoint.y, set.armSegmentDistance, set.armSegmentDistance, lastAngle, lastPoint, targetPoint);
  segmentBlocks.add(lastSegment);

  lastPoint = targetPoint;

  saveFrames(frames); // only if recording
}

void stampSegment()
{
  stampSegment(1);
} //<>//


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
void stampTipAuto()
{
  if (allowOverlap || !overlaps())
  {
    tipFlip = randomSignum();
    float angleAdjust = radians(random(6) + random(6) + random(6) - 9);
    stampTip(lastAngle + angleAdjust);
    //println("angleAdjust: " + angleAdjust);
    clearPreview();
  }
}

void stampTip()
{
  stampTip(lastAngle);
}

void stampTip(float stampAngle)
{
  SpriteSet set = tipSets[currentTip];
  if (set == null) return; // quick fix???
  
  thread("playTipSound");
  saveFrames(1); // Extra delay before drawing tip -- could be 2 for that "pop"
  mouseToVector(centerPoint);
  centerPointMatchesTip(set);
  set = rightOrLeftHand(set);
  
  if (stampAngle == 0) stampAngle = angleToMouse(lastPoint); 
  if (set.name.contains("horn")) stampAngle = lastAngle;
  
  if (set.name.contains("hand")) centerPoint = lastPoint;

  if (set.name.contains("eye"))
  {
    if (overlaps(tipCanvas))
    {
      set = eyeballSet;
      set.loadSprites();
    }
    stampAngle += radians(90);
    if (autoEyeball)
    {
      eyeballRandomLook();
    }
    if (set.name == "eye")
    {
      stampAngle += radians (random(200) - 100);
    }
  }
  
  stamp (set, centerPoint, stampAngle, tipFlip, tipCanvas);

  lastTip = new Block(centerPoint.x, centerPoint.y, set.width, set.height, stampAngle, lastPoint, targetPoint);
  tipBlocks.add(lastTip);
  
  saveFrames(12);
}

void eyeballRandomLook()
{
  // AUTO-STAMP EYEBALL!
  eyeballX = random(-95, 95);
  eyeballY = random(-45, 45);
  float absX = abs(eyeballX);
  if (absX > 30)
  {
    absX = map(absX, 30, 100, 1, 0.01);
    // if it's 31, reduce a bit, if it's 100, reduce to 0
    eyeballY *= absX;
  }
  
  eyeballX /= scaleFactor;
  eyeballY /= scaleFactor;
      //eyeballSet.loadSprites();
      //eyeballPoint = centerPoint;
      //eyeballPoint.x += random(40)-20;
      //eyeballPoint.y += random(20)-10 - (abs(eyeballPoint.x)/4);
      
      //eyeballX = random(36)-18;
      //eyeballY = random(18)-9;
      //if (abs(eyeballX) > 8)
      //{
      //  eyeballY /= abs(eyeballX)/5 + 1;
      //}
      
      // - (abs(eyeballX)/5);
      //stamp (eyeballSet, eyeballPoint, stampAngle, tipFlip);
}


/********************************************************
 ***  STAMP  ********************************************
 *********************************************************/
void stamp(SpriteSet spriteSet, PVector centerPoint, float rotation, float flipX, PGraphics previewCanvas)
{
  if (spriteSet == null) return; // quick fix???
  
  // NOT SURE WHY WE DO THIS
  //stampToPreviewCanvas(spriteSet, rotation, flipX);
  
  int index = (int)random(spriteSet.length);
  for (int i=0; i<canvasFramesCount; i++)
  {
    stampToCanvas(canvasFrames[i], centerPoint, spriteSet, (index+i)%spriteSet.length, rotation, flipX);
  }
  stampToCanvas(previewCanvas, centerPoint, spriteSet, index, rotation, flipX);
  

  if (hiResEnabled)
  {
    stampToHiRes(centerPoint, spriteSet, index, rotation, flipX);
  }

  // https://discourse.processing.org/t/how-do-you-rotate-an-image-without-the-image-being-moved/6579/4
  // https://discourse.processing.org/t/solved-question-about-flipping-images/7391/2
}



void stampToCanvas(PGraphics canvas, PVector location, SpriteSet set, int index, float rotation, float flipY)
{
  canvas.beginDraw();
  canvas.blendMode(MULTIPLY);
  if (canvas == rootCanvas || canvas == segmentCanvas || canvas == tipCanvas)
  {
    canvas.blendMode(SUBTRACT);
  }
  canvas.imageMode(CENTER); // use image center instead of top left
  canvas.pushMatrix(); // remember current drawing matrix
  canvas.translate(location.x, location.y);
  canvas.rotate(rotation);
  canvas.scale(1, flipY);
  canvas.image(set.sprites[index], set.offsetX, set.offsetY * flipY);
  if (autoEyeball && set.name.contains("eye"))
  {
    canvas.image(eyeballSet.sprites[index], eyeballX, eyeballY);
  //stamp (eyeballSet, eyeballPoint, stampAngle, tipFlip);
  }
  canvas.popMatrix();
  canvas.endDraw();
}

void stampToHiRes(PVector location, SpriteSet set, int index, float rotation, float flipX)
{
  hiResCanvas.beginDraw();
  hiResCanvas.blendMode(MULTIPLY);
  hiResCanvas.imageMode(CENTER); // use image center instead of top left
  hiResCanvas.pushMatrix(); // remember current drawing matrix
  hiResCanvas.translate(location.x * scaleFactor, location.y * scaleFactor);
  hiResCanvas.rotate(rotation);
  hiResCanvas.scale(1, flipX);
  hiResCanvas.image(set.hiResSprites[index], set.offsetX * scaleFactor, set.offsetY * flipX * scaleFactor);
  hiResCanvas.popMatrix();
  hiResCanvas.endDraw();
}
