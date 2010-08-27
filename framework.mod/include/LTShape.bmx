'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTPivot.bmx"
Include "LTCircle.bmx"
Include "LTRectangle.bmx"
Include "LTLine.bmx"
Include "LTGraph.bmx"
Include "LTTileMap.bmx"
Include "Collisions.bmx"

Type LTShape Extends LTObject Abstract
	Field Model:LTModel = L_DefaultModel
	Field Visual:LTVisual = L_DefaultVisual
	Field Frame:Int
	
	
	
	Method New()
		If L_DefaultModelTypeID Then Model = LTModel( L_DefaultModelTypeID.NewObject() )
	End Method
	
	' ==================== Drawing ===================	
	
	Method Draw()
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
	End Method
	
	' ==================== Collisions ===================
	
	Method CollidesWith:Int( Shape:LTShape )
	End Method
	
	
	
	Method CollidesWithPivot:Int( Pivot:LTPivot )
	End Method
	
	
	
	Method CollidesWithCircle:Int( Circle:LTCircle )
	End Method
	
	
	
	Method CollidesWithRectangle:Int( Rectangle:LTRectangle )
	End Method
	
	
	
	Method CollidesWithLine( Line:LTLine )
	End Method
	
	' ==================== Pushing ====================
	
	Method Push( Shape:LTShape )
	End Method


	
	Method PushPivot( Piv:LTPivot )
	End Method

		
	
	Method PushCircle( Circ:LTCircle )
	End Method
	
	
	
	Method PushRectangle( Rectangle:LTRectangle )
	End Method
	
	' ==================== Model parameters ====================
	
	Method GetAngle:Float()
		Return Model.GetAngle()
	End Method
	
	
	
	Method SetAngle:Float( NewAngle:Float )
		Model.SetAngle( NewAngle )
	End Method
	
	
	
	Method GetVelocity:Float()
		Return Model.GetVelocity()
	End Method
	
	
	
	Method SetVelocity:Float( NewVelocity:Float )
		Model.SetVelocity( NewVelocity )
	End Method
	
	
	
	Method GetAngularVelocity:Float()
		Return Model.GetAngularVelocity()
	End Method
	
	
	
	Method SetAngularVelocity:Float( NewAngularVelocity:Float )
		Model.SetAngularVelocity( NewAngularVelocity )
	End Method
	
	
	
	Method GetMass:Float()
		Return Model.GetMass()
	End Method
	
	
	
	Method SetMass:Float( NewMass:Float )
		Model.SetMass( NewMass )
	End Method
	
	' ==================== Other ====================
	
	Method Update()
	End Method
End Type