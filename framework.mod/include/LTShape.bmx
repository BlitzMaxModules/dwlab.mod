'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTActor.bmx"
Include "LTLine.bmx"
Include "LTGraph.bmx"

Type LTShape Extends LTObject Abstract
	Field Shape:Int = L_Rectangle
	Field Visual:LTVisual = L_DefaultVisual

	
	' ==================== Drawing ===================	
	
	Method Draw()
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
	End Method
	
	' ==================== Collisions ===================
	
	Method CollidesWith:Int( Shape:LTShape )
	End Method
	
	
	
	Method CollidesWithActor:Int( Actor:LTActor )
	End Method
	
	
	
	Method CollidesWithLine:Int( Line:LTLine )
	End Method
	
	' ==================== Pushing ====================
	
	Method Push( Shape:LTShape )
	End Method


	
	Method PushActor( Actor:LTActor )
	End Method
	
	' ==================== Collision map ===================
	
	Method HandleCollision( Shape:LTShape )
	End Method
End Type