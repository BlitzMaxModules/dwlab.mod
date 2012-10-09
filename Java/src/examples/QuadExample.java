package examples;

import org.lwjgl.LWJGLException;
import org.lwjgl.opengl.Display;
import org.lwjgl.opengl.DisplayMode;
import org.lwjgl.opengl.GL11;
 
public class QuadExample {
 
    public void start() {
        try {
	    Display.setDisplayMode(new DisplayMode(800,600));
	    Display.create();
	} catch (LWJGLException e) {
	    e.printStackTrace();
	    System.exit(0);
	}
 
	// init OpenGL
	GL11.glMatrixMode(GL11.GL_PROJECTION);
	GL11.glLoadIdentity();
	GL11.glOrtho(0, 800, 0, 600, 1, -1);
	GL11.glMatrixMode(GL11.GL_MODELVIEW);
 
	float x = 0, y = 0;
	float xx =600, yy = 0;
	
	while (!Display.isCloseRequested()) {
	    // Clear the screen and depth buffer
	    GL11.glClear(GL11.GL_COLOR_BUFFER_BIT | GL11.GL_DEPTH_BUFFER_BIT);	
		
	    // set the color of the quad (R,G,B,A)
	    GL11.glColor3f(0.5f,0.5f,1.0f);
	    	
	    // draw quad
	    GL11.glBegin(GL11.GL_QUADS);
	        GL11.glVertex2f( x +xx,y + yy);
		GL11.glVertex2f(x +xx+200,y + yy);
		GL11.glVertex2f(x +xx+200,y + yy+200);
		GL11.glVertex2f(x +xx,y + yy+200);
	    GL11.glEnd();
 
		y = y + 1;
			
	    Display.update();
	}
 
	Display.destroy();
    }
 
    public static void main(String[] argv) {
        QuadExample quadExample = new QuadExample();
        quadExample.start();
    }
}