'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TNewColorBall Extends LTTemporaryModel
	Field X:Double, Y:Double, Angle:Double
	
	Function Create( TileX:Int, TileY:Int, Angle:Double )
	End Function
	
	Method ApplyTo( Shape:LTShape )
		Local K:Double = ( Game.Time - StartingTime ) / Period
		Shape.SetCoords( X + Cos( Angle ) * K, Y + Sin( Angle ) * K )
		Shape.SetDiameter( K )
		Super.ApplyTo( Shape )
	End Method
End Type