package examples;
import java.lang.Math;
import dwlab.base.Action;
import dwlab.base.Align;
import dwlab.base.Image;
import dwlab.base.Project;
import dwlab.base.Object;
import dwlab.base.Drag;
import dwlab.shapes.Shape;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.sprites.Sprite;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final int spritesQuantity = 50;

	public Layer sprites = new Layer();
	public Image spriteImage = Image.fromFile( " incbinkolobok .png" );
	public MoveDrag drag = new MoveDrag();

	public void init() {
		for( int n = 1; n <= spritesQuantity; n++ ) {
			Sprite sprite = Sprite.fromShape( Math.random( -15, 15 ), Math.random( -11, 11 ), , , Sprite.oval );
			sprite.setDiameter( Math.random( 1, 3 ) );
			sprite.displayingAngle= Math.random( 360 );
			sprite.visualizer.setRandomColor();
			sprite.visualizer.image = spriteImage;
			sprite.visualizer.setVisualizerScales( 1.3 );
			sprites.addLast( sprite );
		}
		initGraphics();
	}

	public void logic() {
		drag.execute();

		pushActionsList();
		if( keyDown( key_LControl ) || keyDown( key_RControl ) ) {
			if( keyHit( key_Z ) ) undo();
			if( keyHit( key_Y ) ) redo();
		}

		if( keyHit( key_F2 ) ) sprites.saveToFile( "sprites2.lw" );
		if( keyHit( key_F3 ) ) sprites = Layer( Object.loadFromFile( "sprites2.lw" ) );

		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		sprites.draw();
		drawText( "Drag sprites with left mouse button, press CTRL-Z to undo, CTRL-Y to redo, F2 to save, F3 to load", 0, 0 );
		printText( "LTAction, L_Undo, L_Redo, L_PushActionsList, LTDrag example", 0, 12, Align.toCenter, Align.toBottom );
	}
}



public class MoveDrag extends Drag {
	public Shape shape;
	public MoveAction action;
	public double dX, double dY;

	public int dragKey() {
		return mouseDown( 1 );
	}

	public void startDragging() {
		shape = cursor.firstCollidedSpriteOfLayer( example.sprites );
		if( shape ) {
			action = MoveAction.create( shape );
			dX = shape.x - cursor.x;
			dY = shape.y - cursor.y;
		} else {
			draggingState = false;
		}
	}

	public void dragging() {
		shape.setCoords( cursor.x + dX, cursor.y + dY );
	}

	public void endDragging() {
		action.newX = shape.x;
		action.newY = shape.y;
		action.do();
	}
}



public class MoveAction extends Action {
	public Shape shape;
	public double oldX, double oldY;
	public double newX, double newY;

	public static MoveAction create( Shape shape ) {
		MoveAction action = new MoveAction();
		action.shape = shape;
		action.oldX = shape.x;
		action.oldY = shape.y;
		return action;
	}

	public void do() {
		shape.setCoords( newX, newY );
		super.do();
	}

	public void undo() {
		shape.setCoords( oldX, oldY );
		super.undo();
	}
}
