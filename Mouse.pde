/*********************************************************
 ***  INPUT / MOUSE     **********************************
 *********************************************************/

void mousePressed()
{
  mouseIsPressed = true;
  print ("\nMOUSE IS PRESSED");
  attractTimerReset();

  // Check MenuBar Buttons
  for (MenuBarButton button : menuBarButtons) button.hover();


  switch(state) {
  case CHOOSING:
    // let player choose stamps
    for (StampButton button : rootButtons) button.hover();
    for (StampButton button : segmentButtons) button.hover();
    for (StampButton button : tipButtons) button.hover();
    enterButton.hover();
    break;

  case ATTRACTING:
    exitAttractMode();
    state = State.WAITING;

  case WAITING:
    resetVectorPoints();
    if (mouseY < 40) return;
    /*
    if (mouseX < 100 && mouseY < 40)
     {
     toggleChoiceMenu();
     }
     */
    Block overlapBlock = findOverlappingBlock();
    //tipFlip = (int)random(2);

    if (mouseButton == RIGHT) {
      state = State.PREVIEWING_TIP;
      tipFlip = randomSignum();
    } else if (overlapBlock != null) {
      lastPoint = new PVector (overlapBlock.x, overlapBlock.y);
      state = State.OVERLAPPING_ROOT;
    } else if (rootSets[currentRoot] == null) {
      state = State.OVERLAPPING_ROOT;
    } else {
      state = State.PREVIEWING_ROOT;
      rootFlip = randomSignum();
      rootRotation = randomRotationNSEW();
    }
    break;

  default:
    break;
  }
}


void ifMouseDragged()
{
  if (!mousePressed) return;

  attractTimerReset();
  //SpriteSet currentSegmentSet = segmentSets[currentSegment];
  float maxDistance;

  if ((keyPressed && key == ' ')) {
    moveSpriteWithSpace();
  }

  /*
  if (mouseButton == RIGHT && mouseButton == LEFT) {
   moveSpriteWithSpace();
   }
   */

  switch(state) {
  case PREVIEWING_ROOT:
    previewRoot();
    //thread("previewRoot");
    if (!overlaps(previewCanvas)) {
      findPointsOutsideBlock(); //thread("findPointsOutsideBlock");
      stampRoot();
      if (segmentSets[currentSegment] == null) {
        state = State.PREVIEWING_TIP;
      } else if (segmentSets[currentSegment].stretchy) {
        state = State.PREVIEWING_STRETCHY_SEGMENT;
      } else {
        state = State.SEGMENTING;
        print ("Segment: " + segmentSets[currentSegment].name);
      }
    }
    break;

  case OVERLAPPING_ROOT:
  
       ghostSegment();
    // UPDATE -- First Segment shouldn't be drawn until mouse is outside all blocks. And that will be the lastPoint...
    if (!overlaps(rootCanvas) && !overlaps(tipCanvas)) {
       findPointsOutsideBlock(); //thread("findPointsOutsideBlock");
      if (segmentSets[currentSegment] == null) {
        state = State.PREVIEWING_TIP;
      } else if (segmentSets[currentSegment].stretchy) {
        state = State.PREVIEWING_STRETCHY_SEGMENT;
      } else {
        state = State.SEGMENTING;
        print ("Segment: " + segmentSets[currentSegment].name);
      }
    }
    break;

  case SEGMENTING:
    maxDistance = segmentSets[currentSegment].armSegmentDistance;
    //calculateCenterAndTarget(maxDistance);
    calculateCenterAndTarget(); //thread("calculateCenterAndTarget");
    if (isSegmentFarEnough(maxDistance)) {
      thread("stampSegment");
    } else {
      thread("previewSegment"); //previewSegment();
    }

    break;

  case PREVIEWING_STRETCHY_SEGMENT:
    //maxDistance = currentSegmentSet.armSegmentDistance;
    maxDistance = segmentSets[currentSegment].width;
    calculateCenterAndTarget(maxDistance);
    thread("previewSegment");
    break;

  case PREVIEWING_TIP:
    thread("previewTip");
    break;

  default:
    break;
  }
}

void mouseReleased()
{
  mouseIsPressed = false;
  print ("\nMOUSE IS RELEASED");
  attractTimerReset();

  // Check MenuBar Buttons
  for (MenuBarButton button : menuBarButtons) button.select();


  lastRoot = null;
  //clearPreview();

  switch(state) {
  case CHOOSING:
    // let player choose stamps
    // Check Stamp Buttons
    for (StampButton button : rootButtons) button.select();
    for (StampButton button : segmentButtons) button.select();
    for (StampButton button : tipButtons) button.select();
    enterButton.select();
    break;

  case PREVIEWING_ROOT:
    stampRoot(); // rotateToMouse() then stamp center block
    state = State.WAITING;
    break;

  case SEGMENTING:
   if (!overlapsAnyButLastSegment()) //overlaps()) //rootCanvas) && !overlaps(tipCanvas))
    {
    if (mouseAutoTip) {
      //thread("stampTipAuto");
      stampTipAuto();
    }
   }
    state = State.WAITING;
    break;

  case PREVIEWING_STRETCHY_SEGMENT:
    if (!overlapsAnyButLastSegment()) //
    {
      stampSegment(6);
      if (mouseAutoTip)
      {
        stampTip(lastAngle);
      }
    }
    state = State.WAITING;
    break;

  case PREVIEWING_TIP:
   if (!overlapsAnyButLastSegment()) //if (!overlaps()) //rootCanvas) && !overlaps(tipCanvas)) 
   {
    thread("stampTip");
   }
    state = State.WAITING;
    break;

  default:
    state = State.WAITING;
    break;
  }

  thread("clearPreview");
}

void toggleMouseAuto()
{
  mouseAutoTip = !mouseAutoTip;
  savePrefs();
}
