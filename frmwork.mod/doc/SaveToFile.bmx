SuperStrict

Framework brl.basic

Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const SpritesQuantity:Int = 70

	Field Layer:LTLayer = New LTLayer
	Field Ang:Double
	Field OldSprite:LTSprite

	Method Init()
		L_InitGraphics()
		For Local N:Int = 1 To SpritesQuantity
			OldSprite = LTSprite.FromShape( Rnd( -15, 15 ), Rnd( -11, 11 ), , , LTSprite.Oval, Rnd( 360 ), 5 )
			OldSprite.SetDiameter( Rnd( 0.5, 1.5 ) )
			OldSprite.Visualizer.SetRandomColor()
			Layer.AddLast( OldSprite )
		Next
	End Method
	
	Method Logic()
		Ang = 1500 * Sin( 7 * Time )
		For Local Sprite:LTSprite = Eachin Layer
			OldSprite.DirectTo( Sprite )
			OldSprite.Angle :+ L_PerSecond( Ang ) + Rnd( -45, 45 )
			Sprite.MoveForward()
			OldSprite = Sprite
		Next
		
		If KeyHit( Key_F2 ) Then Layer.SaveToFile( "sprites.lw" )
		If KeyHit( Key_F3 ) Then Layer = LTLayer( LTObject.LoadFromFile( "sprites.lw" ) )
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		DrawText( "Press F2 to save and F3 to load position of sprites", 0, 0 )
	End Method
End Type