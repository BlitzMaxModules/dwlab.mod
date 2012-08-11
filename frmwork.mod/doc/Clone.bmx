SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Incbin "kolobok.png"

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const SpritesQuantity:Int = 50
	
	Field Sprites:LTLayer = New LTLayer
	Field SpriteImage:LTImage = LTImage.FromFile( "incbin::kolobok.png" )
	
	Method Init()
		For Local N:Int = 1 To SpritesQuantity
			Local Sprite:LTSprite = LTSprite.FromShape( Rnd( -15, 15 ), Rnd( -11, 11 ), , , LTSprite.Oval )
			Sprite.SetDiameter( Rnd( 1, 3 ) )
			Sprite.DisplayingAngle= Rnd( 360 )
			Sprite.Visualizer.SetRandomColor()
			Sprite.Visualizer.Image = SpriteImage
			Sprite.Visualizer.SetVisualizerScales( 1.3 )
			Sprites.AddLast( Sprite )
		Next
		L_InitGraphics()
	End Method
	
	Method Logic()
		If MouseHit( 1 ) Then
			Local Sprite:LTSprite = L_Cursor.FirstCollidedSpriteOfLayer( Sprites )
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
		L_PrintText( "AlterAngle, AlterCoords, AlterDiameter, Clone example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type