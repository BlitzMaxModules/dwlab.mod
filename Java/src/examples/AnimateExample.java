package examples;

import dwlab.base.Align;
import dwlab.base.Graphics;
import dwlab.base.Image;
import dwlab.base.Project;
import dwlab.controllers.ButtonAction;
import dwlab.controllers.KeyboardKey;
import dwlab.shapes.sprites.Sprite;
import org.lwjgl.input.Keyboard;

public class AnimateExample extends Project {
	static {
		Graphics.init();
	}
	
	private static AnimateExample instance = new AnimateExample();
	
	public static void main(String[] argv) {
		instance.act();
	}
	
	public Sprite player = new Sprite( 0, 0, 1, 2 );
	public double animStartingTime;
	public boolean pingPong;

	@Override
	public void init() {
		player.visualizer.image = new Image( "res/mario.png", 4, 1 );
		initGraphics();
	}

	private ButtonAction runAnimation = ButtonAction.create( KeyboardKey.create( Keyboard.KEY_SPACE ) );
	private ButtonAction switchPingPong = ButtonAction.create( KeyboardKey.create( Keyboard.KEY_F ) );
	
	@Override
	public void logic() {
		if( runAnimation.isDown() ) {
			if( animStartingTime == 0 ) animStartingTime = time;
			player.animate( 0.1, 3, 1, animStartingTime, pingPong );
		} else {
			player.frame = 0;
			animStartingTime = 0;
		}
		if( switchPingPong.wasPressed() ) pingPong = ! pingPong;
	}

	@Override
	public void render() {
		player.draw();
		Graphics.drawText( "Press space to animate sprite, P to toggle ping-pong animation (now it's " + pingPong + ")", 0, 0 );
		Graphics.drawText( "Animate example", 0, 12, Align.TO_CENTER, Align.TO_BOTTOM );
	}
}
