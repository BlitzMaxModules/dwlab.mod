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
Global L_CurrentCamera:LTCamera = LTCamera.Create()

Rem
bbdoc: Global flag for discrete graphics.
End Rem
Global L_DiscreteGraphics:Int = False

Rem
bbdoc: Camera for displaying game objects.
about: Camera sprite defines rectangular area on game field which will be projected to the defined viewport rectangle.
End Rem
Type LTCamera Extends LTVectorSprite
	Rem
	bbdoc: Viewport rectangular shape.
	about: See also: #ViewportClipping, #SetCameraViewport, #ResetViewport
	End Rem
	Field Viewport:LTShape = New LTShape
	
	Field K:Double = 1.0
	Field VDX:Double, VDY:Double
	
	Field Z:Double, DZ:Double, ZK:Double = 1.1
	
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
	
	Rem
	bbdoc: Elements of vectors V1 and V2 for Isometric view.
	End Rem
	Field VX1:Double, VY1:Double, VX2:Double, VY2:Double, VK:Double, AVK:Double
	
	
	Rem
	bbdoc: Transforms screen coordinates to game field coordinates.
	about: See also: #SizeScreenToField, #DistScreenToField, #FieldToScreen, #SizeFieldToScreen, #DistFieldToScreen
	End Rem
	Method ScreenToField( ScreenX:Double, ScreenY:Double, FieldX:Double Var, FieldY:Double Var )
		If Isometric Then
			FieldX = ( ScreenX * VY2 - ScreenY * VX2 ) / VK - VDX
			FieldY = ( ScreenY * VX1 - ScreenX * VY1 ) / VK  - VDY
		Else
			FieldX = ScreenX / K - VDX
			FieldY = ScreenY / K - VDY
		End If
	End Method

	
	
	Rem
	bbdoc: Transforms size of the object on the screen in pixels to size of this object on game field in units.
	about: See also: #ScreenToField, #DistScreenToField, #FieldToScreen, #SizeFieldToScreen, #DistFieldToScreen
	End Rem
	Method SizeScreenToField( ScreenWidth:Double, ScreenHeight:Double, FieldWidth:Double Var, FieldHeight:Double Var )
		If Isometric Then
			FieldWidth = Abs( ( Abs( ScreenWidth * VY2 ) - Abs( ScreenHeight * VX2 ) ) / AVK )
			FieldHeight = Abs( ( Abs( ScreenHeight * VY2 ) - Abs( ScreenWidth * VX2 ) ) / AVK )
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
			ScreenX = ( ( FieldX + VDX ) * VX1 + ( FieldY + VDY ) * VX2 ) * K
			ScreenY = ( ( FieldX + VDX ) * VY1 + ( FieldY + VDY ) * VY2 ) * K
		Else
			ScreenX = ( FieldX + VDX ) * K
			ScreenY = ( FieldY + VDY ) * K
		End If
		
		If L_DiscreteGraphics Then
			ScreenX = Int( ScreenX )
			ScreenY = Int( ScreenY )
		End If
	End Method

	
	
	Rem
	bbdoc: Same as FieldToScreen, but for Floats.
	End Rem
	Method FieldToScreenFloat( FieldX:Double, FieldY:Double, ScreenX:Float Var, ScreenY:Float Var )
		If Isometric Then
			ScreenX = ( ( FieldX + VDX ) * VX1 + ( FieldY + VDY ) * VX2 ) * K
			ScreenY = ( ( FieldX + VDX ) * VY1 + ( FieldY + VDY ) * VY2 ) * K
		Else
			ScreenX = ( FieldX + VDX ) * K
			ScreenY = ( FieldY + VDY ) * K
		End If
		
		If L_DiscreteGraphics Then
			ScreenX = Int( ScreenX )
			ScreenY = Int( ScreenY )
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
		
		If L_DiscreteGraphics Then
			ScreenWidth = Int( ScreenWidth )
			ScreenHeight = Int( ScreenHeight )
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
		If ViewportClipping Then	
			SetViewport( Viewport.X - 0.5 * Viewport.Width, Viewport.Y - 0.5 * Viewport.Height, Viewport.Width, Viewport.Height )
		Else
			ResetViewport()
		End If
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
		SetSize( Viewport.Width / K, Viewport.Height / K )
	End Method
	
	
	
	Method ShiftCameraToPoint( NewX:Double, NewY:Double, Acceleration:Double = 6.0 )
		ApplyAcceleration( X, NewX, DX, Acceleration )
		ApplyAcceleration( Y, NewY, DY, Acceleration )
		MoveForward()
	End Method
	
	
	
	
	Method ShiftCameraToShape( Shape:LTShape, Acceleration:Double = 6.0 )
		ShiftCameraToPoint( Shape.X, Shape.Y, Acceleration )
	End Method
	
	
	
	Method ApplyAcceleration:Double( X:Double, NewX:Double, DX:Double Var, Acceleration:Double )
		Local A:Double = L_DeltaTime * Acceleration * Sgn( NewX - X )
		If ( NewX - X ) * DX < 0 Then
			DX :+ A
		ElseIf DX * DX / 2.0 / Acceleration < Abs( NewX - X ) Then
			DX :+ A
		Else
			DX :- A
		End If
	End Method
	
	
	
	Method AlterCameraMagnification( NewZ:Double, OldK:Double, Acceleration:Double )
		ApplyAcceleration( Z, NewZ, DZ, Acceleration )
		'If Abs( NewZ - Z ) > Abs( DZ ) Then DZ = NewZ - Z
		Z :+ L_DeltaTime * DZ
		SetMagnification( OldK * ZK ^ Z )
	End Method
	
	
	
	Method Update()
		If Isometric Then
			Local DWidth:Double = Abs( VX1 ) + Abs( VX2 )
			Local DHeight:Double = Abs( VY1 ) + Abs( VY2 )
			K = Min( Viewport.Width / DWidth / Width, Viewport.Height / DHeight / Height )
			VK = ( VX1 * VY2 - VY1 * VX2 ) * K
			AVK = ( Abs( VX1 * VY2 ) - Abs( VY1 * VX2 ) ) * K
			VDX = ( Viewport.X * VY2 - Viewport.Y * VX2 ) / VK - X
			VDY = ( Viewport.Y * VX1 - Viewport.X * VY1 ) / VK - Y
		Else
			K = Viewport.Width / Width
			Height = Viewport.Height / K
			VDX = Viewport.X / K - X
			VDY = Viewport.Y/ K - Y
		End If
	End Method
	
	
	
	Rem
	bbdoc: Applies color with given intensity to the whole viewport.
	about: Red color for example will make picture more "reddish".
	If you use intensity 0.0, it will give no effect and intensity 1.0 will make whole viewport solid red.
	
	See also: #Lighten, #Darken
	End Rem
	Method ApplyColor( Intensity:Double, Red:Double, Green:Double, Blue:Double )
		SetAlpha( Intensity )
		SetColor( 255.0 * Red, 255.0 * Green, 255.0 * Blue )
		DrawRect( Viewport.X - 0.5 * Viewport.Width, Viewport.Y - 0.5 * Viewport.Height, Viewport.Width, Viewport.Height )
		LTVisualizer.ResetColor()
	End Method
	
	
	
	Rem
	bbdoc: Lightens current camera viewport.
	about: 0.0 intensity will give no effect, 1.0 intensity will turn viewport to solid white.
	
	See also: #ApplyColor, #Darken
	End Rem
	Method Lighten( Intensity:Double )
		ApplyColor( Intensity, 1.0, 1.0, 1.0 )
	End Method
	
	
	
	Rem
	bbdoc: Darkens current camera viewport.
	about: 0.0 intensity will give no effect, 1.0 intensity will turn viewport to solid black.
	
	See also: #ApplyColor, #Lighten
	End Rem
	Method Darken( Intensity:Double )
		ApplyColor( Intensity, 0.0, 0.0, 0.0 )
	End Method
	
	' ==================== Other ====================	
	
	Method Clone:LTShape()
		Local NewSprite:LTSprite = New LTSprite
		CopyTo( NewSprite )
		Return NewSprite
	End Method

	
	
	Method CopyTo( Shape:LTShape )
		Super.CopyTo( Shape )
		Local Camera:LTCamera = LTCamera( Shape )
		
		?debug
		If Not Camera Then L_Error( "Trying to copy camera ~q" + Shape.GetTitle() + "~q data to non-camera" )
		?
		
		Camera.Viewport = Viewport.Clone()
		Camera.ViewportClipping = ViewportClipping
		Camera.Isometric = Isometric
		Camera.VX1 = VX1
		Camera.VY1 = VY1
		Camera.VX2 = VX2
		Camera.VY2 = VY2
		Camera.Update()
	End Method
	
	
	Rem
	bbdoc: Creates new camera object.
	returns: New camera object.
	End Rem
	Function Create:LTCamera( Width:Double = 800.0, Height:Double = 600.0, UnitSize:Double = 25.0 )
		Local Camera:LTCamera = New LTCamera
		Camera.Viewport.SetCoords( 0.5 * Width, 0.5 * Height )
		Camera.Viewport.SetSize( Width, Height )
		Camera.SetSize( Width / UnitSize, Height / UnitSize )
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
Function L_InitGraphics( Width:Int = 800, Height:Int = 600, UnitSize:Double = 25.0, ColorDepth:Int = 0, Frequency:Int = 60 )
	Graphics( Width, Height, ColorDepth, Frequency )
	AutoImageFlags( FILTEREDIMAGE | DYNAMICIMAGE )
	SetBlend( AlphaBlend )
	
	L_CurrentCamera.Viewport.SetSize( Width, Height )
	L_CurrentCamera.Viewport.SetCoords( 0.5 * Width, 0.5 * Height )
	L_CurrentCamera.SetSize( Width / UnitSize, Height / UnitSize )
