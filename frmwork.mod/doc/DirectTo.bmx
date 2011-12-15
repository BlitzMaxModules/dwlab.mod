SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const KoloboksQuantity:Int = 50
	
	Field Layer:LTLayer = New LTLayer
	Field Cursor:LTSprite = New LTSprite
	Field KolobokImage:LTImage = LTImage.FromFile( "kolobok.png" )
	
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
		Cursor.SetDiameter( 0.5 )
		Cursor.Visualizer.SetColorFromHex( "FF0000" )
		L_InitGraphics()
	End Method
	
	Method Logic()
		Cursor.SetMouseCoords()
		Layer.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		Cursor.Draw()
		DrawText( "", 0, 0 )
	End Method
End Type



Type TKolobok Extends LTSprite
	Method Act()
		DirectTo( Example.Cursor )
	End Method
End Type