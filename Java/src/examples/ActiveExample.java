package examples;
import java.lang.Math;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.shapes.Shape;
import dwlab.shapes.layers.Layer;
import dwlab.visualizers.ContourVisualizer;
import dwlab.shapes.sprites.SpriteCollisionHandler;
import dwlab.shapes.sprites.Sprite;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final int spritesQuantity = 50;

	public Layer layer = new Layer();
	public Shape rectangle = Sprite.fromShape( 0, 0, 30, 20 );

	public void init() {
		for( int n = 1; n <= spritesQuantity; n++ ) {
			Ball.create();
		}
		rectangle.visualizer = ContourVisualizer.fromWidthAndHexColor( 0.1, "FF0000" );
		initGraphics();
	}

	public void logic() {
		layer.act();
		if( keyHit( key_Space ) ) {
			for( Sprite sprite : layer ) {
				sprite.active = true;
				sprite.visible = true;
			}
		}
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		layer.draw();
		rectangle.draw();
		drawText( "Press left mouse button on circle to make it inactive, right button to make it invisible.", 0, 0 );
		drawText( "Press space to restore all back.", 0, 16 );
		printText( "Active, BounceInside, CollisionsWisthSprite, HandleCollisionWithSprite, Visible example", 0, 12, Align.toCenter, Align.toBottom );
	}
}

public class Ball extends Sprite {
	public CollisionHandler handler = new CollisionHandler();

	public static Ball create() {
		Ball ball = new Ball();
		ball.setCoords( Math.random( -13, 13 ), Math.random( -8, 8 ) );
		ball.setDiameter( Math.random( 0.5, 1.5 ) );
		ball.angle = Math.random( 360 );
		ball.velocity = Math.random( 3, 7 );
		ball.shapeType = Sprite.oval;
		ball.visualizer.setRandomColor();
		example.layer.addLast( ball );
		return ball;
	}

	public void act() {
		moveForward();
		bounceInside( example.rectangle );
		collisionsWithSprite( cursor, handler );
	}
}

public class CollisionHandler extends SpriteCollisionHandler {
	public void handleCollision( Sprite sprite1, Sprite sprite2 ) {
		if( mouseDown( 1 ) ) sprite1.active = false;
		if( mouseDown( 2 ) ) sprite1.visible = false;
	}
}
