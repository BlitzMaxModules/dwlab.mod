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
	public final int koloboksQuantity = 50;

	public Layer layer = new Layer();
	public Image kolobokImage = Image.fromFile( " incbinkolobok .png" );

	public void init() {
		for( int n = 1; n <= koloboksQuantity; n++ ) {
			Kolobok kolobok = new Kolobok();
			kolobok.setCoords( Math.random( -15, 15 ), Math.random( -11, 11 ) );
			kolobok.setDiameter( Math.random( 1, 3 ) );
			kolobok.shapeType = Sprite.oval;
			kolobok.visualizer.setRandomColor();
			kolobok.visualizer.image = kolobokImage;
			layer.addLast( kolobok );
		}
		initGraphics();
	}

	public void logic() {
		layer.act();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		layer.draw();
		printText( "DirectTo example", 0, 12, Align.toCenter, Align.toBottom );
	}
}



public class Kolobok extends Sprite {
	public void act() {
		directTo( cursor );
	}
}
