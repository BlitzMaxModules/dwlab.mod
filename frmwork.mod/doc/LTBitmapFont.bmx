SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Local Font:LTBitmapFont = LTBitmapFont.FromFile( "font.png", 32,127, 16, True )
L_InitGraphics()

SetClsColor 0, 128, 0
Cls

Repeat
	If AppTerminate() Or KeyHit( Key_Escape ) Then Exit
	Font.Print( "Hello!", Rnd( -15, 15 ), Rand( -11, 11 ), Rnd( 0.5, 2.0 ), Rand( 0, 2 ), Rand( 0, 2 ) )
	Flip
Forever