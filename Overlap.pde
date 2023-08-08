/********************************************************
 ***  OVERLAP / COLLISION  ******************************
 *********************************************************/

// Does a point overlap an opaque part of a canvas?
boolean overlaps(PGraphics canvas, int x, int y)
{
  color mouseColor = canvas.get(x, y);
  return (mouseColor < 0);
}

boolean overlaps(PGraphics canvas, PVector v)
{
  return overlaps(canvas, (int)v.x, (int)v.y);
}

boolean overlaps(PGraphics canvas)
{
  return overlaps(canvas, mouseX, mouseY);
}

boolean overlaps()
{
  return (overlaps(rootCanvas) || overlaps(segmentCanvas) || overlaps(tipCanvas));
}

Block findOverlappingBlock()
{
    if (overlaps(rootCanvas)) {
      return nearestBlock(rootBlocks);
    } 
    else if (overlaps(tipCanvas)) {
      return nearestBlock(tipBlocks);
    } 
    else if (overlaps(segmentCanvas)) {
      return nearestBlock(segmentBlocks);
    }
    
    return null;
}


// Find Nearest Block
Block nearestBlock(ArrayList<Block> blocks)
{
  Block returnBlock = null;
  float distSq = width * width;

  for (Block block : blocks) {
    float newDistSq = findDistSq(mouseX, mouseY, block.y, block.y);
    if (newDistSq < distSq) {
      distSq = newDistSq;
      returnBlock = block;
    }
  }
  return returnBlock;
}


Block findOverlappingBlock(ArrayList<Block> blocks, float safeZone)
{
  // safeZone is a multiplier to the block's width & height
  for (Block block : blocks) {
    float minX = block.x - block.width/scaleFactor * safeZone;
    float maxX = block.x + block.width/scaleFactor * safeZone;
    float minY = block.y - block.height/scaleFactor * safeZone;
    float maxY = block.y + block.height/scaleFactor * safeZone;
    //print ("Block " + i + " x(" + minX + ", " + maxX + "), y(" + minY + ", " + maxY + ") \n");

    if (mouseX > minX && mouseX < maxX && mouseY > minY && mouseY < maxY) {
      //print ("Trying to draw within a block \n");
      return block;
    }
  }
  //print ("Not inside a block \n");
  return null;
}


boolean isOverlappingBlocks(ArrayList<Block> blocks, float safeZone)
{
  Block block = findOverlappingBlock(blocks, safeZone);
  if (block != null) {
    return true;
  }
  
  return false;
}