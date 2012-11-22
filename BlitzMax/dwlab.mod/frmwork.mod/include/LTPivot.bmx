'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTPivot Extends LTShapeType
	Global ServicePivot:LTSprite
	
	Method GetNum:Int()
		Return 0
	End Method
	
	Method GetName:String()
		Return "Pivot"
	End Method
	
	Method GetTileSprite:LTSprite( Sprite:LTSprite, DX:Double, DY:Double, XScale:Double, YScale:Double )
		ServicePivot.X = Sprite.X * XScale + DX
		ServicePivot.Y = Sprite.Y * YScale + DY
		Return ServicePivot
	End Method
End Type

LTShapeType.Register( LTSprite.Pivot )
LTPivot.ServicePivot = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )