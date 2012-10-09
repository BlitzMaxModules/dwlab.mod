package examples;
import dwlab.base.Align;
import dwlab.base.Project;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public String word;

	public void init() {
		initGraphics();
	}

	public void logic() {
		if( intInLimits( mouseX(), 200, 600 ) ) word = ""; else word = "not ";
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		setColor( 255, 0, 0 );
		drawLine( 200, 0, 200, 599 );
		drawLine( 600, 0, 600, 599 );
		setColor( 255, 255, 255 );
		drawText( mouseX() + " is " + word + "in limits of [ 200, 600 ]", 0, 0 );
		drawOval( mouseX() - 2, mouseY() - 2, 5, 5 );
		printText( "L_IntInLimits example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
