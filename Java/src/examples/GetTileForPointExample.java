package examples;
import dwlab.base.Align;
import dwlab.shapes.maps.TileMap;
import dwlab.base.Image;
import dwlab.base.Project;
import dwlab.shapes.sprites.Sprite;
import dwlab.shapes.maps.TileSet;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final int tileMapWidth = 16;
	public final int tileMapHeight = 12;

	public TileSet tileSet = TileSet.create( Image.fromFile( " incbintiles .png", 8, 4 ) );
	public TileMap tileMap = TileMap.create( tileSet, tileMapWidth, tileMapHeight );
	public Sprite cursor = Sprite.fromShape( 0, 0, 2, 2 );

	public void init() {
		initGraphics();
		tileMap.setSize( tileMapWidth * 2, tileMapHeight * 2 );
		for( int y = 0; y <= tileMapHeight; y++ ) {
			for( int x = 0; x <= tileMapWidth; x++ ) {
				tileMap.setTile( x, y, rand( 1, 31 ) );
			}
		}
		cursor.visualizer.image = tileMap.tileSet.image;
		cursor.frame = 1;
	}

	public void logic() {
		cursor.setMouseCoords();
		int tileX, int tileY;
		tileMap.getTileForPoint( cursor.x, cursor.y, tileX, tileY );
		if( tileX >= 0 && tileY >= 0 && tileX < tileMap.xQuantity && tileY < tileMap.yQuantity ) {
			if( mouseDown( 1 ) ) tileMap.setTile( tileX, tileY, cursor.frame );
			if( mouseHit( 2 ) ) cursor.setAsTile( tileMap, tileX, tileY );
		}
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		tileMap.draw();
		cursor.draw();
		drawText( "Press right mouse button to select brush, left button to draw.", 0, 0 );
		printText( "GetTileForPoint, SetTile, SetAsTile example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
