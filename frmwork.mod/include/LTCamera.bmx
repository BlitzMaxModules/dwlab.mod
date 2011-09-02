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
	
	Field K:Double = 1.0
	Field DX:Double, DY:Double
	
	Rem
	bbdoc: Viewport clipping flag.
	about: Defines will the objects parts outside viewport be clipped. Defaults to True.
	
	See also: #Viewport, #SetCameraViewport, #ResetViewport
	End Rem
	Field ViewportClipping:Int = True
	
	Rem
	bbdoc: Isometric view flag.
	End Rem
	Field Isometric:Int
	Field VX1:Double, VY1:Double, VX2:Double, VY2:Double, VK:Double
	
	
	
	Rem
	bbdoc: Transforms screen coordinates to game field coordinates.
	about: See also: #SizeScreenToField, #DistScreenToField, #FieldToScreen, #SizeFieldToScreen, #DistFieldToScreen
	End Rem
	Method ScreenToField( ScreenX:Double, ScreenY:Double, FieldX:Double Var, FieldY:Double Var )
		If Isometric Then
			FieldX = ( ScreenY * VX2 - ScreenX * VY2 ) / VK - DX
			FieldY = ( ScreenX * VY1  - ScreenY * VX1 ) / VK - DY
		Else
			FieldX = ScreenX / K - DX
			FieldY = ScreenY / K - DY
		End If
	End Method

	
	
	Rem
	bbdoc: Transforms size of the object on the screen in pixels to size of this object on game field in units.
	about: See also: #ScreenToField, #DistScreenToField, #FieldToScreen, #SizeFieldToScreen, #DistFieldToScreen
	End Rem
	Method SizeScreenToField( ScreenWidth:Double, ScreenHeight:Double, FieldWidth:Double Var, FieldHeight:Double Var )
		If Isometric Then
			FieldWidth = ( ScreenHeight * VX2 - ScreenWidth * VY2 ) / VK
			FieldHeight = ( ScreenWidth * VY1  - ScreenHeight * VX1 ) / VK
		Else
			FieldWidth = ScreenWidth / K
			FieldHeight = ScreenHeight / K
		End If
	End Method

	
	
	Rem
	bbdoc: Transforms distance from the screen to field coordinate system.
	about: See also: #ScreenToField, #SizeScreenToField, #FieldToScreen, #SizeFieldToScreen, #DistFieldToScreen
	End Rem
	Method DistScreenToField:Double( ScreenDist:Double )
		Return ScreenDist / K
	End Method
	
	
	
	Rem
	bbdoc: Transforms game field coordinates to the screen coordinates.
	about: See also: #ScreenToField, #SizeScreenToField, #DistScreenToField, #SizeFieldToScreen, #DistFieldToScreen
	End Rem
	Method FieldToScreen( FieldX:Double, FieldY:Double, ScreenX:Double Var, ScreenY:Double Var )
		If Isometric Then
			ScreenX = ( ( FieldX + DX ) * VX1 + ( FieldY + DY ) * VX2 ) * K
			ScreenY = ( ( FieldX + DX ) * VY1 + ( FieldY + DY ) * VY2 ) * K
		Else
			ScreenX = ( FieldX + DX ) * K
			ScreenY = ( FieldY + DY ) * K
		End If
	End Method

	
	
	Method FieldToScreenFloat( FieldX:Double, FieldY:Double, ScreenX:Float Var, ScreenY:Float Var )
		If Isometric Then
			ScreenX = ( ( FieldX + DX ) * VX1 + ( FieldY + DY ) * VX2 ) * K
			ScreenY = ( ( FieldX + DX ) * VY1 + ( FieldY + DY ) * VY2 ) * K
		Else
			ScreenX = ( FieldX + DX ) * K
			ScreenY = ( FieldY + DY ) * K
		End If
	End Method
	
	
	
	Rem
	bbdoc: Transforms size of the object on the field in units to size of this object on screen in pixels.
	about: See also: #ScreenToField, #SizeScreenToField, #DistScreenToField, #FieldToScreen, #DistFieldToScreen
	End Rem
	Method SizeFieldToScreen( FieldWidth:Double, FieldHeight:Double, ScreenWidth:Double Var, ScreenHeight:Double Var )
		If Isometric Then
			ScreenWidth = ( Abs( FieldWidth * VX1 ) + Abs( FieldHeight * VX2 ) ) * K
			ScreenHeight = ( Abs( FieldWidth * VY1 ) + Abs( FieldHeight * VY2 ) ) * K
		Else
			ScreenWidth = FieldWidth * K
			ScreenHeight = FieldHeight * K
		End If
	End Method

	
	
	Rem
	bbdoc: Transforms field distance to the screen distance.
	about: See also: #ScreenToField, #SizeScreenToField, #DistScreenToField, #FieldToScreen, #SizeFieldToScreen
	End Rem
	Method DistFieldToScreen:Double( ScreenDist:Double )
		Return ScreenDist * K
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
	
	
	
	Method SetMagnification( NewK:Double )
		K = NewK
		Width = Viewport.Width / K
		Height = Viewport.Height / K
		Update()
	End Method
	
	
	
	Method ShiftCameraToPoint( NewX:Double, NewY:Double )
		X :+ L_CameraSpeed * L_DeltaTime * ( NewX - X )
		Y :+ L_CameraSpeed * L_DeltaTime * ( NewY - Y )
		Update()
	End Method
	
	
	
	Method AlterCameraMagnification( NewK:Double )
		SetMagnification( K + L_CameraMagnificationSpeed * L_DeltaTime * ( NewK - K ) )
	End Method
	
	
	
	Method Update()
		If Isometric Then
			Local DWidth:Double = Abs( VX1 ) + Abs( VX2 )
			Local DHeight:Double = Abs( VY1 ) + Abs( VY2 )
			K = Min( Viewport.Width / DWidth / Width, Viewport.Height / DHeight / Height  )
			VK = ( VY1 * VX2 - VX1 * VY2 ) * K
			DX = ( Viewport.X * VX2 - Viewport.Y * VY2 ) / VK - X
			DY = ( Viewport.X * VY1 - Viewport.Y * VX1 ) / VK - Y
		Else
			K = Viewport.Width / Width
			Height = Viewport.Height / K
			DX = Viewport.X / K - X
			DY = Viewport.Y/ K - Y
		End If
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
	
	' ==================== Saving / loading ====================
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		Viewport = LTShape( XMLObject.ManageObjectField( "viewport", Viewport ) )
		XMLObject.ManageIntAttribute( "viewport-clipping", ViewportClipping )
		XMLObject.ManageIntAttribute( "isometric", Isometric )
		XMLObject.ManageDoubleAttribute( "x1", VX1 )
		XMLObject.ManageDoubleAttribute( "y1", VY1 )
		XMLObject.ManageDoubleAttribute( "x2", VX2 )
		XMLObject.ManageDoubleAttribute( "y2", VY2 )
		
		If L_XMLMode = L_XMLGet Then Update()
	End Method
End Type



Rem
bbdoc: Sets graphics mode.
about: Provide width and height of screen in pixels and unit size in pixels for camera.
End Rem
Function L_InitGraphics( Width:Int = 800, Height:Int = 600, UnitSize:Double = 32.0, ColorDepth:Int = 0 )
	Graphics( Width, Height, ColorDepth )
	L_CurrentCamera = LTCamera.Create( Width, Height, UnitSize )
	AutoImageFlags( FILTEREDIMAGE | DYNAMICIMAGE )
	SetBlend( AlphaBlend )
End Function