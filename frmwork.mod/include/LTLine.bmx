'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

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
	
	
	
	Method CollidesWithLine:Int( Line:LTLine, IncludingPivots:Int = True )
		if Pivot[ 0 ] = Line.Pivot[ 0 ] Or Pivot[ 0 ] = Line.Pivot[ 1 ] Or Pivot[ 1 ] = Line.Pivot[ 0 ] Or Pivot[ 1 ] = Line.Pivot[ 1 ] Then
			If IncludingPivots Then Return True Else Return False
		End If
		
		Local X1:Double = Pivot[ 0 ].X
		Local Y1:Double = Pivot[ 0 ].Y
		Local X2:Double = Pivot[ 1 ].X
		Local Y2:Double = Pivot[ 1 ].Y
		Local X3:Double = Line.Pivot[ 0 ].X
		Local Y3:Double = Line.Pivot[ 0 ].Y
		Local X4:Double = Line.Pivot[ 1 ].X
		Local Y4:Double = Line.Pivot[ 1 ].Y
		Local DX1:Double = X2 - X1
		Local DY1:Double = Y2 - Y1
		Local DX3:Double = X4 - X3
		Local DY3:Double = Y4 - Y3
		Local D:Double = DX3 * DY1 - DY3 * DX1
		If D = 0 Then Return False
		
		Local N:Double = ( DY1 * ( X1 - X3 ) + DX1 * ( Y3 - Y1 ) ) / D
		Local M:Double = ( DX3 * ( Y3 - Y1 ) + DY3 * ( X1 - X3 ) ) / D
		If IncludingPivots Then
			If N >= 0.0 And N <= 1.0 And M >= 0.0 And M <= 1.0 Then Return True
		Else
			If N > 0.0 And N < 1.0 And M > 0.0 And M < 1.0 Then Return True
		End If
	End Method

	' ==================== Other ====================

	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		Pivot[ 0 ] = LTSprite( XMLObject.ManageObjectField( "piv0", Pivot[ 0 ] ) )
		Pivot[ 1 ] = LTSprite( XMLObject.ManageObjectField( "piv1", Pivot[ 1 ] ) )
	End Method
End Type