'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTTopLeftTriangle Extends LTShapeType
	Global ServiceTriangle:LTSprite = New LTSprite
	
	Method GetNum:Int()
		Return 4
	End Method
	
	Method GetTileSprite:LTSprite( Sprite:LTSprite, DX:Double, DY:Double, XScale:Double, YScale:Double )
		ServiceTriangle.X = Sprite.X * XScale + DX
		ServiceTriangle.Y = Sprite.Y * YScale + DY
		ServiceTriangle.Width = Sprite.Width * XScale
		ServiceTriangle.Height = Sprite.Height * YScale
		ServiceTriangle.ShapeType = Sprite.ShapeType
		Return ServiceTriangle
	End Method
End Type

LTShapeType.Register( LTSprite.TopLeftTriangle )