End Function



Rem
VK = ( VX1 * VY2 - VY1 * VX2 ) * K

ScreenX = ( ( FieldX + DX ) * VX1 + ( FieldY + DY ) * VX2 ) * K
ScreenX / K = ( FieldX + DX ) * VX1 + ( FieldY + DY ) * VX2
ScreenX / K - ( FieldX + DX ) * VX1 = ( FieldY + DY ) * VX2
( ScreenX / K - ( FieldX + DX ) * VX1 ) / VX2 = FieldY + DY
( ScreenX / K - ( FieldX + DX ) * VX1 ) / VX2 - DY = FieldY

ScreenY = ( ( FieldX + DX ) * VY1 + ( FieldY + DY ) * VY2 ) * K
ScreenY = ( ( FieldX + DX ) * VY1 + ( ( ScreenX / K - ( FieldX + DX ) * VX1 ) / VX2 - DY + DY ) * VY2 ) * K
ScreenY / K = ( FieldX + DX ) * VY1 + ( ( ScreenX / K - ( FieldX + DX ) * VX1 ) / VX2 - DY + DY ) * VY2
ScreenY / K = FieldX * VY1 + DX * VY1 + ScreenX / K / VX2 * VY2 - FieldX * VX1 / VX2 * VY2 - DX * VX1 / VX2 * VY2
ScreenY / K - DX * VY1 - ScreenX / K / VX2 * VY2 + DX * VX1 / VX2 * VY2 = FieldX * VY1 - FieldX * VX1 / VX2 * VY2
( ScreenY - ScreenX / VX2 * VY2 ) / K + DX * ( VX1 / VX2 * VY2 - VY1 ) = FieldX * ( VY1 - VX1 / VX2 * VY2 )
( ScreenY - ScreenX / VX2 * VY2 ) / ( VY1 - VX1 / VX2 * VY2 ) / K - DX = FieldX
( ScreenY * VX2 - ScreenX * VY2 ) / ( VY1 * VX2 - VX1 * VY2 ) / K - DX = FieldX
( ScreenX * VY2 - ScreenY * VX2 ) / VK - DX = FieldX


