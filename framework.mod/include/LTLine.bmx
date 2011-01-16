'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTLine Extends LTShape
	Field Pivot:LTSprite[] = New LTSprite[ 2 ]
	
	
	
	Method Create:LTLine( Pivot1:LTSprite, Pivot2:LTSprite )
		Local Line:LTLine = New LTLine
		Line.Pivot[ 0 ] = Pivot1
		Line.Pivot[ 1 ] = Pivot2
		Return Line
	End Method
	
	' ==================== Drawing ===================	
	
	Method Draw()
		Visualizer.DrawUsingLine( Self )
	End Method
	
	
	
	Method DrawUsingVisualizer( Vis:LTVisualizer )
		Vis.DrawUsingLine( Self )
	End Method
	
	' ==================== Collisions ===================
	
	Method Collides:Int( Shape:LTShape )
		Return Shape.CollidesWithLine( Self )
	End Method
	
	
	
	Method CollidesWithSprite:Int( Sprite:LTSprite )
		Select Sprite.Shape
			Case L_Pivot
				'Return L_PivotWithLine( Sprite, Self )
			Case L_Circle
				Return L_CircleWithLine( Sprite.X, Sprite.Y, Sprite.Width, Pivot[ 0 ].X, Pivot[ 0 ].Y, Pivot[ 1 ].X, Pivot[ 1 ].Y )
			Case L_Rectangle
				'Return L_RectangleWithLine( Sprite, Self )
		End Select
	End Method

	' ==================== Other ====================

	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		Pivot[ 0 ] = LTSprite( XMLObject.ManageObjectField( "piv0", Pivot[ 0 ] ) )
		Pivot[ 1 ] = LTSprite( XMLObject.ManageObjectField( "piv1", Pivot[ 1 ] ) )
	End Method
End Type