package examples;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.shapes.sprites.Sprite;
import dwlab.visualizers.Visualizer;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public Sprite ball = Sprite.fromShape( 0, 0, 3, 3, Sprite.oval, 0, 5 );

	public void init() {
		initGraphics();
		ball.visualizer = Visualizer.fromHexColor( "3F3F7F" );
		cursor = Sprite.fromShape( 0, 0, 1, 1, Sprite.oval );
		cursor.visualizer = Visualizer.fromHexColor( "7FFF3F" );
	}

	public void logic() {
		ball.moveTowards( cursor, ball.velocity );
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		ball.draw();
		cursor.draw();
		if( ball.isAtPositionOf( cursor ) ) drawText( "Ball is at position of cursor", 0, 0 );
		printText( "IsAtPositionOf, MoveTowards example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
