'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Framework brl.basic

Import dwlab.frmwork

Local Test:TTest = New TTest
Test.Execute()

'PushingStressTest()

Type TTest Extends LTProject
	Field Sprite1:LTSprite = New LTSprite
	Field Sprite2:LTSprite = New LTSprite
	Field CircleSprite1:LTSprite = New LTSprite
	Field CircleSprite2:LTSprite = New LTSprite
	
	
	
	Method Init()
		L_InitGraphics()
		
		Sprite1.ShapeType = LTSprite.rectangle
		Sprite1.SetSize( 3.0, 6.0 )
		Sprite1.Visualizer = New LTVisualizer
		Sprite1.Visualizer.SetColorFromRGB( 1.0, 0.0, 0.0 )
		
		Sprite2.ShapeType = LTSprite.Oval
		Sprite2.SetSize( 6.0, 3.0 )
		Sprite2.Visualizer = New LTVisualizer
		Sprite2.Visualizer.Alpha = 0.5
		
		CircleSprite1.ShapeType = LTSprite.Oval
		CircleSprite1.Visualizer = New LTEmptyPrimitive
		
		CircleSprite2.ShapeType = LTSprite.Oval
		CircleSprite2.Visualizer = New LTEmptyPrimitive
	End Method
	
	
	
	Method Logic()
		Sprite2.SetMouseCoords()
		If Sprite1.CollidesWithSprite( Sprite2 ) Then
			Sprite2.Visualizer.SetColorFromRGB( 1.0, 1.0, 0.0 )
		Else
			Sprite2.Visualizer.SetColorFromRGB( 0.0, 1.0, 0.0 )
		End If
		CircleSprite1.JumpTo( Sprite1 )
		CircleSprite2.JumpTo( Sprite2 )
		CircleSprite1.SetDiameter( L_GetOvalDiameter( CircleSprite1.X, CircleSprite1.Y, Sprite1.Width, Sprite1.Height, Sprite2.X, Sprite2.Y ) )
		CircleSprite2.SetDiameter( L_GetOvalDiameter( CircleSprite2.X, CircleSprite2.Y, Sprite2.Width, Sprite2.Height, CircleSprite1.X, CircleSprite1.Y ) )
		If KeyHit( KEY_ESCAPE ) Then End
	End Method
	
	
	
	Method Render()
		Sprite1.Draw()
		Sprite2.Draw()
		CircleSprite1.Draw()
		CircleSprite2.Draw()
	End Method
End Type



Function PushingStressTest()
	SeedRnd 0
	
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