ScreenY = ( ( FieldX + DX ) * VY1 + ( FieldY + DY ) * VY2 ) * K
ScreenY / K = ( FieldX + DX ) * VY1 + ( FieldY + DY ) * VY2
ScreenY / K - ( FieldY + DY ) * VY2 = ( FieldX + DX ) * VY1
( ScreenY / K - ( FieldY + DY ) * VY2 ) / VY1 = FieldX + DX
( ScreenY / K - ( FieldY + DY ) * VY2 ) / VY1 - DX = FieldX

ScreenX = ( ( FieldX + DX ) * VX1 + ( FieldY + DY ) * VX2 ) * K
ScreenX = ( ( ( ScreenY / K - ( FieldY + DY ) * VY2 ) / VY1 - DX + DX ) * VX1 + ( FieldY + DY ) * VX2 ) * K
ScreenX / K = ( ( ScreenY / K - ( FieldY + DY ) * VY2 ) / VY1 ) * VX1 + ( FieldY + DY ) * VX2
ScreenX / K = ScreenY / K / VY1 * VX1 - FieldY * VY2 / VY1 * VX1 - DY * VY2 / VY1 * VX1 + FieldY * VX2 + DY * VX2
ScreenX / K - ScreenY / K / VY1 * VX1 + DY * VY2 / VY1 * VX1 - DY * VX2 = FieldY * VX2 - FieldY * VY2 / VY1 * VX1
( ScreenX - ScreenY / VY1 * VX1 ) / K + DY * ( VY2 / VY1 * VX1 - VX2 ) = FieldY * ( VX2 - VY2 / VY1 * VX1 )
( ScreenX - ScreenY / VY1 * VX1 ) / ( VX2 - VY2 / VY1 * VX1 ) / K  - DY = FieldY
( ScreenX * VY1 - ScreenY * VX1 ) / ( VX2 * VY1 - VY2 * VX1 ) / K  - DY = FieldY
( ScreenY * VX1 - ScreenX * VY1 ) / VK  - DY = FieldY
EndRem