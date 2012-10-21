package examples;
import dwlab.shapes.maps.TileMap;
import dwlab.base.Image;
import dwlab.base.Project;
import dwlab.shapes.sprites.Sprite;
import dwlab.shapes.maps.TileSet;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final int tileMapWidth = 64;
	public final int tileMapHeight = 64;

	public TileMap tileMap = TileMap.create( TileSet.create( Image.fromFile( " incbintiles .png", 8, 4 ) ), tileMapWidth, tileMapHeight );
	public Sprite cursor = Sprite.fromShape( 0, 0, 0.5, 0.5, Sprite.oval );
	public double z, double baseK;

	public void init() {
		initGraphics();
		tileMap.setSize( tileMapWidth * 2, tileMapHeight * 2 );
		for( int y = 0; y <= tileMapHeight; y++ ) {
			for( int x = 0; x <= tileMapWidth; x++ ) {
				tileMap.setTile( x, y, rand( 1, 31 ) );
			}
		}
		cursor.visualizer.setColorFromHex( "FFBF7F" );
		baseK = currentCamera.k;
	}

	public void logic() {
		cursor.moveUsingArrows( 10.0 );
		currentCamera.shiftCameraToShape( cursor, 10.0 );

		if( keyDown( key_A ) ) z += perSecond( 8.0 );
		if( keyDown( key_Z ) ) z -= perSecond( 8.0 );
		currentCamera.alterCameraMagnification( z, baseK, 8.0 );

		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		tileMap.draw();
		cursor.draw();
		drawText( "Shift cursor by arrow keys and alter magnigication by A and Z keys.", 0, 0 );
		String message = "LTCamera, AlterCameraMagnification, ShiftCameraToShape example";
		drawText( message, 400 - 4 * len( message ), 584 );
	}
}
