/*********************************************************
 ***  UTILITY  *******************************************
 *********************************************************/

// Find TargetPoint if mouse is far enough from LastPoint
boolean findTargetCenterPoints(float distance)
{
  PVector toTarget = new PVector(mouseX - lastPoint.x, mouseY - lastPoint.y);

  toTarget.limit(distance/2);
  centerPoint = PVector.add(lastPoint, toTarget);
  targetPoint = PVector.add(centerPoint, toTarget);
  targetAngle = angleLastToTarget();
  return (toTarget.magSq() > sq(distance));


  // Check to see if current x,y is beyond threshold distance away from lastX, lastY
  // find vector from lastXY to mouseXY
  // targetXY is stampLength distance along that vector
}

void mouseToVector(PVector v)
{
  v.x = mouseX;
  v.y = mouseY;
}

PVector lastPointToMouse()
{
  return new PVector(mouseX - lastPoint.x, mouseY - lastPoint.y);
}

void calculateCenterAndTarget(float distance)
{
  PVector lastPointToMouse = lastPointToMouse();

  if (segmentSets[currentSegment].stretchy)
  {
    distance = max(distance, lastPointToMouse.mag());
  }

  lastPointToMouse.setMag(distance/2);

  centerPoint = PVector.add(lastPoint, lastPointToMouse);
  targetPoint = PVector.add(centerPoint, lastPointToMouse);
  lastAngle = angleLastToTarget();

  // targetXY is stampLength distance along that vector
}

boolean isSegmentFarEnough(float distance)
{
  // Check to see if current x,y is beyond threshold distance away from lastX, lastY
  return lastPointToMouse().magSq() > sq(distance);
}

float segmentScale(SpriteSet set)
{
  float scaleX = 1;

  if (set.stretchy)
  {
    float dist = lastPointToMouse().mag();
    if (dist < set.width)
    {
      scaleX = dist / set.width;
    }
  }

  return scaleX;
}


float angleToMouse(PVector vector)
{
  return atan2(mouseY - vector.y, mouseX - vector.x);
}

float angleLastToTarget()
{
  return atan2(targetPoint.y - lastPoint.y, targetPoint.x - lastPoint.x);
}

float randomRotationNSEW()
{
  // Calculate random NSEW rotation
  float randomRotation = floor(random(4)) * 90; // + random(10) - 5;
  return radians(randomRotation);
  //print ("Random Rotation: " + randomRotation + "\n");
}

int randomSignum() {
  // randomize either -1 or 1
  return (int) random(2) * 2 - 1;
}

// UTILITY - Find Distance Squared
float findDistSq(float x1, float y1, float x2, float y2)
{
  float xDist = abs(x1-x2);
  float yDist = abs(y1-y2);
  return (xDist * xDist + yDist * yDist);
}

float findDistSq(PVector v1, PVector v2)
{
  return findDistSq(v1.x, v1.y, v2.y, v2.y);
}

float findDistSq(PVector v)
{
  return findDistSq(mouseX, mouseY, v.x, v.y);
}

float findDistSq(float x, float y)
{
  return findDistSq(mouseX, mouseY, x, y);
}

void centerPointMatchesTip(SpriteSet set)
{
  if (set.name.contains("hand"))
  {
    centerPoint = lastPoint;
    //centerPoint = PVector.add(lastPoint, PVector.mult(PVector.fromAngle(lastAngle), set.width/2));
    //centerPoint = PVector.add(lastPoint, PVector.fromAngle(lastAngle, targetPoint));
    //centerPoint = PVector.add(centerPoint, PVector.fromAngle(lastAngle, targetPoint));
    //targetPoint = PVector.add(lastPoint, PVector.mult(PVector.fromAngle(lastAngle), set.width));
  } else
  {
    centerPoint = PVector.add(lastPoint, PVector.mult(PVector.fromAngle(lastAngle), set.width/2));
    //centerPoint = PVector.add(centerPoint, PVector.mult(PVector.fromAngle(lastAngle), set.width*2/3));
  }
  //switch(set.name)
  //{
  //case "hand-red":
  //case "hand-black":
  //  centerPoint = PVector.add(lastPoint, PVector.fromAngle(lastAngle, targetPoint));
  //  break;

  //  //case "swab":
  //  //  centerPoint = PVector.add(lastPoint,  PVector.fromAngle(lastAngle, targetPoint));
  //  //  break;

  //default:
  //  centerPoint = PVector.add(lastPoint, PVector.mult(PVector.fromAngle(lastAngle), set.width/2));
  //  break;
  //}
}


// Left Hand or Right Hand?
SpriteSet rightOrLeftHand(SpriteSet set)
{
  int whichSet = floor(random(2));
  /*int whichSet = tipFlip;
   if (whichSet == -1) {
   whichSet = 0;
   } */
  println("Tip Set: " + set.name + " " + whichSet);
  //if (set.name == "hand-red")
  if (set.name.contains("hand red")) 
  {
    return handRedSets[whichSet];
    //return handRedSets[(int)random(handRedSets.length)];
  } 
  //else if (set.name == "hand-black") 
  if (set.name.contains("hand-black"))
  {
    return handBlackSets[whichSet];
    //return handBlackSets[(int)random(handBlackSets.length)];
  }
  return set;
}

int scaleUI (int input)
{
  float output = input / refScale;
  return (int)output;
}
