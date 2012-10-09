package examples;
import java.lang.Math;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.base.Object;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.sprites.Sprite;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final int spritesQuantity = 70;

	public Layer layer = new Layer();
	public double ang;
	public Sprite oldSprite;

	public void init() {
		initGraphics();
		for( int n = 1; n <= spritesQuantity; n++ ) {
			oldSprite = Sprite.fromShape( Math.random( -15, 15 ), Math.random( -11, 11 ), , , Sprite.oval, Math.random( 360 ), 5 );
			oldSprite.setDiameter( Math.random( 0.5, 1.5 ) );
			oldSprite.visualizer.setRandomColor();
			layer.addLast( oldSprite );
		}
	}

	public void logic() {
		ang = 1500 * Math.sin( 7 * time );
		for( Sprite sprite : layer ) {
			oldSprite.directTo( sprite );
			oldSprite.angle += perSecond( ang ) + Math.random( -45, 45 );
			sprite.moveForward();
			oldSprite = sprite;
		}

		if( keyHit( key_F2 ) ) layer.saveToFile( "sprites.lw" );
		if( keyHit( key_F3 ) ) layer = Layer( Object.loadFromFile( "sprites.lw" ) );

		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		layer.draw();
		drawText( "Press F2 to save and F3 to load position of sprites", 0, 0 );
		printText( "LoadFromFile, SaveToFile example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
