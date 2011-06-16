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
	Field DX:Double, DY:Double
	
	' ==================== Position ====================
	
	Method MoveForward()
		SetCoords( X + DX * L_DeltaTime, Y + DY * L_DeltaTime )
	End Method
	
	' ==================== Other ====================
	
	Method Clone:LTShape()
		Local NewSprite:LTVectorSprite = New LTVectorSprite
		CopyTo( NewSprite )
		Return NewSprite
	End Method

	
	
	Method CopyTo( Shape:LTShape )
		Super.CopyTo( Shape )
		Local Sprite:LTVectorSprite = LTVectorSprite( Shape )
		
		?debug
		If Not Sprite Then L_Error( "Trying to copy vector sprite ~q" + Shape.Name + "~q data to non-vector sprite" )
		?
		
		Sprite.DX = DX
		Sprite.DY = DY
	End Method

	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageDoubleAttribute( "dx", DX )
		XMLObject.ManageDoubleAttribute( "dy", DY )
	End Method
End Type