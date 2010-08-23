' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Include "LTPivot.bmx"
Include "LTCircle.bmx"
Include "LTRectangle.bmx"
Include "LTLine.bmx"
Include "LTGraph.bmx"
Include "Collisions.bmx"

Type LTModel Extends LTObject Abstract
	Field Angle:Float = 0.0
	Field Velocity:Float = 1.0
	Field Mass:Float = 1.0
	Field Visual:LTVisual = L_DefaultVisual
	Field Frame:Int
	
	
	
	Method Draw()
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
	End Method
	
	' ==================== Collidess ===================
	
	Method CollidesWith:Int( Model:LTModel )
	End Method
	
	
	
	Method CollidesWithPivot:Int( Pivot:LTPivot )
	End Method
	
	
	
	Method CollidesWithCircle:Int( Circle:LTCircle )
	End Method
	
	
	
	Method CollidesWithRectangle:Int( Rectangle:LTRectangle )
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
End Type