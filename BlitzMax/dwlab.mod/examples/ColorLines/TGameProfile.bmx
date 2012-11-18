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
	Const ColdPlate:Int = 12
	
	Const ClosedPocket:Int = 22
	Const OpenedPocket:Int = 23
	Const PocketForeground:Int = 24
	Const TileCursor:Int = 11
	
	Const NoBall:Int = 0
	Const BlackBall:Int = 8
	Const RandomBall:Int = 9
	Const Bomb:Int = 10
	Const Stone:Int = 13
	
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
	Field TotalBalls:Int
	Field OnlySameColor:Int
	Field ShowNextBalls:Int
	Field TotalBallPacks:Int
	Field PackNum:Int
	
	Field TotalLevelTime:Double
	Field TotalTurns:Int
	Field Turns:Int
	Field TotalTurnTime:Double
	Field TurnTime:Double
	Field LevelScores:TMap = New TMap
	
	Field ExplodedBallPoints:Int = 1
	Field ExplodedStonePoints:Int = 5
	Field ExplodedIcePoints:Int = 3
	Field ClearedGluePoints:Int = 1
	Field BallInPocketPoints:Int = 10
	
	Field SkipTurn:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Space ), "Skip turn" )
	Field BossKey:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Z ), "Boss key" )
	Field ExitToMenu:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Escape ), "Exit to menu" )
	
	Method Reset()
		Score = 0
		Game.Selected = Null
		Game.Objects.Clear()
	End Method

	Method LoadLevel( Level:LTLayer )
		Local Layer:LTLayer = Null
		Game.Objects.Clear()
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
		TotalLevelTime = 0
		TotalTurns = 0
		TotalTurnTime = 0
		TotalBalls = 7
		OnlySameColor = False
		ShowNextBalls = True
		TotalBallPacks = -1
		PackNum = 0
		
		Goals.Clear()
		Pool.Clear()
		For Local Parameter:LTParameter = Eachin Level.Parameters
			Local IntValue:Int = Parameter.Value.ToInt()
			Local DoubleValue:Int = Parameter.Value.ToDouble()
			Local Parameters:String[] = Parameter.Value.Split( "," )
			Select Parameter.Name
				Case "new-balls"
					BallsPerTurn = IntValue
				Case "line-balls"
					BallsInLine = IntValue
				Case "no-swap"
					Swap = False
				Case "no-orthogonal-lines"
					OrthogonalLines = False
				Case "no-diagonal-lines"
					DiagonalLines = False
				Case "no-overflow"
					Overflow = False
				Case "put-balls-in-holes"
					TPutBallsInHoles.Create( IntValue )
				Case "get-score"
					TGetScore.Create( IntValue )
				Case "remove-balls"
					TRemoveBalls.Create( Parameters[ 0 ].ToInt(), Parameters[ 1 ].ToInt() )
				Case "remove-stones"
					TRemoveBalls.Create( Stone, IntValue )
				Case "remove-combinations"
					TRemoveCombinations.Create( Parameters[ 0 ].ToInt(), Parameters[ 1 ].ToInt(), Parameters[ 2 ].ToInt() )
				Case "remove-ice"
					TRemoveIce.Create( IntValue )
				Case "ball-percent"
					AddPoolObject( Parameters[ 0 ].ToInt(), Parameters[ 1 ].ToInt() )
				Case "bomb"
					AddPoolObject( 10, DoubleValue )
				Case "black-ball"
					AddPoolObject( 8, DoubleValue )
				Case "level-time"
					TotalLevelTime = ToTime( Parameter.Value )
				Case "turns"
					TotalTurns = IntValue
				Case "turn-time"
					TotalTurnTime = ToTime( Parameter.Value )
				Case "total-balls"
					TotalBalls = IntValue
				Case "only-same-color"
					OnlySameColor = True
				Case "remove-lights"
					TRemoveLights.Create( IntValue )
				Case "hide-next-balls"
					ShowNextBalls = False
				Case "total-ball-packs"
					TotalBallPacks = IntValue
			End Select
		Next
		Local TotalPercent:Double = 0
		For Local PoolObject:TPoolObject = Eachin Pool
			TotalPercent :+ PoolObject.Percent
		Next
		AddPoolObject( 9, 100 - TotalPercent )
		
		For Local Y:Int = 0 Until Balls.YQuantity
			For Local X:Int = 0 Until Balls.XQuantity
				If Balls.GetTile( X, Y ) = RandomBall Then Balls.SetTile( X, Y, Rand( 1, 7 ) )
			Next
		Next

		InitLevel()
		
		LevelTime = 0
		Turns = 0
		Score = 0
			
		NextBalls = New Int[ BallsPerTurn ]
		FillNextBalls()
		NewTurn()
		Game.Locked = True
		Game.Selected = Null
		Profile.LevelName = Level.GetName()
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
	
	Global ExistentBalls:Int[] = New Int[ 8 ]
	
	Method NewTurn()
		Profile.TurnTime = 0.0
		Profile.Turns :+ 1
		
		PackNum :+ 1
		If PackNum > TotalBallPacks And TotalBallPacks >= 0 Then Return
		
		ExistentBalls = New Int[ 8 ]
		Game.EmptyCells.Clear()
		For Local Y:Int = 0 Until GameField.YQuantity
			For Local X:Int = 0 Until GameField.XQuantity
				Local BallNum:Int = Balls.GetTile( X, Y )
				If GameField.GetTile( X, Y ) = Plate And BallNum = NoBall Then Game.EmptyCells.AddLast( TCell.Create( X, Y ) )
				If BallNum <= 7 Then ExistentBalls[ BallNum ] = 1
			Next
		Next
		
		If OnlySameColor Then FillNextBalls()
		
		For Local BallNum:Int = Eachin Profile.NextBalls
			If Game.EmptyCells.IsEmpty() Then
				If Overflow Then Game.LoadWindow( Menu.Interface, "LTLevelFailedWindow" )
				Return
			End If
			Local Cell:TCell = TCell.PopFrom( Game.EmptyCells )
			TPopUpBall.Create( Cell.X, Cell.Y, BallNum )
		Next
		FillNextBalls()
		
		Menu.SaveToFile( "settings.xml" )
	End Method
	
	Method FillNextBalls()
		Local BallStack:TList = New TList
		For Local N:Int = 1 To 7
			If ExistentBalls[ N ] Then BallStack.AddLast( String( N ) )
		Next
		
		For Local Y:Int = 0 Until GameField.YQuantity
			For Local X:Int = 0 Until GameField.XQuantity
				if Modifiers.GetTile( X, Y ) = Lights Then
					If OnlySameColor And BallStack.Count() Then
						Balls.SetTile( X, Y, RandValue( BallStack ) )
					Else
						Balls.SetTile( X, Y, Rand( 1, TotalBalls ) )
					End If
				End If
			Next
		Next
			
		For Local N:Int = 0 Until BallsPerTurn
			Local Choice:Double = Rnd( 100 )
			For Local PoolObject:TPoolObject = Eachin Pool
				Choice :- PoolObject.Percent
				If Choice < 0 Then
					If PoolObject.Num = RandomBall Then 
						If OnlySameColor And BallStack.Count() Then
							NextBalls[ N ] = RandValue( BallStack )
						Else
							NextBalls[ N ] = Rand( 1, TotalBalls )
						End If
					Else
						NextBalls[ N ] = PoolObject.Num
					End If
					Exit
				End If
			Next
		Next
	End Method
	
	Function RandValue:Int( BallStack:TList )
		Return String( BallStack.ValueAtIndex( Rand( 0, BallStack.Count() - 1 ) ) ).ToInt()
	End Function
	
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
		InitLevel()
	End Method
	
	Method Save()
	End Method
	
	Method SetAsCurrent()
		Profile = Self
	End Method
	
	Function ToTime:Double( Time:String )
		Local TimeChunks:String[] = Time.Split( ":" )
		If TimeChunks.Length = 1 Then Return 60.0 * Time.ToInt() Else Return 60.0 * TimeChunks[ 0 ].ToInt() + 1.0 * TimeChunks[ 1 ].ToInt()
	End Function
	
	Method AddHighScore( LevelIsCompleted:Int )
		If LevelIsCompleted Then
			TStats.AddStats( True )
			LTHighScoresList.HighScoresList = Menu.AddHighScore( LevelName, Score )
			Local OldScore:Int = 0
			If LevelScores.Contains( LevelName ) Then OldScore = String( LevelScores.ValueForKey( LevelName ) ).ToInt()
			If OldScore < Profile.Score Then LevelScores.Insert( LevelName, String( Score ) )
		Else
			TStats.AddStats( False )
		End If
	End Method
	
	Method AddKeys( Items:TList )
		Items.AddLast( Profile.SkipTurn )
		Items.AddLast( Profile.ExitToMenu )
		Items.AddLast( Profile.BossKey )
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
		XMLObject.ManageIntAttribute( "total-balls", TotalBalls )
		XMLObject.ManageIntAttribute( "only-same-color", OnlySameColor )
		XMLObject.ManageIntAttribute( "show-next-balls", ShowNextBalls )
		XMLObject.ManageIntAttribute( "orthogonal-lines", OrthogonalLines, 1 )
		XMLObject.ManageIntAttribute( "diagonal-lines", DiagonalLines, 1 )
		XMLObject.ManageIntAttribute( "total-ball-packs", TotalBallPacks, -1 )
		XMLObject.ManageDoubleAttribute( "total-time", TotalLevelTime )
		XMLObject.ManageDoubleAttribute( "time", LevelTime )
		XMLObject.ManageIntAttribute( "total-turns", TotalTurns )
		XMLObject.ManageIntAttribute( "turns", Turns )
		XMLObject.ManageDoubleAttribute( "total-turn-time", TotalTurnTime )
		XMLObject.ManageDoubleAttribute( "turn-time", TurnTime )
		XMLObject.ManageStringMapField( "scores", LevelScores )
		XMLObject.ManageListField( "pool", Pool )
		SkipTurn = LTButtonAction( XMLObject.ManageObjectField( "skip-turn", SkipTurn ) )
		ExitToMenu = LTButtonAction( XMLObject.ManageObjectField( "exit-to-menu", ExitToMenu ) )
		BossKey = LTButtonAction( XMLObject.ManageObjectField( "boss-key", BossKey ) )
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



Type TPoolObject Extends LTObject
	Field Num:Int
	Field Percent:Double
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageIntAttribute( "num", Num )
		XMLObject.ManageDoubleAttribute( "percent", Percent )
	End Method
End Type