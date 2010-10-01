'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
Type LTVectorModel Extends LTModel Abstract
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
	
	
	
	Method AlterDX( DDX:Float )
		DX :+ DDX
	End Method
	
	
	
	Method SetDX( NewDX:Float )
		DX = NewDX
	End Method
	
	
	
	Method GetDY:Float()
		Return DY
	End Method
	
	
	
	Method AlterDY( DDY:Float )
		DY :+ DDY
	End Method
	
	
	
	Method SetDY( NewDY:Float )
		DY = NewDY
	End Method
	
	
	
	Method AlterDXDY( DDX:Float, DDY:Float )
		DX :+ DDX
		DY :+ DDY
	End Method
	
	
	
	Method SetDXDY( NewDX:Float, NewDY:Float )
		DX = NewDX
		DY = NewDY
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
		L_DefaultModelTypeID = TTypeID.ForName( "LTVectorModel" )
	End Function
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageFloatAttribute( "dx", DX )
		XMLObject.ManageFloatAttribute( "dy", DY, 1.0 )
		XMLObject.ManageFloatAttribute( "angular-velocity", AngularVelocity, 1.0 )
		XMLObject.ManageFloatAttribute( "mass", Mass, 1.0 )
	End Method
End Type