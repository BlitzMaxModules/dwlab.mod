package examples;
import java.util.LinkedList;
import java.lang.Math;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.shapes.Shape;
import dwlab.visualizers.ContourVisualizer;
import dwlab.shapes.sprites.SpriteCollisionHandler;
import dwlab.shapes.sprites.Sprite;
import dwlab.shapes.maps.SpriteMap;
import dwlab.visualizers.Visualizer;

public static Example example = new Example();
example.execute();

public final int mapSize = 192;

public class Example extends Project {
	public final int spritesQuantity = 800;

	public Shape rectangle = Sprite.fromShape( 0, 0, mapSize, mapSize );
	public Sprite cursor = Sprite.fromShape( 0, 0, 0, 0, Sprite.pivot );
	public SpriteMap spriteMap = SpriteMap.createForShape( rectangle, 2.0 );
	public CollisionHandler collisionHandler = new CollisionHandler();

	public void init() {
		for( int n = 1; n <= spritesQuantity; n++ ) {
			Ball.create();
		}
		rectangle.visualizer = ContourVisualizer.fromWidthAndHexColor( 0.1, "FF0000" );
		spriteMap.initialArraysSize = 2;
		initGraphics();
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



public class Ball extends Sprite {
	public static Ball create() {
		Ball ball = new Ball();
		ball.setCoords( Math.random( -0.5 * ( mapSize - 2 ), 0.5 * ( mapSize - 2 ) ), Math.random( -0.5 * ( mapSize - 2 ), 0.5 * ( mapSize - 2 ) ) );
		ball.setDiameter( Math.random( 0.5, 1.5 ) );
		ball.angle = Math.random( 360 );
		ball.velocity = Math.random( 3, 7 );
		ball.shapeType = Sprite.oval;
		ball.visualizer.setRandomColor();
		example.spriteMap.insertSprite( ball );
		return ball;
	}

	public void act() {
		super.act();
		currentCamera.bounceInside( example.rectangle );
		moveForward();
		bounceInside( example.rectangle );
		collisionsWithSpriteMap( example.spriteMap, example.collisionHandler );
	}
}



public class CollisionHandler extends SpriteCollisionHandler {
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
		Area.startingTime = example.time;
		double angle = ball1.directionTo( ball2 ) + 90;
		for( int n = 0; n <= particlesQuantity; n++ ) {
			Sprite particle = new Sprite();
			particle.jumpTo( Area );
			particle.angle = angle + Math.random( -15, 15 ) + ( n % 2 ) * 180;
			particle.setDiameter( Math.random( 0.2, 0.6 ) );
			particle.velocity = Math.random( 0.5, 3 );
			Area.particles.addLast( particle );
		}
		example.spriteMap.insertSprite( Area );
	}

	public void draw() {
		double a = 1.0 - ( example.time - startingTime ) / fadingTime;
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
		if( example.time > startingTime + fadingTime ) example.spriteMap.removeSprite( this );

		if( collidesWithSprite( currentCamera ) ) {
			for( Sprite sprite : particles ) {
				sprite.moveForward();
			}
		}
	}
}
