'
' "Please wait" - Digital Wizard's Lab template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global LastLoadingFrameTime:Double
Const LoadingFramePeriod:Int = 15
Const LoadingTurningSpeed:Double = 360.0
Const LoadingRadius:Double = 200.0
Const LoadingCirclesQuantity:Int = 15
Const LoadingCirclesSector:Double = 135.0
Const LoadingCircleDiameter:Double = 50.0

Function PleaseWait()
	If Millisecs() > LastLoadingFrameTime + LoadingFramePeriod Then
		Cls
		LastLoadingFrameTime = Millisecs()
		Local StartingAngle:Double = Millisecs() * 0.001 * LoadingTurningSpeed
		For Local K:Double = 0.0 To 1.0 Step 1.0 / LoadingCirclesQuantity
			SetColor 255.0 * K, 255.0 * K, 255.0 * K
			Local Angle:Double = StartingAngle - LoadingCirclesSector * ( 1.0 - K )
			Local X:Int = 0.5 * GraphicsWidth() + Cos( Angle ) * LoadingRadius - 0.5 * LoadingCircleDiameter
			Local Y:Int = 0.5 * GraphicsHeight() + Sin( Angle ) * LoadingRadius - 0.5 * LoadingCircleDiameter
			DrawOval( X, Y, LoadingCircleDiameter, LoadingCircleDiameter )
		Next
		DrawText( "Please wait...", 0.5 * GraphicsWidth() - 4 * 14, 0.5 * GraphicsHeight() - 4 )
		SetColor 255, 255, 255
		Flip False		
	End If
End Function