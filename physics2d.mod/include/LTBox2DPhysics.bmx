'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTBox2DPhysics
	Global Box2DWorld:b2World
	Global VelocityIterations:Int = 10
	Global PositionIterations:Int = 8
	
	
	
	Function InitWorld( World:LTLayer )
		Local Gravity:Float = 10.0
		If World.ParameterExists( "gravity" ) Then Gravity = World.GetParameter( "gravity" ).ToFloat()
		Box2DWorld = b2World.CreateWorld( b2AABB.CreateAABB( Vec2( World.Bounds.LeftX(), World.Bounds.TopY() ), ..
				Vec2( World.Bounds.RightX(), World.Bounds.BottomY() ) ), Vec2( 0, Gravity ), True )
		ProcessLayer( World )
	End Function
	
	
	
	Function ProcessLayer( Layer:LTLayer )
		For Local Shape:LTShape = Eachin Layer.Children
			Local ChildLayer:LTLayer = LTLayer( Shape )
			If ChildLayer Then
				ProcessLayer( ChildLayer )
			ElseIf Shape.Physics() Then
				Shape.Init()
			End If
		Next
	End Function
	
	
	
	Function Logic( TimeStep:Float )
		Box2DWorld.DoStep( TimeStep, VelocityIterations, PositionIterations )
		Box2DWorld.Validate()
	End Function
End Type
