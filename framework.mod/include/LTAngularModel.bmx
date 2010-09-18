'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

LTAngularModel.SetDefault()

Type LTAngularModel Extends LTModel
	Field Angle:Float = 0.0
	Field Velocity:Float = 1.0
	Field AngularVelocity:Float = 1.0
	Field Mass:Float = 1.0
	
	
	
	Method GetAngle:Float()
		Return Angle
	End Method
	
	
	
	Method SetAngle:Float( NewAngle:Float )
		Angle = NewAngle
	End Method
	
	
	
	Method AlterAngle( DAngle:Float )
		Angle :+ DAngle
	End Method
	
	
	
	Method GetVelocity:Float()
		Return Velocity
	End Method
	
	
	
	Method SetVelocity:Float( NewVelocity:Float )
		Velocity = NewVelocity
	End Method
	
	
	
	Method GetDX:Float()
		Return Velocity * Cos( Angle )
	End Method
	
	
	
	Method SetDX( NewDX:Float )
		Local DY:Float = GetDY()
		Velocity = Sqr( NewDX * NewDX + DY * DY )
		Angle = ATan2( DY, NewDX )
	End Method
	
	
	
	Method GetDY:Float()
		Return Velocity * Sin( Angle )
	End Method
	
	
	
	Method SetDY( NewDY:Float )
		Local DX:Float = GetDX()
		Velocity = Sqr( DX * DX + NewDY * NewDY )
		Angle = ATan2( NewDY, DX )
	End Method
	
	
	
	Method AlterDXDY( DDX:Float, DDY:Float )
		SetDX( GetDX() + DDX )
		SetDY( GetDY() + DDY )
	End Method
	
	
	
	Method SetDXDY( NewDX:Float, NewDY:Float )
		Velocity = Sqr( NewDX * NewDX + NewDY * NewDY )
		Angle = ATan2( NewDY, NewDX )
	End Method
	
	
	
	Method GetAngularVelocity:Float()
		Return AngularVelocity
	End Method
	
	
	
	Method SetAngularVelocity:Float( NewAngularVelocity:Float )
		AngularVelocity = NewAngularVelocity
	End Method
	
	
	
	Method GetMass:Float()
		Return Mass
	End Method
	
	
	
	Method SetMass:Float( NewMass:Float )
		Mass = NewMass
	End Method
	
	
	
	Function SetDefault()
		L_DefaultModelTypeID = TTypeID.ForName( "LTAngularModel" )
	End Function
End Type