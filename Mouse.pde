/*********************************************************
 ***  INPUT / MOUSE     **********************************
 *********************************************************/

void mousePressed()
{
  mouseIsPressed = true;
  //println("MOUSE IS PRESSED");
  attractTimerReset();

  // Check Options Click
  if (overCornerMenu())
  {
    startDraggingCorner();
  }

  // Check MenuBar Buttons
  if (showMenuBar)
  {
    for (MenuBarButton button : menuBarButtons) button.hover();
  }

  switch(state) {
  case CHOOSING:
    // let player choose stamps
    for (StampButton button : rootButtons) button.hover();
    for (StampButton button : segmentButtons) button.hover();
    for (StampButton button : tipButtons) button.hover();
    eraseButton.hover();
    break;

  case ATTRACTING:
    exitAttractMode();
    state = State.WAITING;

  case WAITING:
    resetVectorPoints();

    Block overlapBlock = overlappingBlock();
    //tipFlip = (int)random(2);

    //if (mouseButton == RIGHT)
    //{
    //  state = State.PREVIEWING_TIP;
    //  tipFlip = randomSignum();
    //}
    if (overlapBlock != null)
    {
      println("OVERLAPPING ROOT");
      //lastPoint = new PVector (overlapBlock.x, overlapBlock.y);
      mouseToVector(lastPoint);
      state = State.OVERLAPPING_ROOT;
    } 
    else if (rootSets[currentRoot] == null)
    {
      state = State.OVERLAPPING_ROOT;
    } 
    else
    {
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
  moveSpriteWithSpace();
  float maxDistance;

  switch(state) {
  case DRAGGING:
    dragCorner();
    break;

  case PREVIEWING_ROOT:
    previewRoot();
    if (!overlaps(previewCanvas)) {
      stampRoot();
      startPreviewingSegment();
    }
    break;

  case OVERLAPPING_ROOT:
    // 1st Segment shouldn't be drawn until mouse is outside all blocks. And that will be the lastPoint...

    if (!overlaps(rootCanvas) && !overlaps(tipCanvas)) {
     startPreviewingSegment();
    }
    break;

  case SEGMENTING:
    maxDistance = segmentSets[currentSegment].armSegmentDistance;
    calculateCenterAndTarget(maxDistance);
    if (isSegmentFarEnough(maxDistance)) {
      stampSegment();
    } else {
      previewSegment();
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
  //println("MOUSE IS RELEASED");
  attractTimerReset();

  // Check MenuBar Buttons
  if (showMenuBar)
  {
    for (MenuBarButton button : menuBarButtons) button.select();
  }

  lastRoot = null;
  //clearPreview();

  switch(state) {
  case DRAGGING:
    toggleChoiceMenu();
    savePrefs();
    break;

  case CHOOSING:
    if (!overChoiceMenu()) hideChoiceMenu();
    // let player choose stamps
    // Check Stamp Buttons
    for (StampButton button : rootButtons) button.select();
    for (StampButton button : segmentButtons) button.select();
    for (StampButton button : tipButtons) button.select();
    eraseButton.select();
    break;

  case PREVIEWING_ROOT:
    stampRoot(); // rotateToMouse() then stamp center block
    state = State.WAITING;
    break;

  case SEGMENTING:
    if (!overlapsAnyButLastSegment()) //overlaps()) //rootCanvas) && !overlaps(tipCanvas))
    {
      if (mouseAutoTip) stampTipAuto();
    }
    state = State.WAITING;
    break;

  case PREVIEWING_STRETCHY_SEGMENT:
    if (!overlapsAnyButLastSegment()) //
    {
      stampSegment(6);
      if (mouseAutoTip) stampTipAuto(); // stampTip(lastAngle);
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
