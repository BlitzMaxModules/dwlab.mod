SuperStrict

Framework brl.basic

Import brl.pngloader

Import dwlab.frmwork

Global Game:TGame = New TGame
Game.Execute()

Type TGame Extends LTProject
	Const MazeSize:Int = 256
	Const ZombieProbability:Double = 0.1
	
	Field Template:LTWorld
	Field Maze:LTTileMap
	Field Objects:LTSpriteMap
	Field Zombies:Int
	Field ActingRegion:TActingRegion = New TActingRegion
	
	
	
	Method Init()
		L_InitGraphics()
		Template = LTWorld.FromFile( "template.lw" )
		Maze = LTTileMap( Template.FindShape( "LTTileMap" ) )
		Maze.SetResolution( MazeSize, MazeSize )
		( New TMazeGenerator ).Execute( Maze )
		Maze.Stretch( 2, 2 )
		Maze.Enframe()
		Objects = LTSpriteMap( Template.FindShape( "LTSpriteMap" ) )
		Objects.SetCellSize( 2.0, 2.0 )
		Objects.SetResolution( MazeSize, MazeSize )
		
		Local WallSprite:TWall = TWall( CreateShape( Template.FindShape( "TWall" ) ) )
		Local FloorSprite:TFloor = TFloor( CreateShape( Template.FindShape( "TFloor" ) ) )
		Local ZombieSprite:TZombie =  TZombie( CreateShape( Template.FindShape( "TZombie" ) ) )
		For Local Y:Int = 0 Until Maze.YQuantity
			For Local X:Int = 0 Until Maze.XQuantity
				If Maze.Value[ X, Y ] = 1 Then
					InsertSprite( FloorSprite, X, Y, Rand( 0, 3 ) )
					If Rnd() < ZombieProbability Then
						InsertSprite( ZombieSprite, X, Y, Rand( 0, 63 ) )
						Zombies :+ 1
					End If
				ElseIf Maze.Value[ X, Y ] >= 4 Then
					InsertSprite( WallSprite, X, Y, Maze.Value[ X, Y ] )
					If Maze.Value[ X, Y ] = 8 Or Maze.Value[ X, Y ] = 10 Then InsertSprite( FloorSprite, X, Y, Rand( 0, 3 ) )
				End If
			Next
		Next
		
		ActingRegion.ShapeType = LTSprite.Rectangle
		ActingRegion.SetSize( 2.0 * L_CurrentCamera.Width, 2.0 * L_CurrentCamera.Height )
	End Method
	
	
	
	Method InsertSprite( Sprite:LTSprite, X:Int, Y:Int, Frame:Int )
		Local NewSprite:LTSprite = LTSprite( TTypeID.ForObject( Sprite ).NewObject() )
		Sprite.CopyTo( NewSprite )
		NewSprite.X :+ X - Y
		NewSprite.Y :+ 0.5 * ( X + Y )
		NewSprite.Frame = Frame
		NewSprite.Init()
		Objects.InsertSprite( NewSprite )
	End Method
	
	
	
	Method Logic()
		L_CurrentCamera.MoveUsingArrows( 8.0 )
		ActingRegion.JumpTo( L_CurrentCamera )
		ActingRegion.CollisionsWithSpriteMap( Objects )
		If KeyHit( Key_Escape ) Then End
	End Method
	
	
	
	Method Render()
		Objects.Draw()
		ShowDebugInfo()
		DrawText( "Zombies: " + Zombies, 0, 96 )
	End Method
End Type



