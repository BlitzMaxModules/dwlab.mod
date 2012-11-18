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
bbdoc: Sprite collision handling class.
about: Sprite collision check method with specified collision handler will execute this handler's method on collision one sprite with another.

See also: #Active example
End Rem
Type LTSpriteCollisionHandler Extends LTObject
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
	End Method
End Type



Rem
bbdoc: Sprite and tile collision handling class.
about: Collision check method with specified collision handler will execute this handler's method on collision sprite with tile.

See also: #Active example
End Rem
Type LTSpriteAndTileCollisionHandler Extends LTObject
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionSprite:LTSprite )
	End Method
End Type



Rem
bbdoc: Sprite and line collision handling class.
about: Collision check method with specified collision handler will execute this handler's method on collision sprite with line.

See also: #Active example
End Rem
Type LTSpriteAndLineSegmentCollisionHandler Extends LTObject
	Method HandleCollision( Sprite:LTSprite, LineSegment:LTLineSegment )
	End Method
End Type
