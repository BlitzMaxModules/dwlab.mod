SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const FlowersQuantity:Int = 12
	Const FlowerCircleDiameter:Double = 10
	Const FlowerDiameter:Double = 2.0
	
	Field Flowers:LTSprite[] = New LTSprite[ FlowersQuantity ]
	Field FlowerVisualizer:TFlowerVisualizer = New TFlowerVisualizer
	
	Method Init()
		L_InitGraphics()
		For Local N:Int = 0 Until FlowersQuantity
			Flowers[ N ] = New LTSprite
			Flowers[ N ].SetDiameter( FlowerDiameter )
		Next
	End Method
	
	Method Logic()
		For Local N:Int = 0 Until FlowersQuantity
			Local Angle:Double = N * 360 / FlowersQuantity + 45 * Time
			Flowers[ N ].SetCoords( Cos( Angle ) * FlowerCircleDiameter, Sin( Angle ) * FlowerCircleDiameter )
			Flowers[ N ].Angle = 90 * Time
		Next
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		For Local N:Int = 0 Until FlowersQuantity
			Flowers[ N ].DrawUsingVisualizer( FlowerVisualizer )
		Next
		DrawText( "", 0, 0 )
	End Method
End Type

Type TFlowerVisualizer Extends LTVisualizer
	Const CirclesQuantity:Int = 30
	Const CirclesPer360:Int = 7
	Const Amplitude:Double = 0.15
	
	Method DrawUsingSprite( Sprite:LTSprite )
		Local SpriteDiameter:Double = Sprite.GetDiameter()
		Local CircleDiameter:Double = L_CurrentCamera.DistFieldToScreen( 2.0 * Pi * SpriteDiameter / CirclesQuantity ) * 1.5
		For Local N:Int = 0 Until CirclesQuantity
			Local Angle:Double = 360.0 * N / CirclesQuantity
			Local Angles:Double = Sprite.Angle + Angle
			Local Distance:Double = SpriteDiameter * ( 1.0 + Amplitude * Sin( 360.0 * Example.Time + 360.0 * N / CirclesQuantity * CirclesPer360 ) )
			Local SX:Double, SY:Double
			L_CurrentCamera.FieldToScreen( Sprite.X + Distance * Cos( Angles ), Sprite.Y + Distance * Sin( Angles ), SX, SY )
			DrawOval( SX - 0.5 * CircleDiameter, SY - 0.5 * CircleDiameter, CircleDiameter, CircleDiameter )
		Next
	End Method
End Type