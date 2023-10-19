/*********************************************************
 ***  INPUT / KEYS     ***********************************
 *********************************************************/

void keyReleased()
{
  switch(key) {
  case 'C':
  case 'c':
    toggleChoiceMenu();
    break;

  case ENTER:
  case RETURN:
    hideChoiceMenu();
    break;

  case 'S':
  case 's':
    saveHiResImage();
    break;

  case 'R':
  case 'r':
    toggleRecording();
    break;

  case 'D':
  case 'd':
    toggleDebug();
    break;

  case 'P':
  case 'p':
    togglePreview();
    break;

  case 'M':
  case 'm':
    toggleMouseAuto();
    break;

  case 'Z':
  case 'z':
    cancel();
    break;

  case 'X':
  case 'x':
    saveAndEraseScreen();
    break;

  case 'U':
  case 'u':
    menuBarToggle();
    break;

  case 'A':
  case 'a':
    toggleAnimating();
    break;

  case '1':
  case '2':
  case '3':
    int selectedFrame = (int)key - 48;
    //print (selectedFrame + " was selected");
    selectCanvasFrame(selectedFrame - 1);
    break;

  default:
    break;
  }
  //if (key == 'C' || key == 'c') toggleMenu();
  //if (key == 'S' || key == 's') saveImage();
  //if (key == 'R' || key == 'r') toggleRecording();
  //if (key == 'D' || key == 'd') debugging = !debugging;
  //if (key == 'P' || key == 'p') showPreview = !showPreview;
  //if (key == 'X' || key == 'x') setup();
  //if (key == 'U' || key == 'u') showUI = !showUI;
  //if (key == 'A' || key == 'a') animating = !animating;
  //if (key == '1' || key == '2' || key == '3') displayCanvasFrame((int)key - 1);
}

void cancel()
{
 clearPreview();
 state = State.WAITING; 
}

void toggleAnimating()
{
  animating = !animating;
}
