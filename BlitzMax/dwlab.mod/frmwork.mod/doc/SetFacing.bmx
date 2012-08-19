SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Incbin "kolobok.png"

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Sprite:LTSprite = LTSprite.FromShape( 0, 0, 8, 8 )
	
	Method Init()
		L_InitGraphics()
		Sprite.Visualizer.Image = LTImage.FromFile( "incbin::kolobok.png" )
	End Method
	
	Method Logic()
		If KeyHit( Key_Left ) Then Sprite.SetFacing( LTSprite.LeftFacing )
		If KeyHit( Key_Right ) Then Sprite.SetFacing( LTSprite.RightFacing )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Sprite.Draw()
		DrawText( "Press left and right arrows to change sprite facing", 0, 0 )
		L_PrintText( "SetFacing example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type