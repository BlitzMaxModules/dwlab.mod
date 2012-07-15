SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const SpritesQuantity:Int = 20
	
	Field Layer:LTLayer = New LTLayer
	Field LineSegment:LTLineSegment = New LTLineSegment
	Field MinSprite:LTSprite

	Method Init()
		L_InitGraphics()
		For Local N:Int = 1 To SpritesQuantity
			Local Sprite:LTSprite = LTSprite.FromShape( Rnd( -15, 15 ), Rnd( -11, 11 ), , , LTSprite.Oval )
			Sprite.SetDiameter( Rnd( 0.5, 1.5 ) )
			Sprite.Visualizer.SetRandomColor()
			Layer.AddLast( Sprite )
		Next
		L_Cursor = LTSprite.FromShape( 0, 0, 0.5, 0.5, LTSprite.Oval )
		LineSegment.Pivot[ 0 ] = L_Cursor
	End Method
	
	Method Logic()
		MinSprite = Null
		Local MinDistance:Double
		For Local Sprite:LTSprite = Eachin Layer
			If L_Cursor.DistanceTo( Sprite ) < MinDistance Or Not MinSprite Then
				MinSprite = Sprite
				MinDistance = L_Cursor.DistanceTo( Sprite )
			End If
		Next
		LineSegment.Pivot[ 1 ] = MinSprite
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		
		LineSegment.Draw()
		L_PrintText( L_TrimDouble( L_Cursor.DistanceTo( MinSprite ) ), 0.5 * ( L_Cursor.X + MinSprite.X ), 0.5 * ( L_Cursor.Y + MinSprite.Y ) )
		
		Local SX:Double, SY:Double
		L_CurrentCamera.FieldToScreen( L_Cursor.X, L_Cursor.Y, SX, SY )
		DrawLine( SX, SY, 400, 300 )
		L_PrintText( L_TrimDouble( L_Cursor.DistanceToPoint( 0, 0 ) ), 0.5 * L_Cursor.X, 0.5 * L_Cursor.Y )
		
		DrawText( "Direction to field center is " + L_TrimDouble( L_Cursor.DirectionToPoint( 0, 0 ) ), 0, 0 )
		DrawText( "Direction to nearest sprite is " + L_TrimDouble( L_Cursor.DirectionTo( MinSprite ) ), 0, 16 )
		L_PrintText( "DirectionTo, DirectionToPoint, DistanceTo, DistanceToPoint example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type