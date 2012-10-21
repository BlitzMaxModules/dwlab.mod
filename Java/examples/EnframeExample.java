package examples;
import dwlab.base.Align;
import dwlab.shapes.maps.TileMap;
import dwlab.shapes.layers.EditorData;
import dwlab.shapes.layers.World;
import dwlab.shapes.maps.DoubleMap;
import dwlab.shapes.maps.TileSet;

public final int mapSize = 64;
public final double mapScale = 8;
public final int filledTileNum = 20;




initGraphics();
editorData = new EditorData();
setClsColor( 64, 128, 0 );

cls;
DoubleMap doubleMap = new DoubleMap();
doubleMap.setResolution( mapSize, mapSize );
drawDoubleMap( doubleMap );
drawText( "Step creating 1 Double map and set its resolution", 0, 0 );
flip;
waitkey;

cls;
doubleMap.perlinNoise( 16, 16, 0.25, 0.5, 4 );
drawDoubleMap( doubleMap );
drawText( "Step filling 2 DoubleMap with Perlin noise", 0, 0 );
flip;
waitkey;

cls;
setIncbin( true );
World world = World.fromFile( "tileset.lw" );
setIncbin( false );
TileSet tileSet = TileSet( editorData.tilesets.getFirst() );
TileMap tileMap = TileMap.create( tileSet, mapSize, mapSize );
tileMap.setSize( mapSize * mapScale / 25.0, mapSize * mapScale / 25.0 );
drawText( "Step loading 3 world, extract tileset from there and", 0, 0 );
drawText( "creating tilemap with same size and this tileset", 0, 16 );
drawDoubleMap( doubleMap );
flip;
waitkey;


cls;
doubleMap.extractTo( tileMap, 0.5, 1.0, filledTileNum );
drawText( "Step setting 4 tiles number of tilemap to FilledTileNum", 0, 0 );
drawText( "if corresponding value of Double map is higher than 0.5", 0, 16 );
tileMap.draw();
drawSignature();
flip;
waitkey;

cls;
for( int y = 0; y <= mapSize; y++ ) {
	for( int x = 0; x <= mapSize; x++ ) {
		fix( tileMap, x, y );
	}
}
drawText( "Step preparing 5 tilemap by fixing some unmanaged cell positions", 0, 0 );
tileMap.draw();
drawSignature();
flip;
waitkey;

cls;
tileMap.enframe();
drawText( "Step enframing 6a tile map", 0, 0 );
tileMap.draw();
drawSignature();
flip;
waitkey;


cls;
prolongTiles = false;
tileMap.enframe() ;
drawText( "Step enframing 6b tile map with prolonging tiles off", 0, 0 );
tileMap.draw();
drawSignature();
flip;
waitkey;


setClsColor( 0, 0, 0 );


public static void drawDoubleMap( DoubleMap map ) {
	tImage image = createImage( mapSize, mapSize );
	tPixmap pixmap = lockimage( image );
	clearPixels( pixmap, $fF000000 );
	map.pasteToPixmap( pixmap );
	unlockimage( image );
	setScale( mapScale, mapScale );
	drawImage( image, 400 - 0.5 * mapScale * mapSize, 300 - 0.5 * mapScale * mapSize );
	setScale( 1, 1 );
	drawSignature();
}



public static void drawSignature() {
	printText( "PerlinNoise, ExtractTo, Enframe, L_ProlongTiles, example", 0, 12, Align.toCenter, Align.toBottom );
}



public static void fix( TileMap tileMap, int x, int y ) {
	if( tileMap.value[ x, y ] == filledTileNum ) return;
	int doFix = false;

	int fixHorizontal = true;
	if( x > 0 && x < mapSize - 1 ) {
		if( tileMap.value[ x - 1, y ] == filledTileNum && tileMap.value[ x + 1, y ] == filledTileNum ) doFix = true;
	} else {
		fixHorizontal = false;
	}

	int fixVertical = true;
	if( y > 0 && y < mapSize - 1 ) {
		if( tileMap.value[ x, y - 1 ] == filledTileNum && tileMap.value[ x, y + 1 ] == filledTileNum ) doFix = true;
	} else {
		fixVertical = false;
	}

	if( doFix ) {
		tileMap.value[ x, y ] = filledTileNum;
		if( fixHorizontal ) {
			fix( tileMap, x - 1, y );
			fix( tileMap, x + 1, y );
		}
		if( fixVertical ) {
			fix( tileMap, x, y - 1 );
			fix( tileMap, x, y + 1 );
		}
	}
}
