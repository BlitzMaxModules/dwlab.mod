package examples;
import dwlab.base.Project;
import dwlab.shapes.Shape;
import dwlab.shapes.sprites.VectorSprite;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.Line;
import dwlab.visualizers.ContourVisualizer;
import dwlab.shapes.sprites.Sprite;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final double gravity = 10.0;

	public Layer layer = new Layer();
	public Shape rectangle = Sprite.fromShape( 0, 0, 30, 20 );

	public void init() {
		VectorSprite pivots[] = new VectorSprite()[ 4 ];
		for( int y = 0; y <= 1; y++ ) {
			for( int x = 0; x <= 1; x++ ) {
				pivots[ x + y * 2 ] = VectorSprite.fromShapeAndVector( x * 2 - 1, y * 2 - 1, 0.3, 0.3, Sprite.rectangle );
				layer.addLast( pivots[ x + y * 2 ] );
			}
		}
		for( int n = 0; n <= 2; n++ ) {
			for( int m = n + 1; m <= 3; m++ ) {
				Spring spring = Spring.fromPivotsAndResistances( pivots[ n ], pivots[ m ] );
				spring.visualizer = ContourVisualizer.fromWidthAndHexColor( 0.3, "FF0000" );
				layer.addLast( spring  );
			}
		}

		pivots[ 0 ].dX = 5.0;

		rectangle.visualizer = ContourVisualizer.fromWidthAndHexColor( 0.1, "FF0000" );

		initGraphics();
	}

	public void logic() {
		for( VectorSprite pivot : layer ) {
			pivot.dY += perSecond( gravity );
			pivot.moveForward();
			pivot.bounceInside( rectangle );
		}
		layer.act();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		rectangle.draw();
		layer.draw();
	}
}

public class Spring extends Line {
	public double movingResistance[] = new double()[ 2 ];
	public double distance;

	public static Spring fromPivotsAndResistances( Sprite pivot1, Sprite pivot2, double pivot1movingResistance = 0.5, double pivot2movingResistance = 0.5 ) {
		Spring spring = new Spring();
		spring.pivot[ 0 ] = pivot1;
		spring.pivot[ 1 ] = pivot2;
		spring.movingResistance[ 0 ] = pivot1movingResistance;
		spring.movingResistance[ 1 ] = pivot2movingResistance;
		spring.distance = pivot1.distanceTo( pivot2 );
		return spring;
	}

	public void act() {
		VectorSprite pivot0 = VectorSprite( pivot[ 0 ] );
		VectorSprite pivot1 = VectorSprite( pivot[ 1 ] );
		double k = 1.0 - distance / pivot0.distanceTo( pivot1 );
		pivot0.dX += deltaTime * 20.0 * ( pivot1.x - pivot0.x ) * k;
		pivot0.dY += deltaTime * 20.0 * ( pivot1.y - pivot0.y ) * k;
		pivot1.dX -= deltaTime * 20.0 * ( pivot1.x - pivot0.x ) * k;
		pivot1.dY -= deltaTime * 20.0 * ( pivot1.y - pivot0.y ) * k;
	}
}
