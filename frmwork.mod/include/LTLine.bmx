'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTBone.bmx"

Rem
bbdoc: It's line section between 2 pivots (sprites centers).
End Rem
Type LTLine Extends LTShape
	Rem
	bbdoc: Pivots array.
	End Rem
	Field Pivot:LTSprite[] = New LTSprite[ 2 ]
	
	
	
	Rem
	bbdoc: Creates line section between two pivots.
	returns: New line.
	End Rem
	Function FromPivots:LTLine( Pivot1:LTSprite, Pivot2:LTSprite )
		Local Line:LTLine = New LTLine
		Line.Pivot[ 0 ] = Pivot1
		Line.Pivot[ 1 ] = Pivot2
		Return Line
	End Function
	
	' ==================== Drawing ===================	
	
	Method Draw()
		If Visible Then Visualizer.DrawUsingLine( Self )
	End Method
	
	
	
	Method DrawUsingVisualizer( Vis:LTVisualizer )
		If Visible Then Vis.DrawUsingLine( Self )
	End Method
	
	' ==================== Collisions ===================
	
	Method SpriteGroupCollisions( Sprite:LTSprite, CollisionType:Int )
		Sprite.CollisionsWithLine( Self, CollisionType )
	End Method
	
	
	
	Method Length:Double()
		Return Pivot[ 0 ].DistanceTo( Pivot[ 1 ] )
	End Method

	' ==================== Other ====================

	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		Pivot[ 0 ] = LTSprite( XMLObject.ManageObjectField( "piv0", Pivot[ 0 ] ) )
		Pivot[ 1 ] = LTSprite( XMLObject.ManageObjectField( "piv1", Pivot[ 1 ] ) )
	End Method
End Type