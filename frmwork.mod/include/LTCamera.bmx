'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: Global variable for current camera.
End Rem
Global L_CurrentCamera:LTCamera
Global L_CameraSpeed:Double = 2.0
Global L_CameraMagnificationSpeed:Double = 2.0

Rem
bbdoc: Camera for displaying game objects.
about: Camera sprite defines rectangular area on game field which will be projected to the defined viewport rectangle.
End Rem
Type LTCamera Extends LTSprite
	Rem
	bbdoc: Viewport rectangular shape.
	about: See also: #ViewportClipping, #SetCameraViewport, #ResetViewport
	End Rem
	Field Viewport:LTShape = New LTShape
	
	Field XK:Double = 1.0, YK:Double = 1.0
	Field DX:Double, DY:Double
	
	Rem
	bbdoc: Viewport clipping flag
	about: Defines will the objects parts outside viewport be clipped. Defaults to True.
	
	See also: #Viewport, #SetCameraViewport, #ResetViewport
	End Rem
	Field ViewportClipping:Int = True
	
	
	
	Rem
	bbdoc: Transforms screen coordinates to game field coordinates.
	about: See also: #SizeScreenToField, #DistScreenToField, #FieldToScreen, #SizeFieldToScreen, #DistFieldToScreen
	End Rem
	Method ScreenToField( ScreenX:Double, ScreenY:Double, FieldX:Double Var, FieldY:Double Var )
		FieldX = ScreenX / XK - DX
		FieldY = ScreenY / YK - DY
	End Method

	
	
	Rem
	bbdoc: Transforms size of the object on the screen in pixels to size of this object on game field in units.
	about: See also: #ScreenToField, #DistScreenToField, #FieldToScreen, #SizeFieldToScreen, #DistFieldToScreen
	End Rem
	Method SizeScreenToField( ScreenWidth:Double, ScreenHeight:Double, FieldWidth:Double Var, FieldHeight:Double Var )
		FieldWidth = ScreenWidth / XK
		FieldHeight = ScreenHeight / YK
	End Method

	
	
	Rem
	bbdoc: Transforms distance from the screen to field coordinate system.
	about: See also: #ScreenToField, #SizeScreenToField, #FieldToScreen, #SizeFieldToScreen, #DistFieldToScreen
	End Rem
	Method DistScreenToField:Double( ScreenDist:Double )
		Return ScreenDist / XK
	End Method
	
	
	
	Rem
	bbdoc: Transforms game field coordinates to the screen coordinates.
	about: See also: #ScreenToField, #SizeScreenToField, #DistScreenToField, #SizeFieldToScreen, #DistFieldToScreen
	End Rem
	Method FieldToScreen( FieldX:Double, FieldY:Double, ScreenX:Double Var, ScreenY:Double Var )
		ScreenX = ( FieldX + DX ) * XK
		ScreenY = ( FieldY + DY ) * YK
	End Method

	
	
	Rem
	bbdoc: Transforms size of the object on the field in units to size of this object on screen in pixels.
	about: See also: #ScreenToField, #SizeScreenToField, #DistScreenToField, #FieldToScreen, #DistFieldToScreen
	End Rem
	Method SizeFieldToScreen( FieldWidth:Double, FieldHeight:Double, ScreenWidth:Double Var, ScreenHeight:Double Var )
		ScreenWidth = FieldWidth * XK
		ScreenHeight = FieldHeight * YK
	End Method

	
	
	Rem
	bbdoc: Transforms field distance to the screen distance.
	about: See also: #ScreenToField, #SizeScreenToField, #DistScreenToField, #FieldToScreen, #SizeFieldToScreen
	End Rem
	Method DistFieldToScreen:Double( ScreenDist:Double )
		Return ScreenDist * XK
	End Method
	
	
	
	Rem
	bbdoc: Set viewport cliiping for camera.
	about: If ViewportClipping flag is set to False, then this command does nothing.
	
	See also: #Viewport, #ViewportClipping, #ResetViewport
	End Rem
	Method SetCameraViewport()
		If Not ViewportClipping Then Return
	
		SetViewport( X - 0.5 * Width, Y - 0.5 * Height, Width, Height )
	End Method
	
	
	
	Rem
	bbdoc: Resets viewport to whole screen.
	about: See also: #Viewport, #ViewportClipping, #SetCameraViewport
	End Rem
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
	
	
	
	Rem
	bbdoc: Creates new camera object.
	returns: New camera object.
	End Rem
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



Rem
bbdoc: Sets graphics mode.
about: Provide width and height of screen in pixels and unit size in pixels for camera.
End Rem
Function L_InitGraphics( Width:Int = 800, Height:Int = 600, UnitSize:Double = 32.0 )
	Graphics( Width, Height )
	L_CurrentCamera = LTCamera.Create( Width, Height, UnitSize )
	AutoImageFlags( FILTEREDIMAGE | DYNAMICIMAGE )
	SetBlend( AlphaBlend )
End Function