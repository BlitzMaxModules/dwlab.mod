'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTRectangle Extends LTPivot
	
	' ==================== Parameters ====================
	
	' ==================== Drawing ===================	
	
	Method Draw()
		Visual.DrawUsingRectangle( Self )
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
		Vis.DrawUsingRectangle( Self )
	End Method

	' ==================== Collisions ===================
	
	Method Collides:Int( Shape:LTShape )
		Return Shape.CollidesWithRectangle( Self )
	End Method

	
	
	Method CollidesWithPivot:Int( Piv:LTPivot )
		If L_PivotWithRectangle( Piv, Self ) Then Return True
	End Method

	
	
	Method CollidesWithCircle:Int( Circ:LTCircle )
		If L_CircleWithRectangle( Circ, Self ) Then Return True
	End Method
	
	
	
	Method CollidesWithRectangle:Int( Rectangle:LTRectangle )
		If L_RectangleWithRectangle( Rectangle, Self ) Then Return True
	End Method
	
	' ==================== Collision map ===================
	
	Method InsertIntoMap( Map:LTCollisionMap )
		Map.InsertRectangle( Self )
	End Method
	
	
	
	Method RemoveFromMap( Map:LTCollisionMap )
		Map.RemoveRectangle( Self )
	End Method
	
	
	
	Method Collisions( Map:LTCollisionMap )
		Map.CollisionsWithRectangle( Self )
	End Method
	
	
	
	Method HandleCollision( Shape:LTShape )
	End Method
	
	' ==================== Pushing ====================
	
	Method Push( Shape:LTShape )
		Shape.PushRectangle( Self )
	End Method


	
	Method PushCircle( Circ:LTCircle )
		L_PushCircleWithRectangle( Circ, Self )
	End Method

	
	
	Method PushRectangle( Rectangle:LTRectangle )
		L_PushRectangleWithRectangle( Self, Rectangle )
	End Method
	
	' ==================== Other ====================
	
	Method CloneShape:LTShape( DX:Float, DY:Float, XK:Float, YK:Float )
	End Method
	
	

	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
	End Method
End Type