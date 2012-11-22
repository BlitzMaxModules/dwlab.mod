'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTOval Extends LTShapeType
	Global ServiceOval:LTSprite
	
	Method GetNum:Int()
		Return 1
	End Method
	
	Method GetName:String()
		Return "Oval"
	End Method
	
	Method GetTileSprite:LTSprite( Sprite:LTSprite, DX:Double, DY:Double, XScale:Double, YScale:Double )
		ServiceOval.X = Sprite.X * XScale + DX
		ServiceOval.Y = Sprite.Y * YScale + DY
		ServiceOval.Width = Sprite.Width * XScale
		ServiceOval.Height = Sprite.Height * YScale
		Return ServiceOval
	End Method
End Type

LTOval.ServiceOval = LTSprite.FromShapeType( LTSprite.Oval )
LTShapeType.Register( LTSprite.Oval )