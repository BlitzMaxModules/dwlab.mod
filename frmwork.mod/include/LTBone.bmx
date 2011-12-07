'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTBone Extends LTLine
	Field MovingResistance:Double[] = New Double[ 2 ]
	Field Distance:Double
	
	Function FromPivotsAndResistances:LTBone( Pivot1:LTSprite, Pivot2:LTSprite, Pivot1MovingResistance:Double = 0.5, Pivot2MovingResistance:Double = 0.5 )
		Local Bone:LTBone = New LTBone
		Bone.Pivot[ 0 ] = Pivot1
		Bone.Pivot[ 1 ] = Pivot2
		Bone.MovingResistance[ 0 ] = Pivot1MovingResistance
		Bone.MovingResistance[ 1 ] = Pivot2MovingResistance
		Bone.Distance = Pivot1.DistanceTo( Pivot2 )
		Return Bone
	End Function
	
	Method Act()
		Local Pivot0:LTVectorSprite = LTVectorSprite( Pivot[ 0 ] )
		Local Pivot1:LTVectorSprite = LTVectorSprite( Pivot[ 1 ] )
		Local K:Double = 1.0 - Distance / Pivot0.DistanceTo( Pivot1 )
		Pivot0.DX = 0.9 * Pivot0.DX + 0.1 * ( Pivot1.X - Pivot0.X ) * K
		Pivot0.DY = 0.9 * Pivot0.DY + 0.1 * ( Pivot1.Y - Pivot0.Y ) * K
		Pivot1.DX = 0.9 * Pivot1.DX - 0.1 * ( Pivot1.X - Pivot0.X ) * K
		Pivot1.DY = 0.9 * Pivot1.DY - 0.1 * ( Pivot1.Y - Pivot0.Y ) * K
	End Method
End Type