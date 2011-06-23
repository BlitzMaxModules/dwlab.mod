'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
	
Type LTAngularSprite Extends LTSprite
	Field Angle:Double
	Field Velocity:Double
	
	' ==================== Position ====================
	
	Method MoveTowards( Shape:LTShape )
		Local Angle:Double = DirectionTo( Shape )
		Local DX:Double = Cos( Angle ) * Velocity * L_DeltaTime
		Local DY:Double = Sin( Angle ) * Velocity * L_DeltaTime
		If Abs( DX ) >= Abs( X - Shape.X ) And Abs( DY ) >= Abs( Y - Shape.Y ) Then
			SetCoords( Shape.X, Shape.Y )
		Else
			SetCoords( X + DX, Y + DY )
		End If
	End Method
	
	
	
	Method MoveForward()
		SetCoords( X + Cos( Angle ) * Velocity * L_DeltaTime, Y + Sin( Angle ) * Velocity * L_DeltaTime )
	End Method
	
	
	
	Method MoveUsingWSAD()
		MoveUsingKeys( Key_W, Key_S, Key_A, Key_D )
	End Method
	
	
	
	Method MoveUsingArrows()
		MoveUsingKeys( Key_Up, Key_Down, Key_Left, Key_Right )
	End Method
	
	
	
	Method MoveUsingKeys( KUp:Int, KDown:Int, KLeft:Int, KRight:Int )
		Local DX:Double = KeyDown( KRight ) - KeyDown( KLeft )
		Local DY:Double = KeyDown( KDown ) - KeyDown( KUp )
		If DX * DY Then
			DX :/ Sqr( 2 )
			DY :/ Sqr( 2 )
		End If
		Angle = ATan2( DY, DX )
		SetCoords( X + DX * Velocity * L_DeltaTime, Y + DY * Velocity * L_DeltaTime )
	End Method

	' ==================== Angle ====================
	
	Method DirectAs( Sprite:LTAngularSprite )
		Angle = Sprite.Angle
	End Method
	
	
	
	Method Turn( TurningSpeed:Double )
		Angle :+ L_DeltaTime * TurningSpeed
	End Method
	
	
	
	Method DirectTo( Shape:LTShape )
		Angle = ATan2( Shape.Y - Y, Shape.X - X )
	End Method
	
	' ==================== Other ====================
	
	Method Clone:LTShape()
		Local NewSprite:LTAngularSprite = New LTAngularSprite
		CopyTo( NewSprite )
		Return NewSprite
	End Method
	
	

	Method CopyTo( Shape:LTShape )
		Super.CopyTo( Shape )
		Local Sprite:LTAngularSprite = LTAngularSprite( Shape )
		
		?debug
		If Not Sprite Then L_Error( "Trying to copy angular sprite ~q" + Shape.Name + "~q data to non-angular sprite" )
		?
		
		Sprite.Angle = Angle
		Sprite.Velocity = Velocity
	End Method

	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageDoubleAttribute( "angle", Angle )
		XMLObject.ManageDoubleAttribute( "velocity", Velocity )
	End Method
End Type