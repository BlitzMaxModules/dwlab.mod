' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Include "LTPivot.bmx"
Include "LTCircle.bmx"
Include "LTRectangle.bmx"
Include "LTGraph.bmx"
Include "Collisions.bmx"

Type LTModel Extends LTObject
	Field Angle:Float
	Field Velocity:Float
	Field Mass:Float = 1.0
	
	
	
	Method DrawUsing( Visual:LTVisual )
	End Method
	
	' ==================== Collisions ===================
	
	Method CollisionWith:Int( Model:LTModel )
	End Method
	
	
	
	Method CollisionWithPivot:Int( Pivot:LTPivot )
	End Method
	
	
	
	Method CollisionWithCircle:Int( Circle:LTCircle )
	End Method
	
	
	
	Method CollisionWithRectangle:Int( Rectangle:LTRectangle )
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