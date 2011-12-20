SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()


Type TExample Extends LTProject
	Field Velocity:Double = 5.0
	Field BulletVelocity:Double = 10.0

	Field MoveLeft:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Left ), "move left" )
	Field MoveRight:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Right ), "move right" )
	Field MoveUp:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Up ), "move up" )
	Field MoveDown:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Down ), "move down" )
	Field Fire:LTButtonAction = LTButtonAction.Create( LTMouseButton.Create( 1 ), "fire" )
	Field Actions:LTButtonAction[] = [ MoveLeft, MoveRight, MoveUp, MoveDown, Fire ]
	
	Field Player:LTSprite = LTSprite.FromShape( 0, 0, 1, 1, LTSprite.Oval )
	Field Bullets:LTLayer = New LTLayer
	
	Method Init()
		L_InitGraphics()
		Player.Visualizer.SetColorFromHex( "7FBFFF" )
	End Method
	
	Method Logic()
		If MoveLeft.IsDown() Then Player.Move( -Velocity, 0 )
		If MoveRight.IsDown() Then Player.Move( Velocity, 0 )
		If MoveUp.IsDown() Then Player.Move( 0, -Velocity )
		If MoveDown.IsDown() Then Player.Move( 0, Velocity )
		If Fire.IsDown() Then TBullet.Create()
		
		Bullets.Act()
		
		If KeyDown( Key_LControl ) Or KeyDown( Key_RControl ) Then If KeyDown( Key_D ) Then SwitchTo( New TDefineKeys )
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Bullets.Draw()
		Player.Draw()
		DrawText( "Press Ctrl-D to define keys", 0, 0 )
		L_PrintText( "LTButtonAction, SwitchTo, Move example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TBullet Extends LTSprite
	Function Create:TBullet()
		Local Bullet:TBullet = New TBullet
		Bullet.SetCoords( Example.Player.X, Example.Player.Y )
		Bullet.SetDiameter( 0.25 )
		Bullet.ShapeType = LTSprite.Oval
		Bullet.Angle = Example.Player.DirectionTo( L_Cursor )
		Bullet.Velocity = Example.BulletVelocity
		Bullet.Visualizer.SetColorFromHex( "7FFFBF" )
		Example.Bullets.AddLast( Bullet )
	End Function
	
	Method Act()
		MoveForward()
	End Method
End Type



Type TDefineKeys Extends LTProject
	Field ActionNum:Int = 0
	Field Z:Int
	
	Method Init()
		FlushKeys()
		FlushMouse()
	End Method
	
	Method Logic()
		If Example.Actions[ ActionNum ].Define() Then
			ActionNum :+ 1
			If ActionNum = Example.Actions.Dimensions()[ 0 ] Then Exiting = True
		End If
	End Method
	
	Method Render()
		Example.Render()
		DrawText( "Press key for " + Example.Actions[ ActionNum ].Name, 0, 16 )
	End Method
End Type