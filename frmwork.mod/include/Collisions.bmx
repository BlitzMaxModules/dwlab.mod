'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

' Collision handlers, functions and detection modules

Rem
bbdoc: Constant for dealing with inaccuracy of double type operations.
End Rem
Const L_Inaccuracy:Double = 0.000001

Rem
bbdoc: Sprite collision handling class.
about: Sprite collision check method with specified collision handler will execute this handler's method on collision one sprite with another.

See also: #Active example
End Rem
Type LTSpriteCollisionHandler Extends LTObject
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
	End Method
End Type



Rem
bbdoc: Sprite and tile collision handling class.
about: Collision check method with specified collision handler will execute this handler's method on collision sprite with tile.

See also: #Active example
End Rem
Type LTSpriteAndTileCollisionHandler Extends LTObject
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int )
	End Method
End Type



Rem
bbdoc: Sprite and line collision handling class.
about: Collision check method with specified collision handler will execute this handler's method on collision sprite with line.

See also: #Active example
End Rem
Type LTSpriteAndLineCollisionHandler Extends LTObject
	Method HandleCollision( Sprite:LTSprite, Line:LTLine )
	End Method
End Type



Function L_PivotWithPivot:Int( Pivot1X:Double, Pivot1Y:Double, Pivot2X:Double, Pivot2Y:Double )
	If Pivot1X = Pivot2X And Pivot1Y = Pivot2Y Then Return True
End Function



Function L_PivotWithOval:Int( PivotX:Double, PivotY:Double, OvalX:Double, OvalY:Double, OvalWidth:Double, OvalHeight:Double )
	Local OvalDiameter:Double
	If OvalWidth = OvalHeight Then
		OvalDiameter = OvalWidth
	Else
		OvalDiameter = L_GetOvalDiameter( OvalX, OvalY, OvalWidth, OvalHeight, PivotX, PivotY )
	End If
	If ( PivotX - OvalX ) * ( PivotX - OvalX ) + ( PivotY - OvalY ) * ( PivotY - OvalY ) < 0.25 * OvalDiameter * OvalDiameter Then Return True
End Function



Function L_PivotWithRectangle:Int( PivotX:Double, PivotY:Double, RectangleX:Double, RectangleY:Double, RectangleWidth:Double, RectangleHeight:Double )
	If 2.0 * Abs( PivotX - RectangleX ) < RectangleWidth - L_Inaccuracy And 2.0 * Abs( PivotY - RectangleY ) < RectangleHeight - L_Inaccuracy Then Return True
End Function



Function L_OvalWithOval:Int( Oval1X:Double, Oval1Y:Double, Oval1Width:Double, Oval1Height:Double, Oval2X:Double, Oval2Y:Double, Oval2Width:Double, Oval2Height:Double )
	Local Oval1Diameter:Double, Oval2Diameter:Double
	If Oval1Width = Oval1Height Then
		Oval1Diameter = Oval1Width
	Else
		Oval1Diameter = L_GetOvalDiameter( Oval1X, Oval1Y, Oval1Width, Oval1Height, Oval2X, Oval2Y )
	End If
	If Oval2Width = Oval2Height Then
		Oval2Diameter = Oval2Width
	Else
		Oval2Diameter = L_GetOvalDiameter( Oval2X, Oval2Y, Oval2Width, Oval2Height, Oval1X, Oval1Y )
	End If
	If 4.0 * ( ( Oval2X - Oval1X ) * ( Oval2X - Oval1X ) + ( Oval2Y - Oval1Y ) * ( Oval2Y - Oval1Y ) ) < ( Oval2Diameter + Oval1Diameter ) * ( Oval2Diameter + Oval1Diameter ) - L_Inaccuracy Then Return True
End Function



Function L_OvalWithRectangle:Int( OvalX:Double, OvalY:Double, OvalWidth:Double, OvalHeight:Double, RectangleX:Double, RectangleY:Double, RectangleWidth:Double, RectangleHeight:Double )
	Local OvalDiameter:Double
	If OvalWidth = OvalHeight Then
		OvalDiameter = OvalWidth
	Else
		OvalDiameter = L_GetOvalDiameter( OvalX, OvalY, OvalWidth, OvalHeight, RectangleX, RectangleY )
	End If
	If ( RectangleX - RectangleWidth * 0.5 <= OvalX And OvalX <= RectangleX + RectangleWidth * 0.5 ) Or ( RectangleY - RectangleHeight * 0.5 <= OvalY And OvalY <= RectangleY + RectangleHeight * 0.5 ) Then
		If 2.0 * Abs( OvalX - RectangleX ) < OvalDiameter + RectangleWidth - L_Inaccuracy And 2.0 * Abs( OvalY - RectangleY ) < OvalDiameter + RectangleHeight - L_Inaccuracy Then Return True
	Else
		Local DX:Double = Abs( RectangleX - OvalX ) - 0.5 * RectangleWidth
		Local DY:Double = Abs( RectangleY - OvalY ) - 0.5 * RectangleHeight
		If 4.0 * ( DX * DX + DY * DY ) < OvalDiameter * OvalDiameter - L_Inaccuracy Then Return True
	End If
