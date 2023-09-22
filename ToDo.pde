/*********************************************************
 ***  TO DO   ********************************************
 *********************************************************
 
 404 TODO
 [ ] Must double-click to push a button.
 [ ] Attract Mode - finger that drags on screen to entice participants
     [X] Quick test - Attract state, with canvas that says "Attract Mode"
     [X] Attract mode Pressing mouse will select random blocks
 [ ] Touch/Mouse mode - fix the UI
 [ ] Choose menu - needs to "feel" better - on the right side of screen?
 [ ] Export animated gif to web for QR code to retrieve?
 [X] Reworked Menu Bar with MenuBarButton class
 [ ] FEATURE - add Sound to all stamps!
 
 TODO
 [ ] DEBUG - Dragging off Root will not stamp it to RootCanvas? Only mouse up.
 [ ] Preview is glitched -- make it so preview canvas only shows when mouse is down? NOPE - did not work
 [-] Buttons at bottom should be clickable (as well as selected by key)
 [-] Menu must be mouse driven (click on UI buttons)
 [ ] START SCREEN - instructions?
 [ ] UI that shows current tool & lets user select CHOICE
 [ ] can eyeball move around???
 [ ] better algorithm for eyeball placement re: eye block
 [ ] Stretchy Arms are not drawing correctly
 [ ] Optimize for multiple users on touch screen
 [ ] In Mouse Auto mode, User can left-click on Eye Block to preview/place Black Eyeball
 [ ] Store last move in a temp PGraphics so it can be undone?
 [ ] Store Arms in separate ArrayLists within a larger array. ArrayList of ArrayLists, each is a single arm
 [ ] Undo for a specific arm if it sucks?
 [ ] Record animation as data & play it back procedurally
 [ ] If you record animation, you can have it draw to Hi-Res in separate process
 [ ] Choose ScaleFactor -- make slider or other selector
 
 DONE
 [X] Eyeball should have an auto-place function
 [X] Eye tip should randomly rotate 100 degrees R or L before stamping
 [X] Eye tip (all tips?) should have a randomizer for rotation - weighted toward center
 [X] Animate at correct animationRate
 [X] Tip random rotate/flip is messed up -- it's doing random rotate instead of flip
 [X] OK to draw on top of existing block!
 [X] When you drag off central block, start segmenting
 [X] Mouse Auto is broken? -- it only works once one has been started
 [X] Previous Settings can be stored in a User Settings text file?
 [X] Added Eye Block & Eyeball segments
 [X] If user right-clicks on Eye Block & it's active, preview/place Black Eyeball instead
 [X] Stretchy segments should anchor to lastPoint instead of centerPoint
 [X] Preview the root/segment/tip combo in Choice menu
 [X] Also store a hi-res canvas that you print to a file at the end
 [X] Added AOTM mode, with different size, scaleFactor, and guides
 [X] Choice Menu redesign so that buttons flow to new line if width = too small
 [X] Erase keeps your choices instead of simply resetting the entire project
 [X] Two-mouse-button mode, where left-click/drag creates segments, and right-click/drag creates tips
 [X] Put random NSEW back into Root Rotation
 [X] Find a way to distinguish between segment & full arm -- maybe segment multiplier = 0. Nope, a "stretchy" boolean
 [X] Preview when Waiting To Segment / Segmenting
 [X] With long arms, scale based on length of mouse drag
 [X] Added red line & long arm blocks
 [X] Added 2 new arm segments
 [X] Root Preview implemented
 [X] Menu Buttons are now in horizontal rows
 [X] implemented red segment, black block, black hands
 [X] Organized into tabs for less scrolling insanity
 [X] AAAAARGH! *** Hand often draws at crazy angle! -- FIXED - it was in the random scale x
 [X] Store rotations in block data
 [X] Store the time in frames in block data
 [X] Random Selection of hands & blocks
 [X] Random flip of hands (right/left)
 [X] Draw circle at each mouse point for Debug
 [X] Draw connecting lines for debug
 [X] More careful rotation/placement of segments? Rotate from back end?
 [X] Determine rotation in its own method before the stamp method
 [X] Very slight random rotation for middle blocks
 [X] Random sprite selection is now in Stamp
 [X] Added 3 frameCanvases for animation
 [X] Stamp to frameCanvas instead of directly to screen
 [X] UI now displays above animated frames
 [X] Updated UI to display active modes, and to hide itself
 [X] Create & implement SpriteSet class
 [X] When Animating -- Print 3 frames for Center & Hand but only 1 for Arm Segment
 [X] Animation - more efficient way to stamp multiple frames
 [X] Fix animation timing - 12 frames at beginning, end, and hand stamp
 [X] For arms, calculate a centerPoint for storage in array
 [X] Added eyes as possible end -- and calculated angle & placement
 [X] Added "name" attribute to spriteSet to help determine placement
 [X] Optimized SpriteSet.loadSprites for later use
 [X] Add beginSpriteSet, segmentSpriteSet, endSpriteSet as references - to prepare for selection menu
 [X] Add choiceCanvas - to contain choices for Begin, Middle, End
 [X] Added State enum to track what the mouse is actually doing
 [X] Renamed Root, Segment, Tip
 [X] Root only stamps when you let go of mouse -- unpredictable positioning otherwise.
 [-] When extending segment, figure out if it's closer to beginning or end -- nope
 [X] Prepare other options for blocks, arms, etc.
 [X] A bunch of methods are modifying lastPoint, centerPoint, targetPoint. Gotta fix that!
 [X] A way to select the type of block, line segment, end
 [X] Detect overlapCanvas based on pixel color -- honestly not quite sure WHY it works to check if color < 0, but OK...
 [X] in IsOverlapping method -- rotate the collision detection in its own matrix? Or just keep a sloppy box collider?
 https://joshuawoehlke.com/detecting-clicks-rotated-rectangles/
 Maybe... if simple xy check shows that it's within w+h of center, then do a more specific check
 b = block;
 if (mouseX > b.x-b.w-b.h && mouseX < b.x+b.w+b.h && etc.) {complexCollisionCheck;}
 
 *************************************************/
