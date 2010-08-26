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
Include "Physics.bmx"

Type LTModel Extends LTObject Abstract
	Field Angle:Float = 0.0
	Field Velocity:Float = 1.0
	Field Mass:Float = 1.0
	Field Visual:LTVisual = L_DefaultVisual
	Field Frame:Int
	
	' ==================== Drawing ===================	
	
	Method Draw()
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
	End Method
	
	' ==================== Collisions ===================
	
	Method CollidesWith:Int( Model:LTModel )
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
	
	Method Push( Mdl:LTModel )
	End Method


	
	Method PushPivot( Piv:LTPivot )
	End Method

		
	
	Method PushCircle( Circ:LTCircle )
	End Method
	
	
	
	Method PushRectangle( Rectangle:LTRectangle )
	End Method
	
	' ==================== Other ====================
	
	Method Update()
	End Method
End Type