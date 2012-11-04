'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TCheckLines
	Function Execute( BallNum:Int, NewTurn:Int = True )
		Game.TotalBalls = 0
		
		Local Rows:TList = New TList
		For Local Y:Int = 0 Until Profile.GameField.YQuantity
			For Local X:Int = 0 Until Profile.GameField.XQuantity
				Local CurrentBall:Int = Profile.Balls.GetTile( X, Y )
				If CurrentBall = Profile.NoBall Or CurrentBall > 7 Then Continue
				If Profile.OrthogonalLines Then
					CheckRow( CurrentBall, Rows, X, Y, 1, 0 )
					CheckRow( CurrentBall, Rows, X, Y, 0, 1 )
				End If
				If Profile.DiagonalLines Then
					CheckRow( CurrentBall, Rows, X, Y, 1, 1 )
					CheckRow( CurrentBall, Rows, X, Y, -1, 1 )
				End If
			Next
		Next
		
		For Local Row:TRow = Eachin Rows
			Row.Remove()
		Next
		
		If Rows.IsEmpty() Then
			If NewTurn Then Profile.NewTurn()
		Else
			L_CurrentProfile.PlaySnd( Game.ExplosionSound )
			Profile.Score :+ Profile.BallsInLine + Progression( 1, 1 + Game.TotalBalls - Profile.BallsInLine ) - 1
			
			For Local Goal:TGetScore = Eachin Profile.Goals
				If Goal.Count <= Profile.Score Then Goal.Count = 0
			Next
			For Local Goal:TRemoveCombinations = Eachin Profile.Goals
				If ( Goal.BallType = BallNum Or Goal.BallType = Profile.RandomBall ) And Game.TotalBalls >= Goal.LineBallsQuantity Then
					Goal.Count :- 1
				End If
			Next
		End If
	End Function
	
	Function Progression:Int( FromValue:Int, ToValue:Int )
		Return ( FromValue + ToValue ) * ( ToValue - FromValue + 1 ) * 0.5
	End Function
	
	Function CheckRow( BallNum:Int, Rows:TList, X:Int, Y:Int, DX:Int, DY:Int )
		Local K:Int = 0
		If X > 0 And Y > 0 And X < Profile.GameField.XQuantity - 1 And Y < Profile.GameField.YQuantity - 1 Then
			If Profile.Balls.GetTile( X - DX, Y - DY ) = BallNum Then Return
		End If
		While Profile.Balls.GetTile( X + DX * K, Y + DY * K ) = BallNum
			K :+ 1
			If X + DX * K >= Profile.GameField.XQuantity Or Y + DY * K >= Profile.GameField.YQuantity Or X + DX * K < 0 Then Exit
		Wend
		If K >= Profile.BallsInLine Then
			Rows.AddLast( TRow.Create( X, Y, DX, DY, K - 1 ) )
		End If
	End Function
End Type

Type TRow
	Field X:Int, Y:Int, DX:Int, DY:Int, K:Int
	
	Function Create:TRow( X:Int, Y:Int, DX:Int, DY:Int, K:Int )
		Local Row:TRow = New TRow
		Row.X = X
		Row.Y = Y
		Row.DX = DX
		Row.DY = DY
		Row.K = K
		Return Row
	End Function
	
	Method Remove()
		For Local KK:Int = 0 To K
			Local XX:Int = X + DX * KK
			Local YY:Int = Y + DY * KK
			TExplosion.ManageParticles( XX, YY )
		Next
	End Method
End Type