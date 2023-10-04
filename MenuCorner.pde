/*********************************************************
 ***  CORNER MENU  ***************************************
 *********************************************************/
 
 void drawCornerMenu()
 {
     // Draw preview of root/segment/tip
  int strokeW = 3;
  cornerMenuCanvas.beginDraw();
  cornerMenuCanvas.background(255, 255, 255, 0);
    
  cornerMenuCanvas.stroke(color(0));
  cornerMenuCanvas.strokeWeight(strokeW);
  cornerMenuCanvas.fill(255);
  cornerMenuCanvas.rect(0, 0, choiceMenuOffsetX-strokeW, cornerMenuHeight, 3);
  
  //cornerMenuCanvas.fill(color(255));
  //cornerMenuCanvas.stroke(color(0));
  //cornerMenuCanvas.strokeWeight(strokeW);
  //cornerMenuCanvas.rect(0, choiceMenuOffsetY, choiceMenuOffsetX-strokeW, cornerMenuHeight-strokeW, 3);
  
  
  cornerMenuCanvas.fill(255, 0, 0);
  cornerMenuCanvas.textFont(fjordFont);  
  cornerMenuCanvas.textSize(28);

  //PVector previewMargin = new PVector (50, 50);
  //float marginX = 25;
  float marginY = 25;
  float textHeight = marginY + 10;
  float x = choiceMenuOffsetX/2;
  float y = textHeight;
  //PVector location = new PVector(marginX, previewMargin.y); // margin
  
  cornerMenuCanvas.textAlign(CENTER);
  //cornerMenuCanvas.text("StampSketch", x, y);
  //y += textHeight;
  cornerMenuCanvas.text("Options", x, y);
  y += marginY;

  SpriteSet set = rootSets[currentRoot];
  if (set != null) {
    y += set.width/2;
    //x += set.height/2;
    x = choiceMenuOffsetX/2;
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
  
  
  cornerMenuHeight = (int)y;

 
 image(cornerMenuCanvas, 0, 0);
 
   //for (int i=0; i<sets.length; i++) {
  //  SpriteSet set = sets[i];
  //  if (set != null) {
  //    if (i==0) {
  //      location.x -= set.height/2;
  //    }
  //    location.y -= set.width/2;
  //    //stampToCanvas(choiceCanvas, location, sets[i], 0, 0, 1);
  //    // WTF -- this is causing buttons to shift?
  //    drawCurrentTools(set, location);

  //    location.y -= sets[i].width/2;
  //  }
  //}
 
  //image(previewCanvas, 0, 0);
}
 
 void drawCurrentTools(SpriteSet set, float x, float y)
{
  PGraphics canvas = cornerMenuCanvas;
  canvas.blendMode(MULTIPLY);
  canvas.imageMode(CENTER); // use image center instead of top left
  canvas.pushMatrix(); // remember current drawing matrix
  canvas.translate(x, y);
  //canvas.rotate(radians(90));
  if (set.name != "eye red" && set.name != "eye black")
  {
    canvas.rotate(radians(90));
  }
  canvas.image(set.sprites[0], set.offsetX, set.offsetY);
  canvas.popMatrix();
}
