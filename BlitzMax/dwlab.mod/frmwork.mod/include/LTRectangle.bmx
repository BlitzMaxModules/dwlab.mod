'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTRectangle Extends LTShapeType
	Global ServiceRectangle:LTSprite
	
	Method GetNum:Int()
		Return 2
	End Method
	
	Method GetName:String()
		Return "Rectangle"
	End Method
	
	Method GetTileSprite:LTSprite( Sprite:LTSprite, DX:Double, DY:Double, XScale:Double, YScale:Double )
		ServiceRectangle.X = Sprite.X * XScale + DX
		ServiceRectangle.Y = Sprite.Y * YScale + DY
		ServiceRectangle.Width = Sprite.Width * XScale
		ServiceRectangle.Height = Sprite.Height * YScale
		Return ServiceRectangle
	End Method
End Type

LTRectangle.ServiceRectangle = LTSprite.FromShapeType( LTSprite.Rectangle )
LTShapeType.Register( LTSprite.Rectangle )