package examples;
import java.lang.Math;
import dwlab.base.BitmapFont;
import dwlab.base.Align;

initGraphics();
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
