package examples;
import java.lang.Math;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.shapes.LineSegment;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.sprites.Sprite;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final int spritesQuantity = 20;

	public Layer layer = new Layer();
	public LineSegment lineSegment = new LineSegment();
	public Sprite minSprite;

	public void init() {
		initGraphics();
		for( int n = 1; n <= spritesQuantity; n++ ) {
			Sprite sprite = Sprite.fromShape( Math.random( -15, 15 ), Math.random( -11, 11 ), , , Sprite.oval );
			sprite.setDiameter( Math.random( 0.5, 1.5 ) );
			sprite.visualizer.setRandomColor();
			layer.addLast( sprite );
		}
		cursor = Sprite.fromShape( 0, 0, 0.5, 0.5, Sprite.oval );
		lineSegment.pivot[ 0 ] = cursor;
	}

	public void logic() {
		minSprite = null;
		double minDistance;
		for( Sprite sprite : layer ) {
			if( cursor.distanceTo( sprite ) < minDistance || ! minSprite ) {
				minSprite = sprite;
				minDistance = cursor.distanceTo( sprite );
			}
		}
		lineSegment.pivot[ 1 ] = minSprite;

		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		layer.draw();

		lineSegment.draw();
		printText( trimDouble( cursor.distanceTo( minSprite ) ), 0.5 * ( cursor.x + minSprite.x ), 0.5 * ( cursor.y + minSprite.y ) );

		double sX, double sY;
		currentCamera.fieldToScreen( cursor.x, cursor.y, sX, sY );
		drawLine( sX, sY, 400, 300 );
		printText( trimDouble( cursor.distanceToPoint( 0, 0 ) ), 0.5 * cursor.x, 0.5 * cursor.y );

		drawText( "Direction to field center is " + trimDouble( cursor.directionToPoint( 0, 0 ) ), 0, 0 );
		drawText( "Direction to nearest sprite is " + trimDouble( cursor.directionTo( minSprite ) ), 0, 16 );
		printText( "DirectionTo, DirectionToPoint, DistanceTo, DistanceToPoint example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
