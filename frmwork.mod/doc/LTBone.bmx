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
				Local Bone:LTBone = LTBone.FromPivotsAndResistances( Pivots[ N ], Pivots[ M ] )
				Bone.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.3, "FF0000" )
				Layer.AddLast( Bone )
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