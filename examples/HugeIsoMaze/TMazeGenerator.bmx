'
' Huge isometric maze - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

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
		Repeat
			PleaseWait()
			Local Quantity:Int = PivotList.Count()
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