package examples;
import dwlab.behavior_models.FixedJoint;
import java.util.LinkedList;
import java.lang.Math;
import java.lang.System;
import dwlab.behavior_models.IsModelActive;
import dwlab.base.XMLObject;
import dwlab.behavior_models.RandomWaitingModel;
import dwlab.base.BitmapFont;
import dwlab.base.Action;
import dwlab.behavior_models.BehaviorModel;
import dwlab.behavior_models.RevoluteJoint;
import dwlab.base.Align;
import dwlab.behavior_models.IsButtonActionDown;
import dwlab.shapes.maps.TileMap;
import dwlab.behavior_models.AnimationModel;
import dwlab.behavior_models.ModelActivator;
import dwlab.base.Image;
import dwlab.base.Project;
import dwlab.base.RasterFrame;
import dwlab.base.Object;
import dwlab.behavior_models.DistanceJoint;
import dwlab.controllers.ButtonAction;
import dwlab.behavior_models.FixedWaitingModel;
import dwlab.base.Drag;
import dwlab.shapes.layers.EditorData;
import dwlab.behavior_models.ModelDeactivator;
import dwlab.shapes.sprites.Camera;
import dwlab.behavior_models.ModelStack;
import dwlab.shapes.Shape;
import dwlab.shapes.LineSegment;
import dwlab.controllers.KeyboardKey;
import dwlab.shapes.sprites.VectorSprite;
import dwlab.controllers.MouseButton;
import dwlab.graph.Graph;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.layers.World;
import dwlab.shapes.maps.DoubleMap;
import dwlab.visualizers.ContourVisualizer;
import dwlab.shapes.sprites.SpriteCollisionHandler;
import dwlab.shapes.sprites.Sprite;
import dwlab.shapes.sprites.SpriteAndTileCollisionHandler;
import dwlab.shapes.maps.SpriteMap;
import dwlab.visualizers.MarchingAnts;
import dwlab.shapes.maps.TileSet;
import dwlab.visualizers.Visualizer;

superStrict;




initGraphics();
printText( "Press ESC to switch examples", 0, 0, Align.toCenter, Align.toCenter );
flip;
waitkey;


//Active.bmx
currentCamera = Camera.create();
public static Example1 example1 = new Example1();
example1.execute();

public class Example1 extends Project {
	public final int spritesQuantity = 50;

	public Layer layer = new Layer();
	public Shape rectangle = Sprite.fromShape( 0, 0, 30, 20 );

	public void init() {
		for( int n = 1; n <= spritesQuantity; n++ ) {
			Ball1.create();
		}
		rectangle.visualizer = ContourVisualizer.fromWidthAndHexColor( 0.1, "FF0000" );
		currentCamera = Camera.create();
	}

	public void logic() {
		layer.act();
		if( keyHit( key_Space ) ) {
			for( Sprite sprite : layer ) {
				sprite.active = true;
				sprite.visible = true;
			}
		}
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		layer.draw();
		rectangle.draw();
		drawText( "Press left mouse button on circle to make it inactive, right button to make it invisible.", 0, 0 );
		drawText( "Press space to restore all back.", 0, 16 );
		printText( "Active, BounceInside, CollisionsWisthSprite, HandleCollisionWithSprite, Visible example", 0, 12, Align.toCenter, Align.toBottom );
	}
}

public class Ball1 extends Sprite {
	public CollisionHandler1 handler = new CollisionHandler1();

	public static Ball1 create() {
		Ball1 ball = new Ball1();
		ball.setCoords( Math.random( -13, 13 ), Math.random( -8, 8 ) );
		ball.setDiameter( Math.random( 0.5, 1.5 ) );
		ball.angle = Math.random( 360 );
		ball.velocity = Math.random( 3, 7 );
		ball.shapeType = Sprite.oval;
		ball.visualizer.setRandomColor();
		example1.layer.addLast( ball );
		return ball;
	}

	public void act() {
		moveForward();
		bounceInside( example1.rectangle );
		collisionsWithSprite( cursor, handler );
	}
}

public class CollisionHandler1 extends SpriteCollisionHandler {
	public void handleCollision( Sprite sprite1, Sprite sprite2 ) {
		if( mouseDown( 1 ) ) sprite1.active = false;
		if( mouseDown( 2 ) ) sprite1.visible = false;
	}
}
cls;


incbin "mario.png";

//Animate.bmx
currentCamera = Camera.create();
public static Example2 example2 = new Example2();
example2.execute();

public class Example2 extends Project {
	public Sprite player = Sprite.fromShape( 0, 0, 1, 2 );
	public double startingTime;
	public int pingPong;

