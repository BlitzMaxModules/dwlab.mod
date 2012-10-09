package examples;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.shapes.maps.DoubleMap;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final int mapSize = 128;
	public final double mapScale = 4.0;
	public final double picScale = 5.0;

	public DoubleMap doubleMap = DoubleMap.create( mapSize, mapSize );

	public void init() {
		initGraphics();
		setClsColor( 0, 0, 255 );
		float array[][][] = [ [ [ 0.0, -7.0, 5.0 ], [ 0.0, -1.5, 7.0 ], [ -4.0, -3.0, 2.0 ], [ 4.0, -3.0, 2.0 ], [ 0.0, 6.0, 9.0 ] ], 
				[ [ 0.0, -7.0, 1.5 ], [ -1.0, -8.0, 1.0 ], [ 1.0, -8.0, 1.0 ], [ 0.0, -3.5, 1.0 ], [ 0.0, -2.0, 1.0 ], [ 0.0, -0.5, 1.0 ] ] ];
		for( int col = 0; col <= 1; col++ ) {
			for local float shape[] = eachin array[ col ];
				doubleMap.drawCircle( shape[ 0 ] * picScale + 0.5 * mapSize, shape[ 1 ] * picScale + 0.5 * mapSize, 0.5 * shape[ 2 ] * picScale, 1.0 - 0.7 * col );
			}
		}
	}

	public void logic() {
		if( keyHit( key_Space ) ) doubleMap.blur();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		setScale( mapScale, mapScale );
		drawImage( doubleMap.toNewImage().bMaxImage, 400, 300 );
		setScale( 1, 1 );
		drawText( "Press space to blur map", 0, 0 );
		printText( "DrawCircle, Blur example", 0, 12, Align.toCenter, Align.toBottom );
	}

	public void deInit() {
		setClsColor( 0, 0, 0 );
	}
}
