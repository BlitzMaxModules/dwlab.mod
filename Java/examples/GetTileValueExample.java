package examples;
import dwlab.base.Align;
import dwlab.shapes.maps.TileMap;
import dwlab.base.Image;
import dwlab.base.Project;
import dwlab.shapes.maps.TileSet;
import dwlab.visualizers.Visualizer;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final int tileMapWidth = 16;
	public final int tileMapHeight = 12;

	public TileMap tileMap = TileMap.create( TileSet.create( Image.fromFile( " incbintiles .png", 8, 4 ) ), tileMapWidth, tileMapHeight );

	public void init() {
		initGraphics();
		tileMap.setSize( tileMapWidth * 2, tileMapHeight * 2 );
		tileMap.visualizer = new LighntingVisualizer();
	}

	public void logic() {
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		tileMap.draw();
		printText( "GetTileValue example", 0, 12, Align.toCenter, Align.toBottom );
	}
}

public class LighntingVisualizer extends Visualizer {
	public final double radius = 4;

	public int getTileValue( TileMap tileMap, int tileX, int tileY ) {
		x0, y0;
		tileMap.getTileForPoint( cursor.x, cursor.y, x0, y0 );
		if( distance( tileX - x0, tileY - y0 ) <= radius ) return 18; else return 26;
	}
}
