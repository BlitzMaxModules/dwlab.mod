package examples;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.visualizers.ContourVisualizer;
import dwlab.shapes.sprites.Sprite;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public Sprite ball[] = new Sprite()[ 7 ];
	public Sprite rectangle = Sprite.fromShape( 0, 0, 22, 14 );

	public void init() {
		initGraphics();
		rectangle.visualizer = ContourVisualizer.fromWidthAndHexColor( 0.1, "FF0000" );
		for( int n = 0; n <= 6; n++ ) {
			ball[ n ] = new Sprite();
			ball[ n ].shapeType = Sprite.oval;
			ball[ n ].setDiameter( 0.5 * ( 7 - n ) );
			ball[ n ].visualizer.setRandomColor();
		}
	}

	public void logic() {
		for( int n = 0; n <= 6; n++ ) {
			ball[ n ].setMouseCoords();
		}
		ball[ 0 ].limitWith( rectangle );
		ball[ 1 ].limitHorizontallyWith( rectangle );
		ball[ 2 ].limitVerticallyWith( rectangle );
		ball[ 3 ].limitLeftWith( rectangle );
		ball[ 4 ].limitTopWith( rectangle );
		ball[ 5 ].limitRightWith( rectangle );
		ball[ 6 ].limitBottomWith( rectangle );
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		rectangle.draw();
		for( int n = 0; n <= 6; n++ ) {
			ball[ n ].draw();
		}
		drawText( "Move cursor to see how the balls are limited in movement", 0, 0 );
		printText( "Limit...With example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
