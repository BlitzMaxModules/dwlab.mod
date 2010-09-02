'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
Include "LTAngularModel.bmx"
Include "LTVectorModel.bmx"
Include "Physics.bmx"

Global L_DefaultModel:LTModel = New LTNullModel
Global L_DefaultModelTypeID:TTypeID

Type LTModel Extends LTObject Abstract
	Method GetAngle:Float()
	End Method
	
	
	
	Method SetAngle:Float( NewAngle:Float )
	End Method
	
	
	
	Method AlterAngle( DAngle:Float )
	End Method
	

	
	Method GetVelocity:Float()
	End Method
	
	
	
	Method SetVelocity:Float( NewVelocity:Float )
	End Method
	
	
	
	Method GetDX:Float()
	End Method
	
	
	
	Method AlterDX( DDX:Float )
	End Method
	
	
	
	Method SetDX( NewDX:Float )
	End Method
	
	
	
	Method GetDY:Float()
	End Method
	
	
	
	Method AlterDY( DDY:Float )
	End Method
	
	
	
	Method SetDY( NewDY:Float )
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





Type LTNullModel Extends LTModel
	Method GetVelocity:Float()
		Return 1.0
	End Method
	
	
	
	Method GetAngularVelocity:Float()
		Return 180.0
	End Method
	
	
	
	Method GetMass:Float()
		Return 1.0
	End Method
	
	
	
	Function SetDefault()
		L_DefaultModelTypeID = Null
	End Function
End Type