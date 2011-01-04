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
Global L_CameraSpeed:Float = 2.0
Global L_CameraMagnificationSpeed:Float = 2.0

Type LTCamera Extends LTActor
	Field Viewport:LTActor = New LTActor
	Field XK:Float = 1.0, YK:Float = 1.0
	Field DX:Float, DY:Float
	Field ViewportClipping:Int = 1
	
	
	
	Method ScreenToField( ScreenX:Float, ScreenY:Float, FieldX:Float Var, FieldY:Float Var )
		FieldX = ScreenX / XK - DX
		FieldY = ScreenY / YK - DY
	End Method

	
	
	Method SizeScreenToField( ScreenWidth:Float, ScreenHeight:Float, FieldWidth:Float Var, FieldHeight:Float Var )
		FieldWidth = ScreenWidth / XK
		FieldHeight = ScreenHeight / YK
	End Method

	
	
	Method DistScreenToField:Float( ScreenDist:Float )
		Return ScreenDist / XK
	End Method
	
	
	
	Method FieldToScreen( FieldX:Float, FieldY:Float, ScreenX:Float Var, ScreenY:Float Var )
		ScreenX = ( FieldX + DX ) * XK
		ScreenY = ( FieldY + DY ) * YK
	End Method

	
	
	Method SizeFieldToScreen( FieldWidth:Float, FieldHeight:Float, ScreenWidth:Float Var, ScreenHeight:Float Var )
		ScreenWidth = FieldWidth * XK
		ScreenHeight = FieldHeight * YK
	End Method

	
	
	Method DistFieldToScreen:Float( ScreenDist:Float )
		Return ScreenDist * XK
	End Method
	
	
	
	Method SetCameraViewport()
		If Not ViewportClipping Then Return
	
		SetViewport( X - 0.5 * Width, Y - 0.5 * Height, Width, Height )
	End Method
	
	
	
	Method ResetViewport()
		SetViewport( 0, 0, GraphicsWidth(), GraphicsHeight() )
	End Method
	
	
	
	Method SetMagnification( NewXK:Float, NewYK:Float )
		XK = NewXK
		YK = NewYK
		Width = Viewport.Width / XK
		Height = Viewport.Height / YK
	End Method
	
	
	
	Method ShiftCameraToPoint( NewX:Float, NewY:Float )
		X :+ L_CameraSpeed * L_DeltaTime * ( NewX - X )
		Y :+ L_CameraSpeed * L_DeltaTime * ( NewY - Y )
		Update()
	End Method
	
	
	
	Method AlterCameraMagnification( NewXK:Float, NewYK:Float )
		SetMagnification( XK + L_CameraMagnificationSpeed * L_DeltaTime * ( NewXK - XK ), ..
		 YK + L_CameraMagnificationSpeed * L_DeltaTime * ( NewYK - YK ) )
	End Method
	
	
	
	Method LimitWith( Rectangle:LTActor )
		Local X1:Float = Min( Rectangle.X, Rectangle.CornerX() + 0.5 * Width )
		Local Y1:Float = Min( Rectangle.Y, Rectangle.CornerY() + 0.5 * Height )
		Local X2:Float = Max( Rectangle.X, Rectangle.X + 0.5 * ( Rectangle.Width - Width ) )
		Local Y2:Float = Max( Rectangle.Y, Rectangle.Y + 0.5 * ( Rectangle.Height - Height ) )
		X = L_LimitFloat( X, X1, X2 )
		Y = L_LimitFloat( Y, Y1, Y2 )
		Update()
	End Method
	
	
	
	Method Update()
		XK = Viewport.Width / Width
		YK = Viewport.Height / Height
		DX = Viewport.X / XK - X
		DY = Viewport.Y/ YK - Y
	End Method
	
	
	
	Function Create:LTCamera( Width:Float, Height:Float, WidthInUnits:Float = 8 )
		Local Camera:LTCamera = New LTCamera
		Camera.Width = 32.0
		Camera.Height = 32.0 * Height / Width
		Camera.Viewport.Width = Width
		Camera.Viewport.Height = Height
		Camera.Viewport.X = 0.5 * Width
		Camera.Viewport.Y = 0.5 * Height
		Camera.Update()
		
		Return Camera
	End Function
End Type



Function InitGraphics( Width:Int = 800, Height:Int = 600 )
	Graphics( Width, Height )
	L_CurrentCamera = LTCamera.Create( Width, Height, 32.0 )
	SetGraphicsParameters()
End Function



Function SetGraphicsParameters()
	AutoImageFlags( FILTEREDIMAGE | DYNAMICIMAGE )
	SetBlend( AlphaBlend )
End Function