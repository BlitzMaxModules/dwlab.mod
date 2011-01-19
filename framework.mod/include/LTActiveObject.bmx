'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
Include "LTList.bmx"
Include "LTShape.bmx"

Type LTActiveObject Extends LTObject

	
	' ==================== Drawing ===================
	
	Method Draw()
	End Method
	
	
	
	Method DrawUsingVisualizer( Vis:LTVisualizer )
	End Method
	
	' ==================== Collisions ===================
	
	Method GetCollisionType:Int( Obj:LTActiveObject )
	End Method
	
	
	Rem
	bbdoc:Checks if objects collide.
	returns:True if objects collide.
	EndRem
	Method CollidesWith:Int( Obj:LTActiveObject )
	End Method
	
	
	
	Method CollidesWithSprite:Int( Sprite:LTSprite )
	End Method
	
	
	
	Method CollidesWithLine:Int( Line:LTLine )
	End Method
	
	
	Rem
	bbdoc:Checks collisions of objects and executes @HandleCollision for each collision.
	EndRem
	Method CollisionsWith( Obj:LTActiveObject )
	End Method
	
	
	
	Method CollisionsWithSprite( Sprite:LTSprite )
	End Method
	
	
	
	Method CollisionsWithLine( Line:LTLine )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method HandleCollisionWith( Obj:LTActiveObject, CollisionType:Int )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
	End Method
	
	' ==================== Pushing ====================
	
	Rem
	bbdoc:Wedges off shapes.
	about:Wedging off depends on masses of shapes:
	[ First shape | Second shape | Result 
	* less than 0 | bigger than 0 | Second shape will move from first, first will remain unmoved
	* more than 0 | 0 | Second shape will move from first, first will remain unmoved
	* less than 0 | less than 0 | Shapes will be moved from each other with same coefficients.
	* 0 | 0 | Shapes will be moved from each other with same coefficients.
	]	 
	EndRem
	Method WedgeOffWith( Obj:LTActiveObject, SelfMass:Float, ShapeMass:Float )
	End Method


	
	Method WedgeOffWithSprite( Sprite:LTSprite, SelfMass:Float, SpriteMass:Float )
	End Method
	
	
	
	Method PushFrom( Obj:LTActiveObject )
		WedgeOffWith( Obj, 0.0, 1.0 )
	End Method	
	
	' ==================== Other ===================
	
	Method Act()
	End Method
	
	
	
	Method Update()
	End Method
	
	
	
	Method Destroy()
	End Method
End Type