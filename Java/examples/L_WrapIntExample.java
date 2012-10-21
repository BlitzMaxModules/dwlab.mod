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
		drawEmptyRect( -1, -1, 102, 102 );
		drawEmptyRect( 299, 249, 202, 102 );
		setColor( 0, 255, 0 );
		drawOval( wrapInt( mouseX(), 100 ) - 2, wrapInt( mouseY(), 100 ) - 2, 5, 5 );
		drawText( "L_WrapInt(" + mouseX() + ", 100)=" + wrapInt( mouseX(), 100 ), 0, 102 );
		setColor( 0, 0, 255 );
		drawOval( wrapInt2( mouseX(), 300, 500 ) - 2, wrapInt2( mouseY(), 250, 350 ) - 2, 5, 5 );
		drawText( "L_WrapInt2(" + mouseX() + ", 300, 500)=" + wrapInt2( mouseX(), 300, 500 ), 300, 352 );
		drawText( "", 0, 0 );
		setColor( 255, 255, 255 );
		printText( "L_WrapInt and L_WrapInt2 example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
