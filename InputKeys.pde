/********************************************************
 ***  INPUT / KEYS     ***********************************
 *********************************************************/
void keyReleased()
{
  switch(key) {
  case 'C':
  case 'c':
    toggleMenu();
    break;

  case ENTER:
  case RETURN:
    hideMenu();
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
    debugging = !debugging;
    break;

  case 'P':
  case 'p':
    showPreview = !showPreview;
    break;

  case 'M':
  case 'm':
    mouseAutoTip = !mouseAutoTip;
    savePrefs();
    break;

  case 'Z':
  case 'z':
    clearPreview();
    state = State.WAITING;
    break;

  case 'X':
  case 'x':
    eraseScreen();
    break;

  case 'U':
  case 'u':
    showUI = !showUI;
    break;

  case 'A':
  case 'a':
    animating = !animating;
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
