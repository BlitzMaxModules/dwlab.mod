package examples;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.controllers.ButtonAction;
import dwlab.controllers.KeyboardKey;
import dwlab.controllers.MouseButton;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.sprites.Sprite;

public static Example example = new Example();
example.execute();


public class Example extends Project {
	public double velocity = 5.0;
	public double bulletVelocity = 10.0;

	public ButtonAction moveLeft = ButtonAction.create( KeyboardKey.create( key_Left ), "move left" );
	public ButtonAction moveRight = ButtonAction.create( KeyboardKey.create( key_Right ), "move right" );
	public ButtonAction moveUp = ButtonAction.create( KeyboardKey.create( key_Up ), "move up" );
	public ButtonAction moveDown = ButtonAction.create( KeyboardKey.create( key_Down ), "move down" );
	public ButtonAction fire = ButtonAction.create( MouseButton.create( 1 ), "fire" );
	public ButtonAction actions[] = [ moveLeft, moveRight, moveUp, moveDown, fire ];

	public Sprite player = Sprite.fromShape( 0, 0, 1, 1, Sprite.oval );
	public Layer bullets = new Layer();

	public void init() {
		initGraphics();
		player.visualizer.setColorFromHex( "7FBFFF" );
	}

	public void logic() {
		if( moveLeft.isDown() ) player.move( -velocity, 0 );
		if( moveRight.isDown() ) player.move( velocity, 0 );
		if( moveUp.isDown() ) player.move( 0, -velocity );
		if( moveDown.isDown() ) player.move( 0, velocity );
		if( fire.isDown() ) Bullet.create();

		bullets.act();

		if( keyDown( key_LControl ) || keyDown( key_RControl ) ) if keyDown( key_D ) then switchTo( new DefineKeys() );

		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		bullets.draw();
		player.draw();
		drawText( "Press Ctrl-D to define keys", 0, 0 );
		printText( "LTButtonAction, SwitchTo, Move example", 0, 12, Align.toCenter, Align.toBottom );
	}
}



public class Bullet extends Sprite {
	public static Bullet create() {
		Bullet bullet = new Bullet();
		bullet.setCoords( example.player.x, example.player.y );
		bullet.setDiameter( 0.25 );
		bullet.shapeType = Sprite.oval;
		bullet.angle = example.player.directionTo( cursor );
		bullet.velocity = example.bulletVelocity;
		bullet.visualizer.setColorFromHex( "7FFFBF" );
		example.bullets.addLast( bullet );
	}

	public void act() {
		moveForward();
	}
}



public class DefineKeys extends Project {
	public int actionNum = 0;
	public int z;

	public void init() {
		flushKeys();
		flushMouse();
	}

	public void logic() {
		if( example.actions[ actionNum ].define() ) {
			actionNum += 1;
			if( actionNum == example.actions.dimensions()[ 0 ] ) exiting = true;
		}
	}

	public void render() {
		example.render();
		drawText( "Press key for " + example.actions[ actionNum ].name, 0, 16 );
	}
}
