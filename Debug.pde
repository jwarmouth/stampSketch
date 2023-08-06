void stampToDebug()
{
  debugCanvas.beginDraw();
  debugCanvas.clear();
  debugCanvas.fill(255, 255, 0);
  debugCanvas.line(lastPoint.x, lastPoint.y, targetPoint.x, targetPoint.y);

  //circle(mouseX, mouseY, 10);

  debugCanvas.fill(255, 0, 0); // Red
  debugCanvas.circle(lastPoint.x, lastPoint.y, 10);
  //circle(targetPoint.x, targetPoint.y, 5);

  debugCanvas.fill(0, 255, 0); // Green
  debugCanvas.circle(centerPoint.x, centerPoint.y, 10);

  debugCanvas.fill(0, 0, 255); // Blue
  debugCanvas.circle(targetPoint.x, targetPoint.y, 10);

  debugCanvas.endDraw();
}


void drawDebug()
{
  if (debugging)
  {
    image(debugCanvas, 0, 0);
  }
}
