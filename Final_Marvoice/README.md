# mpcs51030-2018-final-project-ruyuzhou

## View Instruction:

The Marvoice app helps users who love music to catch instant inspiration and allows users to record a sound using the device’s microphone. It also provides functionality allowing users to play the composed music or recorded sound back with some different sound modulations: super slow, superfast, high pitch, low pitch, echo and reverb. The app has 7 View Controller Scenes.

* Menu View: 
This is home page and displays three buttons which embedded in a Stack View. Those three buttons show segue to three different function pages. 

* Piano View: 
It displays seven buttons to constitute the key of a piano, each button represents a tune and continuous tapping can simulate the effect of the piano. Tapping the microphone image button will start an audio recording session, and after tapping stop button, the app should complete its recording and then push the second scene “Pitch Change View” onto the navigation stack.

* Pitch Change View:
This part has 3 buttons to play the recorded composed music with corresponding effects and 1 button to stop the playback. Tab “Back” button can return to the Piano view.

* Sound Record View: 
This view consists of a button with a microphone image, indicating the user to tap the button and an audio recording session will start. The app uses code from AVFoundation to record sounds from the microphone. After tapping the button, the record button will be disabled, and display a “Recording…” label, and present a stop button. It also allows the user the to pause the recording process. When the stop button is tabbed, the app should complete its recording and then push the second scene “Play Sounds View” onto the navigation stack.

* Play Sounds View: 
The Play Sound view has six buttons to play the recorded sound file and a button to stop the playback. At the top left of the screen, the navigation bar’s left button says “Back”. Clicking this button will pop the play sounds view off the stack and return the user to the Sound Record view.

* Sample Music
The Sample Music View uses a table view to present all the music and related information, tapping the table cell will navigate to next view scene.

* Detail View
In this view, the app uses AVFoundation and MediaPlayer to play music. During playing the play button will become stop button. Previous button and Next button can help changing songs, but when it comes to first song or last song, an alert will show up.

## Attribution

1. How to add effect like echo and reverb to audio player(chinese): https://www.jianshu.com/p/8acc016da423

2. Use timer to control when to stop: https://www.jianshu.com/p/f509bd4304e1

3. How to handle audio file: https://stackoverflow.com/questions/43256549/how-to-set-a-completionhandler-for-avaudioengine

4. Use tag attribute to distinguish which button are pressed: https://gist.github.com/dhavaln/2021993bbbbe8a9a0934

5. Adjusting rate/pitch: https://stackoverflow.com/questions/32294934/pitch-shifting-in-real-time-with-avaudioengine-using-swift

6. Creates a list of path strings for the specified directories in the specified domains: https://developer.apple.com/documentation/foundation/1414224-nssearchpathfordirectoriesindoma?language=objc

7. How to save recorded file: https://stackoverflow.com/questions/39433639/how-to-save-recorded-audio-ios

8. How to load the list of music from plist: https://stackoverflow.com/questions/39910461/how-to-read-from-a-plist-with-swift-3-ios-app