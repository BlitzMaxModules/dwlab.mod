SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import brl.pngloader

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const SpritesQuantity:Int = 50
	
	Field Layer:LTLayer = New LTLayer
	Field Cursor:TCursor = New TCursor
	Field SpriteImage:LTImage = LTImage.FromFile( "kolobok.png" )
	Field Selected:LTSprite
	Field MarchingAnts:LTMarchingAnts = New LTMarchingAnts
	
	Method Init()
		For Local N:Int = 1 To SpritesQuantity
			Local Sprite:LTSprite = LTSprite.FromShape( Rnd( -15, 15 ), Rnd( -11, 11 ), , , LTSprite.Oval, Rnd( 360 ) )
			Sprite.SetDiameter( Rnd( 1, 3 ) )
			Sprite.Visualizer.SetRandomColor()
			Sprite.Visualizer.Image = SpriteImage
			Layer.AddLast( Sprite )
		Next
		
		Cursor.Visualizer.Image = SpriteImage
		Cursor.ShapeType = LTSprite.Pivot
		L_InitGraphics()
	End Method
	
	Method Logic()
		Cursor.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		Cursor.Draw()
		DrawText( "Click left mouse button on sprite to direct cursor sprite as it", 0, 0 )
		DrawText( "and right button to set size equal to sprite's", 0, 16 )
	End Method
End Type



Type TCursor Extends LTSprite
	Method Act()
		SetMouseCoords()
		If MouseHit( 1 ) Then CollisionsWithGroup( Example.Layer, 0 )
		If MouseHit( 2 ) Then CollisionsWithGroup( Example.Layer, 1 )
	End Method
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int = 0 )
		If CollisionType Then
			SetSizeAs( Sprite )
		Else
			DirectAs( Sprite )
		End If
	End Method
End Type