End Function



Function L_RectangleWithRectangle:Int( Rectangle1X:Double, Rectangle1Y:Double, Rectangle1Width:Double, Rectangle1Height:Double, Rectangle2X:Double, Rectangle2Y:Double, Rectangle2Width:Double, Rectangle2Height:Double )
	If 2.0 * Abs( Rectangle1X - Rectangle2X ) < Rectangle1Width + Rectangle2Width - L_Inaccuracy And 2.0 * Abs( Rectangle1Y - Rectangle2Y ) < Rectangle1Height + Rectangle2Height - L_Inaccuracy Then Return True
End Function



Function L_OvalWithLine:Int( OvalX:Double, OvalY:Double, OvalWidth:Double, OvalHeight:Double, LineX1:Double, LineY1:Double, LineX2:Double, LineY2:Double )
	Local A:Double = LineY2 - LineY1
	Local B:Double = LineX1 - LineX2
	Local C1:Double = -A * LineX1 - B * LineY1
	Local AABB:Double = A * A + B * B
	Local D:Double = Abs( A * OvalX + B * OvalY + C1 ) / AABB
	If D < 0.5 * Max( OvalWidth, OvalHeight ) Then
		If L_PivotWithOval( LineX1, LineY1, OvalX, OvalY, OvalWidth, OvalHeight ) Then Return True
		If L_PivotWithOval( LineX2, LineY2, OvalX, OvalY, OvalWidth, OvalHeight ) Then Return True
		Local C2:Double = A * OvalY - B * OvalX
		Local X0:Double = -( A * C1 + B * C2 ) / AABB
		Local Y0:Double = ( A * C2 - B * C1 ) / AABB
		If LineX1 <> LineX2 Then
			If Min( LineX1, LineX2 ) <= X0 And X0 <= Max( LineX1, LineX2 ) Then Return True
		Else
			If Min( LineY1, LineY2 ) <= Y0 And Y0 <= Max( LineY1, LineY2 ) Then Return True
		End If
	End If
End Function



Function L_OvalOverlapsOval:Int( Oval1X:Double, Oval1Y:Double, Oval1Width:Double, Oval1Height:Double, Oval2X:Double, Oval2Y:Double, Oval2Width:Double, Oval2Height:Double )
	Local Oval1Diameter:Double, Oval2Diameter:Double
	If Oval1Width = Oval1Height Then
		Oval1Diameter = Oval1Width
	Else
		Oval1Diameter = L_GetOvalDiameter( Oval1X, Oval1Y, Oval1Width, Oval1Height, Oval2X, Oval2Y )
	End If
	If Oval2Width = Oval2Height Then
		Oval2Diameter = Oval2Width
	Else
		Oval2Diameter = L_GetOvalDiameter( Oval2X, Oval2Y, Oval2Width, Oval2Height, Oval1X, Oval1Y )
	End If
	If 4.0 * ( ( Oval1X - Oval2X ) * ( Oval1X - Oval2X ) + ( Oval1Y - Oval2Y ) * ( Oval1Y - Oval2Y ) ) <= ( Oval1Diameter - Oval2Diameter ) * ( Oval1Diameter - Oval2Diameter ) Then Return True
End Function



Function L_RectangleOverlapsRectangle:Int( Rectangle1X:Double, Rectangle1Y:Double, Rectangle1Width:Double, Rectangle1Height:Double, Rectangle2X:Double, Rectangle2Y:Double, Rectangle2Width:Double, Rectangle2Height:Double )
	If ( Rectangle1X - 0.5 * Rectangle1Width <= Rectangle2X - 0.5 * Rectangle2Width ) And ( Rectangle1Y - 0.5 * Rectangle1Height <= Rectangle2Y - 0.5 * Rectangle2Height ) And ..
		( Rectangle1X + 0.5 * Rectangle1Width >= Rectangle2X + 0.5 * Rectangle2Width ) And ( Rectangle1Y + 0.5 * Rectangle1Height >= Rectangle2Y + 0.5 * Rectangle2Height ) Then Return True
End Function



Function L_GetOvalDiameter:Double( OvalX:Double Var, OvalY:Double Var, OvalWidth:Double, OvalHeight:Double, X:Double, Y:Double )
	If OvalWidth > OvalHeight Then
		OvalX = L_LimitDouble( X, OvalX - 0.5 * ( OvalWidth - OvalHeight ), OvalX + 0.5 * ( OvalWidth - OvalHeight ) )
		Return OvalHeight
	Else
		OvalY = L_LimitDouble( Y, OvalY - 0.5 * ( OvalHeight - OvalWidth ), OvalY + 0.5 * ( OvalHeight - OvalWidth ) )
		Return OvalWidth
	End If
End Function