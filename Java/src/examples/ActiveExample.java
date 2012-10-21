package examples;
import dwlab.base.Align;
import dwlab.base.Graphics;
import dwlab.base.Project;
import dwlab.base.Service;
import dwlab.controllers.ButtonAction;
import dwlab.controllers.KeyboardKey;
import dwlab.controllers.MouseButton;
import dwlab.shapes.Shape;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.sprites.Sprite;
import dwlab.shapes.sprites.SpriteCollisionHandler;
import dwlab.visualizers.ContourVisualizer;
import org.lwjgl.input.Keyboard;

public class ActiveExample extends Project {
	static {
		Graphics.init();
	}
	
	private static ActiveExample instance = new ActiveExample();
	
	public static void main(String[] argv) {
		instance.act();
	}
	
	public final int spritesQuantity = 50;

	public static Layer layer = new Layer();
	public static Sprite rectangle = new Sprite( 0, 0, 30, 20 );

	
	@Override
	public void init() {
		for( int n = 1; n <= spritesQuantity; n++ ) {
			Ball.create();
		}
		rectangle.visualizer = new ContourVisualizer( 0.1, "FF0000" );
		initGraphics();
	}

	
	private static ButtonAction reset = ButtonAction.create( KeyboardKey.create( Keyboard.KEY_SPACE ) );
	
	@Override
	public void logic() {
		layer.act();
		if( reset.wasPressed() ) {
			for( Shape shape : layer.children ) {
				shape.active = true;
				shape.visible = true;
			}
		}
	}
	

	@Override
	public void render() {
		layer.draw();
		rectangle.draw();
		Graphics.drawText( "Press left mouse button on circle to make it inactive, right button to make it invisible.", 0, 0 );
		Graphics.drawText( "Press space to restore all back.", 0, 16 );
		Graphics.drawText( "Active, BounceInside, CollisionsWisthSprite, HandleCollisionWithSprite, Visible example", 0d, 12d, Align.TO_CENTER, Align.TO_BOTTOM );
	}


	public static class Ball extends Sprite {
		public static CollisionHandler handler = new CollisionHandler();

		public static Ball create() {
			Ball ball = new Ball();
			ball.setCoords( Service.random( -13, 13 ), Service.random( -8, 8 ) );
			ball.setDiameter( Service.random( 0.5, 1.5 ) );
			ball.angle = Service.random( 360 );
			ball.velocity = Service.random( 3, 7 );
			ball.shapeType = ShapeType.OVAL;
			ball.visualizer.setRandomColor();
			layer.addLast( ball );
			return ball;
		}
		

		@Override
		public void act() {
			moveForward();
			bounceInside( rectangle );
			collisionsWithSprite( cursor, handler );
		}
	}
	

	public static class CollisionHandler extends SpriteCollisionHandler {
		private static ButtonAction makeInactive = ButtonAction.create( MouseButton.create( MouseButton.LEFT_BUTTON ) );
		private static ButtonAction makeInvisible = ButtonAction.create( MouseButton.create( MouseButton.RIGHT_BUTTON ) );

		@Override
		public void handleCollision( Sprite sprite1, Sprite sprite2 ) {
			if( makeInactive.wasPressed() ) sprite1.active = false;
			if( makeInvisible.wasPressed() ) sprite1.visible = false;
		}
	}
}