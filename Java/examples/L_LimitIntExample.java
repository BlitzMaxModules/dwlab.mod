package examples;
import dwlab.base.Align;
import dwlab.base.Project;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public void init() {
		initGraphics();
	}

	public void logic() {
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		setColor( 255, 0, 0 );
		drawLine( 200, 0, 200, 599 );
		drawLine( 600, 0, 600, 599 );
		setColor( 255, 255, 255 );
		int x = limitInt( mouseX(), 200, 600 );
		drawOval( x - 2, mouseY() - 2, 5, 5 );
		drawText( "LimitInt(MouseX(),200,600) = " + x, 0, 0 );
		printText( "L_LimitInt example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
