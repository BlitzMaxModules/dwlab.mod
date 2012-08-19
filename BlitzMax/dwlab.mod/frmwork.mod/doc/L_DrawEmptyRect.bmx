SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

L_InitGraphics()
Repeat
	If AppTerminate() Or KeyHit( Key_Escape ) Then Exit
	For Local N:Int = 1 To 10
		Local Width:Double = Rnd( 700 )
		Local Height:Double = Rnd( 500 )
		SetColor( Rnd( 128, 255 ), Rnd( 128, 255 ), Rnd( 128, 255 ) )
		L_DrawEmptyRect( Rnd( 800 - Width ), Rnd( 600 - Height ), Width, Height )
	Next
	SetColor( 0, 0, 0 )
	SetAlpha( 0.04 )
	DrawRect( 0, 0, 800, 600 )
	LTVisualizer.ResetColor() 
	L_PrintText( "L_DrawEmptyRect example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	Flip
Forever
