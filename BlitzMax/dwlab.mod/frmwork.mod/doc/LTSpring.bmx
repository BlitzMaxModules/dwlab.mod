SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import brl.pngloader

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const Gravity:Double = 10.0
	
	Field Layer:LTLayer = New LTLayer
	Field Rectangle:LTShape = LTSprite.FromShape( 0, 0, 30, 20 )
	
	Method Init()
		Local Pivots:LTVectorSprite[] = New LTVectorSprite[ 4 ]
		For Local Y:Int = 0 To 1
			For Local X:Int = 0 To 1
				Pivots[ X + Y * 2 ] = LTVectorSprite.FromShapeAndVector( X * 2 - 1, Y * 2 - 1, 0.3, 0.3, LTSprite.Rectangle )
				Layer.AddLast( Pivots[ X + Y * 2 ] )
			Next
		Next
		For Local N:Int = 0 To 2
			For Local M:Int = N + 1 To 3
				Local Spring:LTSpring = LTSpring.FromPivotsAndResistances( Pivots[ N ], Pivots[ M ] )
				Spring.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.3, "FF0000" )
				Layer.AddLast( Spring  )
			Next
		Next
		
		Pivots[ 0 ].DX = 5.0
		
		Rectangle.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.1, "FF0000" )
		
		L_InitGraphics()
	End Method
	
	Method Logic()
		For Local Pivot:LTVectorSprite = EachIn Layer
			Pivot.DY :+ PerSecond( Gravity )
			Pivot.MoveForward()
			Pivot.BounceInside( Rectangle )
		Next
		Layer.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Rectangle.Draw()
		Layer.Draw()
	End Method
End Type

Type LTSpring Extends LTLine
	Field MovingResistance:Double[] = New Double[ 2 ]
	Field Distance:Double
	
	Function FromPivotsAndResistances:LTSpring( Pivot1:LTSprite, Pivot2:LTSprite, Pivot1MovingResistance:Double = 0.5, Pivot2MovingResistance:Double = 0.5 )
		Local Spring:LTSpring = New LTSpring
		Spring.Pivot[ 0 ] = Pivot1
		Spring.Pivot[ 1 ] = Pivot2
		Spring.MovingResistance[ 0 ] = Pivot1MovingResistance
		Spring.MovingResistance[ 1 ] = Pivot2MovingResistance
		Spring.Distance = Pivot1.DistanceTo( Pivot2 )
		Return Spring
	End Function
	
	Method Act()
		Local Pivot0:LTVectorSprite = LTVectorSprite( Pivot[ 0 ] )
		Local Pivot1:LTVectorSprite = LTVectorSprite( Pivot[ 1 ] )
		Local K:Double = 1.0 - Distance / Pivot0.DistanceTo( Pivot1 )
		Pivot0.DX :+ L_DeltaTime * 20.0 * ( Pivot1.X - Pivot0.X ) * K
		Pivot0.DY :+ L_DeltaTime * 20.0 * ( Pivot1.Y - Pivot0.Y ) * K
		Pivot1.DX :- L_DeltaTime * 20.0 * ( Pivot1.X - Pivot0.X ) * K
		Pivot1.DY :- L_DeltaTime * 20.0 * ( Pivot1.Y - Pivot0.Y ) * K
	End Method
End Type