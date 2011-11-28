'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTLayer.bmx"

Rem
bbdoc: Group of shapes.
about: It has a lot of methods duplicating methods of TList.
End Rem
Type LTGroup Extends LTShape
	Rem
	bbdoc: List of shapes.
	End Rem
	Field Children:TList = New TList
	
	' ==================== Drawing ===================
	
	Rem
	bbdoc: Draws the group.
	about: Every child shape will be drawn.
	End Rem
	Method Draw()
		If Visible Then
			For Local Obj:LTShape = Eachin Children
				Obj.Draw()
			Next
		End If
	End Method
	
	
	
	Rem
	bbdoc: Draws group using given visualizer
	about: Every child shape will be drawn using given visualizer
	End Rem
	Method DrawUsingVisualizer( Vis:LTVisualizer )
		If Visible Then
			For Local Obj:LTShape = Eachin Children
				Obj.DrawUsingVisualizer( Vis )
			Next
		End If
	End Method
	
	
	
	Method SetCoords( NewX:Double, NewY:Double )
		For Local Shape:LTShape = Eachin Children
			Shape.SetCoords( Shape.X + NewX - X, Shape.Y + NewY - Y )
		Next
		X = NewX
		Y = NewY
		Update()
	End Method
	
	
	
	Rem
	bbdoc: Initialization method.
	about: Every child shape will be initialized by default.
	End Rem
	Method Init()
		For Local Obj:LTShape = Eachin Children
			Obj.Init()
		Next
	End Method
	
	

	Rem
	bbdoc: Acting method.
	about: Every child shape will be acted.
	End Rem
	Method Act()
		Super.Act()
		If Active Then
			For Local Obj:LTShape = Eachin Children
				If Obj.Active Then
					?debug
					L_SpriteActed = False
					?
					
					Obj.Act()
					
					?debug
					If LTSprite( Obj ) And Not L_SpriteActed Then L_SpritesActed :+ 1
					?
				End If
			Next
		End If
	End Method
	
	' ==================== Collisions ===================
	
	Method GroupFirstSpriteCollision:LTSprite( Sprite:LTSprite, CollisionType:Int )
		Return Sprite.FirstCollidedSpriteOfGroup( Self, CollisionType )
	End Method
	
	
	
	Method SpriteGroupCollisions( Sprite:LTSprite, CollisionType:Int )
		Sprite.CollisionsWithGroup( Self, CollisionType )
	End Method
	
	
	
	Method TileShapeCollisionsWithSprite( Sprite:LTSprite, DX:Double, DY:Double, XScale:Double, YScale:Double, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
		For Local GroupSprite:LTSprite = Eachin Children
			If GroupSprite.TileSpriteCollidesWithSprite( Sprite, DX, DY, XScale, YScale ) Then
				Sprite.HandleCollisionWithTile( TileMap, TileX, TileY, CollisionType )
				Return
			End If
		Next
	End Method
		
	' ==================== List methods ====================
	
	Method AddFirst:TLink( Shape:LTShape )
		Return Children.AddFirst( Shape )
	End Method
	
	
	
	
	Method AddLast:TLink( Shape:LTShape )
		Return Children.AddLast( Shape )
	End Method
	
	
	
	Method Remove( Shape:LTShape )
		Children.Remove( Shape )
	End Method
	
	
	
	Method Clear()
		Children.Clear()
	End Method
	
	
	
	Method ValueAtIndex:LTShape( Index:Int )
		Return LTShape( Children.ValueAtIndex( Index ) )
	End Method
	
	
	
	Method ObjectEnumerator:TListEnum()
		Return Children.ObjectEnumerator()
	End Method
	
	
	
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