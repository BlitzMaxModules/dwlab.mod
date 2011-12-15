SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const SpritesQuantity:Int = 50
	
	Field Layer:LTLayer = New LTLayer
	
	Method Init()
		L_InitGraphics()
		Local SpriteVisualizer:LTVisualizer = LTVisualizer.FromFile( "mario.png", 4 )
		For Local N:Int = 1 To SpritesQuantity
			Local Sprite:LTSprite = LTSprite.FromShape( Rnd( -15, 15 ), Rnd( -11, 11 ), Rnd( 0.5, 2 ), Rnd( 0.5, 2 ) )
			Sprite.Visualizer = SpriteVisualizer
			Layer.AddLast( Sprite )
		Next
	End Method
	
	Method Logic()
		If KeyHit( Key_Space ) Then
			For Local Sprite:LTSprite = EachIn Layer
				Sprite.CorrectHeight()
			Next
		End If
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		DrawText( "Press space to correct height", 0, 0 )
	End Method
End Type