SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import brl.pngloader

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const KoloboksQuantity:Int = 50
	
	Field Layer:LTLayer = New LTLayer
	Field Cursor:TCursor = New TCursor
	Field KolobokImage:LTImage = LTImage.FromFile( "kolobok.png" )
	Field Selected:LTSprite
	Field MarchingAnts:LTMarchingAnts = New LTMarchingAnts
	
	Method Init()
		For Local N:Int = 1 To KoloboksQuantity
			Local Kolobok:LTSprite = New LTSprite
			Kolobok.SetCoords( Rnd( -15, 15 ), Rnd( -11, 11 ) )
			Kolobok.SetDiameter( Rnd( 1, 3 ) )
			Kolobok.ShapeType = LTSprite.Oval
			Kolobok.Angle = Rnd( 360 )
			Kolobok.Visualizer.SetRandomColor()
			Kolobok.Visualizer.Image = KolobokImage
			Layer.AddLast( Kolobok )
		Next
		
		Cursor.SetDiameter( 0.5 )
		L_InitGraphics()
	End Method
	
	Method Logic()
		Cursor.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		If Selected Then Selected.DrawUsingVisualizer( Example.MarchingAnts )
		DrawText( "Select kolobok by left-clicking on it", 0, 0 )
	End Method
End Type



Type TCursor Extends LTSprite
	Method Act()
		SetMouseCoords()
		If MouseHit( 1 ) Then
			Example.Selected = Null
			CollisionsWithGroup( Example.Layer )
		End If
	End Method
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int = 0 )
		Example.Selected = Sprite
	End Method
End Type