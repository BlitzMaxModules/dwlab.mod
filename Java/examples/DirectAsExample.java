package examples;
import java.lang.Math;
import dwlab.base.Align;
import dwlab.base.Image;
import dwlab.base.Project;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.sprites.SpriteCollisionHandler;
import dwlab.shapes.sprites.Sprite;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final int spritesQuantity = 50;

	public Layer layer = new Layer();
	public Cursor cursor = new Cursor();
	public Image spriteImage = Image.fromFile( " incbinkolobok .png" );
	public Sprite selected;

	public void init() {
		for( int n = 1; n <= spritesQuantity; n++ ) {
			Sprite sprite = Sprite.fromShape( Math.random( -15, 15 ), Math.random( -11, 11 ), , , Sprite.oval, Math.random( 360 ) );
			sprite.setDiameter( Math.random( 1, 3 ) );
			sprite.visualizer.setRandomColor();
			sprite.visualizer.image = spriteImage;
			layer.addLast( sprite );
		}

		cursor.visualizer.image = spriteImage;
		cursor.shapeType = Sprite.pivot;
		initGraphics();
	}

	public void logic() {
		cursor.act();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		layer.draw();
		cursor.draw();
		drawText( "Click left mouse button on sprite to direct cursor sprite as it", 0, 0 );
		drawText( "and right button to set size equal to sprite's", 0, 16 );
		printText( "DirectAs, SetSizeAs example", 0, 12, Align.toCenter, Align.toBottom );
	}
}



public class Cursor extends Sprite {
	public SizeCollisionHandler sizeHandler = new SizeCollisionHandler();
	public DirectionCollisionHandler directionHandler = new DirectionCollisionHandler();

	public void act() {
		setMouseCoords();
		if( mouseHit( 1 ) ) collisionsWithLayer( example.layer, directionHandler );
		if( mouseHit( 2 ) ) collisionsWithLayer( example.layer, sizeHandler );
	}
}



public class SizeCollisionHandler extends SpriteCollisionHandler {
	public void handleCollision( Sprite sprite1, Sprite sprite2 ) {
		sprite1.setSizeAs( sprite2 );
	}
}



public class DirectionCollisionHandler extends SpriteCollisionHandler {
	public void handleCollision( Sprite sprite1, Sprite sprite2 ) {
		sprite1.directAs( sprite2 );
	}
}
