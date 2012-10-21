package examples;
import java.lang.Math;
import dwlab.base.Align;
import dwlab.base.Image;
import dwlab.base.Project;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.sprites.SpriteCollisionHandler;
import dwlab.shapes.sprites.Sprite;
import dwlab.visualizers.MarchingAnts;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final int spritesQuantity = 50;

	public Layer layer = new Layer();
	public Cursor cursor = new Cursor();
	public Image spriteImage = Image.fromFile( " incbinkolobok .png" );
	public Sprite selected;
	public MarchingAnts marchingAnts = new MarchingAnts();

	public void init() {
		for( int n = 1; n <= spritesQuantity; n++ ) {
			Sprite sprite = Sprite.fromShape( Math.random( -15, 15 ), Math.random( -11, 11 ), , , Sprite.oval, Math.random( 360 ) );
			sprite.setDiameter( Math.random( 1, 3 ) );
			sprite.visualizer.setRandomColor();
			sprite.visualizer.image = spriteImage;
			layer.addLast( sprite );
		}

		cursor.setDiameter( 0.5 );
		initGraphics();
	}

	public void logic() {
		cursor.act();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		layer.draw();
		if( selected ) selected.drawUsingVisualizer( example.marchingAnts );
		drawText( "Select Sprite by left-clicking on it", 0, 0 );
		printText( "LTMarchingAnts example", 0, 12, Align.toCenter, Align.toBottom );
	}
}



public class Cursor extends Sprite {
	public SelectionHandler handler = new SelectionHandler();

	public void act() {
		setMouseCoords();
		if( mouseHit( 1 ) ) {
			example.selected = null;
			collisionsWithLayer( example.layer, handler );
		}
	}
}



public class SelectionHandler extends SpriteCollisionHandler {
	public void handleCollision( Sprite sprite1, Sprite sprite2 ) {
		example.selected = sprite2;
	}
}
