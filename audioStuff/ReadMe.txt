Audio Stuff
-----------

To add real-time audio to your application, do the following:

1. Add mo_audio.h, mo_audio.mm, and mo_def.h to the project. 

2. Add AudioToolbox.framework and CoreAudio.framework to the project. 

3. Call MoAudio::init and MoAudio::start at application launch. 

4. Supply an audio callback to MoAudio::start, within which you will write your audio synthesis code. 

