package examples;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.shapes.sprites.Sprite;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public Sprite rectangle = Sprite.fromShape( 0, 0, 16, 12 );

	public void init() {
		initGraphics();
	}

	public void logic() {
		rectangle.setMouseCoords();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public final double textSize = 0.7;

	public void render() {
		rectangle.drawContour( 2 );

		rectangle.printText( "topleft corner", textSize, Align.toLeft, Align.toTop );
		rectangle.printText( "top", textSize, Align.toCenter, Align.toTop );
		rectangle.printText( "topright corner", textSize, Align.toRight, Align.toTop );
		rectangle.printText( "left side", textSize, Align.toLeft, Align.toCenter );
		rectangle.printText( "center", textSize, Align.toCenter, Align.toCenter );
		rectangle.printText( "right side", textSize, Align.toRight, Align.toCenter );
		rectangle.printText( "bottomleft corner", textSize, Align.toLeft, Align.toBottom );
		rectangle.printText( "bottom", textSize, Align.toCenter, Align.toBottom );
		rectangle.printText( "bottomright corner", textSize, Align.toRight, Align.toBottom );
		printText( "PrintText example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
