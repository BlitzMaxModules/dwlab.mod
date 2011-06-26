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
bbdoc: 
returns: 
about: 
End Rem
Type LTBehaviorModel Extends LTObject
	Field Active:Int
	Field Link:TLink
	
	
	
	Rem
	bbdoc: 
	returns: 
	about: 
	End Rem
	Method Init( Shape:LTShape )
	End Method

	
	
	Rem
	bbdoc: 
	returns: 
	about: 
	End Rem
	Method Activate( Shape:LTShape )
	End Method
	
	
	
	Rem
	bbdoc: 
	returns: 
	about: 
	End Rem
	Method Deactivate( Shape:LTShape )
	End Method
	
	
	
	Rem
	bbdoc: 
	returns: 
	about: 
	End Rem
	Method Watch( Shape:LTShape )
	End Method
	
	
	
	Rem
	bbdoc: 
	returns: 
	about: 
	End Rem
	Method ApplyTo( Shape:LTShape )
	End Method
	
	
	
	Rem
	bbdoc: 
	returns: 
	about: 
	End Rem
	Method HandleCollisionWithSprite( Sprite1:LTSprite, Sprite2:LTSprite, CollisionType:Int )
	End Method

	
	
	Rem
	bbdoc: 
	returns: 
	about: 
	End Rem
	Method HandleCollisionWithTile( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
	End Method

	
	
	Rem
	bbdoc: 
	returns: 
	about: 
	End Rem
	Method ActivateModel( Shape:LTShape )
		Activate( Shape )
		Active = True
	End Method
	
	
	
	Rem
	bbdoc: 
	returns: 
	about: 
	End Rem
	Method DeactivateModel( Shape:LTShape )
		Deactivate( Shape )
		Active = False
	End Method
	
	
	
	Rem
	bbdoc: 
	returns: 
	about: 
	End Rem
	Method Remove( Shape:LTShape )
		If Active Then DeactivateModel( Shape )
		Link.Remove()
	End Method
End Type