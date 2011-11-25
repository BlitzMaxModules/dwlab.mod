SuperStrict

Framework brl.basic
Import dwlab.frmwork

SeedRnd( MilliSecs() )
Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const SpritesQuantity:Int = 50
	
	Field Layer:LTLayer = New LTLayer
	Field Shape:LTShape = LTSprite.FromShape( 0, 0, 30, 20 )
	Field Cursor:LTSprite = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
	
	Method Init()
		For Local N:Int = 1 To SpritesQuantity
			TBall.Create()
		Next
		Shape.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.1, "FF0000" )
		L_InitGraphics()
	End Method
	
	Method Logic()
		Cursor.SetMouseCoords()
		Layer.Act()
		If KeyHit( Key_Space ) Then
			For Local Sprite:LTSprite = Eachin Layer
				Sprite.Active = True
				Sprite.Visible = True
			Next
		End If
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		Shape.Draw()
		DrawText( "Press left mouse button on circle to make it inactive, right button to make it invisible, space to restore all back.", 0, 0 )
	End Method
End Type

Type TBall Extends LTSprite
	Function Create:TBall()
		Local Ball:TBall = New TBall
		Ball.SetCoords( Rnd( -13, 13 ), Rnd( -8, 8 ) )
		Ball.SetDiameter( Rnd( 0.5, 1.5 ) )
		Ball.Angle = Rnd( 360 )
		Ball.Velocity = Rnd( 3, 7 )
		Ball.ShapeType = LTSprite.Oval
		Ball.Visualizer = LTVisualizer.FromRGBColor( Rnd( 0.25, 1.0 ), Rnd( 0.25, 1.0 ), Rnd( 0.25, 1.0 ) )
		Example.Layer.AddLast( Ball )
		Return Ball
	End Function
	
	Method Act()
		MoveForward()
		BounceInside( Example.Shape )
		CollisionsWithSprite( Example.Cursor )
	End Method
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int = 0 )
		If MouseDown( 1 ) Then Active = False
		If MouseDown( 2 ) Then Visible = False
	End Method
End Type