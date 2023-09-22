/*********************************************************
 ***  INPUT / MOUSE     **********************************
 *********************************************************/

void mousePressed()
{
  mouseIsPressed = true;
  attractTimerReset();
  
  switch(state) {
  case ATTRACTING:
    randomizeAllStamps();
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
  SpriteSet currentSegmentSet = segmentSets[currentSegment];
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
      thread("stampRoot");
      thread("findPointsOutsideBlock");
      if (currentSegmentSet == null) {
        state = State.PREVIEWING_TIP;
      } else if (currentSegmentSet.stretchy) {
        state = State.PREVIEWING_STRETCHY_SEGMENT;
      } else {
        state = State.SEGMENTING;
      }
    }
    break;

  case OVERLAPPING_ROOT:
    // UPDATE -- First Segment shouldn't be drawn until mouse is outside all blocks. And that will be the lastPoint...
    if (!overlaps(rootCanvas) && !overlaps(tipCanvas)) {
      thread("findPointsOutsideBlock");
      if (currentSegmentSet == null) {
        state = State.PREVIEWING_TIP;
      } else if (currentSegmentSet.stretchy) {
        state = State.PREVIEWING_STRETCHY_SEGMENT;
      } else {
        state = State.SEGMENTING;
      }
    }
    break;

  case SEGMENTING:
    maxDistance = currentSegmentSet.armSegmentDistance;
    //calculateCenterAndTarget(maxDistance);
    thread("calculateCenterAndTarget");
    if (isSegmentFarEnough(maxDistance)) {
      thread("stampSegment");
    } else {
      previewSegment();
    }

    break;

  case PREVIEWING_STRETCHY_SEGMENT:
    //maxDistance = currentSegmentSet.armSegmentDistance;
    maxDistance = currentSegmentSet.width;
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

  switch(state) {
  
  case CHOOSING:
    // let player choose stamps
    break;

  case PREVIEWING_ROOT:
    thread("stampRoot"); // rotateToMouse() then stamp center block
    state = State.WAITING;
    break;

  case SEGMENTING:
    if (mouseAutoTip) {
      thread("stampTipAuto");
    }
    state = State.WAITING;
    break;

  case PREVIEWING_STRETCHY_SEGMENT:
    if (!overlaps()) {
      stampSegment(6);
      if (mouseAutoTip)
      {
        stampTip(lastAngle);
      }
    }
    state = State.WAITING;
    break;

  case PREVIEWING_TIP:
    thread("stampTip");
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
