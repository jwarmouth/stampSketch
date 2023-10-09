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


  if (state == State.CHOOSING)
  {
    // let player choose stamps
    if (!overChoiceMenu()) hideChoiceMenu();
    for (StampButton button : rootButtons) button.hover();
    for (StampButton button : segmentButtons) button.hover();
    for (StampButton button : tipButtons) button.hover();
    randomButton.hover();
    eraseButton.hover();
    closeButton.hover();
  }

switch(state) {
  case ATTRACTING:
    exitAttractMode();
    state = State.WAITING;

  case WAITING:
    resetVectorPoints();
    Block overlapBlock = overlappingBlock();
   
    if (overlapBlock != null)
    {
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
    
    //if (mouseButton == RIGHT)
    //{
    //  state = State.PREVIEWING_TIP;
    //  tipFlip = randomSignum();
    //}
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
  attractTimerReset();
  lastRoot = null;
  //clearPreview();
  
  if (showMenuBar) for (MenuBarButton button : menuBarButtons) button.select();

  switch(state) {
  case DRAGGING:
    toggleChoiceMenu();
    savePrefs();
    break;

  case CHOOSING:
    for (StampButton button : rootButtons) button.select();
    for (StampButton button : segmentButtons) button.select();
    for (StampButton button : tipButtons) button.select();
    randomButton.select();
    eraseButton.select();
    closeButton.select();
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
      //stampTip();
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
