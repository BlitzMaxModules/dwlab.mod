package examples;
import dwlab.base.Align;
import dwlab.shapes.maps.TileMap;
import dwlab.base.Image;
import dwlab.base.Project;
import dwlab.shapes.sprites.VectorSprite;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.maps.TileSet;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final int tileMapWidth = 16;
	public final int tileMapHeight = 12;

	public TileSet tileSet = TileSet.create( Image.fromFile( " incbintiles .png", 8, 4 ) );
	public TileMap tileMap = TileMap.create( tileSet, tileMapWidth, tileMapHeight );
	public Layer pieces = new Layer();

	public void init() {
		initGraphics();
		tileMap.setSize( tileMapWidth * 2, tileMapHeight * 2 );
		for( int y = 0; y <= tileMapHeight; y++ ) {
			for( int x = 0; x <= tileMapWidth; x++ ) {
				tileMap.setTile( x, y, rand( 1, 31 ) );
			}
		}
	}

	public void logic() {
		if( mouseHit( 1 ) ) {
			int tileX, int tileY;
			tileMap.getTileForPoint( cursor.x, cursor.y, tileX, tileY );
			if( tileMap.getTile( tileX, tileY ) > 0 ) {
				Piece piece = Piece.create();
				piece.setAsTile( tileMap, tileX, tileY );
				tileMap.setTile( tileX, tileY, 0 );
			}
		}
		pieces.act();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		tileMap.draw();
		pieces.draw();
		drawText( "Click on tiles to make them fall", 0, 0 );
		printText( "SetAsTile example", 0, 12, Align.toCenter, Align.toBottom );
	}
}



public class Piece extends VectorSprite {
	public final double gravity = 8.0;

	public double startingTime = 0;
	public double angularDirection = 0;

	public static Piece create() {
		Piece piece = new Piece();
		piece.startingTime = example.time;
		piece.angularDirection = -1 + 2 * rand( 0, 1 );
		example.pieces.addFirst( piece );
		return piece;
	}

	public void act() {
		moveForward();
		angle = ( example.time - startingTime ) * 45 * angularDirection;
		dY += perSecond( gravity );
		if( topY() > example.tileMap.bottomY() ) example.pieces.remove( this );
	}
}
