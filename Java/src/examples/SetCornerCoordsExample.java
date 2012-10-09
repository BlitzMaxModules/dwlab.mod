package examples;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.shapes.sprites.Sprite;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public Sprite rectangle = Sprite.fromShape( 0, 0, 8, 6 );

	public void init() {
		initGraphics();
	}

	public void logic() {
		rectangle.setCornerCoords( cursor.x, cursor.y );
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		rectangle.draw();
		printText( "SetCornerCoords example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
