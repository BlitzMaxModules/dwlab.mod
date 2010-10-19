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

Global L_ScreenXSize:Int
Global L_ScreenYSize:Int

Type LTCamera Extends LTActor
	Field Viewport:LTActor = New LTActor
	Field XK:Float = 1.0, YK:Float = 1.0
	Field DX:Float, DY:Float
	Field ViewportClipping:Int = 1
	
	
	
	Method ScreenToField( ScreenX:Float, ScreenY:Float, FieldX:Float Var, FieldY:Float Var )
		FieldX = ScreenX / XK - DX
		FieldY = ScreenY / YK - DY
	End Method

	
	
	Method SizeScreenToField( ScreenXSize:Float, ScreenYSize:Float, FieldXSize:Float Var, FieldYSize:Float Var )
		FieldXSize = ScreenXSize / XK
		FieldYSize = ScreenYSize / YK
	End Method

	
	
	Method DistScreenToField:Float( ScreenDist:Float )
		Return ScreenDist / XK
	End Method
	
	
	
	Method FieldToScreen( FieldX:Float, FieldY:Float, ScreenX:Float Var, ScreenY:Float Var )
		ScreenX = ( FieldX + DX ) * XK
		ScreenY = ( FieldY + DY ) * YK
	End Method

	
	
	Method SizeFieldToScreen( FieldXSize:Float, FieldYSize:Float, ScreenXSize:Float Var, ScreenYSize:Float Var )
		ScreenXSize = FieldXSize * XK
		ScreenYSize = FieldYSize * YK
	End Method

	
	
	Method DistFieldToScreen:Float( ScreenDist:Float )
		Return ScreenDist * XK
	End Method
	
	
	
	Method SetCameraViewport()
		If Not ViewportClipping Then Return
	
		SetViewport( X - 0.5 * XSize, Y - 0.5 * YSize, XSize, YSize )
	End Method
	
	
	
	Method ResetViewport()
		SetViewport( 0, 0, L_ScreenXSize, L_ScreenYSize )
	End Method
	
	
	
	Method SetMagnification( NewXK:Float, NewYK:Float )
		XK = NewXK
		YK = NewYK
		Xsize = Viewport.XSize / XK
		Ysize = Viewport.YSize / YK
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
		Local X1:Float = Min( Rectangle.X, Rectangle.CornerX() + 0.5 * XSize )
		Local Y1:Float = Min( Rectangle.Y, Rectangle.CornerY() + 0.5 * YSize )
		Local X2:Float = Max( Rectangle.X, Rectangle.X + 0.5 * ( Rectangle.XSize - XSize ) )
		Local Y2:Float = Max( Rectangle.Y, Rectangle.Y + 0.5 * ( Rectangle.YSize - YSize ) )
		X = L_LimitFloat( X, X1, X2 )
		Y = L_LimitFloat( Y, Y1, Y2 )
		Update()
	End Method
	
	
	
	Method Update()
		XK = Viewport.XSize / XSize
		YK = Viewport.YSize / YSize
		DX = Viewport.X / XK - X
		DY = Viewport.Y/ YK - Y
	End Method
End Type





Function InitCamera()
	L_ScreenXSize = GraphicsWidth()
	L_ScreenYSize = GraphicsHeight()
	
	L_CurrentCamera = New LTCamera
	L_CurrentCamera.XSize = 32.0
	L_CurrentCamera.YSize = 32.0 * L_ScreenYSize / L_ScreenXSize
	L_CurrentCamera.Viewport.XSize = L_ScreenXSize
	L_CurrentCamera.Viewport.YSize = L_ScreenYSize
	L_CurrentCamera.Viewport.X = 0.5 * L_ScreenXSize
	L_CurrentCamera.Viewport.Y = 0.5 * L_ScreenYSize
	L_CurrentCamera.Update()
	
	AutoImageFlags( FILTEREDIMAGE | DYNAMICIMAGE )
	SetBlend( AlphaBlend )
End Function