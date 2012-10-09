package examples;
import java.lang.Math;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.shapes.sprites.Sprite;
import dwlab.visualizers.Visualizer;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final int flowersQuantity = 12;
	public final double flowerCircleDiameter = 9;
	public final double flowerDiameter = 1.8;

	public Sprite flowers[] = new Sprite()[ flowersQuantity ];
	public FlowerVisualizer flowerVisualizer = new FlowerVisualizer();

	public void init() {
		initGraphics();
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
			double distance = spriteDiameter * ( 1.0 + amplitude * Math.sin( 360.0 * example.time + 360.0 * n / circlesQuantity * circlesPer360 ) );
			double sX, double sY;
			currentCamera.fieldToScreen( sprite.x + distance * Math.cos( angles ), sprite.y + distance * Math.sin( angles ), sX, sY );
			drawOval( sX - 0.5 * circleDiameter, sY - 0.5 * circleDiameter, circleDiameter, circleDiameter );
		}
	}
}
