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
	Function Execute( CreateBalls:Int = True )
		Game.TotalBalls = 0
		
		Local Rows:TList = New TList
		For Local Y:Int = 0 Until Profile.GameField.YQuantity
			For Local X:Int = 0 Until Profile.GameField.XQuantity
				Local CurrentBall:Int = Profile.Balls.GetTile( X, Y )
				If CurrentBall = Profile.NoBall Or CurrentBall > 7 Then Continue
				CheckRow( CurrentBall, Rows, X, Y, 1, 0 )
				CheckRow( CurrentBall, Rows, X, Y, 0, 1 )
				CheckRow( CurrentBall, Rows, X, Y, 1, 1 )
				CheckRow( CurrentBall, Rows, X, Y, -1, 1 )
			Next
		Next
		
		For Local Row:TRow = Eachin Rows
			Row.Remove()
		Next
		
		If Rows.IsEmpty() Then
			If CreateBalls Then Profile.CreateBalls()
		Else
			L_PlaySound( Game.ExplosionSound )
			Profile.Score :+ ( Game.TotalBalls - 7 ) * Game.TotalBalls / 2 + 10
		End If
	End Function
	
	Function CheckRow( BallNum:Int, Rows:TList, X:Int, Y:Int, DX:Int, DY:Int )
		Local K:Int = 0
		While Profile.Balls.GetTile( X + DX * K, Y + DY * K ) = BallNum
			K :+ 1
			If X + DX * K >= Profile.GameField.XQuantity Or Y + DY * K >= Profile.GameField.YQuantity Or X + DX * K < 0 Then Exit
		Wend
		K :- 1
		If K >= 4 Then Rows.AddLast( TRow.Create( X, Y, DX, DY, K ) )
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
			TExplosion.Create( XX, YY )
		Next
	End Method
End Type