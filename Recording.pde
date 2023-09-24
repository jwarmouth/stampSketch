/*********************************************************
 ***  RECORDING  *****************************************
 *********************************************************/

void toggleRecording()
{
  if (!recording)
    startRecording();
  else
    stopRecording();
}

void startRecording()
{
  background(255);
  recording = true;
  tempName = nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  String dateTime = nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + "_" + tempName;
  clipFolder = fileName + "-" + dateTime;
  frameIndex = 0;
  //saveFrames(6); // No need for white frames at beginning.
}

void stopRecording()
{
  saveFrames(36);
  saveHiResImage();
  recording = false;
  drawMenuBar();
}

void saveHiResImage()
{
  if (!hiResEnabled) return;
  
  String imageName;
  if (recording) {
    imageName = clipFolder;
  }
  else {
    String dateTime = nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + "_" + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    imageName = fileName + "-" + dateTime;
  }
  hiResCanvas.save(saveFolder + imageName + "-hiRes" + saveHiResFormat);
  //tempName = nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  //String dateTime = nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + "_" + tempName;
  //hiResCanvas.save(saveFolder + fileName + "-" + dateTime + saveHiResFormat);
}

void saveFrames(int howManyFrames)
{
  if (!recording) return;

  for (int i=0; i < howManyFrames; i++)
  {
    canvasFrames[frameIndex%3].save(saveFolder + clipFolder + "/" + fileName + "_" + tempName + "_" + nf(frameIndex, 4) + saveFormat);
    frameIndex++;
    //saveCanvasNum = frameIndex%3;
    print ("Saved frame" + nf(frameIndex, 4) + "\n");
    print ("saveCanvasNum: " + saveCanvasNum + "\n");
  }
}

void saveThreeFrames()
{
  startRecording();
  saveFrames(3);
  
  // Stop Recording
  saveHiResImage();
  recording = false;
  drawMenuBar();
}
