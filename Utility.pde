/********************************************************
 ***  UTILITY  *****************************************
 *********************************************************/


// Find TargetPoint if mouse is far enough from LastPoint
boolean findTargetCenterPoints(float distance)
{
  // Check to see if current x,y is beyond threshold distance away from lastX, lastY
  //if (abs(lastX - mouseX) + abs(lastY - mouseY) < armSegmentDistance) return;

  // find vector from lastXY to mouseXY
  PVector toTarget = new PVector(mouseX - lastPoint.x, mouseY - lastPoint.y);
  if (toTarget.magSq() > sq(distance))
  {
    toTarget.limit(distance/2);
    centerPoint = PVector.add(lastPoint, toTarget);
    targetPoint = PVector.add(centerPoint, toTarget);
    targetAngle = angleLastToTarget();
    return true;
  }
  return false;
  // targetXY is stampLength distance along that vector
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
