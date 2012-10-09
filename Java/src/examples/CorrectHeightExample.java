package examples;
import java.lang.Math;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.sprites.Sprite;
import dwlab.visualizers.Visualizer;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final int spritesQuantity = 50;

	public Layer layer = new Layer();

	public void init() {
		initGraphics();
		Visualizer spriteVisualizer = Visualizer.fromFile( " incbinmario .png", 4 );
		for( int n = 1; n <= spritesQuantity; n++ ) {
			Sprite sprite = Sprite.fromShape( Math.random( -15, 15 ), Math.random( -11, 11 ), Math.random( 0.5, 2 ), Math.random( 0.5, 2 ) );
			sprite.visualizer = spriteVisualizer;
			layer.addLast( sprite );
		}
	}

	public void logic() {
		if( keyHit( key_Space ) ) {
			for( Sprite sprite : layer ) {
				sprite.correctHeight();
			}
		}
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		layer.draw();
		drawText( "Press space to correct height", 0, 0 );
		printText( "CorrectHeight example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
