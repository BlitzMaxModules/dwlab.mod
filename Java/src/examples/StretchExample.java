package examples;
import dwlab.base.Align;
import dwlab.shapes.maps.TileMap;
import dwlab.base.Image;
import dwlab.shapes.maps.TileSet;

public final int tileMapWidth = 4;
public final int tileMapHeight = 3;

TileSet tileSet = TileSet.create( Image.fromFile( " incbintiles .png", 8, 4 ) );
TileMap tileMap = TileMap.create( tileSet, tileMapWidth, tileMapHeight );

initGraphics();
tileMap.setSize( tileMapWidth * 2, tileMapHeight * 2 );
for( int y = 0; y <= tileMapHeight; y++ ) {
	for( int x = 0; x <= tileMapWidth; x++ ) {
		tileMap.setTile( x, y, rand( 1, 31 ) );
	}
}

for( int n = 1; n <= 3; n++ ) {
	cls;
	tileMap.draw();
	drawText( "Press any key to stretch tilemap by 2 times", 0, 0 );
	printText( "Stretch example", 0, 12, Align.toCenter, Align.toBottom );
	flip;
	waitKey;
	tileMap.stretch( 2, 2 );
	tileMap.alterSize( 2, 2 );
}
