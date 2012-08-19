SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Incbin "kolobok.png"

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const SpritesQuantity:Int = 50
	
	Field Layer:LTLayer = New LTLayer
	Field Cursor:TCursor = New TCursor
	Field SpriteImage:LTImage = LTImage.FromFile( "incbin::kolobok.png" )
	Field Selected:LTSprite
	Field MarchingAnts:LTMarchingAnts = New LTMarchingAnts
	
	Method Init()
		For Local N:Int = 1 To SpritesQuantity
			Local Sprite:LTSprite = LTSprite.FromShape( Rnd( -15, 15 ), Rnd( -11, 11 ), , , LTSprite.Oval, Rnd( 360 ) )
			Sprite.SetDiameter( Rnd( 1, 3 ) )
			Sprite.Visualizer.SetRandomColor()
			Sprite.Visualizer.Image = SpriteImage
			Layer.AddLast( Sprite )
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
		DrawText( "Select Sprite by left-clicking on it", 0, 0 )
		L_PrintText( "LTMarchingAnts example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TCursor Extends LTSprite
	Field Handler:TSelectionHandler = New TSelectionHandler
	
	Method Act()
		SetMouseCoords()
		If MouseHit( 1 ) Then
			Example.Selected = Null
			CollisionsWithLayer( Example.Layer, Handler )
		End If
	End Method
End Type



Type TSelectionHandler Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Example.Selected = Sprite2
	End Method
End Type