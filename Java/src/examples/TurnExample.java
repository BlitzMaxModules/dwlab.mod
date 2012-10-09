package examples;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.shapes.sprites.Sprite;
import dwlab.visualizers.Visualizer;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final double turningSpeed = 90;

	public Sprite tank = Sprite.fromShape( 0, 0, 2, 2, Sprite.rectangle, 0, 5 );

	public void init() {
		initGraphics();
		tank.visualizer = Visualizer.fromFile( " incbintank .png" );
	}

	public void logic() {
		if( keyDown( key_Left ) ) tank.turn( -turningSpeed );
		if( keyDown( key_Right ) ) tank.turn( turningSpeed );
		if( keyDown( key_Up ) ) tank.moveForward();
		if( keyDown( key_Down ) ) tank.moveBackward();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		tank.draw();
		drawText( "Press arrow keys to move tank", 0, 0 );
		printText( "Turn, MoveForward, MoveBackward example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
