package examples;
import dwlab.base.Align;
import dwlab.base.Project;

superStrict;





public static Example example = new Example();
example.execute();

public class Example extends Project {
	public int x = 400;
	public int y = 300;

	public void init() {
		initGraphics();
	}

	public void logic() {
		if( mouseHit( 1 ) ) {
			x = mouseX();
			y = mouseY();
		}
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		drawOval( x - 2, y - 2, 5, 5 );
		drawLine( x, y, mouseX(), mouseY() );
		drawText( "Distance is " + trimDouble( distance( y - mouseY(), x - mouseX() ) ) + " pixels", 0, 0 );
		printText( "L_Distance example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
