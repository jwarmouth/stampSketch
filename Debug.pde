/*********************************************************
 ***  DEBUG   ********************************************
 *********************************************************/

void toggleDebug()
{
  debugging = !debugging;
}

void drawDebug()
{
  if (!debugging) return;
  
  debugCanvas.beginDraw();
  debugCanvas.clear();
  debugCanvas.fill(255, 255, 0);
  debugCanvas.line(lastPoint.x, lastPoint.y, targetPoint.x, targetPoint.y);

  //circle(mouseX, mouseY, 10);

  debugCanvas.fill(255, 0, 0); // Red
  debugCanvas.circle(lastPoint.x, lastPoint.y, 10);
  debugCanvas.circle(10, 800, 10);
  debugCanvas.text("lastPoint", 20, 800);
  //circle(targetPoint.x, targetPoint.y, 5);

  debugCanvas.fill(0, 255, 0); // Green
  debugCanvas.circle(centerPoint.x, centerPoint.y, 10);
  debugCanvas.circle(10, 840, 10);
  debugCanvas.text("centerPoint", 20, 840);

  debugCanvas.fill(0, 0, 255); // Blue
  debugCanvas.circle(targetPoint.x, targetPoint.y, 10);
  debugCanvas.circle(10, 880, 10);
  debugCanvas.text("targetPoint", 20, 880);

  debugCanvas.endDraw();

  image(debugCanvas, 0, 0);
}

//void stampToDebug()
//{
//  debugCanvas.beginDraw();
//  debugCanvas.clear();
//  debugCanvas.fill(255, 255, 0);
//  debugCanvas.line(lastPoint.x, lastPoint.y, targetPoint.x, targetPoint.y);

//  //circle(mouseX, mouseY, 10);

//  debugCanvas.fill(255, 0, 0); // Red
//  debugCanvas.circle(lastPoint.x, lastPoint.y, 10);
//  //circle(targetPoint.x, targetPoint.y, 5);

//  debugCanvas.fill(0, 255, 0); // Green
//  debugCanvas.circle(centerPoint.x, centerPoint.y, 10);

//  debugCanvas.fill(0, 0, 255); // Blue
//  debugCanvas.circle(targetPoint.x, targetPoint.y, 10);

//  debugCanvas.endDraw();
//}
