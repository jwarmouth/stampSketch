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

  float stampAngle = angleToMouse(lastPoint) + rootRotation;

  stamp (set, centerPoint, stampAngle, rootFlip);
  previewTo(rootCanvas);
  makeTransparent(previewCanvas);

  lastRoot = new Block(lastPoint.x, lastPoint.y, set.width, set.height, stampAngle + randomRotationNSEW(), lastPoint, targetPoint);
  rootBlocks.add(lastRoot);

  // saveFrames only happens if recording
  saveFrames(12);
  
  playSound(rootSounds[0], mouseX, mouseY);
}



/********************************************************
 ***  STAMP SEGMENT   ***********************************
 *********************************************************/
void stampSegment(int frames)
{
  SpriteSet set = segmentSets[currentSegment];

  if (set == null) return; // quick fix???

  lastAngle = angleToMouse(lastPoint);

  stamp(set, centerPoint, lastAngle, segmentScale(set));
  previewTo(segmentCanvas);

  lastSegment = new Block(centerPoint.x, centerPoint.y, set.armSegmentDistance, set.armSegmentDistance, lastAngle, lastPoint, targetPoint);
  segmentBlocks.add(lastSegment);

  lastPoint = targetPoint;
  
  playSound(segmentSounds[0], mouseX, mouseY);

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
void stampTipAuto()
{
  if (allowOverlap || !overlaps())
  {
    //previewTip(targetAngle); that doesn't fix the issue
    tipFlip = randomSignum();
    float angleAdjust = radians(random(6) + random(6) + random(6) - 9);
    //targetAngle += angleAdjust;
    //stampTip(targetAngle);
    //thread("previewTip");
    stampTip(targetAngle + angleAdjust);
    print ("\nangleAdjust: " + angleAdjust);
    clearPreview();
  }
}

void stampTip()
{
  stampTip(targetAngle);
}

void stampTip(float stampAngle)
{
  SpriteSet set = tipSets[currentTip];
  if (set == null) return; // quick fix???

  if (set.name == "eye block")
  {
    if (overlaps(tipCanvas))
    {
      set = eyeballSet;
      set.loadSprites();
    }
  }

  saveFrames(1); // Extra delay before drawing tip -- could be 2 for that "pop"

  targetPoint = new PVector (mouseX, mouseY);
  // stamp end with rotation to mouse
  if (stampAngle == 0)
  {
    stampAngle = angleToMouse(lastPoint);
  }

  centerPointMatchesTip(set);
  set = rightOrLeftHand(set);
  if (set.name == "eye block") {
    stampAngle += radians(90);
  }
  
  if (set.name == "eye")
  {
    stampAngle += radians (random(200) - 100);
  }

  if (set.name.indexOf("hand") > 0) {
    // Make sure it's the right hand set
  }

  stamp (set, centerPoint, stampAngle, tipFlip);
  if (set.name == "eye block" && autoEyeball)
  {
    // AUTO-STAMP EYEBALL!
    eyeballSet.loadSprites();
    PVector eyeballPoint = centerPoint;
    eyeballPoint.x += random(40)-20;
    eyeballPoint.y += random(20)-10;
    stamp (eyeballSet, eyeballPoint, stampAngle, tipFlip);
  }
  previewTo(tipCanvas);

  lastTip = new Block(centerPoint.x, centerPoint.y, set.width, set.height, stampAngle, lastPoint, targetPoint);
  tipBlocks.add(lastTip);
  
  
  playSound(tipSounds[0], mouseX, mouseY);
  saveFrames(12);

  //if (debugging)
  //{
  //  debugCanvas.beginDraw();
  //  debugCanvas.fill(0, 255, 0);
  //  debugCanvas.circle(targetPoint.x, targetPoint.y, 10);
  //  debugCanvas.endDraw();
  //}
}


/********************************************************
 ***  STAMP  ********************************************
 *********************************************************/
void stamp(SpriteSet spriteSet, PVector centerPoint, float rotation, float flipX)
{
  if (spriteSet == null) return; // quick fix???
  stampPreview(spriteSet, rotation, flipX);
  int index = (int)random(spriteSet.length);

  for (int i=0; i<canvasFramesCount; i++)
  {
    stampToCanvas(canvasFrames[i], centerPoint, spriteSet, (index+i)%spriteSet.length, rotation, flipX);
  }

  if (hiResEnabled)
  {
    stampToHiRes(centerPoint, spriteSet, index, rotation, flipX);
  }

  // NOT SURE WHY THIS IS DISABLED?????
  //if (debugging)
  //{
  //  stampToDebug();
  //}

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
  canvas.scale(1, flipX);
  canvas.image(spriteSet.sprites[index], spriteSet.offsetX, spriteSet.offsetY * flipX);
  canvas.popMatrix();
  canvas.endDraw();
}

void stampToHiRes(PVector location, SpriteSet spriteSet, int index, float rotation, float flipX)
{
  hiResCanvas.beginDraw();
  hiResCanvas.blendMode(MULTIPLY);
  hiResCanvas.imageMode(CENTER); // use image center instead of top left
  hiResCanvas.pushMatrix(); // remember current drawing matrix
  hiResCanvas.translate(location.x * scaleFactor, location.y * scaleFactor);
  hiResCanvas.rotate(rotation);
  hiResCanvas.scale(1, flipX);
  hiResCanvas.image(spriteSet.hiResSprites[index], spriteSet.offsetX * scaleFactor, spriteSet.offsetY * flipX * scaleFactor);
  hiResCanvas.popMatrix();
  hiResCanvas.endDraw();
}
