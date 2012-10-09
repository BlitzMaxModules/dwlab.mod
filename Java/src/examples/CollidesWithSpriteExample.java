package examples;
import java.lang.Math;
import dwlab.base.Align;
import dwlab.base.Image;
import dwlab.base.Project;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.sprites.Sprite;

public static Example example = new Example();
example.execute();



public class Example extends Project {
	public Layer sprites = new Layer();
	public Image image = Image.fromFile( " incbinspaceship .png" );

	public void init() {
		for( int n = 0; n <= 9; n++ ) {
			Sprite sprite = new Sprite().fromShape( ( n % 3 ) * 8.0 - 8.0, Math.floor( n / 3 ) * 6.0 - 6.0, 6.0, 4.0, n );
			if( n == Sprite.raster ) sprite.visualizer.image = image;
			sprite.visualizer.setColorFromHex( "7FFF7F" );
			sprite.angle = 60;
			sprites.addLast( sprite );
		}
		initGraphics();
		cursor = new Sprite().fromShape( 0.0, 0.0, 5.0, 7.0, Sprite.pivot );
		cursor.angle = 45;
		cursor.visualizer.setColorFromHex( "7F7F7FFF" );
		cursor.shapeType = Sprite.ray;
	}

	public void logic() {
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
		if( mouseHit( 2 ) ) {
			cursor.shapeType = ( cursor.shapeType + 1 ) % 9;
			if( cursor.shapeType == Sprite.raster ) cursor.visualizer.image = image; else cursor.visualizer.image = null;
		}
		//L_Cursor.Angle += 0.5
	}

	public void render() {
		sprites.draw();
		for( Sprite sprite : sprites.children ) {
			//If Sprite.ShapeType < 4 Then Continue
			if( cursor.collidesWithSprite( sprite ) ) {
				sprite.visualizer.setColorFromHex( "FF7F7F" );
				Sprite wedgedCursor = Sprite( cursor.clone() );
				wedgedCursor.wedgeOffWithSprite( sprite, 0, 1 );
				wedgedCursor.visualizer.setColorFromHex( "7F7FFFFF" );
				wedgedCursor.draw();
			} else {
				sprite.visualizer.setColorFromHex( "7FFF7F" );
			}
		}
		cursor.draw();

		printText( "Press right mouse button to change shape ", 0, -12, Align.toCenter, Align.toTop );
		printText( "ColldesWithSprite example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
