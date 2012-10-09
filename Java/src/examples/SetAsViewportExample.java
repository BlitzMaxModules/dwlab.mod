package examples;
import java.lang.Math;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.shapes.Shape;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.sprites.Sprite;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final int spritesQuantity = 100;

	public Layer layer = new Layer();
	public Shape rectangle = Sprite.fromShape( 0, 0, 30, 20 );

	public void init() {
		cursor = Sprite.fromShape( 0, 0, 8, 6 );
		for( int n = 1; n <= spritesQuantity; n++ ) {
			Sprite sprite = Sprite.fromShape( Math.random( -13, 13 ), Math.random( -8, 8 ), , , Sprite.oval, Math.random( 360 ), Math.random( 3, 7 ) );
			sprite.visualizer.setRandomColor();
			layer.addLast( sprite );
		}
		initGraphics();
	}

	public void logic() {
		for( Sprite sprite : layer ) {
			sprite.moveForward();
			sprite.bounceInside( rectangle );
		}
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		cursor.setAsViewport();
		layer.draw();
		rectangle.drawContour( 2 );
		currentCamera.resetViewport();
		cursor.drawContour( 2 );
		printText( "SetAsViewport, ResetViewport example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
