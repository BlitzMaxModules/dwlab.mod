package examples;
import java.lang.Math;
import dwlab.base.Align;
import dwlab.visualizers.Visualizer;

initGraphics();
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