	public void init() {
		player.visualizer.image = Image.fromFile( " incbinmario .png", 4 );
		currentCamera = Camera.create();
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
cls;



//AnimateTest2.bmx
currentCamera = Camera.create();
public static Example3 example3 = new Example3();
example3.execute();

public class Example3 extends Project {
	public Sprite player = Sprite.fromShape(0, 0, 1, 2);
	public Sprite playerClone = Sprite.fromShape(4, 0, 1, 2);
	public Sprite entrance = Sprite.fromShape(2, 1, 4, 4);
	public double startingTime;
	public int pingPong;

	public void init() {
		player.visualizer.image = Image.fromFile(" incbinmario .png", 4);
		playerClone.visualizer.image = Image.fromFile(" incbinmario .png", 4);
		entrance.visualizer.alpha = 0.3;
		currentCamera = Camera.create();
	}

	public void logic() {
		if( keyDown( key_Space ) ) {
			if( startingTime == 0 ) startingTime = time;
			player.animate( 0.1, 3, 1, startingTime, pingPong );
		} else {
			player.frame = 0;
			startingTime = 0;
		}
		if( keyHit(kEY_P) ) pingPong = ! pingPong;
		if( keyHit(kEY_LEFT) ) player.setFacing(Sprite.leftFacing);
		if( keyHit(kEY_RIGHT) ) player.setFacing(Sprite.rightFacing);
		if( keyHit(kEY_C) ) {
			player.limitByWindowShape(entrance);
			playerClone.limitByWindowShape(entrance);
		}
		playerClone.frame = player.frame;
		playerClone.setFacing(player.getFacing());
		if( appTerminate() || keyHit(kEY_ESCAPE) ) exiting = true;
	}

	public void render() {
		player.draw();
		playerClone.draw();
		entrance.draw();
		drawText( "Press space to animate sprite, P to toggle ping-pong animation (now it's " + pingPong + ")", 0, 0 );
		printText( "Animate example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;


incbin "kolobok.png";

//Clone.bmx
currentCamera = Camera.create();
public static Example4 example4 = new Example4();
example4.execute();

public class Example4 extends Project {
	public final int spritesQuantity = 50;

	public Layer sprites = new Layer();
	public Image spriteImage = Image.fromFile( " incbinkolobok .png" );

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
		currentCamera = Camera.create();
	}

	public void logic() {
		if( mouseHit( 1 ) ) {
			Sprite sprite = cursor.firstCollidedSpriteOfLayer( sprites );
			if( sprite ) {
				Sprite newSprite = Sprite( sprite.clone() );
				newSprite.alterCoords( Math.random( -2, 2 ), Math.random( -2, 2 ) );
				newSprite.alterDiameter( Math.random( 0.75, 1.5 ) );
				newSprite.alterAngle( Math.random( -45, 45 ) ) ;
				sprites.addLast( newSprite );
			}
		}

		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		sprites.draw();
		drawText( "Clone sprites with left mouse button", 0, 0 );
		printText( "AlterAngle, AlterCoords, AlterDiameter, Clone example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;


//CollidesWithSprite.bmx
currentCamera = Camera.create();
public static Example5 example5 = new Example5();
example5.execute();

incbin "spaceship.png";

public class Example5 extends Project {
	public Layer sprites = new Layer();
	public Image image = Image.fromFile( " incbinspaceship .png" );

	public void init() {
		for( int n = 0; n <= 9; n++ ) {
			Sprite sprite = new Sprite().fromShape( ( n % 3 ) * 8.0 - 8.0, Math.floor( n / 3 ) * 6.0 - 6.0, 6.0, 4.0, n );
			if( n == Sprite.raster ) sprite.visualizer.image = image;
			sprite.visualizer.setColorFromHex( "7FFF7F" );
			sprite.angle = 60;
			sprites.addLast( sprite );
		}
		currentCamera = Camera.create();
		cursor = new Sprite().fromShape( 0.0, 0.0, 5.0, 7.0, Sprite.pivot );
		cursor.angle = 45;
		cursor.visualizer.setColorFromHex( "7F7F7FFF" );
		cursor.shapeType = Sprite.ray;
	}

	public void logic() {
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
		if( mouseHit( 2 ) ) {
			cursor.shapeType = ( cursor.shapeType + 1 ) % 9;
			if( cursor.shapeType == Sprite.raster ) cursor.visualizer.image = image; else cursor.visualizer.image = null;
		}
		//L_Cursor.Angle += 0.5
	}

	public void render() {
		sprites.draw();
		for( Sprite sprite : sprites.children ) {
			//If Sprite.ShapeType < 4 Then Continue
			if( cursor.collidesWithSprite( sprite ) ) {
				sprite.visualizer.setColorFromHex( "FF7F7F" );
				Sprite wedgedCursor = Sprite( cursor.clone() );
				wedgedCursor.wedgeOffWithSprite( sprite, 0, 1 );
				wedgedCursor.visualizer.setColorFromHex( "7F7FFFFF" );
				wedgedCursor.draw();
			} else {
				sprite.visualizer.setColorFromHex( "7FFF7F" );
			}
		}
		cursor.draw();

		printText( "Press right mouse button to change shape ", 0, -12, Align.toCenter, Align.toTop );
		printText( "ColldesWithSprite example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;



//CorrectHeight.bmx
currentCamera = Camera.create();
public static Example6 example6 = new Example6();
example6.execute();

public class Example6 extends Project {
	public final int spritesQuantity = 50;

	public Layer layer = new Layer();

	public void init() {
		currentCamera = Camera.create();
		Visualizer spriteVisualizer = Visualizer.fromFile( " incbinmario .png", 4 );
		for( int n = 1; n <= spritesQuantity; n++ ) {
			Sprite sprite = Sprite.fromShape( Math.random( -15, 15 ), Math.random( -11, 11 ), Math.random( 0.5, 2 ), Math.random( 0.5, 2 ) );
			sprite.visualizer = spriteVisualizer;
			layer.addLast( sprite );
		}
	}

	public void logic() {
		if( keyHit( key_Space ) ) {
			for( Sprite sprite : layer ) {
				sprite.correctHeight();
			}
		}
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		layer.draw();
		drawText( "Press space to correct height", 0, 0 );
		printText( "CorrectHeight example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;



//DirectAs.bmx
currentCamera = Camera.create();
public static Example7 example7 = new Example7();
example7.execute();

public class Example7 extends Project {
	public final int spritesQuantity = 50;

	public Layer layer = new Layer();
	public Cursor7 cursor = new Cursor7();
	public Image spriteImage = Image.fromFile( " incbinkolobok .png" );
	public Sprite selected;

	public void init() {
		for( int n = 1; n <= spritesQuantity; n++ ) {
			Sprite sprite = Sprite.fromShape( Math.random( -15, 15 ), Math.random( -11, 11 ), , , Sprite.oval, Math.random( 360 ) );
			sprite.setDiameter( Math.random( 1, 3 ) );
			sprite.visualizer.setRandomColor();
			sprite.visualizer.image = spriteImage;
			layer.addLast( sprite );
		}

		cursor.visualizer.image = spriteImage;
		cursor.shapeType = Sprite.pivot;
		currentCamera = Camera.create();
	}

	public void logic() {
		cursor.act();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		layer.draw();
		cursor.draw();
		drawText( "Click left mouse button on sprite to direct cursor sprite as it", 0, 0 );
		drawText( "and right button to set size equal to sprite's", 0, 16 );
		printText( "DirectAs, SetSizeAs example", 0, 12, Align.toCenter, Align.toBottom );
	}
}



public class Cursor7 extends Sprite {
	public SizeCollisionHandler sizeHandler = new SizeCollisionHandler();
	public DirectionCollisionHandler directionHandler = new DirectionCollisionHandler();

	public void act() {
		setMouseCoords();
		if( mouseHit( 1 ) ) collisionsWithLayer( example7.layer, directionHandler );
		if( mouseHit( 2 ) ) collisionsWithLayer( example7.layer, sizeHandler );
	}
}



public class SizeCollisionHandler extends SpriteCollisionHandler {
	public void handleCollision( Sprite sprite1, Sprite sprite2 ) {
		sprite1.setSizeAs( sprite2 );
	}
}



public class DirectionCollisionHandler extends SpriteCollisionHandler {
	public void handleCollision( Sprite sprite1, Sprite sprite2 ) {
		sprite1.directAs( sprite2 );
	}
}
cls;



//DirectTo.bmx
currentCamera = Camera.create();
public static Example8 example8 = new Example8();
example8.execute();

public class Example8 extends Project {
	public final int koloboksQuantity = 50;

	public Layer layer = new Layer();
	public Image kolobokImage = Image.fromFile( " incbinkolobok .png" );

	public void init() {
		for( int n = 1; n <= koloboksQuantity; n++ ) {
			Kolobok8 kolobok = new Kolobok8();
			kolobok.setCoords( Math.random( -15, 15 ), Math.random( -11, 11 ) );
			kolobok.setDiameter( Math.random( 1, 3 ) );
			kolobok.shapeType = Sprite.oval;
			kolobok.visualizer.setRandomColor();
			kolobok.visualizer.image = kolobokImage;
			layer.addLast( kolobok );
		}
		currentCamera = Camera.create();
	}

	public void logic() {
		layer.act();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		layer.draw();
		printText( "DirectTo example", 0, 12, Align.toCenter, Align.toBottom );
	}
}



public class Kolobok8 extends Sprite {
	public void act() {
		directTo( cursor );
	}
}
cls;


//DistanceToPoint.bmx
currentCamera = Camera.create();
public static Example9 example9 = new Example9();
example9.execute();

public class Example9 extends Project {
	public final int spritesQuantity = 20;

	public Layer layer = new Layer();
	public LineSegment lineSegment = new LineSegment();
	public Sprite minSprite;

	public void init() {
		currentCamera = Camera.create();
		for( int n = 1; n <= spritesQuantity; n++ ) {
			Sprite sprite = Sprite.fromShape( Math.random( -15, 15 ), Math.random( -11, 11 ), , , Sprite.oval );
			sprite.setDiameter( Math.random( 0.5, 1.5 ) );
			sprite.visualizer.setRandomColor();
			layer.addLast( sprite );
		}
		cursor = Sprite.fromShape( 0, 0, 0.5, 0.5, Sprite.oval );
		lineSegment.pivot[ 0 ] = cursor;
	}

	public void logic() {
		minSprite = null;
		double minDistance;
		for( Sprite sprite : layer ) {
			if( cursor.distanceTo( sprite ) < minDistance || ! minSprite ) {
				minSprite = sprite;
				minDistance = cursor.distanceTo( sprite );
			}
		}
		lineSegment.pivot[ 1 ] = minSprite;

		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		layer.draw();

		lineSegment.draw();
		printText( trimDouble( cursor.distanceTo( minSprite ) ), 0.5 * ( cursor.x + minSprite.x ), 0.5 * ( cursor.y + minSprite.y ) );

		double sX, double sY;
		currentCamera.fieldToScreen( cursor.x, cursor.y, sX, sY );
		drawLine( sX, sY, 400, 300 );
		printText( trimDouble( cursor.distanceToPoint( 0, 0 ) ), 0.5 * cursor.x, 0.5 * cursor.y );

		drawText( "Direction to field center is " + trimDouble( cursor.directionToPoint( 0, 0 ) ), 0, 0 );
		drawText( "Direction to nearest sprite is " + trimDouble( cursor.directionTo( minSprite ) ), 0, 16 );
		printText( "DirectionTo, DirectionToPoint, DistanceTo, DistanceToPoint example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;


//DrawCircle.bmx
currentCamera = Camera.create();
public static Example10 example10 = new Example10();
example10.execute();

public class Example10 extends Project {
	public final int mapSize = 128;
	public final double mapScale = 4.0;
	public final double picScale = 5.0;

	public DoubleMap doubleMap = DoubleMap.create( mapSize, mapSize );

	public void init() {
		currentCamera = Camera.create();
		setClsColor( 0, 0, 255 );
		float array[][][] = [ [ [ 0.0, -7.0, 5.0 ], [ 0.0, -1.5, 7.0 ], [ -4.0, -3.0, 2.0 ], [ 4.0, -3.0, 2.0 ], [ 0.0, 6.0, 9.0 ] ], 
				[ [ 0.0, -7.0, 1.5 ], [ -1.0, -8.0, 1.0 ], [ 1.0, -8.0, 1.0 ], [ 0.0, -3.5, 1.0 ], [ 0.0, -2.0, 1.0 ], [ 0.0, -0.5, 1.0 ] ] ];
		for( int col = 0; col <= 1; col++ ) {
			for local float shape[] = eachin array[ col ];
				doubleMap.drawCircle( shape[ 0 ] * picScale + 0.5 * mapSize, shape[ 1 ] * picScale + 0.5 * mapSize, 0.5 * shape[ 2 ] * picScale, 1.0 - 0.7 * col );
			}
		}
	}

	public void logic() {
		if( keyHit( key_Space ) ) doubleMap.blur();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		setScale( mapScale, mapScale );
		drawImage( doubleMap.toNewImage().bMaxImage, 400, 300 );
		setScale( 1, 1 );
		drawText( "Press space to blur map", 0, 0 );
		printText( "DrawCircle, Blur example", 0, 12, Align.toCenter, Align.toBottom );
	}

	public void deInit() {
		setClsColor( 0, 0, 0 );
	}
}
cls;


incbin "tiles.png";
incbin "hit.ogg";

//DrawTile.bmx
currentCamera = Camera.create();
public static Example11 example11 = new Example11();
example11.execute();

public class Example11 extends Project {
	public final int tileMapWidth = 16;
	public final int tileMapHeight = 12;
	public final double shakingPeriod = 1.0;
	public final double periodBetweenShakes = 3.0;

	public TileMap tileMap = TileMap.create( TileSet.create( Image.fromFile( " incbintiles .png", 8, 4 ) ), tileMapWidth, tileMapHeight );
	public tSound hitSound = tSound.load( " incbinhit .ogg", false );
	public double shakingK;
	public double lastShakingTime = -100;

	public void init() {
		currentCamera = Camera.create();
		tileMap.setSize( tileMapWidth * 2, tileMapHeight * 2 );
		for( int y = 0; y <= tileMapHeight; y++ ) {
			for( int x = 0; x <= tileMapWidth; x++ ) {
				tileMap.setTile( x, y, rand( 1, 31 ) );
			}
		}
		tileMap.visualizer = new ShakingVisualizer();
	}

	public void logic() {
		if( time - lastShakingTime > periodBetweenShakes ) {
			lastShakingTime = time;
			hitSound.play();
		}
		if( time - lastShakingTime < shakingPeriod ) {
			shakingK = ( 1.0 - ( time - lastShakingTime ) / shakingPeriod ) ^ 2;
		} else {
			shakingK = 0.0;
		}
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		tileMap.draw();
		printText( "DrawTile example", 0, 12, Align.toCenter, Align.toBottom );
	}
}

public class ShakingVisualizer extends Visualizer {
	public final double dAngle = 15;
	public final double dCoord = 0.2;

	public void drawTile( TileMap tileMap, double x, double y, double width, double height, int tileX, int tileY ) {
		TileSet tileSet =tilemap.tileSet;
		int tileValue = getTileValue( tileMap, tileX, tileY );
		if( tileValue == tileSet.emptyTile ) return;

		setRotation( Math.random( -dAngle * example11.shakingK, dAngle * example11.shakingK ) );
		x += Math.random( -dCoord * example11.shakingK, dCoord * example11.shakingK );
		y += Math.random( -dCoord * example11.shakingK, dCoord * example11.shakingK );

		double sX, double sY;
		currentCamera.fieldToScreen( x, y, sX, sY );

		tileSet.image.draw( sX, sY, width, height, tileValue )		;

		setRotation( 0 );
	}
}
cls;


//DrawUsingLine.bmx
currentCamera = Camera.create();
public static Example12 example12 = new Example12();
example12.execute();

public class Example12 extends Project {
	public Layer lineSegments = new Layer();

	public void init() {
		currentCamera = Camera.create();
		currentCamera.setMagnification( 75.0 );
		Blazing visualizer = new Blazing();
		for local int pivots[] = eachin [ [ -4, -2, -2, -2 ], [ -4, -2, -4, 0 ], [ -4, 0, -4, 2 ], [ -4, 0, -3, 0 ], [ 1, -2, -1, -2 ], [ -1, -2, -1, 0 ], [ -1, 0, 1, 0 ], 
				[ 1, 0, 1, 2 ], [ 1, 2, -1, 2 ], [ 4, -2, 2, -2 ], [ 2, -2, 2, 0 ], [ 2, 0, 2, 2 ], [ 2, 0, 3, 0 ] ];
			LineSegment lineSegment = LineSegment.fromPivots( Sprite.fromShape( pivots[ 0 ], pivots[ 1 ] ), Sprite.fromShape( pivots[ 2 ], pivots[ 3 ] ) );
			lineSegment.visualizer = visualizer;
			lineSegments.addLast( lineSegment );
		}
	}

	public void logic() {
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		lineSegments.draw();
		drawText( "Free Software Forever!", 0, 0 );
		printText( "DrawUsingLine example", 0, 12, Align.toCenter, Align.toBottom );
	}
}



public class Blazing extends Visualizer {
	public final double chunkSize = 25;
	public final double deformationRadius = 15;
	public void drawUsingLineSegment( LineSegment lineSegment ) {
		sX1d, sY1d, sX2d, sY2d;
		currentCamera.fieldToScreen( lineSegment.pivot[ 0 ].x, lineSegment.pivot[ 0 ].y, sX1, sY1 );
		currentCamera.fieldToScreen( lineSegment.pivot[ 1 ].x, lineSegment.pivot[ 1 ].y, sX2, sY2 );
		int chunkQuantity = Math.max( 1, round( 1.0 * distance( sX2 - sX1, sY2 - sY1 ) / chunkSize ) );
		double oldX, double oldY;
		for( int n = 0; n <= chunkQuantity; n++ ) {
			double radius = 0;
			if( n > 0 && n < chunkQuantity ) radius = Math.random( 0.0, deformationRadius );

			double angle = Math.random( 0.0, 360.0 );
			int x = sX1 + ( sX2 - sX1 ) * n / chunkQuantity + Math.cos( angle ) * radius;
			int y = sY1 + ( sY2 - sY1 ) * n / chunkQuantity + Math.sin( angle ) * radius;

			setLineWidth( 9 );
			setColor( 0, 255, 255 );
			drawOval( x - 4, y - 4, 9, 9 );
			if( n > 0 ) {
				drawOval( oldX - 4, oldY - 4, 9, 9 );
				drawLine( x, y, oldX, oldY );
			}
			setLineWidth( 4 );
			setColor( 255, 255, 255 );
			drawOval( x - 2, y - 2, 5, 5 );
			if( n > 0 ) {
				drawOval( oldX - 2, oldY - 2, 5, 5 );
				drawLine( x, y, oldX, oldY );
			}

			oldX = x;
			oldY = y;
		}
	}
}
cls;


//DrawUsingSprite.bmx
currentCamera = Camera.create();
public static Example13 example13 = new Example13();
example13.execute();

public class Example13 extends Project {
	public final int flowersQuantity = 12;
	public final double flowerCircleDiameter = 9;
	public final double flowerDiameter = 1.8;

	public Sprite flowers[] = new Sprite()[ flowersQuantity ];
	public FlowerVisualizer flowerVisualizer = new FlowerVisualizer();

	public void init() {
		currentCamera = Camera.create();
		for( int n = 0; n <= flowersQuantity; n++ ) {
			flowers[ n ] = new Sprite();
			flowers[ n ].setDiameter( flowerDiameter );
		}
	}

	public void logic() {
		for( int n = 0; n <= flowersQuantity; n++ ) {
			double angle = n * 360 / flowersQuantity + 45 * time;
			flowers[ n ].setCoords( Math.cos( angle ) * flowerCircleDiameter, Math.sin( angle ) * flowerCircleDiameter );
			flowers[ n ].angle = 90 * time;
		}
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		for( int n = 0; n <= flowersQuantity; n++ ) {
			flowers[ n ].drawUsingVisualizer( flowerVisualizer );
		}
		printText( "DrawUsingSprite example", 0, 12, Align.toCenter, Align.toBottom );
	}
}

public class FlowerVisualizer extends Visualizer {
	public final int circlesQuantity = 30;
	public final circlesPer360 = 7;
	public final double amplitude = 0.15;

	public void drawUsingSprite( Sprite sprite, Sprite spriteShape = null ) {
		double spriteDiameter = sprite.getDiameter();
		double circleDiameter = currentCamera.distFieldToScreen( 2.0 * PI * spriteDiameter / circlesQuantity ) * 1.5;
		for( int n = 0; n <= circlesQuantity; n++ ) {
			double angle = 360.0 * n / circlesQuantity;
			double angles = sprite.angle + angle;
			double distance = spriteDiameter * ( 1.0 + amplitude * Math.sin( 360.0 * example13.time + 360.0 * n / circlesQuantity * circlesPer360 ) );
			double sX, double sY;
			currentCamera.fieldToScreen( sprite.x + distance * Math.cos( angles ), sprite.y + distance * Math.sin( angles ), sX, sY );
			drawOval( sX - 0.5 * circleDiameter, sY - 0.5 * circleDiameter, circleDiameter, circleDiameter );
		}
	}
}
cls;


public final mapSize14 = 64;
public final mapScale14d = 8;
public final filledTileNum14 = 20;

incbin "tileset.lw";
incbin "curved_areas.png";

//Enframe.bmx
currentCamera = Camera.create();
ex14();
public static void ex14() {
currentCamera = Camera.create();
editorData = new EditorData();
setClsColor( 64, 128, 0 );

cls;
DoubleMap doubleMap = new DoubleMap();
doubleMap.setResolution( mapSize14, mapSize14 );
drawDoubleMap( doubleMap );
drawText( "Step creating 1 Double map and set its resolution", 0, 0 );
flip;
waitkey;

cls;
doubleMap.perlinNoise( 16, 16, 0.25, 0.5, 4 );
drawDoubleMap( doubleMap );
drawText( "Step filling 2 DoubleMap with Perlin noise", 0, 0 );
flip;
waitkey;

cls;
setIncbin( true );
World world = World.fromFile( "tileset.lw" );
setIncbin( false );
TileSet tileSet = TileSet( editorData.tilesets.getFirst() );
TileMap tileMap = TileMap.create( tileSet, mapSize14, mapSize14 );
tileMap.setSize( mapSize14 * mapScale14 / 25.0, mapSize14 * mapScale14 / 25.0 );
drawText( "Step loading 3 world, extract tileset from there and", 0, 0 );
drawText( "creating tilemap with same size and this tileset", 0, 16 );
drawDoubleMap( doubleMap );
flip;
waitkey;


cls;
doubleMap.extractTo( tileMap, 0.5, 1.0, filledTileNum14 );
drawText( "Step setting 4 tiles number of tilemap to FilledTileNum14", 0, 0 );
drawText( "if corresponding value of Double map is higher than 0.5", 0, 16 );
tileMap.draw();
drawSignature();
flip;
waitkey;

cls;
for( int y = 0; y <= mapSize14; y++ ) {
	for( int x = 0; x <= mapSize14; x++ ) {
		fix( tileMap, x, y );
	}
}
drawText( "Step preparing 5 tilemap by fixing some unmanaged cell positions", 0, 0 );
tileMap.draw();
drawSignature();
flip;
waitkey;

cls;
tileMap.enframe();
drawText( "Step enframing 6a tile map", 0, 0 );
tileMap.draw();
drawSignature();
flip;
waitkey;


cls;
prolongTiles = false;
tileMap.enframe() ;
drawText( "Step enframing 6b tile map with prolonging tiles off", 0, 0 );
tileMap.draw();
drawSignature();
flip;
waitkey;


setClsColor( 0, 0, 0 );


}
public static void drawDoubleMap( DoubleMap map ) {
	tImage image = createImage( mapSize14, mapSize14 );
	tPixmap pixmap = lockimage( image );
	clearPixels( pixmap, $fF000000 );
	map.pasteToPixmap( pixmap );
	unlockimage( image );
	setScale( mapScale14, mapScale14 );
	drawImage( image, 400 - 0.5 * mapScale14 * mapSize14, 300 - 0.5 * mapScale14 * mapSize14 );
	setScale( 1, 1 );
	drawSignature();
}



public static void drawSignature() {
	printText( "PerlinNoise, ExtractTo, Enframe, L_ProlongTiles, example", 0, 12, Align.toCenter, Align.toBottom );
}



public static void fix( TileMap tileMap, int x, int y ) {
	if( tileMap.value[ x, y ] == filledTileNum14 ) return;
	int doFix = false;

	int fixHorizontal = true;
	if( x > 0 && x < mapSize14 - 1 ) {
		if( tileMap.value[ x - 1, y ] == filledTileNum14 && tileMap.value[ x + 1, y ] == filledTileNum14 ) doFix = true;
	} else {
		fixHorizontal = false;
	}

	int fixVertical = true;
	if( y > 0 && y < mapSize14 - 1 ) {
		if( tileMap.value[ x, y - 1 ] == filledTileNum14 && tileMap.value[ x, y + 1 ] == filledTileNum14 ) doFix = true;
	} else {
		fixVertical = false;
	}

	if( doFix ) {
		tileMap.value[ x, y ] = filledTileNum14;
		if( fixHorizontal ) {
			fix( tileMap, x - 1, y );
			fix( tileMap, x + 1, y );
		}
		if( fixVertical ) {
			fix( tileMap, x, y - 1 );
			fix( tileMap, x, y + 1 );
		}
	}
}
cls;



//GetTileForPoint.bmx
currentCamera = Camera.create();
public static Example15 example15 = new Example15();
example15.execute();

public class Example15 extends Project {
	public final int tileMapWidth = 16;
	public final int tileMapHeight = 12;

	public TileSet tileSet = TileSet.create( Image.fromFile( " incbintiles .png", 8, 4 ) );
	public TileMap tileMap = TileMap.create( tileSet, tileMapWidth, tileMapHeight );
	public Sprite cursor = Sprite.fromShape( 0, 0, 2, 2 );

	public void init() {
		currentCamera = Camera.create();
		tileMap.setSize( tileMapWidth * 2, tileMapHeight * 2 );
		for( int y = 0; y <= tileMapHeight; y++ ) {
			for( int x = 0; x <= tileMapWidth; x++ ) {
				tileMap.setTile( x, y, rand( 1, 31 ) );
			}
		}
		cursor.visualizer.image = tileMap.tileSet.image;
		cursor.frame = 1;
	}

	public void logic() {
		cursor.setMouseCoords();
		int tileX, int tileY;
		tileMap.getTileForPoint( cursor.x, cursor.y, tileX, tileY );
		if( tileX >= 0 && tileY >= 0 && tileX < tileMap.xQuantity && tileY < tileMap.yQuantity ) {
			if( mouseDown( 1 ) ) tileMap.setTile( tileX, tileY, cursor.frame );
			if( mouseHit( 2 ) ) cursor.setAsTile( tileMap, tileX, tileY );
		}
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		tileMap.draw();
		cursor.draw();
		drawText( "Press right mouse button to select brush, left button to draw.", 0, 0 );
		printText( "GetTileForPoint, SetTile, SetAsTile example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;



//GetTileValue.bmx
currentCamera = Camera.create();
public static Example16 example16 = new Example16();
example16.execute();

public class Example16 extends Project {
	public final int tileMapWidth = 16;
	public final int tileMapHeight = 12;

	public TileMap tileMap = TileMap.create( TileSet.create( Image.fromFile( " incbintiles .png", 8, 4 ) ), tileMapWidth, tileMapHeight );

	public void init() {
		currentCamera = Camera.create();
		tileMap.setSize( tileMapWidth * 2, tileMapHeight * 2 );
		tileMap.visualizer = new LighntingVisualizer();
	}

	public void logic() {
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		tileMap.draw();
		printText( "GetTileValue example", 0, 12, Align.toCenter, Align.toBottom );
	}
}

public class LighntingVisualizer extends Visualizer {
	public final double radius = 4;

	public int getTileValue( TileMap tileMap, int tileX, int tileY ) {
		x0, y0;
		tileMap.getTileForPoint( cursor.x, cursor.y, x0, y0 );
		if( distance( tileX - x0, tileY - y0 ) <= radius ) return 18; else return 26;
	}
}
cls;


//LeftX.bmx
currentCamera = Camera.create();
public static Example17 example17 = new Example17();
example17.execute();

public class Example17 extends Project {
	public Sprite rectangle = Sprite.fromShape( 0, 0, 8, 6 );
	public Sprite ball = Sprite.fromShape( 0, 0, 1, 1, Sprite.oval );

	public void init() {
		currentCamera = Camera.create();
		rectangle.visualizer.setColorFromHex( "FF0000" );
		ball.visualizer.setColorFromHex( "FFFF00" );
	}

	public void logic() {
		rectangle.setMouseCoords();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		rectangle.draw();
		ball.setCoords( rectangle.leftX(), rectangle.y );
		ball.draw();
		ball.setCoords( rectangle.x, rectangle.topY() );
		ball.draw();
		ball.setCoords( rectangle.rightX(), rectangle.y );
		ball.draw();
		ball.setCoords( rectangle.x, rectangle.bottomY() );
		ball.draw();
		printText( "LeftX, TopY, RightX, BottomY example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;


//LimitByWindowShape.bmx
currentCamera = Camera.create();
public static Example18 example18 = new Example18();
example18.execute();

public class Example18 extends Project {
	public Sprite ball1 = Sprite.fromShape( 0, 0, 3, 3, Sprite.oval );
	public Sprite ball2 = Sprite.fromShape( 0, 0, 2, 2, Sprite.oval );
	public Sprite rectangle = Sprite.fromShape( 0, 0, 10, 10 );

	public void init() {
		currentCamera = Camera.create();
		ball1.visualizer.setColorFromHex( "FF0000" );
		ball2.visualizer.setColorFromHex( "FFFF00" );
		ball1.limitByWindowShape( rectangle );
		rectangle.visualizer = ContourVisualizer.fromWidthAndHexColor( 0.1, "00FF00" );
	}

	public void logic() {
		ball1.setMouseCoords();
		ball2.setMouseCoords();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		rectangle.draw();
		ball1.draw();
		ball2.draw();
		drawText( "Move cursor to see how ball is limited by rectangle", 0, 0 );
		printText( "LimitByWindowShape example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;


//LimitWith.bmx
currentCamera = Camera.create();
public static Example19 example19 = new Example19();
example19.execute();

public class Example19 extends Project {
	public Sprite ball[] = new Sprite()[ 7 ];
	public Sprite rectangle = Sprite.fromShape( 0, 0, 22, 14 );

	public void init() {
		currentCamera = Camera.create();
		rectangle.visualizer = ContourVisualizer.fromWidthAndHexColor( 0.1, "FF0000" );
		for( int n = 0; n <= 6; n++ ) {
			ball[ n ] = new Sprite();
			ball[ n ].shapeType = Sprite.oval;
			ball[ n ].setDiameter( 0.5 * ( 7 - n ) );
			ball[ n ].visualizer.setRandomColor();
		}
	}

	public void logic() {
		for( int n = 0; n <= 6; n++ ) {
			ball[ n ].setMouseCoords();
		}
		ball[ 0 ].limitWith( rectangle );
		ball[ 1 ].limitHorizontallyWith( rectangle );
		ball[ 2 ].limitVerticallyWith( rectangle );
		ball[ 3 ].limitLeftWith( rectangle );
		ball[ 4 ].limitTopWith( rectangle );
		ball[ 5 ].limitRightWith( rectangle );
		ball[ 6 ].limitBottomWith( rectangle );
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		rectangle.draw();
		for( int n = 0; n <= 6; n++ ) {
			ball[ n ].draw();
		}
		drawText( "Move cursor to see how the balls are limited in movement", 0, 0 );
		printText( "Limit...With example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;



//LTAction.bmx
currentCamera = Camera.create();
public static Example20 example20 = new Example20();
example20.execute();

public class Example20 extends Project {
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
		currentCamera = Camera.create();
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
		shape = cursor.firstCollidedSpriteOfLayer( example20.sprites );
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
cls;


incbin "jellys.lw";
incbin "tileset.png";
incbin "superjelly.png";
incbin "awpossum.png";
incbin "scheme1.png";
incbin "scheme2.png";

//LTBehaviorModel.bmx
currentCamera = Camera.create();
public static Example21 example21 = new Example21();
example21.execute();

public class Example21 extends Project {
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

		currentCamera = Camera.create();

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


		HorizontalMovement horizontalMovement = HorizontalMovement.create( example21.bumpingWalls );


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


		attachModel( HorizontalMovement.create( example21.pushFromWalls ) );


		attachModel( ModelDeactivator.create( onLand, true ) );
		attachModel( VerticalMovement.create( true ) );


		AnimationModel standingAnimation = AnimationModel.create( true, idleAnimationSpeed, 4, 0, true );
		animationStack.add( standingAnimation );
	}

	public void act() {
		super.act();
		collisionsWithLayer( example21.layer, example21.awPossumHurtingCollision );
		if( x > example21.tileMap.rightX() ) example21.switchTo( new Restart() );
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
		sprite.collisionsWithTileMap( example21.tileMap, collisionHandler );
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
		if( tileMap.getTile( tileX, tileY ) == example21.bricks ) sprite.pushFromTile( tileMap, tileX, tileY );
	}
}



public class VerticalMovement extends BehaviorModel {
	public VerticalCollisionHandler21 handler = new VerticalCollisionHandler21();

	public static VerticalMovement create( int forPlayer ) {
		VerticalMovement verticalMovement = new VerticalMovement();
		verticalMovement.handler.forPlayer = forPlayer;
		return verticalMovement;
	}

	public void applyTo( Shape shape ) {
		VectorSprite sprite = VectorSprite( shape );
		sprite.move( 0, sprite.dY );
		sprite.collisionsWithTileMap( example21.tileMap, handler );
	}

	public String info( Shape shape ) {
		return trimDouble( VectorSprite( shape ).dY );
	}
}



public class VerticalCollisionHandler21 extends SpriteAndTileCollisionHandler {
	public int forPlayer;

	public void handleCollision( Sprite sprite, TileMap tileMap, int tileX, int tileY, Sprite collisionSprite ) {
		if( forPlayer ) if tileMap.getTile( tileX, tileY ) != example21.bricks then return;
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
		Bullet21.create( VectorSprite( shape ), Math.random( fromSpeed, toSpeed ) );
		remove( shape );
	}
}



public class Bullet21 extends VectorSprite {
	public final double minAttack = 5.0;
	public final double maxAttack = 10.0;

	public int collisions = true;

	public static void create( VectorSprite jelly, double speed ) {
		Bullet21 bullet = new Bullet21();
		bullet.setCoords( jelly.x + sgn( jelly.dX ) * jelly.width * 2.2, jelly.y - 0.15 * jelly.height );
		bullet.setSize( 0.45 * jelly.width, 0.45 * jelly.width );
		bullet.shapeType = Sprite.oval;
		bullet.dX = sgn( jelly.dX ) * speed;
		bullet.visualizer.setVisualizerScale( 12, 4 );
		bullet.visualizer.image = jelly.visualizer.image;
		bullet.frame = 6;
		example21.layer.addLast( bullet );
	}

	public void act() {
		moveForward();
		if( collisions ) collisionsWithTileMap( example21.tileMap, example21.destroyBullet );
		super.act();
	}

	public static void disable( Sprite sprite ) {
		Bullet21 bullet = Bullet21( sprite );
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
		if( tileMap.getTile( tileX, tileY ) == example21.bricks ) Bullet21.disable( sprite );
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
		Bullet21 bullet = Bullet21( sprite2 );
		if( bullet ) {
			if( bullet.collisions ) {
				damage = Math.random( Bullet21.minAttack, Bullet21.maxAttack ) * sprite2.getDiameter() / 0.45;
				example21.layer.remove( sprite2 );
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
		example21.awPossumHitCollision.collided = false;
	}

	public void applyTo( Shape shape ) {
		if( punch ) {
			Area.setCoords( shape.x + shape.getFacing() * 0.95, shape.y + 0.15 );
		} else {
			Area.setCoords( shape.x + shape.getFacing() * 0.95, shape.y - 0.1 );
		}
		//Example21.HitArea = Area
		Area.collisionsWithLayer( example21.layer, example21.awPossumHitCollision );
		if( example21.awPossumHitCollision.collided ) remove( shape );
		super.applyTo( shape );
	}

	//Method Deactivate( LTShape Shape )
	//	Example21.HitArea = Null
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

				AwPossum awPossum = AwPossum( example21.layer.findShapeWithType( "TAwPossum" ) );
				awPossum.health = Math.min( awPossum.health + Math.random( AwPossum.minHealthGain, AwPossum.maxHealthGain ), 100.0 );

				jelly.behaviorModels.clear();
				jelly.attachModel( new Death() );
			}
			collided = true;
		} else if( Bullet21( sprite2 ) ) {
			if( ! sprite2.findModel( "TDeath" ) ) {
				Bullet21.disable( sprite2 );
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
		period = example21.deathPeriod;
	}

	public void applyTo( Shape shape ) {
		super.applyTo( shape );
		double alpha = 1.0 - ( currentProject.time - startingTime ) / period;
		if( alpha >= 0.0 ) shape.visualizer.alpha = alpha;
	}

	public void deactivate( Shape shape ) {
		example21.layer.remove( shape );
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
		example21.score += amount;
		example21.layer.addLast( score );
	}

	public void act() {
		move( 0, -speed );
		if( currentProject.time > startingTime + period ) example21.layer.remove( this );
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
			example21.render();
			currentCamera.darken( 0.0005 * ( System.currentTimeMillis()() - startingTime ) );
		} else if( System.currentTimeMillis()() < startingTime + 4000 ) {
			if( ! initialized ) {
				example21.initLevel();
				initialized = true;
			}
			example21.render();
			currentCamera.darken( 0.0005 * ( 4000 - System.currentTimeMillis()() + startingTime ) );
		} else {
			exiting = true;
		}
	}
}
cls;


incbin "font.png";
incbin "font.lfn";

//LTBitmapFont.bmx
currentCamera = Camera.create();
ex22();
public static void ex22() {
currentCamera = Camera.create();
BitmapFont font = BitmapFont.fromFile( " incbinfont .png", 32,127, 16, true );

setClsColor 0, 128, 0;
cls;

while( true ) {
	if( appTerminate() || keyHit( key_Escape ) ) break;
	font.print( "Hello!", Math.random( -15, 15 ), rand( -11, 11 ), Math.random( 0.5, 2.0 ), rand( 0, 2 ), rand( 0, 2 ) );
	printText( "LTBitmapFont example", 0, 12, Align.toCenter, Align.toBottom );
	flip;
}

setClsColor 0, 0, 0;
}
cls;


//LTButtonAction.bmx
currentCamera = Camera.create();
public static Example23 example23 = new Example23();
example23.execute();


public class Example23 extends Project {
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
		currentCamera = Camera.create();
		player.visualizer.setColorFromHex( "7FBFFF" );
	}

	public void logic() {
		if( moveLeft.isDown() ) player.move( -velocity, 0 );
		if( moveRight.isDown() ) player.move( velocity, 0 );
		if( moveUp.isDown() ) player.move( 0, -velocity );
		if( moveDown.isDown() ) player.move( 0, velocity );
		if( fire.isDown() ) Bullet23.create();

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



public class Bullet23 extends Sprite {
	public static Bullet23 create() {
		Bullet23 bullet = new Bullet23();
		bullet.setCoords( example23.player.x, example23.player.y );
		bullet.setDiameter( 0.25 );
		bullet.shapeType = Sprite.oval;
		bullet.angle = example23.player.directionTo( cursor );
		bullet.velocity = example23.bulletVelocity;
		bullet.visualizer.setColorFromHex( "7FFFBF" );
		example23.bullets.addLast( bullet );
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
		if( example23.actions[ actionNum ].define() ) {
			actionNum += 1;
			if( actionNum == example23.actions.dimensions()[ 0 ] ) exiting = true;
		}
	}

	public void render() {
		example23.render();
		drawText( "Press key for " + example23.actions[ actionNum ].name, 0, 16 );
	}
}
cls;



//LTCamera.bmx
currentCamera = Camera.create();
public static Example24 example24 = new Example24();
example24.execute();

public class Example24 extends Project {
	public final int tileMapWidth = 64;
	public final int tileMapHeight = 64;

	public TileMap tileMap = TileMap.create( TileSet.create( Image.fromFile( " incbintiles .png", 8, 4 ) ), tileMapWidth, tileMapHeight );
	public Sprite cursor = Sprite.fromShape( 0, 0, 0.5, 0.5, Sprite.oval );
	public double z, double baseK;

	public void init() {
		currentCamera = Camera.create();
		tileMap.setSize( tileMapWidth * 2, tileMapHeight * 2 );
		for( int y = 0; y <= tileMapHeight; y++ ) {
			for( int x = 0; x <= tileMapWidth; x++ ) {
				tileMap.setTile( x, y, rand( 1, 31 ) );
			}
		}
		cursor.visualizer.setColorFromHex( "FFBF7F" );
		baseK = currentCamera.k;
	}

	public void logic() {
		cursor.moveUsingArrows( 10.0 );
		currentCamera.shiftCameraToShape( cursor, 10.0 );

		if( keyDown( key_A ) ) z += perSecond( 8.0 );
		if( keyDown( key_Z ) ) z -= perSecond( 8.0 );
		currentCamera.alterCameraMagnification( z, baseK, 8.0 );

		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		tileMap.draw();
		cursor.draw();
		drawText( "Shift cursor by arrow keys and alter magnigication by A and Z keys.", 0, 0 );
		String message = "LTCamera, AlterCameraMagnification, ShiftCameraToShape example";
		drawText( message, 400 - 4 * len( message ), 584 );
	}
}
cls;



//LTDistanceJoint.bmx
currentCamera = Camera.create();
Example25 example25 = new Example25();
example25.execute();

public class Example25 extends Project {
	public Sprite hinge = Sprite.fromShape( 0, -8, 1, 1, Sprite.oval );
	public VectorSprite weight1 = VectorSprite.fromShapeAndVector( -8, -6, 3, 3, Sprite.oval );
	public VectorSprite weight2 = VectorSprite.fromShapeAndVector( -12, -9, 3, 3, Sprite.oval );
	public LineSegment rope1 = LineSegment.fromPivots( hinge, weight1 );
	public LineSegment rope2 = LineSegment.fromPivots( weight1, weight2 );

	public void init() {
		currentCamera = Camera.create();
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

cls;


//LTGraph.bmx
currentCamera = Camera.create();
public static Example26 example26 = new Example26();
example26.execute();

public class Example26 extends Project {
	public final int pivotsQuantity = 150;
	public final double maxDistance = 3.0;
	public final double minDistance = 1.0;

	public Graph graph = new Graph();
	public Sprite selectedPivot;
	public LinkedList path;
	public Visualizer pivotVisualizer = Visualizer.fromHexColor( "4F4FFF" );
	public Visualizer lineSegmentVisualizer = ContourVisualizer.fromWidthAndHexColor( 0.15, "FF4F4F", , 3.0 );
	public Visualizer pathVisualizer = ContourVisualizer.fromWidthAndHexColor( 0.15, "4FFF4F", , 4.0 );

	public void init() {
		currentCamera = Camera.create();
		cursor = Sprite.fromShape( 0, 0, 0.5, 0.5, Sprite.oval );
		for( int n = 0; n <= pivotsQuantity; n++ ) {
			while( true ) {
				double x = Math.random( -15,15 );
				double y = Math.random( -11, 11 );
				int passed = true;
				for( Sprite pivot : graph.pivots.keySet() ) {
					if( pivot.distanceToPoint( x, y ) < minDistance ) {
						passed = false ;
						break;
					}
				}
				if( passed ) {
					graph.addPivot( Sprite.fromShape( x, y, 0.3, 0.3, Sprite.oval ) );
					break;
				}
			}
		}
		for( Sprite pivot1 : graph.pivots.keySet() ) {
			for( Sprite pivot2 : graph.pivots.keySet() ) {
				if( pivot1 != pivot2 && pivot1.distanceTo( pivot2 ) <= maxDistance ) {
					int passed = true;
					LineSegment newLineSegment = LineSegment.fromPivots( pivot1, pivot2 );
					for( LineSegment lineSegment : graph.lineSegments.keySet() ) {
						if( lineSegment.collidesWithLineSegment( newLineSegment, false ) ) {
							passed = false;
							break;
						}
					}
					if( passed ) graph.addLineSegment( newLineSegment, false );
				}
			}
		}
	}

	public void logic() {
		if( mouseHit( 1 ) ) {
			switch( edPivot = graph.findPivotCollidingWithSprite( cursor ) ) {
			path = null;
		}
		if( mouseHit( 2 ) && selectedPivot ) {
			switch( Sprite edPivot2 = graph.findPivotCollidingWithSprite( cursor ) ) {
			if( selectedPivot2 ) path = graph.findPath( selectedPivot, selectedPivot2 );
		}
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		graph.drawLineSegmentsUsing( lineSegmentVisualizer );
		Graph.drawPath( path, pathVisualizer );
		graph.drawPivotsUsing( pivotVisualizer );
		if( selectedPivot ) selectedPivot.drawUsingVisualizer( pathVisualizer );
		drawText( "Select first pivot with left mouse button and second with right one", 0, 0 );
		printText( "LTGraph, FindPath, CollidesWithLineSegment example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;



//LTMarchingAnts.bmx
currentCamera = Camera.create();
public static Example27 example27 = new Example27();
example27.execute();

public class Example27 extends Project {
	public final int spritesQuantity = 50;

	public Layer layer = new Layer();
	public Cursor27 cursor = new Cursor27();
	public Image spriteImage = Image.fromFile( " incbinkolobok .png" );
	public Sprite selected;
	public MarchingAnts marchingAnts = new MarchingAnts();

	public void init() {
		for( int n = 1; n <= spritesQuantity; n++ ) {
			Sprite sprite = Sprite.fromShape( Math.random( -15, 15 ), Math.random( -11, 11 ), , , Sprite.oval, Math.random( 360 ) );
			sprite.setDiameter( Math.random( 1, 3 ) );
			sprite.visualizer.setRandomColor();
			sprite.visualizer.image = spriteImage;
			layer.addLast( sprite );
		}

		cursor.setDiameter( 0.5 );
		currentCamera = Camera.create();
	}

	public void logic() {
		cursor.act();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		layer.draw();
		if( selected ) selected.drawUsingVisualizer( example27.marchingAnts );
		drawText( "Select Sprite by left-clicking on it", 0, 0 );
		printText( "LTMarchingAnts example", 0, 12, Align.toCenter, Align.toBottom );
	}
}



public class Cursor27 extends Sprite {
	public SelectionHandler handler = new SelectionHandler();

	public void act() {
		setMouseCoords();
		if( mouseHit( 1 ) ) {
			example27.selected = null;
			collisionsWithLayer( example27.layer, handler );
		}
	}
}



public class SelectionHandler extends SpriteCollisionHandler {
	public void handleCollision( Sprite sprite1, Sprite sprite2 ) {
		example27.selected = sprite2;
	}
}
cls;


incbin "border.png";

//LTRasterFrame.bmx
currentCamera = Camera.create();
public static Example28 example28 = new Example28();
example28.execute();

public class Example28 extends Project {
	public Sprite frame;
	public RasterFrame frameImage = RasterFrame.fromFileAndBorders( " incbinborder .png", 8, 8, 8, 8 );
	public Layer layer = new Layer();
	public CreateFrame createFrame = new CreateFrame();

	public void init() {
		currentCamera = Camera.create();
	}

	public void logic() {
		createFrame.execute();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		layer.draw();
		if( frame ) frame.draw();
		drawText( "Drag left mouse button to create frames", 0, 0 );
		printText( "LTRasterFrame, LTDrag example", 0, 12, Align.toCenter, Align.toBottom );
	}
}



public class CreateFrame extends Drag {
	public double startingX, double startingY;

	public int dragKey() {
		return mouseDown( 1 );
	}

	public void startDragging() {
		startingX = cursor.x;
		startingY = cursor.y;
		example28.frame = Sprite.fromShape( cursor.x, cursor.y, 0, 0 );
		example28.frame.visualizer.setRandomColor();
		example28.frame.visualizer.image = example28.frameImage;
	}

	public void dragging() {
		double cornerX, double cornerY;
		if( startingX < cursor.x ) cornerX = startingX; else cornerX = cursor.x;
		if( startingY < cursor.y ) cornerY = startingY; else cornerY = cursor.y;
		example28.frame.setSize( Math.abs( startingX - cursor.x ), Math.abs( startingY - cursor.y ) );
		example28.frame.setCornerCoords( cornerX, cornerY );
	}

	public void endDragging() {
		example28.layer.addLast( example28.frame );
		example28.frame = null;
	}
}
cls;


incbin "human.lw";
incbin "part.png";

//LTRevoluteJoint.bmx
currentCamera = Camera.create();
public static Example29 example29 = new Example29();
example29.execute();

public class Example29 extends Project {
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
		currentCamera = Camera.create();
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
cls;


//LTSpriteMap.bmx
currentCamera = Camera.create();
public static Example30 example30 = new Example30();
example30.execute();

public final mapSize30 = 192;

public class Example30 extends Project {
	public final int spritesQuantity = 800;

	public Shape rectangle = Sprite.fromShape( 0, 0, mapSize30, mapSize30 );
	public Sprite cursor = Sprite.fromShape( 0, 0, 0, 0, Sprite.pivot );
	public SpriteMap spriteMap = SpriteMap.createForShape( rectangle, 2.0 );
	public CollisionHandler30 collisionHandler = new CollisionHandler30();

	public void init() {
		for( int n = 1; n <= spritesQuantity; n++ ) {
			Ball30.create();
		}
		rectangle.visualizer = ContourVisualizer.fromWidthAndHexColor( 0.1, "FF0000" );
		currentCamera = Camera.create();
	}

	public void logic() {
		currentCamera.move( 0.1 * ( mouseX() - 400 ), 0.1 * ( mouseY() - 300 ) );
		spriteMap.act();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		spriteMap.draw();
		rectangle.draw();
		drawOval( 398, 298, 5, 5 );
		cursor.draw();
		printText( "LTSpriteMap, CollisionsWithSpriteMap example", currentCamera.x, currentCamera.y + 12, Align.toCenter, Align.toBottom );
		showDebugInfo();
	}
}



public class Ball30 extends Sprite {
	public static Ball30 create() {
		Ball30 ball = new Ball30();
		ball.setCoords( Math.random( -0.5 * ( mapSize30 - 2 ), 0.5 * ( mapSize30 - 2 ) ), Math.random( -0.5 * ( mapSize30 - 2 ), 0.5 * ( mapSize30 - 2 ) ) );
		ball.setDiameter( Math.random( 0.5, 1.5 ) );
		ball.angle = Math.random( 360 );
		ball.velocity = Math.random( 3, 7 );
		ball.shapeType = Sprite.oval;
		ball.visualizer.setRandomColor();
		example30.spriteMap.insertSprite( ball );
		return ball;
	}

	public void act() {
		super.act();
		currentCamera.bounceInside( example30.rectangle );
		moveForward();
		bounceInside( example30.rectangle );
		collisionsWithSpriteMap( example30.spriteMap, example30.collisionHandler );
	}
}



public class CollisionHandler30 extends SpriteCollisionHandler {
	public void handleCollision( Sprite sprite1, Sprite sprite2 ) {
		if( ParticleArea( sprite2 ) ) return;
		sprite1.pushFromSprite( sprite2 );
		sprite1.angle = sprite2.directionTo( sprite1 );
		sprite2.angle = sprite1.directionTo( sprite2 );
		ParticleArea.create( sprite1, sprite2 );
	}
}



public class ParticleArea extends Sprite {
	public final int particlesQuantity = 30;
	public final double fadingTime = 1.0;

	public LinkedList particles = new LinkedList();
	public double startingTime;

	public static void create( Sprite ball1, Sprite ball2 ) {
		ParticleArea Area = new ParticleArea();
		double diameters = ball1.getDiameter() + ball2.getDiameter();
		Area.setCoords( ball1.x + ( ball2.x - ball1.x ) * ball1.getDiameter() / diameters, ball1.y + ( ball2.y - ball1.y ) * ball1.getDiameter() / diameters );
		Area.setSize( 4, 4 );
		Area.startingTime = example30.time;
		double angle = ball1.directionTo( ball2 ) + 90;
		for( int n = 0; n <= particlesQuantity; n++ ) {
			Sprite particle = new Sprite();
			particle.jumpTo( Area );
			particle.angle = angle + Math.random( -15, 15 ) + ( n % 2 ) * 180;
			particle.setDiameter( Math.random( 0.2, 0.6 ) );
			particle.velocity = Math.random( 0.5, 3 );
			Area.particles.addLast( particle );
		}
		example30.spriteMap.insertSprite( Area );
	}

	public void draw() {
		double a = 1.0 - ( example30.time - startingTime ) / fadingTime;
		if( a >= 0 ) {
			setAlpha( a );
			setColor( 255, 192, 0 );
			for( Sprite sprite : particles ) {
				double dX = Math.cos( sprite.angle ) * sprite.getDiameter() * 0.5;
				double dY = Math.sin( sprite.angle ) * sprite.getDiameter() * 0.5;
				sX1d, sY1d, sX2d, sY2d;
				currentCamera.fieldToScreen( sprite.x - dX, sprite.y - dY, sX1, sY1 );
				currentCamera.fieldToScreen( sprite.x + dX, sprite.y + dY, sX2, sY2 );
				drawLine( sX1, sY1, sX2, sY2 );
				sprite.moveForward();
			}
			Visualizer.resetColor();
		}
	}

	public void act() {
		if( example30.time > startingTime + fadingTime ) example30.spriteMap.removeSprite( this );

		if( collidesWithSprite( currentCamera ) ) {
			for( Sprite sprite : particles ) {
				sprite.moveForward();
			}
		}
	}
}
cls;



//LTVectorSprite.bmx
currentCamera = Camera.create();
public static Example31 example31 = new Example31();
example31.execute();

public class Example31 extends Project {
	public final int coinsQuantity = 100;
	public final int platformsQuantity = 100;
	public final int minPlatformLength = 3;
	public final int maxPlatformLength = 12;
	public final int mapSize = 128;

	public final int void = 0;
	public final int bricks = 1;
	public final int coin = 2;

	public Player player = Player.create();
	public TileMap tileMap = TileMap.create( TileSet.create( Image.fromFile( " incbintileset .png", 4, 1 ), 0 ), mapSize, mapSize );
	public int coins;

	public void init() {
		tileMap.setSize( mapSize, mapSize );
		for( int n = 0; n <= coinsQuantity; n++ ) {
			tileMap.value[ rand( 1, mapSize - 2 ), rand( 1, mapSize - 2 ) ] = coin;
		}
		for( int n = 0; n <= platformsQuantity; n++ ) {
			int size = rand( minPlatformLength, maxPlatformLength );
			int x = rand( 1, mapSize - 1 - size );
			int y = rand( 1, mapSize - 2 );
			for( int dX = 0; dX <= size; dX++ ) {
				tileMap.value[ x + dX, y ] = bricks;
			}
		}
		for( int n = 0; n <= mapSize ; n++ ) {
			tileMap.value[ n, 0 ] = bricks;
			tileMap.value[ n, mapSize - 1 ] = bricks;
			tileMap.value[ 0, n ] = bricks;
			tileMap.value[ mapSize - 1, n ] = bricks;
		}
		tileMap.tileSet.collisionShape = new Shape()[ 3 ];
		tileMap.tileSet.collisionShape[ 1 ] = Sprite.fromShape( 0.5, 0.5 );
		tileMap.tileSet.collisionShape[ 2 ] = Sprite.fromShape( 0.5, 0.5, , , Sprite.oval );
		currentCamera = Camera.create();
	}

	public void logic() {
		currentCamera.jumpTo( player );
		currentCamera.limitWith( tileMap );
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
		player.act();
	}

	public void render() {
		tileMap.draw();
		player.draw();
		drawText( "Move player with arrow keys", 0, 0 );
		drawText( " Coins" + coins, 0, 16 );
		printText( "LTVectorSprite, CollisionsWithTileMap, HandleCollisionWithTile example", currentCamera.x, currentCamera.y + 12, Align.toCenter, Align.toBottom );
	}
}




public class Player extends VectorSprite {
	public final double gravity = 10.0;
	public final double horizontalSpeed = 5.0;
	public final double jumpStrength = 15.0;

	public int onLand;
	public HorizontalCollisionHandler horizontalCollisionHandler = new HorizontalCollisionHandler();
	public VerticalCollisionHandler31 verticalCollisionHandler = new VerticalCollisionHandler31();

	public static Player create() {
		Player player = new Player();
		player.setSize( 0.8, 1.8 );
		player.setCoords( 0, 2 -0.5 * example31.mapSize );
		player.visualizer.image = Image.fromFile( " incbinmario .png", 4 );
		return player;
	}

	public void act() {
		move( dX, 0 );
		collisionsWithTileMap( example31.tileMap, horizontalCollisionHandler );

		onLand = false;
		move( 0, dY );
		dY = dY + example31.perSecond( gravity );
		collisionsWithTileMap( example31.tileMap, verticalCollisionHandler );

		dX = 0.0;
		if( keyDown( key_Left ) ) {
			dX = -horizontalSpeed;
			setFacing( leftFacing );
		} else if( keyDown( key_Right ) ) {
			dX = horizontalSpeed;
			setFacing( rightFacing );
		}

		if( onLand ) if keyDown( key_Up ) then dY = -jumpStrength;
	}
}



public class HorizontalCollisionHandler extends SpriteAndTileCollisionHandler {
	public void handleCollision( Sprite sprite, TileMap tileMap, int tileX, int tileY, Sprite collisionSprite ) {
		if( bricks( tileMap, tileX, tileY ) ) sprite.pushFromTile( tileMap, tileX, tileY );
	}
}



public class VerticalCollisionHandler31 extends SpriteAndTileCollisionHandler {
	public void handleCollision( Sprite sprite, TileMap tileMap, int tileX, int tileY, Sprite collisionSprite ) {
		if( bricks( tileMap, tileX, tileY ) ) {
			sprite.pushFromTile( tileMap, tileX, tileY );
			Player player = Player( sprite );
			if( player.dY > 0 ) player.onLand = true;
			player.dY = 0;
		}
	}
}



public static int bricks( TileMap tileMap, int tileX, int tileY ) {
	int tileNum = tileMap.getTile( tileX, tileY );
	if( tileNum == example31.coin ) {
		tileMap.value[ tileX, tileY ] = example31.void;
		example31.coins += 1;
	} else if( tileNum = example31.bricks ) {
		return true;
	}
	return false;
}
cls;


//L_Distance.bmx
currentCamera = Camera.create();
public static Example32 example32 = new Example32();
example32.execute();

public class Example32 extends Project {
	public int x = 400;
	public int y = 300;

	public void init() {
		currentCamera = Camera.create();
	}

	public void logic() {
		if( mouseHit( 1 ) ) {
			x = mouseX();
			y = mouseY();
		}
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		drawOval( x - 2, y - 2, 5, 5 );
		drawLine( x, y, mouseX(), mouseY() );
		drawText( "Distance is " + trimDouble( distance( y - mouseY(), x - mouseX() ) ) + " pixels", 0, 0 );
		printText( "L_Distance example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;


//L_DrawEmptyRect.bmx
currentCamera = Camera.create();
ex33();
public static void ex33() {
currentCamera = Camera.create();
while( true ) {
	if( appTerminate() || keyHit( key_Escape ) ) break;
	for( int n = 1; n <= 10; n++ ) {
		double width = Math.random( 700 );
		double height = Math.random( 500 );
		setColor( Math.random( 128, 255 ), Math.random( 128, 255 ), Math.random( 128, 255 ) );
		drawEmptyRect( Math.random( 800 - width ), Math.random( 600 - height ), width, height );
	}
	setColor( 0, 0, 0 );
	setAlpha( 0.04 );
	drawRect( 0, 0, 800, 600 );
	Visualizer.resetColor() ;
	printText( "L_DrawEmptyRect example", 0, 12, Align.toCenter, Align.toBottom );
	flip;
}
}
cls;


//L_IntInLimits.bmx
currentCamera = Camera.create();
public static Example34 example34 = new Example34();
example34.execute();

public class Example34 extends Project {
	public String word;

	public void init() {
		currentCamera = Camera.create();
	}

	public void logic() {
		if( intInLimits( mouseX(), 200, 600 ) ) word = ""; else word = "not ";
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		setColor( 255, 0, 0 );
		drawLine( 200, 0, 200, 599 );
		drawLine( 600, 0, 600, 599 );
		setColor( 255, 255, 255 );
		drawText( mouseX() + " is " + word + "in limits of [ 200, 600 ]", 0, 0 );
		drawOval( mouseX() - 2, mouseY() - 2, 5, 5 );
		printText( "L_IntInLimits example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;


//L_LimitInt.bmx
currentCamera = Camera.create();
public static Example35 example35 = new Example35();
example35.execute();

public class Example35 extends Project {
	public void init() {
		currentCamera = Camera.create();
	}

	public void logic() {
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		setColor( 255, 0, 0 );
		drawLine( 200, 0, 200, 599 );
		drawLine( 600, 0, 600, 599 );
		setColor( 255, 255, 255 );
		int x = limitInt( mouseX(), 200, 600 );
		drawOval( x - 2, mouseY() - 2, 5, 5 );
		drawText( "LimitInt(MouseX(),200,600) = " + x, 0, 0 );
		printText( "L_LimitInt example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;
// First sprite is moving at constant speed regardles of LogicFPS because it use delta-timing PerSecond() method to determine
// on which distance to move in particular logic frame.Second sprite use simple coordinate addition.



//L_LogicFPS.bmx
currentCamera = Camera.create();
public static Example36 example36 = new Example36();
example36.execute();

public class Example36 extends Project {
	public Sprite sprite1 = Sprite.fromShape( -10, -2, 2, 2, Sprite.oval );
	public Sprite sprite2 = Sprite.fromShape( -10, 2, 2, 2, Sprite.oval );

	public void init() {
		currentCamera = Camera.create();
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
cls;


//L_WrapInt.bmx
currentCamera = Camera.create();
public static Example37 example37 = new Example37();
example37.execute();

public class Example37 extends Project {
	public void init() {
		currentCamera = Camera.create();
	}

	public void logic() {
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		setColor( 255, 0, 0 );
		drawEmptyRect( -1, -1, 102, 102 );
		drawEmptyRect( 299, 249, 202, 102 );
		setColor( 0, 255, 0 );
		drawOval( wrapInt( mouseX(), 100 ) - 2, wrapInt( mouseY(), 100 ) - 2, 5, 5 );
		drawText( "L_WrapInt(" + mouseX() + ", 100)=" + wrapInt( mouseX(), 100 ), 0, 102 );
		setColor( 0, 0, 255 );
		drawOval( wrapInt2( mouseX(), 300, 500 ) - 2, wrapInt2( mouseY(), 250, 350 ) - 2, 5, 5 );
		drawText( "L_WrapInt2(" + mouseX() + ", 300, 500)=" + wrapInt2( mouseX(), 300, 500 ), 300, 352 );
		drawText( "", 0, 0 );
		setColor( 255, 255, 255 );
		printText( "L_WrapInt and L_WrapInt2 example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;


//MoveTowards.bmx
currentCamera = Camera.create();
public static Example38 example38 = new Example38();
example38.execute();

public class Example38 extends Project {
	public Sprite ball = Sprite.fromShape( 0, 0, 3, 3, Sprite.oval, 0, 5 );

	public void init() {
		currentCamera = Camera.create();
		ball.visualizer = Visualizer.fromHexColor( "3F3F7F" );
		cursor = Sprite.fromShape( 0, 0, 1, 1, Sprite.oval );
		cursor.visualizer = Visualizer.fromHexColor( "7FFF3F" );
	}

	public void logic() {
		ball.moveTowards( cursor, ball.velocity );
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		ball.draw();
		cursor.draw();
		if( ball.isAtPositionOf( cursor ) ) drawText( "Ball is at position of cursor", 0, 0 );
		printText( "IsAtPositionOf, MoveTowards example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;


//MoveUsingKeys.bmx
currentCamera = Camera.create();
public static Example39 example39 = new Example39();
example39.execute();

public class Example39 extends Project {
	public Sprite ball1 = Sprite.fromShape( -8, 0, 1, 1, Sprite.oval, 0, 7 );
	public Sprite ball2 = Sprite.fromShape( 0, 0, 2, 2, Sprite.oval, 0, 3 );
	public Sprite ball3 = Sprite.fromShape( 8, 0, 1.5, 1.5, Sprite.oval, 0, 5 );

	public void init() {
		ball1.visualizer = Visualizer.fromHexColor( "FF0000" );
		ball2.visualizer = Visualizer.fromHexColor( "00FF00" );
		ball3.visualizer = Visualizer.fromHexColor( "0000FF" );
		currentCamera = Camera.create();
	}

	public void logic() {
		ball1.moveUsingWSAD( ball1.velocity );
		ball2.moveUsingArrows( ball2.velocity );
		ball3.moveUsingKeys( key_I, key_K, key_J, key_L, ball3.velocity );
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		drawText( "Move red ball using WSAD keys", 0, 0 );
		drawText( "Move green ball using arrow keys", 0, 16 );
		drawText( "Move blue ball using IJKL keys", 0, 32 );
		ball1.draw();
		ball2.draw();
		ball3.draw();
		printText( "MoveUsingKeys example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;


//Overlaps.bmx
currentCamera = Camera.create();
public static Example40 example40 = new Example40();
example40.execute();

public class Example40 extends Project {
	public Sprite pivot = Sprite.fromShape( 6, 0, 0, 0, Sprite.pivot );
	public Sprite oval = Sprite.fromShape( -4, -2, 3, 5, Sprite.oval );
	public Sprite rectangle = Sprite.fromShape( 0, 5, 4, 4, Sprite.rectangle );
	public Sprite triangle = Sprite.fromShape( 4, 4, 3, 5, Sprite.topLeftTriangle );
	public Sprite cursor = Sprite.fromShape( 0, 0, 16, 16 );
	public String text;

	public void init() {
		pivot.visualizer.setColorFromHex( "FF0000" );
		oval.visualizer.setColorFromHex( "00FF00" );
		rectangle.visualizer.setColorFromHex( "0000FF" );
		triangle.visualizer.setColorFromHex( "007FFF" );
		cursor.visualizer.alpha = 0.5;
		currentCamera = Camera.create();
	}

	public void logic() {
		cursor.setMouseCoords();
		text = "";
		if( cursor.overlaps( pivot ) ) text = ", pivot";
		if( cursor.overlaps( oval ) ) text += ", oval";
		if( cursor.overlaps( rectangle ) ) text += ", rectangle";
		if( cursor.overlaps( triangle ) ) text += ", triangle";
		if( ! text ) text = ", nothing";
		if( mouseHit( 2 ) ) cursor.shapeType = 3 - cursor.shapeType;
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		pivot.draw();
		oval.draw();
		rectangle.draw();
		triangle.draw();
		cursor.draw();
		drawText( "Press right mouse button to change cursor shape", 0, 0 );
		drawText( "Cursor rectangle fully overlaps " + text[ 2.. ], 0, 16 );
		printText( "Overlaps example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;


incbin "parallax.lw";
incbin "water_and_snow.png";
incbin "grid.png";
incbin "clouds.png";

//Parallax.bmx
currentCamera = Camera.create();
public static Example41 example41 = new Example41();
example41.execute();

public class Example41 extends Project {
  public TileMap ground;
  public TileMap grid;
  public TileMap clouds;

  public void init() {
    currentCamera = Camera.create();
	currentCamera.setMagnification( 32.0 );

	setIncbin( true );
    Layer layer = loadLayer( Layer( World.fromFile( "parallax.lw" ).findShapeWithType( "LTLayer" ) ) );
	setIncbin( false );

    ground = TileMap( layer.findShape( "Ground" ) );
    grid = TileMap( layer.findShape( "Grid" ) );
    clouds = TileMap( layer.findShape( "Clouds" ) );
  }

  public void logic() {
    currentCamera.moveUsingArrows( 8.0 );
    currentCamera.limitWith( grid );
    ground.parallax( grid );
    clouds.parallax( grid );
    if( keyHit( key_Escape ) ) exiting = true;
  }

  public void render() {
    ground.draw();
    grid.draw();
    clouds.draw();
	drawText( "Move camera with arrow keys", 0, 0 );
	printText( "Parallax example", currentCamera.x, currentCamera.y + 9, Align.toCenter, Align.toBottom );
  }
}
cls;


public final mapSize42 = 128;

//Paste.bmx
currentCamera = Camera.create();
ex42();
public static void ex42() {
currentCamera = Camera.create();

DoubleMap sourceMap = DoubleMap.create( mapSize42, mapSize42 );
sourceMap.drawCircle( mapSize42 * 0.375, mapSize42 * 0.375, mapSize42 * 0.35, 0.6 );
draw( sourceMap.toNewImage(), "Source map" );

DoubleMap targetMap = DoubleMap.create( mapSize42, mapSize42 );
targetMap.drawCircle( mapSize42 * 0.625, mapSize42 * 0.625, mapSize42 * 0.35, 0.8 );
draw( targetMap.toNewImage(), "Target map" );

DoubleMap doubleMap = DoubleMap.create( mapSize42, mapSize42 );
doubleMap.paste( targetMap );
doubleMap.paste( sourceMap, 0, 0, DoubleMap.add );
doubleMap.limit();
draw( doubleMap.toNewImage(), "Adding source map to target map" );

doubleMap.paste( targetMap );
doubleMap.paste( sourceMap, 0, 0, DoubleMap.multiply );
draw( doubleMap.toNewImage(), "Multiplying source map with target map" );

doubleMap.paste( targetMap );
doubleMap.paste( sourceMap, 0, 0, DoubleMap.maximum );
draw( doubleMap.toNewImage(), "Maximum of source map and target map" );

doubleMap.paste( targetMap );
doubleMap.paste( sourceMap, 0, 0, DoubleMap.minimum );
draw( doubleMap.toNewImage(), "Minimum of source map and target map" );

setScale( 4.0, 4.0 );
Image image = sourceMap.toNewImage( DoubleMap.red );
targetMap.pasteToImage( image, 0, 0, 0, DoubleMap.green );
draw( image, "Pasting maps to different color channels" );


}
public static void draw( Image image, String text ) {
	setScale ( 4.0, 4.0 );
	drawImage( image.bMaxImage, 400, 300 );
	setScale( 1.0, 1.0 );
	drawText( text, 0, 0 );
	printText( "Paste example", 0, 12, Align.toCenter, Align.toBottom );
	flip;
	waitkey;
	cls;
}
cls;


public final mapSize43 = 256;

//PerlinNoise.bmx
currentCamera = Camera.create();
ex43();
public static void ex43() {
currentCamera = Camera.create();

DoubleMap doubleMap = new DoubleMap();
doubleMap.setResolution( mapSize43, mapSize43 );

int frequency = 16;
double amplitude = 0.25;
double dAmplitude = 0.5;
int layers = 4;

while( true ) {
	cls;
	doubleMap.perlinNoise( frequency, frequency, amplitude, dAmplitude, layers );
	tPixmap pixmap = doubleMap.toNewPixmap();
	drawPixmap( pixmap, 400 - 0.5 * pixmapWidth( pixmap ), 300 - 0.5 * pixmapHeight( pixmap ) )		;
	drawText( "Starting  frequency" + frequency + " ( +/- to change )", 0, 0 );
	drawText( "Starting  amplitude" + trimDouble( amplitude ) + " ( left / right arrow to change )", 0, 16 );
	drawText( "Starting amplitude  increment" + trimDouble( dAmplitude ) + " ( up / down arrow to change )", 0, 32 );
	drawText( "Layers  quantity" + layers + " ( page up / page down arrow to change )", 0, 48 );
	printText( "PerlinNoise example", 0, 12, Align.toCenter, Align.toBottom );
	flip;

	while( true ) {
		if( keyHit( key_NumAdd ) ) {
			if( frequency < 256 ) frequency *= 2;
			break;
		} else if( keyHit( key_NumSubtract ) ) {
			if( frequency > 1 ) frequency /= 2;
			break;
		} else if( keyHit( key_Left ) ) {
			if( amplitude > 0.05 ) amplitude /= 2;
			break;
		} else if( keyHit( key_Right ) ) {
			if( amplitude < 1.0 ) amplitude *= 2;
			break;
		} else if( keyHit( key_Down ) ) {
			if( dAmplitude > 0.05 ) dAmplitude /= 2;
			break;
		} else if( keyHit( key_Up ) ) {
			if( dAmplitude < 2.0 ) dAmplitude *= 2;
			break;
		} else if( keyHit( key_PageUp ) ) {
			if( layers < 8 ) layers += 1;
			break;
		} else if( keyHit( key_PageDown ) ) {
			if( layers > 1 ) layers -= 1;
			break;
		}
	until keyDown( key_Escape );
until keyDown( key_Escape );
}
cls;


//PlaceBetween.bmx
currentCamera = Camera.create();
public static Example44 example44 = new Example44();
example44.execute();

public class Example44 extends Project {
	public Sprite pivot1 = Sprite.fromShape( 0, 0, 0, 0, Sprite.pivot );
	public Sprite pivot2 = Sprite.fromShape( 0, 0, 0, 0, Sprite.pivot );
	public Sprite oval1 = Sprite.fromShape( 0, 0, 0.75, 0.75, Sprite.oval );
	public Sprite oval2 = Sprite.fromShape( 0, 0, 0.75, 0.75, Sprite.oval );
	public LineSegment lineSegment = LineSegment.fromPivots( pivot1, pivot2 );

	public void init() {
		currentCamera = Camera.create();
		lineSegment.visualizer = ContourVisualizer.fromWidthAndHexColor( 0.2, "0000FF", 1.0, 2.0 );
		oval1.visualizer.setColorFromHex( "FF0000" );
		oval2.visualizer.setColorFromHex( "00FF00" );
	}

	public void logic() {
		pivot2.setMouseCoords();
		oval1.placeBetween( pivot1, pivot2, 0.5 );
		oval2.placeBetween( pivot1, pivot2, 0.3 );
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		lineSegment.draw();
		oval1.draw();
		oval2.draw();
		printText( "PlaceBetween example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;


//PrintText.bmx
currentCamera = Camera.create();
public static Example45 example45 = new Example45();
example45.execute();

public class Example45 extends Project {
	public Sprite rectangle = Sprite.fromShape( 0, 0, 16, 12 );

	public void init() {
		currentCamera = Camera.create();
	}

	public void logic() {
		rectangle.setMouseCoords();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		rectangle.drawContour( 2 );
		rectangle.printText( "topleft corner", Align.toLeft, Align.toTop );
		rectangle.printText( "top", Align.toCenter, Align.toTop );
		rectangle.printText( "topright corner", Align.toRight, Align.toTop );
		rectangle.printText( "left side", Align.toLeft, Align.toCenter );
		rectangle.printText( "center", Align.toCenter, Align.toCenter );
		rectangle.printText( "right side", Align.toRight, Align.toCenter );
		rectangle.printText( "bottomleft corner", Align.toLeft, Align.toBottom );
		rectangle.printText( "bottom", Align.toCenter, Align.toBottom );
		rectangle.printText( "bottomright corner", Align.toRight, Align.toBottom );
		printText( "PrintText example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;



//SaveToFile.bmx
currentCamera = Camera.create();
public static Example46 example46 = new Example46();
example46.execute();

public class Example46 extends Project {
	public final int spritesQuantity = 70;

	public Layer layer = new Layer();
	public double ang;
	public Sprite oldSprite;

	public void init() {
		currentCamera = Camera.create();
		for( int n = 1; n <= spritesQuantity; n++ ) {
			oldSprite = Sprite.fromShape( Math.random( -15, 15 ), Math.random( -11, 11 ), , , Sprite.oval, Math.random( 360 ), 5 );
			oldSprite.setDiameter( Math.random( 0.5, 1.5 ) );
			oldSprite.visualizer.setRandomColor();
			layer.addLast( oldSprite );
		}
	}

	public void logic() {
		ang = 1500 * Math.sin( 7 * time );
		for( Sprite sprite : layer ) {
			oldSprite.directTo( sprite );
			oldSprite.angle += perSecond( ang ) + Math.random( -45, 45 );
			sprite.moveForward();
			oldSprite = sprite;
		}

		if( keyHit( key_F2 ) ) layer.saveToFile( "sprites.lw" );
		if( keyHit( key_F3 ) ) layer = Layer( Object.loadFromFile( "sprites.lw" ) );

		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		layer.draw();
		drawText( "Press F2 to save and F3 to load position of sprites", 0, 0 );
		printText( "LoadFromFile, SaveToFile example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;



//SetAsTile.bmx
currentCamera = Camera.create();
public static Example47 example47 = new Example47();
example47.execute();

public class Example47 extends Project {
	public final int tileMapWidth = 16;
	public final int tileMapHeight = 12;

	public TileSet tileSet = TileSet.create( Image.fromFile( " incbintiles .png", 8, 4 ) );
	public TileMap tileMap = TileMap.create( tileSet, tileMapWidth, tileMapHeight );
	public Layer pieces = new Layer();

	public void init() {
		currentCamera = Camera.create();
		tileMap.setSize( tileMapWidth * 2, tileMapHeight * 2 );
		for( int y = 0; y <= tileMapHeight; y++ ) {
			for( int x = 0; x <= tileMapWidth; x++ ) {
				tileMap.setTile( x, y, rand( 1, 31 ) );
			}
		}
	}

	public void logic() {
		if( mouseHit( 1 ) ) {
			int tileX, int tileY;
			tileMap.getTileForPoint( cursor.x, cursor.y, tileX, tileY );
			if( tileMap.getTile( tileX, tileY ) > 0 ) {
				Piece piece = Piece.create();
				piece.setAsTile( tileMap, tileX, tileY );
				tileMap.setTile( tileX, tileY, 0 );
			}
		}
		pieces.act();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		tileMap.draw();
		pieces.draw();
		drawText( "Click on tiles to make them fall", 0, 0 );
		printText( "SetAsTile example", 0, 12, Align.toCenter, Align.toBottom );
	}
}



public class Piece extends VectorSprite {
	public final double gravity = 8.0;

	public double startingTime = 0;
	public double angularDirection = 0;

	public static Piece create() {
		Piece piece = new Piece();
		piece.startingTime = example47.time;
		piece.angularDirection = -1 + 2 * rand( 0, 1 );
		example47.pieces.addFirst( piece );
		return piece;
	}

	public void act() {
		moveForward();
		angle = ( example47.time - startingTime ) * 45 * angularDirection;
		dY += perSecond( gravity );
		if( topY() > example47.tileMap.bottomY() ) example47.pieces.remove( this );
	}
}
cls;


//SetAsViewport.bmx
currentCamera = Camera.create();
public static Example48 example48 = new Example48();
example48.execute();

public class Example48 extends Project {
	public final int spritesQuantity = 100;

	public Layer layer = new Layer();
	public Shape rectangle = Sprite.fromShape( 0, 0, 30, 20 );

	public void init() {
		cursor = Sprite.fromShape( 0, 0, 8, 6 );
		for( int n = 1; n <= spritesQuantity; n++ ) {
			Sprite sprite = Sprite.fromShape( Math.random( -13, 13 ), Math.random( -8, 8 ), , , Sprite.oval, Math.random( 360 ), Math.random( 3, 7 ) );
			sprite.visualizer.setRandomColor();
			layer.addLast( sprite );
		}
		currentCamera = Camera.create();
	}

	public void logic() {
		for( Sprite sprite : layer ) {
			sprite.moveForward();
			sprite.bounceInside( rectangle );
		}
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		cursor.setAsViewport();
		layer.draw();
		rectangle.drawContour( 2 );
		currentCamera.resetViewport();
		cursor.drawContour( 2 );
		printText( "SetAsViewport, ResetViewport example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;


//SetCornerCoords.bmx
currentCamera = Camera.create();
public static Example49 example49 = new Example49();
example49.execute();

public class Example49 extends Project {
	public Sprite rectangle = Sprite.fromShape( 0, 0, 8, 6 );

	public void init() {
		currentCamera = Camera.create();
	}

	public void logic() {
		rectangle.setCornerCoords( cursor.x, cursor.y );
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		rectangle.draw();
		printText( "SetCornerCoords example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;



//SetFacing.bmx
currentCamera = Camera.create();
public static Example50 example50 = new Example50();
example50.execute();

public class Example50 extends Project {
	public Sprite sprite = Sprite.fromShape( 0, 0, 8, 8 );

	public void init() {
		currentCamera = Camera.create();
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
cls;



public final tileMapWidth51 = 4;
public final tileMapHeight51 = 3;

//Stretch.bmx
currentCamera = Camera.create();
ex51();
public static void ex51() {
TileSet tileSet = TileSet.create( Image.fromFile( " incbintiles .png", 8, 4 ) );
TileMap tileMap = TileMap.create( tileSet, tileMapWidth51, tileMapHeight51 );

currentCamera = Camera.create();
tileMap.setSize( tileMapWidth51 * 2, tileMapHeight51 * 2 );
for( int y = 0; y <= tileMapHeight51; y++ ) {
	for( int x = 0; x <= tileMapWidth51; x++ ) {
		tileMap.setTile( x, y, rand( 1, 31 ) );
	}
}

for( int n = 1; n <= 3; n++ ) {
	cls;
	tileMap.draw();
	drawText( "Press any key to stretch tilemap by 2 times", 0, 0 );
	printText( "Stretch example", 0, 12, Align.toCenter, Align.toBottom );
	flip;
	waitKey;
	tileMap.stretch( 2, 2 );
	tileMap.alterSize( 2, 2 );
}
}
cls;


incbin "tank.png";

//Turn.bmx
currentCamera = Camera.create();
public static Example52 example52 = new Example52();
example52.execute();

public class Example52 extends Project {
	public final double turningSpeed = 90;

	public Sprite tank = Sprite.fromShape( 0, 0, 2, 2, Sprite.rectangle, 0, 5 );

	public void init() {
		currentCamera = Camera.create();
		tank.visualizer = Visualizer.fromFile( " incbintank .png" );
	}

	public void logic() {
		if( keyDown( key_Left ) ) tank.turn( -turningSpeed );
		if( keyDown( key_Right ) ) tank.turn( turningSpeed );
		if( keyDown( key_Up ) ) tank.moveForward();
		if( keyDown( key_Down ) ) tank.moveBackward();
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		tank.draw();
		drawText( "Press arrow keys to move tank", 0, 0 );
		printText( "Turn, MoveForward, MoveBackward example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
cls;



//WedgeOffWithSprite.bmx
currentCamera = Camera.create();
public static Example53 example53 = new Example53();
example53.execute();

public class Example53 extends Project {
	public final int koloboksQuantity = 50;

	public Layer koloboks = new Layer();
	public Image kolobokImage = Image.fromFile( " incbinkolobok .png" );
	public Kolobok53 player;
	public int debugMode;
	public CollisionHandler53 collisionHandler = new CollisionHandler53();

	public void init() {
		for( int n = 1; n <= koloboksQuantity; n++ ) {
			Kolobok53.createKolobok();
		}
		player = Kolobok53.createPlayer();
		currentCamera = Camera.create();
	}

	public void logic() {
		koloboks.act();

		if( keyDown( key_Left ) ) player.turn( -player.turningSpeed );
		if( keyDown( key_Right ) ) player.turn( player.turningSpeed );
		if( keyDown( key_Up ) ) player.moveForward();
		if( keyDown( key_Down ) ) player.moveBackward();

		if( keyHit( key_D ) ) debugMode = ! debugMode;

		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		if( debugMode ) {
			koloboks.drawUsingVisualizer( debugVisualizer );
			showDebugInfo();
		} else {
			koloboks.draw();
			drawText( "Move white kolobok with arrow keys and push other koloboks and press D for debug mode", 0, 0 );
			printText( "WedgeOffWithSprite example", 0, 12, Align.toCenter, Align.toBottom );
		}
	}
}



public class Kolobok53 extends Sprite {
	public final double turningSpeed = 180.0;

	public static Kolobok53 createPlayer() {
		Kolobok53 player = create();
		player.setDiameter( 2 );
		player.velocity = 7;
		return player;
	}

	public static Kolobok53 createKolobok() {
		Kolobok53 kolobok = create();
		kolobok.setCoords( Math.random( -15, 15 ), Math.random( -11, 11 ) );
		kolobok.setDiameter( Math.random( 1, 3 ) );
		kolobok.angle = Math.random( 360 );
		kolobok.visualizer.setRandomColor();
		return kolobok;
	}

	public static Kolobok53 create() {
		Kolobok53 kolobok = new Kolobok53();
		kolobok.shapeType = Sprite.oval;
		kolobok.visualizer.image = example53.kolobokImage;
		kolobok.visualizer.setVisualizerScale( 1.3, 1.3 );
		example53.koloboks.addLast( kolobok );
		return kolobok;
	}

	public void act() {
		collisionsWithLayer( example53.koloboks, example53.collisionHandler );
	}
}



public class CollisionHandler53 extends SpriteCollisionHandler {
	public void handleCollision( Sprite sprite1, Sprite sprite2 ) {
		sprite1.wedgeOffWithSprite( sprite2, sprite1.width ^ 2, sprite2.width ^ 2 );
	}
}
cls;


//XMLIO.bmx
currentCamera = Camera.create();
public static Example54 example54 = new Example54();
example54.execute();

public class Example54 extends Project {
	public LinkedList people = new LinkedList();
	public LinkedList professions = new LinkedList();

	public void init() {
		currentCamera = Camera.create();
		for( String name : [ "director", "engineer", "dispatcher", "driver", "secretary", "bookkeeper", "supply agent", "bookkeeper chief", .. ) {
				"lawyer", "programmer", "administrator", "courier" ];
			Profession.create( name );
		}
	}

	public void logic() {
		if( keyHit( key_G ) ) {
			people.clear();
			for( int n = 1; n <= 10; n++ ) {
				Worker.create();
			}
		} else if( keyHit( key_C ) ) {
			people.clear();
		} else if( keyHit( key_F2 ) ) {
			saveToFile( "people.dat" );
		} else if( keyHit( key_F3 ) ) {
			loadFromFile( "people.dat" );
		}

		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		drawText( "Press G to generate data, C to clear, F2 to save, F3 to load", 0, 0 );
		int y = 16;
		for( Worker worker : people ) {
			drawText( worker.firstName + " " + worker.lastName + ", " + worker.age + " years, " + trimDouble( worker.height, 1 ) + " cm, " + 
					trimDouble( worker.weight, 1 ) + " kg, " + worker.profession.name , 0, y );
			y += 16;
		}
		printText( "XMLIO, Manage... example", 0, 12, Align.toCenter, Align.toBottom );
	}

	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );
		xMLObject.manageListField( "professions", example54.professions );
		xMLObject.manageChildList( example54.people );
	}
}



public class Profession extends Object {
	public String name;

	public static Profession create( String name ) {
		Profession profession = new Profession();
		profession.name = name;
		example54.professions.addLast( profession );
	}

	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );
		xMLObject.manageStringAttribute( "name", name );
	}
}



public class Worker extends Object {
	public String firstName;
	public String lastName;
	public int age;
	public double height;
	public double weight;
	public Profession profession;

	public static void create() {
		Worker worker = new Worker();
		worker.firstName = [ "Alexander", "Alex", "Dmitry", "Sergey", "Andrey", "Anton", "Artem", "Vitaly", "Vladimir", "Denis", "Eugene", 
				"Igor", "Constantine", "Max", "Michael", "Nicholas", "Paul", "Roman", "Stanislaw", "Anatoly", "Boris", "Vadim", "Valentine", 
				"Valery", "Victor", "Vladislav", "Vyacheslav", "Gennady", "George", "Gleb", "Egor", "Ilya", "Cyril", "Leonid", "Nikita", "Oleg", 
				"Peter", "Feodor", "Yury", "Ian", "Jaroslav" ][ rand( 0, 40 ) ];
		worker.lastName = [ "Ivanov", "Smirnov", "Kuznetsov", "Popov", "Vasiliev", "Petrov", "Sokolov", "Mikhailov", "Novikov", 
				"Fedorov", "Morozov", "Volkov", "Alekseev", "Lebedev", "Semenov", "Egorov", "Pavlov", "Kozlov", "Stepanov", "Nikolaev", 
				"Orlovv", "Andreev", "Makarov", "Nikitin", "Zakharov" ][ rand( 0, 24 ) ];
		worker.age = rand( 20, 50 );
		worker.height = Math.random( 155, 180 );
		worker.weight = Math.random( 50, 90 );
		worker.profession = Profession( example54.professions.get( rand( 0, example54.professions.size() - 1 ) ) );
		example54.people.addLast( worker );
	}

	public void xMLIO( XMLObject xMLObject ) {
		// !!!!!! Remember to always include this string at the beginning of the method !!!!!!

		super.xMLIO( xMLObject );

		// !!!!!! !!!!!! 

		xMLObject.manageStringAttribute( "first-name", firstName );
		xMLObject.manageStringAttribute( "last-name", lastName );
		xMLObject.manageIntAttribute( "age", age );
		xMLObject.manageDoubleAttribute( "height", height );
		xMLObject.manageDoubleAttribute( "weight", weight );

		// !!!!!! Remember to equate object to to result of ManageObjectAttribute !!!!!!

		profession = Profession( xMLObject.manageObjectField( "profession", profession ) );

		// !!!!!! A = TA( XMLObject.ManageObjectAttribute( "name", A ) ) !!!!!!
	}
}
cls;
printText( "Press ESC to end", 0, 0, Align.toCenter, Align.toCenter );
flip;
waitkey;
