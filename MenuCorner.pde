/*********************************************************
 ***  CORNER MENU  ***************************************
 *********************************************************/

void cornerMenuSetup()
{
  cornerW = (int)(1320/scaleFactor);
  cornerH = 600;
  //cornerX = 0;
  //cornerY = 0;
  
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
  int strokeW = 3;
  cornerMenuCanvas.beginDraw();
  cornerMenuCanvas.background(255, 255, 255, 0);

  cornerMenuCanvas.stroke(color(0));
  cornerMenuCanvas.strokeWeight(strokeW);
  cornerMenuCanvas.fill(255, 255, 255, 200);
  cornerMenuCanvas.rect(0, 0, cornerW-strokeW, cornerH, 3);

  //PVector previewMargin = new PVector (50, 50);
  //float marginX = 25;
  float marginY = cornerW/10;
  float textHeight = marginY * 1.5;
  float x = cornerW/2;
  float y = textHeight;
  //PVector location = new PVector(marginX, previewMargin.y); // margin



  // "Choose Stamps"
  cornerMenuCanvas.fill(255, 0, 0);
  cornerMenuCanvas.textFont(fjordFont);
  cornerMenuCanvas.textSize(28);
  cornerMenuCanvas.textAlign(CENTER);
  cornerMenuCanvas.text("Choose", x, y);
  y += textHeight;
  cornerMenuCanvas.text("Stamps", x, y);
  y += marginY;
  
  cornerMenuCanvas.blendMode(MULTIPLY);

  SpriteSet set = rootSets[currentRoot];
  if (set != null) {
    y += set.width/2;
    //x += set.height/2;
    x = cornerW/2;
    drawCurrentTools(set, x, y);
    y += set.width/2;
  }

  set = segmentSets[currentSegment];
  if (set != null) {
    int loops = 3;
    if (set.stretchy) {
      loops = 1;
    }
    for (int i=0; i<loops; i++) {
      y += set.armSegmentDistance/2;
      drawCurrentTools(set, x, y);
      y += set.armSegmentDistance/2;
    }
  }

  set = tipSets[currentTip];
  if (set != null) {
    if (!set.name.contains("hand")) {
      y += set.width/2;
    }
    drawCurrentTools(set, x, y);
    //location.y -= set.width/2;

    if (set.name.contains("eye"))
    {
      cornerMenuCanvas.image(eyeballSet.sprites[0], x - eyeballX, y - eyeballY);
    }
    y += set.width/2 + marginY;

    if (set.name.contains("hand")) {
      y += set.width/2;
    }
  }
  cornerMenuCanvas.endDraw();

  cornerH = (int)y;
  cornerY = constrain(cornerY, 0, height - cornerH);

  image(cornerMenuCanvas, cornerX, cornerY);

}

void drawCurrentTools(SpriteSet set, float x, float y)
{
  PGraphics canvas = cornerMenuCanvas;
  canvas.blendMode(MULTIPLY);
  canvas.imageMode(CENTER); // use image center instead of top left
  canvas.pushMatrix(); // remember current drawing matrix
  canvas.translate(x, y);
  //canvas.rotate(radians(90));
  if (!set.name.contains("eye"))
  {
    canvas.rotate(radians(90));
  }
  canvas.image(set.sprites[0], set.offsetX, set.offsetY);
  canvas.popMatrix();
}
