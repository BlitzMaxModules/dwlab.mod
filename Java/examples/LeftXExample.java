package examples;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.shapes.sprites.Sprite;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public Sprite rectangle = Sprite.fromShape( 0, 0, 8, 6 );
	public Sprite ball = Sprite.fromShape( 0, 0, 1, 1, Sprite.oval );

	public void init() {
		initGraphics();
		rectangle.visualizer.setColorFromHex( "FF0000" );
		ball.visualizer.setColorFromHex( "FFFF00" );
	}

	public void logic() {
		rectangle.setMouseCoords();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		rectangle.draw();
		ball.setCoords( rectangle.leftX(), rectangle.y );
		ball.draw();
		ball.setCoords( rectangle.x, rectangle.topY() );
		ball.draw();
		ball.setCoords( rectangle.rightX(), rectangle.y );
		ball.draw();
		ball.setCoords( rectangle.x, rectangle.bottomY() );
		ball.draw();
		printText( "LeftX, TopY, RightX, BottomY example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
