package examples;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.behavior_models.DistanceJoint;
import dwlab.shapes.LineSegment;
import dwlab.shapes.sprites.VectorSprite;
import dwlab.visualizers.ContourVisualizer;
import dwlab.shapes.sprites.Sprite;
import dwlab.visualizers.Visualizer;

Example example = new Example();
example.execute();

public class Example extends Project {
	public Sprite hinge = Sprite.fromShape( 0, -8, 1, 1, Sprite.oval );
	public VectorSprite weight1 = VectorSprite.fromShapeAndVector( -8, -6, 3, 3, Sprite.oval );
	public VectorSprite weight2 = VectorSprite.fromShapeAndVector( -12, -9, 3, 3, Sprite.oval );
	public LineSegment rope1 = LineSegment.fromPivots( hinge, weight1 );
	public LineSegment rope2 = LineSegment.fromPivots( weight1, weight2 );

	public void init() {
		initGraphics();
		hinge.visualizer = Visualizer.fromHexColor( "FF0000" );
		weight1.visualizer = Visualizer.fromHexColor( "00FF00" );
		weight2.visualizer = Visualizer.fromHexColor( "FFFF00" );
		rope1.visualizer = ContourVisualizer.fromWidthAndHexColor( 0.25, "0000FF", 1.0 , 2.0 );
		rope2.visualizer = rope1.visualizer;
		weight1.attachModel( DistanceJoint.create( hinge ) );
		weight2.attachModel( DistanceJoint.create( weight1 ) );
	}

	public void render() {
		hinge.draw();
		weight1.draw();
		weight2.draw();
		rope1.draw();
		rope2.draw();
		printText( "LTDistanceJoint example", 0, 12, Align.toCenter, Align.toBottom );
	}

	public void logic() {
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
		weight1.act();
		weight1.dY += perSecond( 2.0 );
		weight1.moveForward();
		weight2.act();
		weight2.dY += perSecond( 2.0 );
		weight2.moveForward();
	}
}

