/*********************************************************
 ***  USER PREFS     *************************************
 *********************************************************/
 
 void loadPrefs()
{
    // Open the file from the createWriter() example
    // https://processing.org/reference/createReader_.html
  BufferedReader reader = createReader("prefs/prefs.txt");
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line, TAB);
      currentRoot = int(pieces[0]);
      currentSegment = int(pieces[1]);
      currentTip = int(pieces[2]);
      mouseAutoTip = boolean(pieces[3]);
      cornerX = int(pieces[4]);
      cornerY = int(pieces[5]);
      // root
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}

void savePrefs()
{
  PrintWriter prefsFile = createWriter("prefs/prefs.txt");
  prefsFile.println(currentRoot + "\t" + currentSegment + "\t" + currentTip + "\t" + str(mouseAutoTip) + "\t" + cornerX + "\t" + cornerY);
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
