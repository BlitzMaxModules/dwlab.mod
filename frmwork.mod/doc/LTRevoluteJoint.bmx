SuperStrict

Framework brl.basic
Import dwlab.frmwork

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const HingesQuantity:Int = 17
	Const CircleDiameter:Double = 8.0
	Const HingeDistance:Double = 3.0

	Method Init()
		Local Circle:LTSprite = LTSprite.FromShape( 0, 0, CircleDiameter, CircleDiameter, LTSprite.Oval )
		Local Hinges:LTSprite[] = New LTSprite[ HingesQuantity ]
		For Local N:Int = 0 Until HingesQuantity
			Hinges[ N ] = New LTSprite
		Next
		Local 
		L_InitGraphics()
	End Method
	
	Method Logic()
		Circle.Turn( 45.0 )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		DrawText( "", 0, 0 )
	End Method
End Type