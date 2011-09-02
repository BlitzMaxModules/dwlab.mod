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
bbdoc: Sprite with angle and velocity parameters.
about: Handy for top-view games.

See also: #LTSprite, #LTVectorSprite
End Rem	
Type LTAngularSprite Extends LTSprite
	Rem
	bbdoc: Direction of the sprite
	about: See also: #MoveForward, #MoveTowards
	End Rem
	Field Angle:Double
	
	Rem
	bbdoc: Velocity of the sprite in units per second.
	about: See also: #MoveForward, #MoveTowards
	End Rem
	Field Velocity:Double
	
	' ==================== Position ====================
	
	Method MoveForward()
		SetCoords( X + Cos( Angle ) * Velocity * L_DeltaTime, Y + Sin( Angle ) * Velocity * L_DeltaTime )
	End Method

	' ==================== Angle ====================
	
	Rem
	bbdoc: Directs sprite as given angular sprite. 
	about: See also: #DirectTo
	End Rem
	Method DirectAs( Sprite:LTAngularSprite )
		Angle = Sprite.Angle
	End Method
	
	
	
	Rem
	bbdoc: Turns the sprite.
	about: Turns the sprite with given speed per second.
	End Rem
	Method Turn( TurningSpeed:Double )
		Angle :+ L_DeltaTime * TurningSpeed
	End Method
	
	
	
	Rem
	bbdoc: Direct the sprite to center of the given shape.
	about: See also: #DirectAs
	End Rem
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