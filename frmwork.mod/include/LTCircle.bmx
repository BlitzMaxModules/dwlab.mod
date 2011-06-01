'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTCircle Extends LTPivot
	Field Diameter:Float = 1.0

	' ==================== Parameters ====================
	
	Method SetDiameter( NewDiameter:Float )
		Diameter = NewDiameter
	End Method
	
	' ==================== Drawing ===================	
	
	Method Draw()
		Visual.DrawUsingCircle( Self )
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
		Vis.DrawUsingCircle( Self )
	End Method

	' ==================== Collisions ===================
	
	Method CollidesWith:Int( Shape:LTShape )
		Return Shape.CollidesWithCircle( Self )
	End Method

	
	
	Method CollidesWithPivot:Int( Piv:LTPivot )
		Return L_PivotWithCircle( Piv, Self )
	End Method

	
	
	Method CollidesWithCircle:Int( Circ:LTCircle )
		Return L_CircleWithCircle( Circ, Self )
	End Method
	
	
	
	Method CollidesWithRectangle:Int( Rectangle:LTRectangle )
		Return L_CircleWithRectangle( Self, Rectangle )
	End Method
	
	
	
	Method CollidesWithLine:Int( Line:LTLine )
		Return L_CircleWithLine( Self, Line )
	End Method
	
	' ==================== Collision map ===================
	
	Method InsertIntoMap( Map:LTCollisionMap )
		Map.InsertCircle( Self )
	End Method
	
	
	
	Method RemoveFromMap( Map:LTCollisionMap )
		Map.RemoveCircle( Self )
	End Method
	
	
	
	Method Collisions( Map:LTCollisionMap )
		Map.CollisionsWithCircle( Self )
	End Method
	
	
	
	Method HandleCollision( Shape:LTShape )
	End Method
	
	' ==================== Pushing ====================
	
	Method Push( Shape:LTShape )
		Shape.PushCircle( Self )
	End Method


	
	Method PushCircle( Circ:LTCircle )
		L_PushCircleWithCircle( Circ, Self )
	End Method

	
	
	Method PushRectangle( Rectangle:LTRectangle )
		L_PushCircleWithRectangle( Self, Rectangle )
	End Method

	' ==================== Other ====================
	
	Method CloneShape:LTShape( DX:Float, DY:Float, XK:Float, YK:Float )
		Local Circle:LTCircle = New LTCircle
		Circle.X = DX + X * XK
		Circle.Y = DY + Y * YK
		Circle.Diameter = Diameter * XK
		Return Circle
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageFloatAttribute( "diameter", Diameter )
	End Method
End Type
