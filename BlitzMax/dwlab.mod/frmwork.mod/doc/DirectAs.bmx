SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Incbin "kolobok.png"

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const SpritesQuantity:Int = 50
	
	Field Layer:LTLayer = New LTLayer
	Field Cursor:TCursor = New TCursor
	Field SpriteImage:LTImage = LTImage.FromFile( "incbin::kolobok.png" )
	Field Selected:LTSprite
	
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
		L_PrintText( "DirectAs, SetSizeAs example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TCursor Extends LTSprite
	Field SizeHandler:TSizeCollisionHandler = New TSizeCollisionHandler
	Field DirectionHandler:TDirectionCollisionHandler = new TDirectionCollisionHandler
	
	Method Act()
		SetMouseCoords()
		If MouseHit( 1 ) Then CollisionsWithLayer( Example.Layer, DirectionHandler )
		If MouseHit( 2 ) Then CollisionsWithLayer( Example.Layer, SizeHandler )
	End Method
End Type



Type TSizeCollisionHandler Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Sprite1.SetSizeAs( Sprite2 )
	End Method
End Type



Type TDirectionCollisionHandler Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Sprite1.DirectAs( Sprite2 )
	End Method
End Type