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
	public final int spritesQuantity = 50;

	public Layer sprites = new Layer();
	public Image spriteImage = Image.fromFile( " incbinkolobok .png" );

	public void init() {
		for( int n = 1; n <= spritesQuantity; n++ ) {
			Sprite sprite = Sprite.fromShape( Math.random( -15, 15 ), Math.random( -11, 11 ), , , Sprite.oval );
			sprite.setDiameter( Math.random( 1, 3 ) );
			sprite.displayingAngle= Math.random( 360 );
			sprite.visualizer.setRandomColor();
			sprite.visualizer.image = spriteImage;
			sprite.visualizer.setVisualizerScales( 1.3 );
			sprites.addLast( sprite );
		}
		initGraphics();
	}

	public void logic() {
		if( mouseHit( 1 ) ) {
			Sprite sprite = cursor.firstCollidedSpriteOfLayer( sprites );
			if( sprite ) {
				Sprite newSprite = Sprite( sprite.clone() );
				newSprite.alterCoords( Math.random( -2, 2 ), Math.random( -2, 2 ) );
				newSprite.alterDiameter( Math.random( 0.75, 1.5 ) );
				newSprite.alterAngle( Math.random( -45, 45 ) ) ;
				sprites.addLast( newSprite );
			}
		}

		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		sprites.draw();
		drawText( "Clone sprites with left mouse button", 0, 0 );
		printText( "AlterAngle, AlterCoords, AlterDiameter, Clone example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
