/********************************************************
 ***  PREVIEW     ****************************************
 *********************************************************/
 
void drawPreview()
{
  if (state == State.WAITING) return;
  
  if (showPreview)
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

void clearPreview()
{
  previewCanvas.beginDraw();
  previewCanvas.clear();
  previewCanvas.endDraw();
}

void stampPreview(SpriteSet spriteSet, float rotation, float flipX)
{
  makeTransparent(previewCanvas);
  stampToCanvas(previewCanvas, centerPoint, spriteSet, 0, rotation, flipX);
  if (debugging) {
    stampToDebug();
  }
}

void stampPreview(SpriteSet spriteSet, float rotation)
{
  stampPreview(spriteSet, rotation, 1);
}

void previewTo(PGraphics canvas)
{
  canvas.beginDraw();
  canvas.blendMode(MULTIPLY);
  canvas.image(previewCanvas, 0, 0);
  canvas.endDraw();
}


/********************************************************
 ***  PREVIEW ROOT  *************************************
 *********************************************************/
void previewRoot()
{
  SpriteSet set = rootSets[currentRoot];
  if (set == null) return; // quick fix???

  float stampAngle = angleToMouse(lastPoint) + rootRotation;

  stampPreview (set, stampAngle, rootFlip);
}


/********************************************************
 ***  PREVIEW SEGMENT   *********************************
 *********************************************************/
void previewSegment()
{
  SpriteSet set = segmentSets[currentSegment];
  if (set == null) return; // quick fix???

  float stampAngle = angleToMouse(lastPoint);

  stampPreview (set, stampAngle, segmentScale(set));
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
  
  if (set.name == "eye block" && overlaps(tipCanvas)) {
    set = eyeballSet;
    set.loadSprites();
  }

  targetPoint = new PVector (mouseX, mouseY);
  // stamp end with rotation to mouse
  if (stampAngle == 0) {
    stampAngle = angleToMouse(lastPoint);
  }
  
  if (set.name == "eye block") {
   stampAngle += radians(90); 
  }

  centerPointMatchesTip(set);
  set = rightOrLeftHand(set);
  stampPreview (set, stampAngle, tipFlip);
}
