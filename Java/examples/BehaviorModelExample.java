package examples;
import java.lang.Math;
import java.lang.System;
import dwlab.behavior_models.IsModelActive;
import dwlab.behavior_models.RandomWaitingModel;
import dwlab.behavior_models.BehaviorModel;
import dwlab.base.Align;
import dwlab.behavior_models.IsButtonActionDown;
import dwlab.shapes.maps.TileMap;
import dwlab.behavior_models.AnimationModel;
import dwlab.behavior_models.ModelActivator;
import dwlab.base.Project;
import dwlab.controllers.ButtonAction;
import dwlab.behavior_models.FixedWaitingModel;
import dwlab.behavior_models.ModelDeactivator;
import dwlab.behavior_models.ModelStack;
import dwlab.shapes.Shape;
import dwlab.controllers.KeyboardKey;
import dwlab.shapes.sprites.VectorSprite;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.layers.World;
import dwlab.shapes.sprites.SpriteCollisionHandler;
import dwlab.shapes.sprites.Sprite;
import dwlab.shapes.sprites.SpriteAndTileCollisionHandler;
import dwlab.visualizers.MarchingAnts;
import dwlab.visualizers.Visualizer;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final int bricks = 1;
	public final double deathPeriod = 1.0;

	public World world;
	public Layer layer;
	public TileMap tileMap;
	public Sprite selectedSprite;
	public MarchingAnts marchingAnts = new MarchingAnts();

	public BumpingWalls bumpingWalls = new BumpingWalls();
	public PushFromWalls pushFromWalls = new PushFromWalls();
	public DestroyBullet destroyBullet = new DestroyBullet();
	public AwPossumHurtingCollision awPossumHurtingCollision = new AwPossumHurtingCollision();
	public AwPossumHitCollision awPossumHitCollision = new AwPossumHitCollision();

	//Field LTSprite HitArea
	public int score;

	public void init() {
		setIncbin( true );
	 	world = World.fromFile( "jellys.lw" );
	 	setIncbin( false );

		initGraphics();

		while( true ) {
			drawImage( loadImage( " incbinscheme2 .png" ), 0, 0 );
			flip;
		until keyHit( key_Escape );

		while( true ) {
			drawImage( loadImage( " incbinscheme1 .png" ), 0, 0 );
			flip;
		until keyHit( key_Escape );

		initLevel();
	}

	public void initLevel() {
		loadAndInitLayer( layer, Layer( world.findShape( "Level" ) ) );
		tileMap = TileMap( layer.findShape( "Field" ) );
	}

	public void logic() {
		currentCamera.jumpTo( tileMap );
		if( mouseHit( 1 ) ) selectedSprite = cursor.firstCollidedSpriteOfLayer( layer );
		layer.act();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		layer.draw();
		if( selectedSprite ) {
			switch( edSprite.showModels( 100 ) ) {
			switch( edSprite.drawUsingVisualizer( marchingAnts ) ) {
		}
		//If HitArea Then HitArea.Draw()
		showDebugInfo();
		printText( "Guide AwesomePossum to exit from maze using arrow and space keys", tileMap.rightX(), tileMap.topY() - 12, Align.toRight, Align.toTop );
		printText( "You can view sprite behavior models by clicking left mouse button on it", tileMap.rightX(), tileMap.topY() - 0.5, Align.toRight, Align.toTop );
		printText( " Score" + firstZeroes( score, 6 ), tileMap.rightX() - 0.1, tileMap.bottomY() - 0.1, Align.toRight, Align.toBottom, true );
		printText( "LTBehaviorModel example", tileMap.x, tileMap.bottomY(), Align.toCenter, Align.toBottom );
	}
}



public class GameObject extends VectorSprite {
	public OnLand onLand = new OnLand();
	public Gravity gravity = new Gravity();
	public AnimationModel jumpingAnimation;
	public AnimationModel fallingAnimation;

	public double health = 100.0;
}



public class Jelly extends GameObject {
	public final double jumpingAnimationSpeed = 0.2;
	public final double firingAnimationSpeed = 0.1;
	public final double walkingAnimationSpeed = 0.2;
	public final double idleAnimationSpeed = 0.4;
	public final double minAttack = 10.0;
	public final double maxAttack = 20.0;
	public final double hurtingTime = 0.2;

	public final double jumpingPause = jumpingAnimationSpeed * 2.0;
	public final double bulletPause = firingAnimationSpeed * 5.0;

	public int score = 100;

	public void init() {
		attachModel( gravity );

		ModelStack animationStack = new ModelStack();
		attachModel( animationStack );

		jumpingAnimation = AnimationModel.create( false, jumpingAnimationSpeed, 8, 8 );
		fallingAnimation = AnimationModel.create( true, jumpingAnimationSpeed, 3, 13, true );
		AnimationModel firingAnimation = AnimationModel.create( false, firingAnimationSpeed, 8, 16 );


		HorizontalMovement horizontalMovement = HorizontalMovement.create( example.bumpingWalls );


		String jumping = getParameter( "jumping" );
		if( jumping ) {
			String parameters[] = jumping.split( "-" );
			RandomWaitingModel waitingForJump = RandomWaitingModel.create( parameters[ 0 ].toDouble(), parameters[ 1 ].toDouble() );
			attachModel( waitingForJump );

			IsModelActive onLandCondition = IsModelActive.create( onLand );
			waitingForJump.nextModels.addLast( onLandCondition );

			IsModelActive animationActive = IsModelActive.create( firingAnimation );
			onLandCondition.trueModels.addLast( animationActive );
			onLandCondition.falseModels.addLast( waitingForJump );

			animationActive.trueModels.addLast( waitingForJump );
			animationActive.falseModels.addLast( ModelActivator.create( jumpingAnimation ) );
			animationActive.falseModels.addLast( ModelDeactivator.create( horizontalMovement ) );
			animationActive.falseModels.addLast( ModelDeactivator.create( gravity ) );

			jumpingAnimation.nextModels.addLast( ModelActivator.create( fallingAnimation ) );

			parameters = getParameter( "jumping_strength" ).split( "-" );
			FixedWaitingModel pauseBeforeJump = FixedWaitingModel.create( jumpingPause );
			pauseBeforeJump.nextModels.addLast( Jump.create( parameters[ 0 ].toDouble(), parameters[ 1 ].toDouble() ) );
			pauseBeforeJump.nextModels.addLast( ModelActivator.create( horizontalMovement ) );
			pauseBeforeJump.nextModels.addLast( ModelActivator.create( gravity ) );
			pauseBeforeJump.nextModels.addLast( waitingForJump );
			animationActive.falseModels.addLast( pauseBeforeJump );

			animationStack.add( jumpingAnimation, false );
			score += 200;
		}


		animationStack.add( fallingAnimation );


		String firing = getParameter( "firing" );
		if( firing ) {
			String parameters[] = firing.split( "-" );
			RandomWaitingModel waitingForFire = RandomWaitingModel.create( parameters[ 0 ].toDouble(), parameters[ 1 ].toDouble() );
			attachModel( waitingForFire );

			IsModelActive onLandCondition = IsModelActive.create( onLand );
			waitingForFire.nextModels.addLast( onLandCondition );

			IsModelActive animationActive = IsModelActive.create( jumpingAnimation );
			onLandCondition.trueModels.addLast( animationActive );
			onLandCondition.falseModels.addLast( waitingForFire );

			animationActive.trueModels.addLast( waitingForFire );
			animationActive.falseModels.addLast( ModelActivator.create( firingAnimation ) );
			animationActive.falseModels.addLast( ModelDeactivator.create( horizontalMovement ) );

			firingAnimation.nextModels.addLast( ModelActivator.create( horizontalMovement ) );

			parameters = getParameter( "firing_speed" ).split( "-" );
			FixedWaitingModel pauseBeforeBullet = FixedWaitingModel.create( bulletPause );
			pauseBeforeBullet.nextModels.addLast( CreateBullet.create( parameters[ 0 ].toDouble(), parameters[ 1 ].toDouble() ) );
			pauseBeforeBullet.nextModels.addLast( waitingForFire );
			animationActive.falseModels.addLast( pauseBeforeBullet );

			animationStack.add( firingAnimation, false );
			score += 300;
		}

		AnimationModel movementAnimation = AnimationModel.create( true, walkingAnimationSpeed, 3, 3, true );
		String moving = getParameter( "moving" );
		if( moving ) {
			String parameters[] = getParameter( "moving" ).split( "-" );
			dX *= Math.random( parameters[ 0 ].toDouble(), parameters[ 1 ].toDouble() );
			attachModel( horizontalMovement );
			animationStack.add( movementAnimation );
			score += 100;
		}


		attachModel( ModelDeactivator.create( onLand, true ) );
		attachModel( VerticalMovement.create( false ) );


		AnimationModel standingAnimation = AnimationModel.create( true, idleAnimationSpeed, 3, 0, true );
		animationStack.add( standingAnimation );

		String scoreParameter = getParameter( "score" );
		if( scoreParameter ) score = scoreParameter.toInt();

		String healthParameter = getParameter( "health" );
		if( healthParameter ) health = healthParameter.toDouble();
	}
}



public class AwPossum extends GameObject {
	public final double jumpingAnimationSpeed = 0.2;
	public final double walkingAnimationSpeed = 0.2;
	public final double idleAnimationSpeed = 0.4;

	public final double jumpingPause = jumpingAnimationSpeed;
	public final double jumpingStrength = 6.0;
	public final double walkingSpeed = 5.0;

	public final double minAttack = 20.0;
	public final double maxAttack = 35.0;
	public final double minHealthGain = 3.0;
	public final double maxHealthGain = 6.0;

	public final double knockOutPeriod = 0.3;
	public final double immortalPeriod = 1.5;
	public final double hitPeriod = 0.2;
	public final double knockOutStrength = 2.0;
	public final double hitPauseTime = 0.5;

	public AnimationModel movementAnimation = AnimationModel.create( true, walkingAnimationSpeed, 4, 4 );
	public AnimationModel hurtingAnimation = AnimationModel.create( false, knockOutPeriod, 1, 14 );
	public AnimationModel punchingAnimation = AnimationModel.create( false, hitPeriod, 1, 15 );
	public AnimationModel kickingAnimation = AnimationModel.create( false, hitPeriod, 1, 11 );

	public MovementControl movementControl = new MovementControl();
	public FixedWaitingModel hitPause = FixedWaitingModel.create( hitPauseTime );

	public ButtonAction moveLeftKey = ButtonAction.create( KeyboardKey.create( key_Left ), "Move left" );
	public ButtonAction moveRightKey = ButtonAction.create( KeyboardKey.create( key_Right ), "Move right" );
	public ButtonAction jumpKey = ButtonAction.create( KeyboardKey.create( key_Up ), "Jump" );
	public ButtonAction hitKey = ButtonAction.create( KeyboardKey.create( key_Space ), "Hit" );

	public void init() {
		attachModel( gravity );


		ModelStack animationStack = new ModelStack();
		attachModel( animationStack );

		animationStack.add( hurtingAnimation, false );
		animationStack.add( punchingAnimation, false );
		animationStack.add( kickingAnimation, false );

		jumpingAnimation = AnimationModel.create( false, jumpingAnimationSpeed, 3, 8 );
		animationStack.add( jumpingAnimation );

		fallingAnimation = AnimationModel.create( true, jumpingAnimationSpeed, 1, 10 );
		jumpingAnimation.nextModels.addLast( ModelActivator.create( fallingAnimation ) );
		animationStack.add( fallingAnimation );

		animationStack.add( movementAnimation );


		attachModel( movementControl );


		IsButtonActionDown jumpKeyDown = IsButtonActionDown.create( jumpKey );
		attachModel( jumpKeyDown );
		jumpKeyDown.falseModels.addLast( jumpKeyDown );

		IsModelActive onLandCondition = IsModelActive.create( onLand );
		jumpKeyDown.trueModels.addLast( onLandCondition );

		onLandCondition.trueModels.addLast( ModelActivator.create( jumpingAnimation ) );
		onLandCondition.trueModels.addLast( ModelDeactivator.create( gravity ) );
		onLandCondition.falseModels.addLast( jumpKeyDown );

		FixedWaitingModel pauseBeforeJump = FixedWaitingModel.create( jumpingPause );
		pauseBeforeJump.nextModels.addLast( Jump.create( jumpingStrength, jumpingStrength ) );
		pauseBeforeJump.nextModels.addLast( ModelActivator.create( gravity ) );
		pauseBeforeJump.nextModels.addLast( jumpKeyDown );
		onLandCondition.trueModels.addLast( pauseBeforeJump );

		animationStack.add( jumpingAnimation, false );


		IsButtonActionDown hitKeyDown = IsButtonActionDown.create( hitKey );
		attachModel( hitKeyDown );
		hitKeyDown.falseModels.addLast( hitKeyDown );

		IsModelActive hitPauseCondition = IsModelActive.create( hitPause );
		hitPauseCondition.falseModels.addLast( hitPause );
		hitPauseCondition.trueModels.addLast( hitKeyDown );
		hitKeyDown.trueModels.addLast( hitPauseCondition );

		IsModelActive onLandCondition2 = IsModelActive.create( onLand );
		onLandCondition2.trueModels.addLast( ModelActivator.create( punchingAnimation ) );
		onLandCondition2.trueModels.addLast( HittingArea.create2( true ) );
		onLandCondition2.trueModels.addLast( hitKeyDown );
		onLandCondition2.falseModels.addLast( ModelActivator.create( kickingAnimation ) );
		onLandCondition2.falseModels.addLast( HittingArea.create2( false ) );
		onLandCondition2.falseModels.addLast( hitKeyDown );
		hitPauseCondition.falseModels.addLast( onLandCondition2 );


		attachModel( HorizontalMovement.create( example.pushFromWalls ) );


		attachModel( ModelDeactivator.create( onLand, true ) );
		attachModel( VerticalMovement.create( true ) );


		AnimationModel standingAnimation = AnimationModel.create( true, idleAnimationSpeed, 4, 0, true );
		animationStack.add( standingAnimation );
	}

	public void act() {
		super.act();
		collisionsWithLayer( example.layer, example.awPossumHurtingCollision );
		if( x > example.tileMap.rightX() ) example.switchTo( new Restart() );
	}

	public void draw() {
		super.draw();
		drawEmptyRect( 5, 580, 104, 15 );
		if( health >= 50.0 ) {
			setColor( ( 100.0 - health ) * 255.0 / 50.0 , 255, 0 );
		} else {
			setColor( 255, health * 255.0 / 50.0, 0 );
		}
		drawRect( 7, 582, health, 11 );
		Visualizer.resetColor();
	}
}



public class OnLand extends BehaviorModel {
}



public class Gravity extends BehaviorModel {
	public final double gravity = 8.0;

	public void applyTo( Shape shape ) {
		VectorSprite( shape ).dY += perSecond( gravity );
	}
}



public class HorizontalMovement extends BehaviorModel {
	public SpriteAndTileCollisionHandler collisionHandler;

	public static HorizontalMovement create( SpriteAndTileCollisionHandler collisionHandler ) {
		HorizontalMovement horizontalMovement = new HorizontalMovement();
		horizontalMovement.collisionHandler = collisionHandler;
		return horizontalMovement;
	}

	public void applyTo( Shape shape ) {
		VectorSprite sprite = VectorSprite( shape );
		sprite.move( sprite.dX, 0 );
		sprite.collisionsWithTileMap( example.tileMap, collisionHandler );
	}

	public String info( Shape shape ) {
		return trimDouble( VectorSprite( shape ).dX );
	}
}



public class BumpingWalls extends SpriteAndTileCollisionHandler {
	public void handleCollision( Sprite sprite, TileMap tileMap, int tileX, int tileY, Sprite collisionSprite ) {
		sprite.pushFromTile( tileMap, tileX, tileY );
		VectorSprite( sprite ).dX *= -1;
		sprite.visualizer.xScale *= -1;
	}
}



public class PushFromWalls extends SpriteAndTileCollisionHandler {
	public void handleCollision( Sprite sprite, TileMap tileMap, int tileX, int tileY, Sprite collisionSprite ) {
		if( tileMap.getTile( tileX, tileY ) == example.bricks ) sprite.pushFromTile( tileMap, tileX, tileY );
	}
}



public class VerticalMovement extends BehaviorModel {
	public VerticalCollisionHandler handler = new VerticalCollisionHandler();

	public static VerticalMovement create( int forPlayer ) {
		VerticalMovement verticalMovement = new VerticalMovement();
		verticalMovement.handler.forPlayer = forPlayer;
		return verticalMovement;
	}

	public void applyTo( Shape shape ) {
		VectorSprite sprite = VectorSprite( shape );
		sprite.move( 0, sprite.dY );
		sprite.collisionsWithTileMap( example.tileMap, handler );
	}

	public String info( Shape shape ) {
		return trimDouble( VectorSprite( shape ).dY );
	}
}



public class VerticalCollisionHandler extends SpriteAndTileCollisionHandler {
	public int forPlayer;

	public void handleCollision( Sprite sprite, TileMap tileMap, int tileX, int tileY, Sprite collisionSprite ) {
		if( forPlayer ) if tileMap.getTile( tileX, tileY ) != example.bricks then return;
		GameObject gameObject = GameObject( sprite );
		gameObject.pushFromTile( tileMap, tileX, tileY );
		if( gameObject.dY > 0 ) {
			gameObject.onLand.activateModel( sprite );
			gameObject.fallingAnimation.deactivateModel( sprite );
			gameObject.jumpingAnimation.deactivateModel( sprite );
		}
		gameObject.dY = 0;
	}
}



public class Jump extends BehaviorModel {
	public double fromStrength, double toStrength;

	public static Jump create( double fromStrength, double toStrength ) {
		Jump jump = new Jump();
		jump.fromStrength = fromStrength;
		jump.toStrength = toStrength;
		return jump;
	}

	public void applyTo( Shape shape ) {
		VectorSprite( shape ).dY = -Math.random( fromStrength, toStrength );
		remove( shape );
	}
}



public class CreateBullet extends BehaviorModel {
	public double fromSpeed, double toSpeed;

	public static CreateBullet create( double fromSpeed, double toSpeed ) {
		CreateBullet createBullet = new CreateBullet();
		createBullet.fromSpeed = fromSpeed;
		createBullet.toSpeed = toSpeed;
		return createBullet;
	}

	public void applyTo( Shape shape ) {
		Bullet.create( VectorSprite( shape ), Math.random( fromSpeed, toSpeed ) );
		remove( shape );
	}
}



public class Bullet extends VectorSprite {
	public final double minAttack = 5.0;
	public final double maxAttack = 10.0;

	public int collisions = true;

	public static void create( VectorSprite jelly, double speed ) {
		Bullet bullet = new Bullet();
		bullet.setCoords( jelly.x + sgn( jelly.dX ) * jelly.width * 2.2, jelly.y - 0.15 * jelly.height );
		bullet.setSize( 0.45 * jelly.width, 0.45 * jelly.width );
		bullet.shapeType = Sprite.oval;
		bullet.dX = sgn( jelly.dX ) * speed;
		bullet.visualizer.setVisualizerScale( 12, 4 );
		bullet.visualizer.image = jelly.visualizer.image;
		bullet.frame = 6;
		example.layer.addLast( bullet );
	}

	public void act() {
		moveForward();
		if( collisions ) collisionsWithTileMap( example.tileMap, example.destroyBullet );
		super.act();
	}

	public static void disable( Sprite sprite ) {
		Bullet bullet = Bullet( sprite );
		if( bullet.collisions ) {
			bullet.attachModel( new Death() );
			bullet.attachModel( new Gravity() );
			bullet.reverseDirection();
			bullet.collisions = false;
			bullet.dX *= 0.25;
		}
	}
}



public class DestroyBullet extends SpriteAndTileCollisionHandler {
	public void handleCollision( Sprite sprite, TileMap tileMap, int tileX, int tileY, Sprite collisionSprite ) {
		if( tileMap.getTile( tileX, tileY ) == example.bricks ) Bullet.disable( sprite );
	}
}



public class MovementControl extends BehaviorModel {
	public void applyTo( Shape shape ) {
		AwPossum awPossum = AwPossum( shape );
		if( awPossum.gravity.active ) {
			if( awPossum.moveLeftKey.isDown() ) {
				awPossum.setFacing( Sprite.leftFacing );
				awPossum.dX = -awPossum.walkingSpeed;
			} else if( awPossum.moveRightKey.isDown() ) {
				awPossum.setFacing( Sprite.rightFacing );
				awPossum.dX = awPossum.walkingSpeed;
			} else {
				awPossum.dX = 0;
			}
		} else {
			awPossum.dX = 0;
		}

		if( awPossum.dX && awPossum.onLand.active ) {
			awPossum.movementAnimation.activateModel( shape );
		} else {
			awPossum.movementAnimation.deactivateModel( shape );
		}
	}
}




public class AwPossumHurtingCollision extends SpriteCollisionHandler {
	public void handleCollision( Sprite sprite1, Sprite sprite2 ) {
		if( sprite1.findModel( "TImmortality" ) ) return;
		if( sprite2.findModel( "TDeath" ) ) return;

		double damage = 0;
		if( Jelly( sprite2 ) ) damage = Math.random( Jelly.minAttack, Jelly.maxAttack );
		Bullet bullet = Bullet( sprite2 );
		if( bullet ) {
			if( bullet.collisions ) {
				damage = Math.random( Bullet.minAttack, Bullet.maxAttack ) * sprite2.getDiameter() / 0.45;
				example.layer.remove( sprite2 );
			}
		}
		if( damage ) {
			AwPossum awPossum = AwPossum( sprite1 );
			awPossum.health -= damage;
			if( awPossum.health > 0.0 ) {
				sprite1.attachModel( new Immortality() );
				sprite1.attachModel( new KnockOut() );
			} else if( ! sprite1.findModel( "TDeath" ) ) {
				sprite1.behaviorModels.clear();
				sprite1.attachModel( new Death() );
			}
		}
	}
}



public class Immortality extends FixedWaitingModel {
	public final double blinkingSpeed = 0.05;

	public void init( Shape shape ) {
		period = AwPossum.immortalPeriod;
	}

	public void applyTo( Shape shape ) {
		shape.visible = Math.floor( currentProject.time / blinkingSpeed ) % 2;
		super.applyTo( shape );
	}

	public void deactivate( Shape shape ) {
		shape.visible = true;
	}
}



public class KnockOut extends FixedWaitingModel {
	public void init( Shape shape ) {
		AwPossum awPossum = AwPossum( shape );
		period = awPossum.knockOutPeriod;
		awPossum.dX = -awPossum.getFacing() * awPossum.knockOutStrength;
		awPossum.movementControl.deactivateModel( shape );
		awPossum.hurtingAnimation.activateModel( shape );
	}

	public void applyTo( Shape shape ) {
		VectorSprite( shape ).dX *= 0.9;
		super.applyTo( shape );
	}

	public void deactivate( Shape shape ) {
		AwPossum awPossum = AwPossum( shape );
		awPossum.hurtingAnimation.deactivateModel( shape );
		awPossum.movementControl.activateModel( shape );
	}
}



public class HittingArea extends FixedWaitingModel {
	public Sprite Area;
	public int punch;

	public static HittingArea create2( int punch ) {
		HittingArea Area = new HittingArea();
		Area.punch = punch;
		return Area;
	}

	public void init( Shape shape ) {
		Area = new Sprite();
		Area.shapeType = Sprite.oval;
		Area.setDiameter( 0.3 );
		period = AwPossum.hitPeriod;
		example.awPossumHitCollision.collided = false;
	}

	public void applyTo( Shape shape ) {
		if( punch ) {
			Area.setCoords( shape.x + shape.getFacing() * 0.95, shape.y + 0.15 );
		} else {
			Area.setCoords( shape.x + shape.getFacing() * 0.95, shape.y - 0.1 );
		}
		//Example.HitArea = Area
		Area.collisionsWithLayer( example.layer, example.awPossumHitCollision );
		if( example.awPossumHitCollision.collided ) remove( shape );
		super.applyTo( shape );
	}

	//Method Deactivate( LTShape Shape )
	//	Example.HitArea = Null
	//End Method
}



public class AwPossumHitCollision extends SpriteCollisionHandler {
	public int collided ;

	public void handleCollision( Sprite sprite1, Sprite sprite2 ) {
		Jelly jelly = Jelly( sprite2 );
		if( jelly ) {
			jelly.health -= Math.random( AwPossum.minAttack, AwPossum.maxAttack );
			if( jelly.health > 0 ) {
				jelly.attachModel( new JellyHurt() );
			} else if( ! jelly.findModel( "TDeath" ) ) {
				Score.create( jelly, jelly.score );

				AwPossum awPossum = AwPossum( example.layer.findShapeWithType( "TAwPossum" ) );
				awPossum.health = Math.min( awPossum.health + Math.random( AwPossum.minHealthGain, AwPossum.maxHealthGain ), 100.0 );

				jelly.behaviorModels.clear();
				jelly.attachModel( new Death() );
			}
			collided = true;
		} else if( Bullet( sprite2 ) ) {
			if( ! sprite2.findModel( "TDeath" ) ) {
				Bullet.disable( sprite2 );
				Score.create( sprite2, 50 );
			}
		}
	}
}



public class JellyHurt extends FixedWaitingModel {
	public void init( Shape shape ) {
		period = Jelly.hurtingTime;
		shape.deactivateModel( "THorizontalMovement" );
	}

	public void applyTo( Shape shape ) {
		super.applyTo( shape );
		double intensity = ( currentProject.time - startingTime ) / period;
		if( intensity <= 1.0 ) shape.visualizer.setColorFromRGB( 1.0, intensity, intensity );
	}

	public void deactivate( Shape shape ) {
		shape.activateModel( "THorizontalMovement" );
		shape.visualizer.setColorFromHex( "FFFFFF" );
	}
}



public class Death extends FixedWaitingModel {
	public void init( Shape shape ) {
		period = example.deathPeriod;
	}

	public void applyTo( Shape shape ) {
		super.applyTo( shape );
		double alpha = 1.0 - ( currentProject.time - startingTime ) / period;
		if( alpha >= 0.0 ) shape.visualizer.alpha = alpha;
	}

	public void deactivate( Shape shape ) {
		example.layer.remove( shape );
	}
}



public class Score extends Sprite {
	public final double speed = 2.0;
	public final double period = 3.0;

	public int amount;
	public double startingTime;

	public static void create( Sprite sprite, int amount ) {
		Score score = new Score();
		score.setCoords( sprite.x, sprite.topY() );
		score.amount = amount;
		score.setDiameter( 0 );
		score.startingTime = currentProject.time;
		example.score += amount;
		example.layer.addLast( score );
	}

	public void act() {
		move( 0, -speed );
		if( currentProject.time > startingTime + period ) example.layer.remove( this );
	}

	public void draw() {
		printText( "+" + amount, , Align.toBottom, , , true );
	}
}



public class Restart extends Project {
	public int startingTime = System.currentTimeMillis()();
	public int initialized;

	public void render() {
		if( System.currentTimeMillis()() < startingTime + 2000 ) {
			example.render();
			currentCamera.darken( 0.0005 * ( System.currentTimeMillis()() - startingTime ) );
		} else if( System.currentTimeMillis()() < startingTime + 4000 ) {
			if( ! initialized ) {
				example.initLevel();
				initialized = true;
			}
			example.render();
			currentCamera.darken( 0.0005 * ( 4000 - System.currentTimeMillis()() + startingTime ) );
		} else {
			exiting = true;
		}
	}
}
