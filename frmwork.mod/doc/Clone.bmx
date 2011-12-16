SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const SpritesQuantity:Int = 50
	
	Field Sprites:LTLayer = New LTLayer
	Field Cursor:LTSprite = New LTSprite
	Field SpriteImage:LTImage = LTImage.FromFile( "kolobok.png" )
	
	Method Init()
		For Local N:Int = 1 To SpritesQuantity
			Local Sprite:LTSprite = LTSprite.FromShape( Rnd( -15, 15 ), Rnd( -11, 11 ), , , LTSprite.Oval )
			Sprite.SetDiameter( Rnd( 1, 3 ) )
			Sprite.Visualizer.SetRandomColor()
			Sprite.Visualizer.Angle = Rnd( 360 )
			Sprite.Visualizer.Image = SpriteImage
			Sprite.Visualizer.SetVisualizerScales( 1.3 )
			Sprites.AddLast( Sprite )
		Next
		Cursor.SetDiameter( 0.5 )
		Cursor.ShapeType = LTSprite.Oval
		Cursor.Visualizer.SetColorFromHex( "FF0000" )
		L_InitGraphics()
	End Method
	
	Method Logic()
		Cursor.SetMouseCoords()
		If MouseHit( 1 ) Then
			Local Sprite:LTSprite = Cursor.FirstCollidedSpriteOfGroup( Sprites )
			If Sprite Then
				Local NewSprite:LTSprite = LTSprite( Sprite.Clone() )
				NewSprite.AlterCoords( Rnd( -2, 2 ), Rnd( -2, 2 ) )
				NewSprite.AlterDiameter( Rnd( 0.75, 1.5 ) )
				NewSprite.AlterAngle( Rnd( -45, 45 ) ) 
				Sprites.AddLast( NewSprite )
			End If
		End If
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Sprites.Draw()
		DrawText( "Clone sprites with left mouse button", 0, 0 )
	End Method
End Type