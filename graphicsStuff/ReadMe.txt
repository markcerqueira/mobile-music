Graphics Stuff
--------------

To add real-time OpenGL graphics to your application, do the following:

1. Add GLViewController.h, GLViewController.mm, GLViewController.xib, GLViewController~iphone.xib, Geometry.h, and Geometry.cpp to the project. 

2. Add GLKit.framework and OpenGLES.framework to the project. 

3. In the AppDelegate, instead of creating a new ViewController, create a new GLViewController. 

4. Write your rendering code in glkView:drawInRect: in GLViewController.mm. 

