SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const SpritesQuantity:Int = 100
	
	Field Layer:LTLayer = New LTLayer
	Field Cursor:LTSprite = LTSprite.FromShape( 0, 0, 8, 6 )
	Field Rectangle:LTShape = LTSprite.FromShape( 0, 0, 30, 20 )
	
	Method Init()
		For Local N:Int = 1 To SpritesQuantity
			Local Sprite:LTSprite = LTSprite.FromShape( Rnd( -13, 13 ), Rnd( -8, 8 ), , , LTSprite.Oval, Rnd( 360 ), Rnd( 3, 7 ) )
			Sprite.Visualizer.SetRandomColor()
			Layer.AddLast( Sprite )
		Next
		L_InitGraphics()
	End Method
	
	Method Logic()
		Cursor.SetMouseCoords()
		For Local Sprite:LTSprite = Eachin Layer
			Sprite.MoveForward()
			Sprite.BounceInside( Rectangle )
		Next
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Cursor.SetAsViewport()
		Layer.Draw()
		Rectangle.DrawContour( 2 )
		L_CurrentCamera.ResetViewport()
		Cursor.DrawContour( 2 )
	End Method
End Type