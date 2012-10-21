package examples;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.shapes.sprites.Sprite;
import dwlab.visualizers.Visualizer;

// First sprite is moving at constant speed regardles of LogicFPS because it use delta-timing PerSecond() method to determine
// on which distance to move in particular logic frame.Second sprite use simple coordinate addition.







public static Example example = new Example();
example.execute();

public class Example extends Project {
	public Sprite sprite1 = Sprite.fromShape( -10, -2, 2, 2, Sprite.oval );
	public Sprite sprite2 = Sprite.fromShape( -10, 2, 2, 2, Sprite.oval );

	public void init() {
		initGraphics();
		sprite1.visualizer = Visualizer.fromRGBColor( 1, 1, 0 );
		sprite2.visualizer = Visualizer.fromRGBColor( 0, 0.5, 1 );
		logicFPS = 100;
	}

	public void logic() {
		sprite1.x += perSecond( 8 );
		if( sprite1.x > 10 ) sprite1.x -= 20;

		sprite2.x += 0.08;
		if( sprite2.x > 10 ) sprite2.x -= 20;

		if( keyDown( key_NumAdd ) ) logicFPS += perSecond( 100 );
		if( keyDown( key_NumSubtract ) && logicFPS > 20 ) logicFPS -= perSecond( 100 );

		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		sprite1.draw();
		sprite2.draw();
		drawText( "Logic  FPS" + trimDouble( logicFPS ) + ", press num+ / num- to change", 0, 0 );
		printText( "L_LogicFPS example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
