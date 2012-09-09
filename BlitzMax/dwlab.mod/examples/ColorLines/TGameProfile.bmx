'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TGameProfile Extends LTProfile
	Const Void:Int = 0
	Const Plate:Int = 1
	Const Glue:Int = 2
	Const Ice:Int = 3
	Const ColdPlate:Int = 4
	Const ColdGlue:Int = 5
	Const ColdIce:Int = 6
	Const ClosedPocket:Int = 7
	
	Const OpenedPocket:Int = 8
	Const PocketForeground:Int = 9
	Const TileCursor:Int = 10
	
	Const NoBall:Int = 0
	Const BlackBall:Int = 8
	Const RandomBall:Int = 9
	Const Bomb:Int = 10
	
	Const NoModifier:Int = 0
	Const Lights:Int = 11
	Const AnyColor:Int = 12
	
	Field GameField:LTTileMap
	Field Balls:LTTileMap
	Field Modifiers:LTTileMap
	Field NextBalls:Int[]
	Field Pool:TList = New TList
	Field Goals:TList = New TList
	Field Score:Int
	Field BallsInLine:Int
	Field BallsPerTurn:Int
	Field Swap:Int
	Field OrthogonalLines:Int
	Field DiagonalLines:Int
	Field Overflow:Int
	
	Field LevelScore:Int
	Field LevelTime:Int
	Field LevelTurns:Int
	Field LevelSkippingTokens:Int
	
	Field BossKey:LTButtonAction
	Field ExitToMenu:LTButtonAction

	Method Init()
		Keys.AddLast( LTButtonAction.Create( LTKeyboardKey.Create( Key_Z ), "Boss key" ) )
		Keys.AddLast( LTButtonAction.Create( LTKeyboardKey.Create( Key_Escape ), "Exit to menu" ) )
	End Method
	
	Method Reset()
		Score = 0
		Game.Selected = Null
		Game.Objects.Clear()
	End Method

	Method LoadLevel( Level:LTLayer )
		Local Layer:LTLayer = Null
		Game.LoadAndInitLayer( Layer, Level )
		GameField = LTTileMap( Layer.FindShape( "Field" ) )
		GameField.Visualizer = TFieldVisualizer.Create( GameField.Visualizer )
		Balls = LTTileMap( Layer.FindShape( "Balls" ) )
		Balls.Visible = False
		Modifiers = LTTileMap( Layer.FindShape( "Modifiers" ) )
		
		BallsInLine = 5
		BallsPerTurn = 3
		Swap = True
		OrthogonalLines = True
		DiagonalLines = True
		Overflow = True
		
		Goals.Clear()
		Pool.Clear()
		For Local Parameter:LTParameter = Eachin Level.Parameters
			Local IntValue:Int = Parameter.Value.ToInt()
			Local Parameters:String[] = Parameter.Value.Split( "," )
			Select Parameter.Name
				Case "new_balls"
					BallsPerTurn = IntValue
				Case "line_balls"
					BallsInLine = IntValue
				Case "no_swap"
					Swap = False
				Case "no_orthogonal_lines"
					OrthogonalLines = False
				Case "no_diagonal_lines"
					DiagonalLines = False
				Case "no_overflow"
					Overflow = False
				Case "put_balls_in_holes"
					TPutBallsInHoles.Create( IntValue )
				Case "get_score"
					TGetScore.Create( IntValue )
				Case "remove_balls"
					TRemoveBalls.Create( Parameters[ 0 ].ToInt(), Parameters[ 1 ].ToInt() )
				Case "remove_combinations"
					TRemoveCombinations.Create( Parameters[ 0 ].ToInt(), Parameters[ 1 ].ToInt(), Parameters[ 2 ].ToInt() )
				Case "remove_ice"
					TRemoveIce.Create( IntValue )
				Case "bomb"
					AddPoolObject( 10, Parameter.Value.ToDouble() )
			End Select
		Next
		
		Local TotalPercent:Double = 0
		For Local PoolObject:TPoolObject = Eachin Pool
			TotalPercent :+ PoolObject.Percent
		Next
		AddPoolObject( 9, 100 - TotalPercent )
		
		For Local Y:Int = 0 Until GameField.YQuantity
			For Local X:Int = 0 Until GameField.XQuantity
				If Balls.GetTile( X, Y ) = RandomBall Then Balls.SetTile( X, Y, Rand( 1, 7 ) )
			Next
		Next

		InitLevel()
			
		NextBalls = New Int[ BallsPerTurn ]
		FillNextBalls()
		CreateBalls()
		Game.Locked = True
	End Method
		
	Method AddPoolObject( Num:Int, Percent:Double )
		Local PoolObject:TPoolObject = New TPoolObject
		PoolObject.Num = Num
		PoolObject.Percent = Percent
		Pool.AddLast( PoolObject )
	End Method
	
	Method InitLevel()
		If Not GameField Then Return
		Game.PathFinder.Map = GameField
		SetFieldMagnification()
		Game.HiddenBalls = New Int[ Balls.XQuantity, Balls.YQuantity ]
		Game.EmptyCells = New TList
		InitGraphics()
	End Method
	
	Method SetFieldMagnification()
		GameCamera.SetMagnification( Min( Floor( L_XResolution / GameField.XQuantity ), ..
				Floor( ( L_YResolution - L_XResolution / 16.0 ) / GameField.YQuantity ) ) )
	End Method
	
	Method InitGraphics()
		InitCamera( GameCamera )
		InitCamera( L_GUICamera )
		If GameField Then
			SetFieldMagnification()
			GameCamera.JumpTo( GameField )
		End If
	End Method
	
	Method CreateBalls()
		Game.EmptyCells.Clear()
		For Local Y:Int = 0 Until GameField.YQuantity
			For Local X:Int = 0 Until GameField.XQuantity
				If GameField.GetTile( X, Y ) = Plate And Balls.GetTile( X, Y ) = NoBall Then Game.EmptyCells.AddLast( TCell.Create( X, Y ) )
				if Modifiers.GetTile( X, Y ) = Lights Then Balls.SetTile( X, Y, Rand( 1, 7 ) )
			Next
		Next
		
		For Local BallNum:Int = Eachin Profile.NextBalls
			If Game.EmptyCells.IsEmpty() Then
				If Overflow Then Menu.LoadGameOverWindow()
				Return
			End If
			Local Cell:TCell = TCell.PopFrom( Game.EmptyCells )
			TPopUpBall.Create( Cell.X, Cell.Y, BallNum )
		Next
		FillNextBalls()
	End Method
	
	Method FillNextBalls()
		For Local N:Int = 0 Until BallsPerTurn
			Local Choice:Double = Rnd( 100 )
			For Local PoolObject:TPoolObject = Eachin Pool
				Choice :- PoolObject.Percent
				If Choice < 0 Then
					If PoolObject.Num = 9 Then 
						NextBalls[ N ] = Rand( 1, 7 )
					Else
						NextBalls[ N ] = PoolObject.Num
					End If
					Exit
				End If
			Next
		Next
	End Method
	
	Method TileToSprite:LTSprite( Model:LTBehaviorModel, X:Int, Y:Int, HideBall:Int = True )
		Local Sprite:TBall = New TBall
		Sprite.SetAsTile( Profile.Balls, X, Y )
		Sprite.Modifier = Profile.Modifiers.GetTile( X, Y )
		Game.Objects.AddLast( Sprite )
		Sprite.AttachModel( Model )
		If HideBall Then Game.HiddenBalls[ X, Y ] = True
		Return Sprite
	End Method
	
	Method Load()
		BossKey = LTButtonAction.Find( Keys, "Boss key" )
		ExitToMenu = LTButtonAction.Find( Keys, "Exit to menu" )
		InitLevel()
	End Method
	
	Method Save()
	End Method
	
	Method SetAsCurrent()
		Profile = Self
	End Method
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		GameField = LTTileMap( XMLObject.ManageObjectField( "field", GameField ) )
		Balls = LTTileMap( XMLObject.ManageObjectField( "balls", Balls ) )
		Modifiers = LTTileMap( XMLObject.ManageObjectField( "modifiers", Modifiers ) )
		XMLObject.ManageIntArrayAttribute( "next-balls", NextBalls )
		XMLObject.ManageListField( "goals", Goals )
		XMLObject.ManageIntAttribute( "score", Score )
		XMLObject.ManageIntAttribute( "balls-in-line", BallsInLine )
		XMLObject.ManageIntAttribute( "balls-per-turn", BallsPerTurn )
		XMLObject.ManageIntAttribute( "swap", Swap, 1 )
		XMLObject.ManageIntAttribute( "overflow", Overflow, 1 )
		XMLObject.ManageIntAttribute( "orthogonal-lines", OrthogonalLines, 1 )
		XMLObject.ManageIntAttribute( "diagonal-lines", DiagonalLines, 1 )
		If Not NextBalls Then FillNextBalls()
	End Method
End Type



Type TCell
	Field X:Int, Y:Int
	
	Function Create:TCell( X:Int, Y:Int )
		Local Cell:TCell = New TCell
		Cell.X = X
		Cell.Y = Y
		Return Cell
	End Function
	
	Function PopFrom:TCell( List:TList )
		Local Cell:TCell = TCell( List.ValueAtIndex( Rand( 0, List.Count() - 1 ) ) )
		List.Remove( Cell )
		Return Cell
	End Function
End Type



Type TPoolObject
	Field Num:Int
	Field Percent:Double
End Type