package examples;
import dwlab.behavior_models.FixedJoint;
import java.lang.Math;
import dwlab.behavior_models.RevoluteJoint;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.layers.World;
import dwlab.shapes.sprites.Sprite;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final double period = 2.0;
	public World world;
	public Layer layer;
	public Sprite body;
	public Sprite upperArm[] = new Sprite()[ 2 ];
	public Sprite lowerArm[] = new Sprite()[ 2 ];
	public Sprite upperLeg[] = new Sprite()[ 2 ];
	public Sprite lowerLeg[] = new Sprite()[ 2 ];
	public Sprite foot[] = new Sprite()[ 2 ];

	public void init() {
		setIncbin( true );
		world = World.fromFile( "human.lw" );
		setIncbin( false );
		layer = Layer( world.findShapeWithType( "LTLayer" ) );
		body = Sprite( layer.findShape( "body" ) );
		layer.findShape( "head" ).attachModel( FixedJoint.create( body ) );
		for( int n = 0; n <= 1; n++ ) {
			String prefix = [ "inner_", "outer_" ][ n ];
			upperArm[ n ] = Sprite( layer.findShape( prefix + "upper_arm" ) );
			lowerArm[ n ] = Sprite( layer.findShape( prefix + "lower_arm" ) );
			upperArm[ n ].attachModel( RevoluteJoint.create( body, 0, -0.333 ) );
			lowerArm[ n ].attachModel( RevoluteJoint.create( upperArm[ n ], 0, -0.333 ) );
			layer.findShape( prefix + "fist" ).attachModel( FixedJoint.create( lowerArm[ n ]  ) );
			upperLeg[ n ] = Sprite( layer.findShape( prefix + "upper_leg" ) );
			lowerLeg[ n ] = Sprite( layer.findShape( prefix + "lower_leg" ) );
			foot[ n ] = Sprite( layer.findShape( prefix + "foot" ) );
			upperLeg[ n ].attachModel( RevoluteJoint.create( body, 0, -0.375 ) );
			lowerLeg[ n ].attachModel( RevoluteJoint.create( upperLeg[ n ], 0, -0.375 ) );
			foot[ n ].attachModel( FixedJoint.create( lowerLeg[ n ] ) );
		}
		currentCamera.jumpTo( body );
		initGraphics();
		body.angle = 16;
	}

	public void logic() {
		double angle = 360 / period * time;
		body.y = -Math.sin( angle * 2 + 240 ) * 0.25 - 5.5;

		upperArm[ 0 ].angle = -Math.sin( angle + 90 ) * 60;
		lowerArm[ 0 ].angle = upperArm[ 0 ].angle - 45 - Math.sin( angle + 90 ) * 30;
		upperLeg[ 0 ].angle = Math.cos( angle ) * 45;
		lowerLeg[ 0 ].angle = upperLeg[ 0 ].angle + Math.sin( angle + 60 ) * 60 + 60;

		upperArm[ 1 ].angle = Math.sin( angle + 90 ) * 60;
		lowerArm[ 1 ].angle = upperArm[ 1 ].angle - 45 + Math.sin( angle + 90 ) * 30;
		upperLeg[ 1 ].angle = Math.cos( angle + 180 ) * 45;
		lowerLeg[ 1 ].angle = upperLeg[ 1 ].angle + Math.sin( angle + 240 ) * 60 + 60;

		layer.act();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		layer.draw();
		printText( "LTFixedJoint, LTRevoluteJoint example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
