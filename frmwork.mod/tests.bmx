'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Import dwlab.frmwork

SeedRnd 0
PushingStressTest()

Function PushingStressTest()
	Local Sprite1:LTSprite = New LTSprite
	Local Sprite2:LTSprite = New LTSprite
	Sprite1.ShapeType = L_Rectangle
	Sprite2.ShapeType = L_Rectangle
	
	Local Count:Int = 0
	
	Local Time:Int = MilliSecs()
	
	Repeat
		Sprite1.SetCoords( Rnd( -1.0, 1.0 ), Rnd( -1.0, 1.0 ) )
		Sprite2.SetCoords( 0.0, 0.0 )
		If Sprite1.CollidesWithSprite( Sprite2 ) Then Sprite1.PushFromSprite( Sprite2 )
		Count :+ 1
		If Count Mod 10000000 = 0 Then Exit
	Until KeyHit( Key_Escape )
	
	Print MilliSecs() - Time
End Function





Function TestCircle()
	Local DoubleMap:LTDoubleMap = New LTDoubleMap
	DoubleMap.SetResolution( 64, 64 )
	DoubleMap.DrawCircle( 32, 32, 31.5, 1.0 )
	For Local Y:Int = 0 Until 64
		For Local X:Int = 0 Until 64
			Local Col:Float = Int( 0.5 + 255.0 * DoubleMap.Value[ X, Y ] )
			SetColor( Col, Col, Col )
			DrawRect( X * 8, Y * 8, 8, 8 )
		Next
	Next
	Flip
End Function





Function TestMaskSpeed()
	Local Map:LTDoubleMap = New LTDoubleMap
	Map.SetResolution( 64, 64 )
	Local Time:Int = MilliSecs()
	For Local N:Int = 0 To 1000
		'Local X:Int = L_WrapInt( 1, Map.XQuantity )
		'Local X:Int = 1 & Map.XMask
		Rem
			For Local Y:Int = 0 Until Map.YQuantity
				For Local X:Int = 0 Until Map.XQuantity
					Map.Value[ X & Map.XMask, Y & Map.YMask ] = 1.0
				Next
			Next
		EndRem
		'Rem
		For Local Y:Int = 0 Until Map.YQuantity
			For Local X:Int = 0 Until Map.XQuantity
				Map.Value[ L_WrapInt( X, Map.XQuantity ), L_WrapInt( Y, Map.YQuantity ) ] = 1.0
			Next
		Next
		'EndRem
	Next
	DebugLog MilliSecs() - Time
	End
End Function





Function TestMaskSpeed2()
	Local Map:LTDoubleMap = New LTDoubleMap
	Map.SetResolution( 65, 65 )
	Local Time:Int = MilliSecs()
	
	For Local N:Int = 0 To 1000
		Map.DrawCircle( 32, 32, 31.5, 1.0 )
	Next

	DebugLog MilliSecs() - Time
	End
End Function