'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "TChaingun.bmx"

Type TPlayer Extends LTSprite
	Const MinTargetDistance:Double = 1.25

	
	
	Field Weapon:TChaingun[] = New TChaingun[ 2 ]
	Field Visor:LTSprite
	
	
	
	Method Init()
		Game.Player = Self
		Visor = LTSprite( Game.Level.FindShape( "Visor" ) )
		Visor.AttachModel( LTFixedJoint.Create( Self ) )
	End Method
	
	
	
	Method Act()
		MoveUsingWSAD( Velocity )
		
		If DistanceTo( Game.Target ) < MinTargetDistance Then
			Local TargetAngle:Double = DirectionTo( Game.Target )
			Game.Target.SetCoords( X + Cos( TargetAngle ) * MinTargetDistance, Y + Sin( TargetAngle ) * MinTargetDistance )
		End If
		DirectTo( Game.Target )
		
	    LimitWith( Game.Level.Bounds )
		
		CollisionsWithSpriteMap( Game.Blocks, PlayerCollisionWithBlock )
		CollisionsWithSpriteMap( Game.Trees, PlayerCollisionWithTree )
	End Method
End Type



Global PlayerCollisionWithBlock:TPlayerCollisionWithBlock = New TPlayerCollisionWithBlock
Type TPlayerCollisionWithBlock Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Sprite1.WedgeOffWithSprite( Sprite2, 6.0, Sprite2.Height * Sprite2.Width )
		Game.ActingMap.Insert( Sprite2, Null )
	End Method
End Type



Global PlayerCollisionWithTree:TPlayerCollisionWithTree = New TPlayerCollisionWithTree
Type TPlayerCollisionWithTree Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Sprite1.PushFromSprite( Sprite2 )
	End Method
End Type