Type TMazeGenerator
	Field BranchPossibility:Double = 0.6
	Field LoopPossibility:Double = 0.2
	Field RoomPossibility:Double = 0.3
	Field MinBranchLength:Int = 4
	Field MaxBranchLength:Int = 16
	Field MinRoomSize:Int = 4
	Field MaxRoomSize:Int = 16
	
	Field PivotList:TList = New TList
	
	
	
	Method Execute( Maze:LTTileMap )
		AddPivot( 1, 1 )
		Local Cnt:Int = 0
		Repeat
			Local Quantity:Int = PivotList.Count()
			If Cnt = 0 Then
				Cls
				DrawText( Quantity, 0, 0 )
				Flip False
			End If
			Cnt = ( Cnt + 1 ) Mod 500
			If Quantity = 0 Then Exit
			Local Pivot:TMazePivot = TMazePivot( PivotList.ValueAtIndex( Rand( 0, Quantity - 1 ) ) )
			SetBranch( Maze, Pivot )
		Forever
	End Method
	
	
	
	Method SetBranch( Maze:LTTileMap, Pivot:TMazePivot )
		PivotList.Remove( Pivot )
		Local DirList:TList = New TList
		If Pivot.X > 1 And Maze.Value[ Pivot.X - 1, Pivot.Y ] = 0 Then DirList.AddLast( TDir.Create( -1, 0 ) )
		If Pivot.Y > 1 And Maze.Value[ Pivot.X, Pivot.Y - 1 ] = 0 Then DirList.AddLast( TDir.Create( 0, -1 ) )
		If Pivot.X < Maze.XQuantity - 1 And Maze.Value[ Pivot.X + 1, Pivot.Y ] = 0 Then DirList.AddLast( TDir.Create( 1, 0 ) )
		If Pivot.Y < Maze.YQuantity - 1 And Maze.Value[ Pivot.X, Pivot.Y + 1 ] = 0 Then DirList.AddLast( TDir.Create( 0, 1 ) )
		Local Quantity:Int = DirList.Count()
		If Not Quantity Then Return
		Local Dir:TDir = TDir( DirList.ValueAtIndex( Rand( 0, Quantity - 1 ) ) )
		Local Length:Int = Rand( MinBranchLength, MaxBranchLength )
		For Local N:Int = 0 To Length
			Local X:Int = Pivot.X + Dir.DX * N
			Local Y:Int = Pivot.Y + Dir.DY * N
			Local NextX:Int = X + Dir.DX
			Local NextY:Int = Y + Dir.DY
			Local ExitFlag:Int = False
			If NextX = 0 Or NextY = 0 Or NextX = Maze.XQuantity - 1 Or NextY = Maze.YQuantity - 1 Or Maze.Value[ NextX, NextY ] = 1 Then
				ExitFlag = True
			ElseIf Maze.Value[ NextX + Dir.DY, NextY + Dir.DX ] = 1 Or Maze.Value[ NextX - Dir.DY, NextY - Dir.DX ] = 1 Then
				ExitFlag = True
			ElseIf Maze.Value[ NextX + Dir.DX, NextY + Dir.DY ] = 1 Then If Rnd() > LoopPossibility Then ExitFlag = True
				ExitFlag = True
			Else
				Maze.Value[ X, Y ] = 1
			End If
			If ExitFlag Then
				If N > 0 Then AddPivot( X, Y )
				Length = N
				Exit
			EndIf
			If N > 0 Then
				If Rnd() < BranchPossibility Then AddPivot( X, Y )
			End If
		Next
		If Length > 0 And Dir.DX >= 0 And Dir.DY >= 0 Then
			Length :+ 1
			TryToMakeRoom( Maze, Pivot.X + Length * Dir.DX, Pivot.Y + Length * Dir.DY, Dir.DY )
		End If
	End Method
	
	
	
	Method AddPivot( X:Int, Y:Int )
		Local Pivot:TMazePivot = New TMazePivot
		Pivot.X = X
		Pivot.Y = Y
		PivotList.AddLast( Pivot )
	End Method
	
	
	
	Const DirX:Int = 0
	Const DirY:Int = 1
	
	Method TryToMakeRoom( Maze:LTTileMap, X:Int, Y:Int, Dir:Int )
		Local Width:Int = Rand( MinRoomSize, MaxRoomSize )
		Local Height:Int = Rand( MinRoomSize, MaxRoomSize )
		If Rnd() > RoomPossibility Then Return
		Local FromD:Int = 1
		Local ToD:Int = Width - 2
		If Dir = DirX Then
			If X + Width >= Maze.XQuantity Then Return
			If Y - ToD <= 0 Then ToD = Y - 1
			if Y + Height - FromD >= Maze.YQuantity - 1 Then FromD = Y + Height - Maze.YQuantity + 1
		Else
			If Y + Height >= Maze.YQuantity Then Return
			If X - ToD <= 0 Then ToD = X - 1
			if X + Width - FromD >= Maze.XQuantity - 1 Then FromD = X + Width - Maze.XQuantity + 1
		End If
		If FromD > ToD Then Return
		Local D:Int = Rand( FromD, ToD )
		For Local DY:Int = -1 To Height
			For Local DX:Int = -1 To Width
				If Dir = DirX Then
					If DX = -1 And DY = D Then Continue
					If Maze.Value[ X + DX, Y + DY - D ] = 1 Then Return
				Else
					If DY = -1 And DX = D Then Continue
					If Maze.Value[ X + DX - D, Y + DY ] = 1 Then Return
				End If
			Next
		Next
		For Local DY:Int = 0 Until Height
			For Local DX:Int = 0 Until Width
				Local XX:Int = X + DX
				Local YY:Int = Y + DY
				If Dir = DirX Then
					YY :- D
				Else
					XX :- D
				End If
				Maze.Value[ XX, YY ] = 1
				If DX = 0 Or DX = Width - 1 Then
					If DY > 0 And DY < Height - 1 Then If Rnd() < BranchPossibility Then AddPivot( XX, YY )
				ElseIf DY = 0 Or DY = Height - 1 Then
					If DX > 0 Or DX < Width - 1 Then If Rnd() < BranchPossibility Then AddPivot( XX, YY )
				End If
			Next
		Next
	End Method
End Type



Type TMazePivot
	Field X:Int, Y:Int
End Type



Type TDir
	Field DX:Int, DY:Int
	
	Function Create:TDir( DX:Int, DY:Int )
		Local Dir:TDir = New TDir
		Dir.DX = DX
		Dir.DY = DY
		Return Dir
	End Function
End Type



Type TWall Extends LTSprite
End Type



Type TFloor Extends LTSprite
End Type



Type TZombie Extends LTAngularSprite
	Field Speed:Double
	Field AnimationSpeed:Double

	Field Destination:LTSprite = New LTSprite
	Field Collided:Int
	
	
	
	Method Init()
		X :+ Rnd( 0.25, -0.25 )
		Y :+ Rnd( 0.25, -0.25 )
		Angle = Rnd( 360.0 )
		Speed = Rnd( 1.0, 1.5 )
		AnimationSpeed = 0.2 / Speed
	End Method
	
	
	
	Method Act()
		Move( Speed * Cos( Angle ), 0.5 * Speed * Sin( Angle ) )
		Collided = False
		CollisionsWithSpriteMap( Game.Objects )
		If Not Collided Then Animate( Game, AnimationSpeed, 8, 8 * ( ( 4.0 + L_Round( Angle / 45.0 ) ) Mod 8 ) )
	End Method
	
	
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int = 0 )
		If Not TFloor( Sprite ) Then
			PushFromSprite( Sprite )
			Angle = Rnd( 360.0 )
			Collided = True
		End If
	End Method
End Type



Type TActingRegion Extends LTSprite
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int = 0 )
		Sprite.Act()
	End Method
End Type