'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Function PushingStressTest()
	Local Sprite1:LTSprite = New LTSprite
	Local Sprite2:LTSprite = New LTSprite
	Sprite1.Shape = L_Rectangle
	Sprite2.Shape = L_Rectangle
	
	Local Count:Int = 0
	
	Repeat
		Sprite1.SetCoords( Rnd( -1.0, 1.0 ), Rnd( -1.0, 1.0 ) )
		Sprite2.SetCoords( 0.0, 0.0 )
		If Sprite1.CollidesWith( Sprite2 ) Then Sprite1.Push( Sprite2, 1.0, 1.0 )
		Count :+ 1
		If Count Mod 10000 = 0 Then DebugLog Count
	Until KeyHit( Key_Escape )
	End
End Function





Function TestCircle()
	Local FloatMap:LTFloatMap = New LTFloatMap
	FloatMap.SetResolution( 64, 64 )
	FloatMap.DrawCircle( 32, 32, 31.5, 1.0 )
	For Local Y:Int = 0 Until 64
		For Local X:Int = 0 Until 64
			Local Col:Float = Int( 0.5 + 255.0 * FloatMap.Value[ X, Y ] )
			SetColor( Col, Col, Col )
			DrawRect( X * 8, Y * 8, 8, 8 )
		Next
	Next
	Flip
End Function





Function TestMaskSpeed()
	Local Map:LTFloatMap = New LTFloatMap
	Map.SetResolution( 64, 64 )
	Local Time:Int = Millisecs()
	For Local N:Int = 0 To 1000
		'Local X:Int = L_WrapInt( 1, Map.XQuantity )
		'Local X:Int = 1 & Map.XMask
		If 0 Then
			For Local Y:Int = 0 Until Map.YQuantity
				For Local X:Int = 0 Until Map.XQuantity
					Map.Value[ X & Map.XMask, Y & Map.YMask ] = 1.0
				Next
			Next
		Else
			For Local Y:Int = 0 Until Map.YQuantity
				For Local X:Int = 0 Until Map.XQuantity
					Map.Value[ L_WrapInt( X, Map.XQuantity ), L_WrapInt( Y, Map.YQuantity ) ] = 1.0
				Next
			Next
		End If
	Next
	DebugLog Millisecs() - Time
	End
End Function





Function TestMaskSpeed2()
	Local Map:LTFloatMap = New LTFloatMap
	Map.SetResolution( 65, 65 )
	Local Time:Int = Millisecs()
	
	For Local N:Int = 0 To 1000
		Map.DrawCircle( 32, 32, 31.5, 1.0 )
	Next

	DebugLog Millisecs() - Time
	End
End Function