SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Incbin "spaceship.png"

Type TExample Extends LTProject
	Field Sprites:LTLayer = New LTLayer
	Field Image:LTImage = LTImage.FromFile( "incbin::spaceship.png" )
	
	Method Init()
		For Local N:Int = 0 Until 9
			Local Sprite:LTSprite = New LTSprite.FromShape( ( N Mod 3 ) * 8.0 - 8.0, Floor( N / 3 ) * 6.0 - 6.0, 6.0, 4.0, N )
			If N = LTSprite.Raster Then Sprite.Visualizer.Image = Image
			Sprite.Visualizer.SetColorFromHex( "7FFF7F" )
			Sprite.Angle = 60
			Sprites.AddLast( Sprite )
		Next
		L_InitGraphics()
		L_Cursor = New LTSprite.FromShape( 0.0, 0.0, 5.0, 7.0, LTSprite.Pivot )
		L_Cursor.Angle = 45
		L_Cursor.Visualizer.SetColorFromHex( "7F7F7FFF" )
	End Method
	
	Method Logic()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
		If MouseHit( 2 ) Then
			L_Cursor.ShapeType = ( L_Cursor.ShapeType + 1 ) Mod 9
			If L_Cursor.ShapeType = LTSprite.Raster Then L_Cursor.Visualizer.Image = Image Else L_Cursor.Visualizer.Image = Null
		End If
	End Method

	Method Render()
		Sprites.Draw()
		For Local Sprite:LTSprite = Eachin Sprites.Children
			if L_Cursor.CollidesWithSprite( Sprite ) Then
				Sprite.Visualizer.SetColorFromHex( "FF7F7F" )
				Local WedgedCursor:LTSprite = LTSprite( L_Cursor.Clone() )
				WedgedCursor.WedgeOffWithSprite( Sprite, 0, 1 )
				WedgedCursor.Visualizer.SetColorFromHex( "7F7FFFFF" )
				WedgedCursor.Draw()
			Else
				Sprite.Visualizer.SetColorFromHex( "7FFF7F" )
			End If
		Next
		L_Cursor.Draw()
		
		Local Triangle:LTSprite = LTSprite( Sprites.ValueAtIndex( 5 ) )
		Triangle.GetHypotenuse( L_Line )
		
		L_PrintText( "Press right mouse button to change shape", 0, -12, LTAlign.ToCenter, LTAlign.ToTop )
		L_PrintText( "ColldesWithSprite example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type