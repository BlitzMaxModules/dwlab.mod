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
	public final int koloboksQuantity = 50;

	public Layer koloboks = new Layer();
	public Image kolobokImage = Image.fromFile( " incbinkolobok .png" );
	public Kolobok player;
	public int debugMode;
	public CollisionHandler collisionHandler = new CollisionHandler();

	public void init() {
		for( int n = 1; n <= koloboksQuantity; n++ ) {
			Kolobok.createKolobok();
		}
		player = Kolobok.createPlayer();
		initGraphics();
	}

	public void logic() {
		koloboks.act();

		if( keyDown( key_Left ) ) player.turn( -player.turningSpeed );
		if( keyDown( key_Right ) ) player.turn( player.turningSpeed );
		if( keyDown( key_Up ) ) player.moveForward();
		if( keyDown( key_Down ) ) player.moveBackward();

		if( keyHit( key_D ) ) debugMode = ! debugMode;

		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		if( debugMode ) {
			koloboks.drawUsingVisualizer( debugVisualizer );
			showDebugInfo();
		} else {
			koloboks.draw();
			drawText( "Move white kolobok with arrow keys and push other koloboks and press D for debug mode", 0, 0 );
			printText( "WedgeOffWithSprite example", 0, 12, Align.toCenter, Align.toBottom );
		}
	}
}



public class Kolobok extends Sprite {
	public final double turningSpeed = 180.0;

	public static Kolobok createPlayer() {
		Kolobok player = create();
		player.setDiameter( 2 );
		player.velocity = 7;
		return player;
	}

	public static Kolobok createKolobok() {
		Kolobok kolobok = create();
		kolobok.setCoords( Math.random( -15, 15 ), Math.random( -11, 11 ) );
		kolobok.setDiameter( Math.random( 1, 3 ) );
		kolobok.angle = Math.random( 360 );
		kolobok.visualizer.setRandomColor();
		return kolobok;
	}

	public static Kolobok create() {
		Kolobok kolobok = new Kolobok();
		kolobok.shapeType = Sprite.oval;
		kolobok.visualizer.image = example.kolobokImage;
		kolobok.visualizer.setVisualizerScale( 1.3, 1.3 );
		example.koloboks.addLast( kolobok );
		return kolobok;
	}

	public void act() {
		collisionsWithLayer( example.koloboks, example.collisionHandler );
	}
}



public class CollisionHandler extends SpriteCollisionHandler {
	public void handleCollision( Sprite sprite1, Sprite sprite2 ) {
		sprite1.wedgeOffWithSprite( sprite2, sprite1.width ^ 2, sprite2.width ^ 2 );
	}
}
