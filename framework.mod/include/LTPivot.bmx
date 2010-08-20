' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Type LTPivot Extends LTModel Abstract
	Field X:Float, Y:Float
	
	
	
	Method DrawUsing( Visual:LTVisual )
		Visual.DrawUsingPivot( Self )
	End Method
	
	' ==================== Collisions ===================
	
	Method CollisionWith:Int( Model:LTModel )
		Return Model.CollisionWithPivot( Self )
	End Method

	
	
	Method CollisionWithPivot:Int( Piv:LTPivot )
		If L_PivotWithPivot( Self, Piv ) Then Return True
	End Method

	
	
	Method CollisionWithCircle:Int( Circ:LTCircle )
		If L_PivotWithCircle( Self, Circ ) Then Return True
	End Method
	
	
	
	Method CollisionWithBox:Int( Box:LTBox )
		If L_PivotWithBox( Self, Box ) Then Return True
	End Method
End Type