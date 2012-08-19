SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Incbin "kolobok.png"

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const KoloboksQuantity:Int = 50
	
	Field Layer:LTLayer = New LTLayer
	Field KolobokImage:LTImage = LTImage.FromFile( "incbin::kolobok.png" )
	
	Method Init()
		For Local N:Int = 1 To KoloboksQuantity
			Local Kolobok:TKolobok = New TKolobok
			Kolobok.SetCoords( Rnd( -15, 15 ), Rnd( -11, 11 ) )
			Kolobok.SetDiameter( Rnd( 1, 3 ) )
			Kolobok.ShapeType = LTSprite.Oval
			Kolobok.Visualizer.SetRandomColor()
			Kolobok.Visualizer.Image = KolobokImage
			Layer.AddLast( Kolobok )
		Next
		L_InitGraphics()
	End Method
	
	Method Logic()
		Layer.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		L_PrintText( "DirectTo example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TKolobok Extends LTSprite
	Method Act()
		DirectTo( L_Cursor )
	End Method
End Type