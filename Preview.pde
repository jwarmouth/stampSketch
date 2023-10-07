/*********************************************************
 ***  PREVIEW     ****************************************
 *********************************************************/

void drawPreview()
{
  //if (state == State.WAITING) return;

  if (showPreview && (mouseIsPressed || state == State.CHOOSING))
  {
    blendMode(MULTIPLY);
    if (state != State.CHOOSING) {
      tint(255, 128);
    }
    image(previewCanvas, 0, 0);
    blendMode(BLEND);
    tint(255, 255);
  }
}

void togglePreview()
{
  showPreview = !showPreview;
}

void clearPreview()
{
  previewCanvas.beginDraw();
  previewCanvas.clear();
  previewCanvas.endDraw();
}

void stampToPreviewCanvas(SpriteSet spriteSet, float rotation, float flipX)
{
  makeTransparent(previewCanvas);
  stampToCanvas(previewCanvas, centerPoint, spriteSet, 0, rotation, flipX);
}

void stampToPreviewCanvas(SpriteSet spriteSet, float rotation)
{
  stampToPreviewCanvas(spriteSet, rotation, 1);
}


/********************************************************
 ***  PREVIEW ROOT  *************************************
 *********************************************************/
void previewRoot()
{
  SpriteSet set = rootSets[currentRoot];
  if (set == null) return; // quick fix???

  float stampAngle = angleToMouse(lastPoint) + rootRotation;
  stampToPreviewCanvas (set, stampAngle, rootFlip);
}


/********************************************************
 ***  PREVIEW SEGMENT   *********************************
 *********************************************************/

void startPreviewingSegment()
{
  mouseToVector(targetPoint);
  PVector toCenter = PVector.sub(lastPoint, targetPoint);
  float mag = sqrt(findDistSq(mouseX, mouseY, pmouseX, pmouseY)) / 2 + 5;
  toCenter.limit(mag); // reduce based on mouse speed
  //println("sonic reduction " + mag);
  lastPoint = PVector.add(targetPoint, toCenter);
  lastAngle = angleToMouse(lastPoint);
  
  if (segmentSets[currentSegment] == null)         state = State.PREVIEWING_TIP;
  else if (segmentSets[currentSegment].stretchy)   state = State.PREVIEWING_STRETCHY_SEGMENT;
  else state = State.SEGMENTING;
}

void previewSegment()
{
  SpriteSet set = segmentSets[currentSegment];
  if (set == null) return; // quick fix???

  float stampAngle = angleToMouse(lastPoint);
  stampToPreviewCanvas (set, stampAngle, segmentScale(set));
}


/********************************************************
 ***  PREVIEW TIP   *************************************
 *********************************************************/
void previewTip()
{
  previewTip(targetAngle);
}

void previewTip(float stampAngle)
{
  SpriteSet set = tipSets[currentTip];
  if (set == null) return; // quick fix???
  
  //mouseToVector(targetPoint); //NOT SURE
  
  if (set.name == "eye block" && overlaps(tipCanvas)) {
    set = eyeballSet;
    set.loadSprites();
  }

  if (stampAngle == 0) stampAngle = angleToMouse(lastPoint);
  if (set.name == "eye block") stampAngle += radians(90);
  //if (set.name.contains("hand")) centerPoint = lastPoint;
  
  centerPointMatchesTip(set);
  set = rightOrLeftHand(set);
  stampToPreviewCanvas (set, stampAngle, tipFlip);
}


/********************************************************
 ***  PREVIEW SEGMENT OLD  ******************************
 *********************************************************/
