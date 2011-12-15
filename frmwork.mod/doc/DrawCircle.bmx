SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const MapSize:Int = 128
	Const MapScale:Double = 4.0
	Const PicScale:Double = 5.0

	Field DoubleMap:LTDoubleMap = LTDoubleMap.Create( MapSize, MapSize )
	
	Method Init()
		L_InitGraphics()
		SetClsColor( 0, 0, 255 )
		Local Array:Float[][][] = [ [ [ 0.0, -7.0, 5.0 ], [ 0.0, -1.5, 7.0 ], [ -4.0, -3.0, 2.0 ], [ 4.0, -3.0, 2.0 ], [ 0.0, 6.0, 9.0 ] ], ..
				[ [ 0.0, -7.0, 1.5 ], [ -1.0, -8.0, 1.0 ], [ 1.0, -8.0, 1.0 ], [ 0.0, -3.5, 1.0 ], [ 0.0, -2.0, 1.0 ], [ 0.0, -0.5, 1.0 ] ] ]
		For Local Col:Int = 0 to 1
			For Local Shape:Float[] = Eachin Array[ Col ]
				DoubleMap.DrawCircle( Shape[ 0 ] * PicScale + 0.5 * MapSize, Shape[ 1 ] * PicScale + 0.5 * MapSize, 0.5 * Shape[ 2 ] * PicScale, 1.0 - 0.7 * Col )
			Next
		Next
	End Method
	
	Method Logic()
		if KeyHit( Key_Space ) Then DoubleMap.Blur()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		SetScale( MapScale, MapScale )
		DrawImage( DoubleMap.ToNewImage().BMaxImage, 400, 300 )
		SetScale( 1, 1 )
		DrawText( "Press space to blur map", 0, 0 )
	End Method
End Type