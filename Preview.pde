/*********************************************************
 ***  PREVIEW     ****************************************
 *********************************************************/
 
void drawPreview()
{
  //if (state == State.WAITING) return;
  
  if (showPreview && mouseIsPressed)
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
  if (debugging) {
    stampToDebug();
  }
}

void stampToPreviewCanvas(SpriteSet spriteSet, float rotation)
{
  stampToPreviewCanvas(spriteSet, rotation, 1);
}

void previewTo(PGraphics canvas)
{
  canvas.beginDraw();
  canvas.blendMode(SUBTRACT);
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

  stampToPreviewCanvas (set, stampAngle, rootFlip);
}


/********************************************************
 ***  PREVIEW SEGMENT   *********************************
 *********************************************************/
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
  stampToPreviewCanvas (set, stampAngle, tipFlip);
}