void startPreviewingSegmentOld()
{
  // YOU ONLY NEED TO set lastPoint on the edge -- don't worry about targetPoint

  println("FINDING POINTS OUTSIDE BLOCK");

  // OPTION 1 -- not great, it's temperamental
  //mouseToVector(targetPoint);
  //PVector toCenter = PVector.sub(lastPoint, targetPoint);
  //toCenter.limit(20);    // Start a TEENY bit back toward the center of lastRoot
  //lastPoint = PVector.add(targetPoint, toCenter);
  //lastAngle = angleToMouse(lastPoint);


  // OPTION 2 -- Good for OVERLAP ROOT but not for PREVIEW ROOT
  //PVector toTarget = PVector.sub(targetPoint, lastPoint);
  //int targetMag = (int)toTarget.mag();
  //println(targetMag + " units from center to target");

  //for (int i=1; i<targetMag; i++)
  //{
  //  println("distance " + i + " overlaps");
  //  PVector lt = PVector.add(lastPoint, toTarget.limit(i));
  //  if (!overlaps(rootCanvas, lt) && !overlaps(tipCanvas, lt))
  //  {
  //    println((toTarget.limit(i)).mag() + " units from center to edge");
  //    float arm = segmentSets[currentSegment].armSegmentDistance;
  //    lt = PVector.add(lastPoint, toTarget.limit(i-arm/4));
  //    lastPoint = lt;
  //    centerPoint = lt;
  //    lastAngle = angleToMouse(lastPoint);
  //    return;
  //  }
  //}


  //OPTION 3 -- Good for OVERLAP ROOT but not for PREVIEW ROOT
  //PVector toCenter = PVector.sub(lastPoint, targetPoint);
  //int toCenterMag = (int)toCenter.mag();
  //for (int i=1; i<toCenterMag; i++)
  //{
  //  PVector lt = PVector.add(targetPoint, toCenter.setMag(i));
  //  if (overlaps(rootCanvas, lt) || overlaps(tipCanvas, lt))
  //  {
  //    //println((toCenter.limit(i)).mag() + " units from center to edge");
  //    println("FOUND A SPOT ON THE EDGE");
  //    lastPoint = PVector.add(targetPoint, toCenter.limit(i)); //lt;
  //    centerPoint = lastPoint;
  //    lastAngle = angleToMouse(lastPoint);
  //    return;
  //  }
  //}

  //OPTION 4 -- Good for OVERLAP ROOT but not for PREVIEW ROOT
  //ONLY find lastPoint
  //PVector toTarget = PVector.sub(targetPoint, lastPoint);
  //int targetMag = (int)toTarget.mag();
  //PVector temp = lastPoint;
  ////println(targetMag + " units from center to target");

  //for (int i=1; i<targetMag; i++)
  //{
  //  temp = PVector.add(lastPoint, toTarget.limit(i));
  //  if (!overlaps(rootCanvas, temp) && !overlaps(tipCanvas, temp))
  //  {
  //    // THIS NEVER HAPPENS. WHY?????
  //    println("FOUND EDGE: " + (toTarget.limit(i)).mag() + " units from center");
  //    float arm = segmentSets[currentSegment].armSegmentDistance;
  //    lastPoint = PVector.add(lastPoint, toTarget.limit(i-arm/4));
  //    //lastPoint = lt;
  //    //centerPoint = lt;
  //    lastAngle = angleToMouse(lastPoint);
  //    //return;
  //  }
  //  println("distance " + i + " overlaps");
  //}

  // OPTION 5 -- NONONO
  PVector toLastNorm = PVector.sub(lastPoint, targetPoint);
  toLastNorm.normalize();
  PVector temp = new PVector(mouseX, mouseY);
  //while (!overlaps(rootCanvas, temp) && !overlaps(tipCanvas, temp))
  //{
  //  temp.add(toLastNorm);
  //  targetPoint = temp;
  //  println("no overlap");
  //}
  println("FOUND EDGE");
  lastPoint = temp; //PVector.add(targetPoint, toTarget.limit(i-arm/4));
  lastAngle = angleToMouse(lastPoint);


  // OPTION 6 -- NONONO
  //mouseToVector(targetPoint);
  //lastAngle = angleToMouse(lastPoint);

  //OPTION 7 -- Good for PREVIEW ROOT but not OVERLAP ROOT
  //mouseToVector(targetPoint);
  //float mag = sqrt(findDistSq(mouseX, mouseY, pmouseX, pmouseY));
  //PVector reduce = PVector.sub(targetPoint, lastPoint);
  //lastPoint.add(reduce.setMag(mag));
  //println("sonic reduction " +mag);
  //lastAngle = angleToMouse(lastPoint);


  if (segmentSets[currentSegment] == null) {
    state = State.PREVIEWING_TIP;
  } else if (segmentSets[currentSegment].stretchy)
  {
    state = State.PREVIEWING_STRETCHY_SEGMENT;
  } else
  {
    //lastAngle = angleToMouse(lastPoint);
    //lastPoint = targetPoint;
    state = State.SEGMENTING;
    //stampSegment();
    //println("START PREVIEWING Segment: " + segmentSets[currentSegment].name);
  }
}


//void startSegmentFromPreview()
//{
//  println("Starting segment from Preview Root");
//  //mouseToVector(lastPoint);
  
//  mouseToVector(targetPoint);
  
//  PVector toCenter = PVector.sub(lastPoint, targetPoint);
//  //toCenter.limit(20);    // Start a TEENY bit back toward the center of lastRoot
//  float mag = sqrt(findDistSq(mouseX, mouseY, pmouseX, pmouseY)) / 2 + 5;
//  toCenter.limit(mag); // reduce based on mouse speed
//  println("sonic reduction " + mag);
//  lastPoint = PVector.add(targetPoint, toCenter);
  
//  lastAngle = angleToMouse(lastPoint);
//  startPreviewingSegment();
//}

//void startSegmentFromOverlap()
//{
//  println("Starting segment from Overlap Root");
//  //mouseToVector(lastPoint);
//  //targetPoint = lastPoint;
//  PVector toCenter = PVector.sub(lastPoint, targetPoint);
//  int toCenterMag = (int)toCenter.mag();
//  for (int i=1; i<toCenterMag; i++)
//  {
//    PVector lt = PVector.add(targetPoint, toCenter.setMag(i));
//    if (overlaps(rootCanvas, lt) || overlaps(tipCanvas, lt))
//    {
//      //println((toCenter.limit(i)).mag() + " units from center to edge");
//      println("FOUND A SPOT ON THE EDGE");
//      lastPoint = PVector.add(targetPoint, toCenter.limit(i)); //lt;
//      centerPoint = lastPoint;
//      lastAngle = angleToMouse(lastPoint);
//      return;
//    }
//  }
//  startPreviewingSegment();
//}
