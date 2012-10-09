package examples;
import dwlab.base.Align;
import dwlab.base.Image;
import dwlab.base.Project;
import dwlab.shapes.sprites.Sprite;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public Sprite player = Sprite.fromShape( 0, 0, 1, 2 );
	public double startingTime;
	public int pingPong;

	public void init() {
		player.visualizer.image = Image.fromFile( " incbinmario .png", 4 );
		initGraphics();
	}

	public void logic() {
		if( keyDown( key_Space ) ) {
			if( startingTime == 0 ) startingTime = time;
			player.animate( 0.1, 3, 1, startingTime, pingPong );
		} else {
			player.frame = 0;
			startingTime = 0;
		}
		if( keyHit( key_P ) ) pingPong = ! pingPong;
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		player.draw();
		drawText( "Press space to animate sprite, P to toggle ping-pong animation (now it's " + pingPong + ")", 0, 0 );
		printText( "Animate example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
