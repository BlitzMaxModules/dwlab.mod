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
bbdoc: Group of shapes.
about: It has a lot of methods duplicating methods of TList.
End Rem
Type LTGroup Extends LTShape
	Rem
	bbdoc: List of sprites.
	End Rem
	Field Children:TList = New TList
	
	' ==================== Drawing ===================
	
	Method Draw()
		For Local Sprite:LTSprite = Eachin Children
			Sprite.Draw()
		Next
	End Method
	
	
	
	Method DrawUsingVisualizer( Vis:LTVisualizer )
		For Local Sprite:LTSprite = Eachin Children
			Sprite.DrawUsingVisualizer( Vis )
		Next
	End Method
	
	' ==================== Collisions ===================
	
	Method TileShapeCollisionsWithSprite( Sprite:LTSprite, DX:Double, DY:Double, XScale:Double, YScale:Double, TileMap:LTTileMap, TileX:Int, TileY:Int, Handler:LTSpriteAndTileCollisionHandler )
		For Local GroupSprite:LTSprite = Eachin Children
			If GroupSprite.TileSpriteCollidesWithSprite( Sprite, DX, DY, XScale, YScale ) Then
				Handler.HandleCollision( Sprite, TileMap, TileX, TileY )
				Return
			End If
		Next
	End Method
		
	' ==================== List wrapping methods ====================
	

	Method AddFirst:TLink( Sprite:LTShape )
		Return Children.AddFirst( Sprite )
	End Method
	
	
	
	
	Method AddLast:TLink( Sprite:LTSprite )
		Return Children.AddLast( Sprite )
	End Method
	
	
	
	Method Clear()
		Children.Clear()
	End Method
	
	
	
	Method Remove( Shape:LTShape )
		Children.Remove( Shape )
	End Method
	
	
	
	Method ValueAtIndex:LTShape( Index:Int )
		Return LTSprite( Children.ValueAtIndex( Index ) )
	End Method
	
	
	
	Method ObjectEnumerator:TListEnum()
		Return Children.ObjectEnumerator()
	End Method
	
	' ==================== Cloning ====================
	
	Method Clone:LTShape()
		Local NewGroup:LTGroup = New LTGroup
		For Local Shape:LTShape = Eachin NewGroup.Children
			NewGroup.Children.AddLast( Shape.Clone() )
		Next
		Return NewGroup
	End Method
	
	' ==================== Saving / loading ====================
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageChildList( Children )
	End Method
End Type