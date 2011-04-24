'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
	
Type LTVectorSprite Extends LTSprite
	Field DX:Float, DY:Float
	
	' ==================== Position ====================
	
	Method MoveForward()
		SetCoords( X + DX * L_DeltaTime, Y + DY * L_DeltaTime )
	End Method
	
	' ==================== Other ====================
	
	Method Clone:LTShape()
		Local NewSprite:LTVectorSprite = New LTVectorSprite
		CopyVectorSpriteTo( NewSprite )
		Return NewSprite
	End Method

	
	
	Method CopyVectorSpriteTo( Sprite:LTVectorSprite )
		CopyShapeTo( Sprite )
		Sprite.ShapeType = ShapeType
		Sprite.DX = DX
		Sprite.DY = DY
		Sprite.Frame = Frame
	End Method

	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageFloatAttribute( "dx", DX )
		XMLObject.ManageFloatAttribute( "dy", DY )
	End Method
End Type