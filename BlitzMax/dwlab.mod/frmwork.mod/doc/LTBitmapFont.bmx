SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Incbin "font.png"
Incbin "font.lfn"

L_InitGraphics()
Local Font:LTBitmapFont = LTBitmapFont.FromFile( "incbin::font.png", 32,127, 16, True )

SetClsColor 0, 128, 0
Cls

Repeat
	If AppTerminate() Or KeyHit( Key_Escape ) Then Exit
	Font.Print( "Hello!", Rnd( -15, 15 ), Rand( -11, 11 ), Rnd( 0.5, 2.0 ), Rand( 0, 2 ), Rand( 0, 2 ) )
	L_PrintText( "LTBitmapFont example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	Flip
Forever

SetClsColor 0, 0, 0