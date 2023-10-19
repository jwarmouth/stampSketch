/*********************************************************
 ***  CORNER MENU  ***************************************
 *********************************************************/

void cornerMenuSetup()
{
  cornerW = 1320/scaleFactor * cornerScale;
  cornerH = 600 * cornerScale;
  cornerX = 0;
  cornerY = height;
  
  choiceX = cornerW;
}

boolean overCornerMenu()
{
  return (mouseX > cornerX && mouseX < cornerX + cornerW && mouseY > cornerY && mouseY < cornerY + cornerH);
}

void startDraggingCorner()
{
  cornerOffsetX = mouseX - cornerX;
  cornerOffsetY = mouseY - cornerY;
  state = State.DRAGGING;
}

void dragCorner()
{
  cornerX = mouseX - cornerOffsetX; //cornerW/2;
  cornerY = mouseY - cornerOffsetY; //cornerH/2;
  cornerX = constrain(cornerX, 0, width - cornerW);
  cornerY = constrain(cornerY, 0, height - cornerH);
}

void drawCornerMenu()
{
  // Draw preview of root/segment/tip
  float bottomY = cornerY + cornerH;
  int strokeW = 3;
  cornerMenuCanvas.beginDraw();
  cornerMenuCanvas.background(255, 255, 255, 0);

  cornerMenuCanvas.stroke(color(0));
  cornerMenuCanvas.strokeWeight(strokeW);
  cornerMenuCanvas.fill(255, 255, 255, 200);
  cornerMenuCanvas.rect(0, 0, cornerW-strokeW, cornerH, 3);
  cornerMenuCanvas.blendMode(MULTIPLY);

  //PVector previewMargin = new PVector (50, 50);
  //float marginX = 25;
  float marginY = cornerW/5 * cornerScale;
  float textHeight = marginY * 1.5;
  float x = cornerW/2;
  float y = textHeight;
  //PVector location = new PVector(marginX, previewMargin.y); // margin


  //y += marginY;

  // Draw Tip
  SpriteSet set = tipSets[currentTip];
  if (set != null) {
    y += set.width/2 * cornerScale;
    float drawY = y;
    if (set.name.contains("hand")) drawY += set.width * cornerScale;
    drawCurrentTools(set, x, drawY);
    //if (set.name.contains("eye")) 
      //cornerMenuCanvas.image(eyeballSet.sprites[0], x - eyeballX, y - eyeballY, set.width * cornerScale, set.height * cornerScale);
    y += set.width/2 * cornerScale;
  }
  
  // Draw Segment
  set = segmentSets[currentSegment];
  if (set != null) {
    int loops = 3;
    if (set.stretchy) {
      loops = 1;
    }
    for (int i=0; i<loops; i++) {
      y += set.armSegmentDistance/2 * cornerScale;
      drawCurrentTools(set, x, y);
      y += set.armSegmentDistance/2 * cornerScale;
    }
  }
  
  // Draw Root
  set = rootSets[currentRoot];
  if (set != null) {
    y += set.width/2 * cornerScale;
    //x += set.height/2;
    x = cornerW/2;
    drawCurrentTools(set, x, y);
    y += set.width/2 * cornerScale;
  }
  
  
  // "Choose Stamps"
  y += marginY*2;
  cornerMenuCanvas.fill(255, 0, 0);
  cornerMenuCanvas.textFont(headingFont);
  cornerMenuCanvas.textSize(200/scaleFactor * cornerScale);
  cornerMenuCanvas.textAlign(CENTER);
  cornerMenuCanvas.text("Choose", x, y);
  if (spanish) {
    y += textHeight;
    cornerMenuCanvas.text("Elegir", x, y);
  }
  y += marginY;
  
  cornerMenuCanvas.endDraw();

  cornerH = (int)y;
  if (cornerY > 0) cornerY = bottomY - cornerH;
  cornerY = constrain(cornerY, 0, height - cornerH);

  image(cornerMenuCanvas, cornerX, cornerY);

}

void drawCurrentTools(SpriteSet set, float x, float y)
{
  boolean isEye = set.name.contains("eye");
  PGraphics canvas = cornerMenuCanvas;
  canvas.blendMode(MULTIPLY);
  canvas.imageMode(CENTER); // use image center instead of top left
  canvas.pushMatrix(); // remember current drawing matrix
  canvas.translate(x, y);
  //canvas.rotate(radians(90));
  if (!isEye) {
    canvas.rotate(radians(-90));
  }
  
  canvas.image(set.sprites[0], set.offsetX, set.offsetY, set.width * cornerScale, set.height * cornerScale);
  
  if (isEye) {
    canvas.image(eyeballSet.sprites[0], eyeballX * cornerScale, eyeballY * cornerScale, eyeballSet.width * cornerScale, eyeballSet.height * cornerScale);
  }
;
  canvas.popMatrix();
}
