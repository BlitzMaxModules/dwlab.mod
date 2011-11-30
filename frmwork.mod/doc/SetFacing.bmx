SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import brl.pngloader

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Sprite:LTSprite = LTSprite.FromShape( 0, 0, 8, 8 )
	
	Method Init()
		L_InitGraphics()
		Sprite.Visualizer.Image = LTImage.FromFile( "kolobok.png" )
	End Method
	
	Method Logic()
		If KeyHit( Key_Left ) Then Sprite.SetFacing( LTSprite.LeftFacing )
		If KeyHit( Key_Right ) Then Sprite.SetFacing( LTSprite.RightFacing )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Sprite.Draw()
		DrawText( "Press left and right arrows to change sprite facing", 0, 0 )
	End Method
End Type