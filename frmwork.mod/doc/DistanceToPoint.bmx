SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const SpritesQuantity:Int = 20
	
	Field Layer:LTLayer = New LTLayer
	Field Cursor:LTSprite = LTSprite.FromShape( 0, 0, 0.5, 0.5, LTSprite.Oval )
	Field Line:LTLine = New LTLine
	Field MinSprite:LTSprite

	Method Init()
		L_InitGraphics()
		For Local N:Int = 1 To SpritesQuantity
			Local Sprite:LTSprite = LTSprite.FromShape( Rnd( -15, 15 ), Rnd( -11, 11 ), , , LTSprite.Oval )
			Sprite.SetDiameter( Rnd( 0.5, 1.5 ) )
			Sprite.Visualizer.SetRandomColor()
			Layer.AddLast( Sprite )
		Next
		Line.Pivot[ 0 ] = Cursor
	End Method
	
	Method Logic()
		Cursor.SetMouseCoords()
		
		MinSprite = Null
		Local MinDistance:Double
		For Local Sprite:LTSprite = Eachin Layer
			If Cursor.DistanceTo( Sprite ) < MinDistance Or Not MinSprite Then
				MinSprite = Sprite
				MinDistance = Cursor.DistanceTo( Sprite )
			End If
		Next
		Line.Pivot[ 1 ] = MinSprite
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		
		Line.Draw()
		L_PrintText( L_TrimDouble( Cursor.DistanceTo( MinSprite ) ), 0.5 * ( Cursor.X + MinSprite.X ), 0.5 * ( Cursor.Y + MinSprite.Y ) )
		
		Local SX:Double, SY:Double
		L_CurrentCamera.FieldToScreen( Cursor.X, Cursor.Y, SX, SY )
		DrawLine( SX, SY, 400, 300 )
		L_PrintText( L_TrimDouble( Cursor.DistanceToPoint( 0, 0 ) ), 0.5 * Cursor.X, 0.5 * Cursor.Y )
		
		DrawText( "Direction to field center is " + L_TrimDouble( Cursor.DirectionToPoint( 0, 0 ) ), 0, 0 )
		DrawText( "Direction to nearest sprite is " + L_TrimDouble( Cursor.DirectionTo( MinSprite ) ), 0, 16 )
	End Method
End Type