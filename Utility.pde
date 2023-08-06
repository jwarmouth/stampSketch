/********************************************************
 ***  UTILITY  *****************************************
 *********************************************************/


// Find TargetPoint if mouse is far enough from LastPoint
boolean findTargetCenterPoints(float distance)
{
  // Check to see if current x,y is beyond threshold distance away from lastX, lastY
  // find vector from lastXY to mouseXY
  PVector toTarget = new PVector(mouseX - lastPoint.x, mouseY - lastPoint.y);

  if (toTarget.magSq() > sq(distance))
  {
    toTarget.limit(distance/2);
    centerPoint = PVector.add(lastPoint, toTarget);
    targetPoint = PVector.add(centerPoint, toTarget);
    targetAngle = angleLastToTarget();
    return true;
  } else
  {
    toTarget.limit(distance/2);
    centerPoint = PVector.add(lastPoint, toTarget);
    targetPoint = PVector.add(centerPoint, toTarget);
    targetAngle = angleLastToTarget();
    return false;
  }
  // targetXY is stampLength distance along that vector
}

void findPointsOutsideBlock()
{
  targetPoint = new PVector(mouseX, mouseY);
  PVector toCenter = PVector.sub(lastPoint, targetPoint);
  toCenter.limit(20);    // Start a TEENY bit back toward the center of lastRoot
  lastPoint = PVector.add(targetPoint, toCenter);
  lastAngle = angleToMouse(lastPoint);
}

boolean isSegmentFarEnough(float distance)
{
  // Check to see if current x,y is beyond threshold distance away from lastX, lastY
  return lastPointToMouse().magSq() > sq(distance);
}

PVector lastPointToMouse()
{
  return new PVector(mouseX - lastPoint.x, mouseY - lastPoint.y);
}

float distanceLastPointToMouse()
{
  return lastPointToMouse().mag();
}

void calculateCenterAndTarget(float distance)
{
  PVector lastPointToMouse = lastPointToMouse();

  if (segmentSets[currentSegment].stretchy)
  {
    float mag = lastPointToMouse.mag();
    if (distance > mag) {
      distance = mag;
    }
  }

  lastPointToMouse.limit(distance/2);

  centerPoint = PVector.add(lastPoint, lastPointToMouse);
  targetPoint = PVector.add(centerPoint, lastPointToMouse);
  targetAngle = angleLastToTarget();

  // targetXY is stampLength distance along that vector
}

float segmentScale(SpriteSet set)
{
  float scaleX = 1;

  if (set.stretchy)
  {
    float distanceFromLastPointToMouse = distanceLastPointToMouse();
    if (distanceFromLastPointToMouse < set.width)
    {
      scaleX = distanceFromLastPointToMouse / set.width;
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
  switch(set.name)
  {
  case "hand-red":
  case "hand-black":
    centerPoint = PVector.add(lastPoint, PVector.fromAngle(lastAngle, targetPoint));
    break;

    //case "swab":
    //  centerPoint = PVector.add(lastPoint,  PVector.fromAngle(lastAngle, targetPoint));
    //  break;

  default:
    centerPoint = PVector.add(lastPoint, PVector.mult(PVector.fromAngle(lastAngle), set.width/2));
    break;
  }
}


// Left Hand or Right Hand?
SpriteSet rightOrLeftHand(SpriteSet set)
{
  int whichSet = tipFlip;
  if (whichSet == -1) {
    whichSet = 0;
  }
  print (set.name + " " + whichSet);
  if (set.name == "hand-red") {
    return handRedSets[whichSet];
    //return handRedSets[(int)random(handRedSets.length)];
  } else if (set.name == "hand-black") {
    return handBlackSets[whichSet];
    //return handBlackSets[(int)random(handBlackSets.length)];
  }
  return set;
}
