'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_CurrentCamera:LTCamera
Global L_CameraSpeed:Double = 2.0
Global L_CameraMagnificationSpeed:Double = 2.0

Type LTCamera Extends LTSprite
	Field Viewport:LTShape = New LTShape
	Field XK:Double = 1.0, YK:Double = 1.0
	Field DX:Double, DY:Double
	Field ViewportClipping:Int = 1
	
	
	
	Method ScreenToField( ScreenX:Double, ScreenY:Double, FieldX:Double Var, FieldY:Double Var )
		FieldX = ScreenX / XK - DX
		FieldY = ScreenY / YK - DY
	End Method

	
	
	Method SizeScreenToField( ScreenWidth:Double, ScreenHeight:Double, FieldWidth:Double Var, FieldHeight:Double Var )
		FieldWidth = ScreenWidth / XK
		FieldHeight = ScreenHeight / YK
	End Method

	
	
	Method DistScreenToField:Double( ScreenDist:Double )
		Return ScreenDist / XK
	End Method
	
	
	
	Method FieldToScreen( FieldX:Double, FieldY:Double, ScreenX:Double Var, ScreenY:Double Var )
		ScreenX = ( FieldX + DX ) * XK
		ScreenY = ( FieldY + DY ) * YK
	End Method

	
	
	Method SizeFieldToScreen( FieldWidth:Double, FieldHeight:Double, ScreenWidth:Double Var, ScreenHeight:Double Var )
		ScreenWidth = FieldWidth * XK
		ScreenHeight = FieldHeight * YK
	End Method

	
	
	Method DistFieldToScreen:Double( ScreenDist:Double )
		Return ScreenDist * XK
	End Method
	
	
	
	Method SetCameraViewport()
		If Not ViewportClipping Then Return
	
		SetViewport( X - 0.5 * Width, Y - 0.5 * Height, Width, Height )
	End Method
	
	
	
	Method ResetViewport()
		SetViewport( 0, 0, GraphicsWidth(), GraphicsHeight() )
	End Method
	
	
	
	Method SetMagnification( NewXK:Double, NewYK:Double )
		XK = NewXK
		YK = NewYK
		Width = Viewport.Width / XK
		Height = Viewport.Height / YK
	End Method
	
	
	
	Method ShiftCameraToPoint( NewX:Double, NewY:Double )
		X :+ L_CameraSpeed * L_DeltaTime * ( NewX - X )
		Y :+ L_CameraSpeed * L_DeltaTime * ( NewY - Y )
		Update()
	End Method
	
	
	
	Method AlterCameraMagnification( NewXK:Double, NewYK:Double )
		SetMagnification( XK + L_CameraMagnificationSpeed * L_DeltaTime * ( NewXK - XK ), ..
		 YK + L_CameraMagnificationSpeed * L_DeltaTime * ( NewYK - YK ) )
	End Method
	
	
	
	Method Update()
		XK = Viewport.Width / Width
		YK = Viewport.Height / Height
		DX = Viewport.X / XK - X
		DY = Viewport.Y/ YK - Y
	End Method
	
	
	
	Function Create:LTCamera( Width:Double, Height:Double, UnitSize:Double )
		Local Camera:LTCamera = New LTCamera
		Camera.Width = Width / UnitSize
		Camera.Height = Height / UnitSize
		Camera.Viewport.Width = Width
		Camera.Viewport.Height = Height
		Camera.Viewport.X = 0.5 * Width
		Camera.Viewport.Y = 0.5 * Height
		Camera.Update()
		
		Return Camera
	End Function
End Type



Function InitGraphics( Width:Int = 800, Height:Int = 600, UnitSize:Double = 32.0 )
	Graphics( Width, Height )
	L_CurrentCamera = LTCamera.Create( Width, Height, UnitSize )
	SetGraphicsParameters()
End Function



Function SetGraphicsParameters()
	AutoImageFlags( FILTEREDIMAGE | DYNAMICIMAGE )
	SetBlend( AlphaBlend )
End Function