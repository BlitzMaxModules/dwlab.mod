SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field LineSegments:LTLayer = New LTLayer
	
	Method Init()
		L_InitGraphics()
		L_CurrentCamera.SetMagnification( 75.0 )
		Local Visualizer:TBlazing = New TBlazing
		For Local Pivots:Int[] = Eachin [ [ -4, -2, -2, -2 ], [ -4, -2, -4, 0 ], [ -4, 0, -4, 2 ], [ -4, 0, -3, 0 ], [ 1, -2, -1, -2 ], [ -1, -2, -1, 0 ], [ -1, 0, 1, 0 ], ..
				[ 1, 0, 1, 2 ], [ 1, 2, -1, 2 ], [ 4, -2, 2, -2 ], [ 2, -2, 2, 0 ], [ 2, 0, 2, 2 ], [ 2, 0, 3, 0 ] ]
			Local LineSegment:LTLineSegment = LTLineSegment.FromPivots( LTSprite.FromShape( Pivots[ 0 ], Pivots[ 1 ] ), LTSprite.FromShape( Pivots[ 2 ], Pivots[ 3 ] ) )
			LineSegment.Visualizer = Visualizer
			LineSegments.AddLast( LineSegment )
		Next
	End Method
	
	Method Logic()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		LineSegments.Draw()
		DrawText( "Free Software Forever!", 0, 0 )
		L_PrintText( "DrawUsingLine example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TBlazing Extends LTVisualizer
	Const ChunkSize:Double = 25
	Const DeformationRadius:Double = 15
	Method DrawUsingLineSegment( LineSegment:LTLineSegment )
		Local SX1:Double, SY1:Double, SX2:Double, SY2:Double
		L_CurrentCamera.FieldToScreen( LineSegment.Pivot[ 0 ].X, LineSegment.Pivot[ 0 ].Y, SX1, SY1 )
		L_CurrentCamera.FieldToScreen( LineSegment.Pivot[ 1 ].X, LineSegment.Pivot[ 1 ].Y, SX2, SY2 )
		Local ChunkQuantity:Int = Max( 1, L_Round( 1.0 * L_Distance( SX2 - SX1, SY2 - SY1 ) / ChunkSize ) )
		Local OldX:Double, OldY:Double
		For Local N:Int = 0 To ChunkQuantity
			Local Radius:Double = 0
			If N > 0 And N < ChunkQuantity Then Radius = Rnd( 0.0, DeformationRadius )
			
			Local Angle:Double = Rnd( 0.0, 360.0 )
			Local X:Int = SX1 + ( SX2 - SX1 ) * N / ChunkQuantity + Cos( Angle ) * Radius
			Local Y:Int = SY1 + ( SY2 - SY1 ) * N / ChunkQuantity + Sin( Angle ) * Radius
			
			SetLineWidth( 9 )
			SetColor( 0, 255, 255 )
			DrawOval( X - 4, Y - 4, 9, 9 )
			If N > 0 Then 
				DrawOval( OldX - 4, OldY - 4, 9, 9 )
				DrawLine( X, Y, OldX, OldY )
			End If
			SetLineWidth( 4 )
			SetColor( 255, 255, 255 )
			DrawOval( X - 2, Y - 2, 5, 5 )
			If N > 0 Then
				DrawOval( OldX - 2, OldY - 2, 5, 5 )
				DrawLine( X, Y, OldX, OldY )
			End If
			
			OldX = X
			OldY = Y
		Next
	End Method
End Type