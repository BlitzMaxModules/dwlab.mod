package examples;
import dwlab.base.Align;
import dwlab.base.Image;
import dwlab.base.Project;
import dwlab.shapes.sprites.Sprite;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public Sprite sprite = Sprite.fromShape( 0, 0, 8, 8 );

	public void init() {
		initGraphics();
		sprite.visualizer.image = Image.fromFile( " incbinkolobok .png" );
	}

	public void logic() {
		if( keyHit( key_Left ) ) sprite.setFacing( Sprite.leftFacing );
		if( keyHit( key_Right ) ) sprite.setFacing( Sprite.rightFacing );
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		sprite.draw();
		drawText( "Press left and right arrows to change sprite facing", 0, 0 );
		printText( "SetFacing example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
