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
	
	Field Cursor:LTSprite = LTSprite.FromShape( 0, 0, 0.5, 0.5, LTSprite.Oval )
	Field Player:LTSprite = LTSprite.FromShape( 0, 0, 1, 1, LTSprite.Oval )
	Field Bullets:LTLayer = New LTLayer
	
	Method Init()
		L_InitGraphics()
		Cursor.Visualizer.SetColorFromHex( "FFBF7F" )
		Player.Visualizer.SetColorFromHex( "7FBFFF" )
	End Method
	
	Method Logic()
		Cursor.SetMouseCoords()
	
		If MoveLeft.IsDown() Then Player.Move( -Velocity, 0 )
		If MoveRight.IsDown() Then Player.Move( Velocity, 0 )
		If MoveUp.IsDown() Then Player.Move( 0, -Velocity )
		If MoveDown.IsDown() Then Player.Move( 0, Velocity )
		If Fire.IsDown() Then TBullet.Create()
		
		Bullets.Act()
		
		If KeyDown( Key_LControl ) Or KeyDown( Key_RControl ) Then If KeyDown( Key_D ) Then
			Local DefineKeys:TDefineKeys = New TDefineKeys
			DefineKeys.Actions = Actions
			DefineKeys.Add()
		End If
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Bullets.Draw()
		Player.Draw()
		Cursor.Draw()
		DrawText( "Press Ctrl-D to define keys", 0, 0 )
	End Method
End Type



Type TBullet Extends LTSprite
	Function Create:TBullet()
		Local Bullet:TBullet = New TBullet
		Bullet.SetCoords( Example.Player.X, Example.Player.Y )
		Bullet.SetDiameter( 0.25 )
		Bullet.ShapeType = LTSprite.Oval
		Bullet.Angle = Example.Player.DirectionTo( Example.Cursor )
		Bullet.Velocity = Example.BulletVelocity
		Bullet.Visualizer.SetColorFromHex( "7FFFBF" )
		Example.Bullets.AddLast( Bullet )
	End Function
	
	Method Act()
		MoveForward()
	End Method
End Type



Type TDefineKeys Extends LTProject
	Field Actions:LTButtonAction[]
	Field ActionNum:Int = 0
	Field Z:Int
	
	Method Init()
		FlushKeys()
		FlushMouse()
	End Method
	
	Method Logic()
		If Actions[ ActionNum ].Define() Then
			ActionNum :+ 1
			If ActionNum = Actions.Dimensions()[ 0 ] Then Exiting = True
		End If
	End Method
	
	Method Render()
		DrawText( "Press key for " + Actions[ ActionNum ].Name, 0, 16 )
	End Method
End Type