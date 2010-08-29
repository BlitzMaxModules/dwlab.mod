'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
Type LTVectorModel Extends LTObject Abstract
	Field DX:Float
	Field DY:Float
	Field AngularVelocity:Float = 1.0
	Field Mass:Float = 1.0

	
	
	Method GetAngle:Float()
		Return ATan2( DY, DX )
	End Method
	
	
	
	Method SetAngle:Float( NewAngle:Float )
		Local Velocity:Float = GetVelocity()
		DX = Velocity * Cos( NewAngle )
		DY = Velocity * Sin( NewAngle )
	End Method
	
	
	
	Method AlterAngle( DAngle:Float )
		SetAngle( GetAngle() + DAngle )
	End Method
	
	
	
	Method GetVelocity:Float()
		Return Sqr( DX * DX + DY * DY )
	End Method
	
	
	
	Method SetVelocity:Float( NewVelocity:Float )
		Local Velocity:Float = GetVelocity()
		
		?debug
		L_Assert( Velocity, "Cannot change velocity of zero vector" )
		?
		
		DX :* NewVelocity / Velocity
		DY :* NewVelocity / Velocity
	End Method
	
	
	
	Method GetDX:Float()
		Return DX
	End Method
	
	
	
	Method SetDX( NewDX:Float )
		DX = NewDX
	End Method
	
	
	
	Method GetDY:Float()
		Return DY
	End Method
	
	
	
	Method SetDY( NewDY:Float )
		DY = NewDY
	End Method
	
	
	
	Method GetAngularVelocity:Float()
	End Method
	
	
	
	Method SetAngularVelocity:Float( NewAngularVelocity:Float )
	End Method
	
	
	
	Method GetMass:Float()
	End Method
	
	
	
	Method SetMass:Float( NewMass:Float )
	End Method
End Type