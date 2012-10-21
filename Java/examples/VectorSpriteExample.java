package examples;
import dwlab.base.Align;
import dwlab.shapes.maps.TileMap;
import dwlab.base.Image;
import dwlab.base.Project;
import dwlab.shapes.Shape;
import dwlab.shapes.sprites.VectorSprite;
import dwlab.shapes.sprites.Sprite;
import dwlab.shapes.sprites.SpriteAndTileCollisionHandler;
import dwlab.shapes.maps.TileSet;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final int coinsQuantity = 100;
	public final int platformsQuantity = 100;
	public final int minPlatformLength = 3;
	public final int maxPlatformLength = 12;
	public final int mapSize = 128;

	public final int void = 0;
	public final int bricks = 1;
	public final int coin = 2;

	public Player player = Player.create();
	public TileMap tileMap = TileMap.create( TileSet.create( Image.fromFile( " incbintileset .png", 4, 1 ), 0 ), mapSize, mapSize );
	public int coins;

	public void init() {
		tileMap.setSize( mapSize, mapSize );
		for( int n = 0; n <= coinsQuantity; n++ ) {
			tileMap.value[ rand( 1, mapSize - 2 ), rand( 1, mapSize - 2 ) ] = coin;
		}
		for( int n = 0; n <= platformsQuantity; n++ ) {
			int size = rand( minPlatformLength, maxPlatformLength );
			int x = rand( 1, mapSize - 1 - size );
			int y = rand( 1, mapSize - 2 );
			for( int dX = 0; dX <= size; dX++ ) {
				tileMap.value[ x + dX, y ] = bricks;
			}
		}
		for( int n = 0; n <= mapSize ; n++ ) {
			tileMap.value[ n, 0 ] = bricks;
			tileMap.value[ n, mapSize - 1 ] = bricks;
			tileMap.value[ 0, n ] = bricks;
			tileMap.value[ mapSize - 1, n ] = bricks;
		}
		tileMap.tileSet.collisionShape = new Shape()[ 3 ];
		tileMap.tileSet.collisionShape[ 1 ] = Sprite.fromShape( 0.5, 0.5 );
		tileMap.tileSet.collisionShape[ 2 ] = Sprite.fromShape( 0.5, 0.5, , , Sprite.oval );
		initGraphics();
	}

	public void logic() {
		currentCamera.jumpTo( player );
		currentCamera.limitWith( tileMap );
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
		player.act();
	}

	public void render() {
		tileMap.draw();
		player.draw();
		drawText( "Move player with arrow keys", 0, 0 );
		drawText( " Coins" + coins, 0, 16 );
		printText( "LTVectorSprite, CollisionsWithTileMap, HandleCollisionWithTile example", currentCamera.x, currentCamera.y + 12, Align.toCenter, Align.toBottom );
	}
}




public class Player extends VectorSprite {
	public final double gravity = 10.0;
	public final double horizontalSpeed = 5.0;
	public final double jumpStrength = 15.0;

	public int onLand;
	public HorizontalCollisionHandler horizontalCollisionHandler = new HorizontalCollisionHandler();
	public VerticalCollisionHandler verticalCollisionHandler = new VerticalCollisionHandler();

	public static Player create() {
		Player player = new Player();
		player.setSize( 0.8, 1.8 );
		player.setCoords( 0, 2 -0.5 * example.mapSize );
		player.visualizer.image = Image.fromFile( " incbinmario .png", 4 );
		return player;
	}

	public void act() {
		move( dX, 0 );
		collisionsWithTileMap( example.tileMap, horizontalCollisionHandler );

		onLand = false;
		move( 0, dY );
		dY = dY + example.perSecond( gravity );
		collisionsWithTileMap( example.tileMap, verticalCollisionHandler );

		dX = 0.0;
		if( keyDown( key_Left ) ) {
			dX = -horizontalSpeed;
			setFacing( leftFacing );
		} else if( keyDown( key_Right ) ) {
			dX = horizontalSpeed;
			setFacing( rightFacing );
		}

		if( onLand ) if keyDown( key_Up ) then dY = -jumpStrength;
	}
}



public class HorizontalCollisionHandler extends SpriteAndTileCollisionHandler {
	public void handleCollision( Sprite sprite, TileMap tileMap, int tileX, int tileY, Sprite collisionSprite ) {
		if( bricks( tileMap, tileX, tileY ) ) sprite.pushFromTile( tileMap, tileX, tileY );
	}
}



public class VerticalCollisionHandler extends SpriteAndTileCollisionHandler {
	public void handleCollision( Sprite sprite, TileMap tileMap, int tileX, int tileY, Sprite collisionSprite ) {
		if( bricks( tileMap, tileX, tileY ) ) {
			sprite.pushFromTile( tileMap, tileX, tileY );
			Player player = Player( sprite );
			if( player.dY > 0 ) player.onLand = true;
			player.dY = 0;
		}
	}
}



public static int bricks( TileMap tileMap, int tileX, int tileY ) {
	int tileNum = tileMap.getTile( tileX, tileY );
	if( tileNum == example.coin ) {
		tileMap.value[ tileX, tileY ] = example.void;
		example.coins += 1;
	} else if( tileNum = example.bricks ) {
		return true;
	}
	return false;
}
