/*********************************************************
 ***  USER PREFS     *************************************
 *********************************************************/
 
 void loadPrefs()
{
    // Open the file from the createWriter() example
    // https://processing.org/reference/createReader_.html
  BufferedReader reader = createReader(dataPath("prefs/prefs.txt"));
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line, TAB);
      currentRoot = int(pieces[0]);
      currentSegment = int(pieces[1]);
      currentTip = int(pieces[2]);
      attractModeDelay = int(pieces[3]);
      cornerX = int(pieces[4]);
      cornerY = int(pieces[5]);
      choiceX = int(pieces[6]);
      choiceY = int(pieces[7]);
      mouseAutoTip = boolean(pieces[8]);
      println("prefs loaded");
      // root
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}

void savePrefs()
{
  PrintWriter prefsFile = createWriter(dataPath("prefs/prefs.txt"));
  prefsFile.println(currentRoot + "\t" + currentSegment + "\t" + currentTip + "\t" + attractModeDelay + 
                    "\t" + cornerX + "\t" + cornerY + "\t" + choiceX + "\t" + choiceY+ "\t" + str(mouseAutoTip));
  prefsFile.flush();
  prefsFile.close();
  // https://processing.org/reference/createWriter_.html
}



// Prefs in order (strings, remember :)
/*
  0 currentRoot (int)
  1 currentSegment (int)
  2 currentTip (int)
  3 mouseAutoTip (boolean)
  
*/
