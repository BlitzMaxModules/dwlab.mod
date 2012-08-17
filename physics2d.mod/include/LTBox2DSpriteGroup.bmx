' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTBox2DSpriteGroup Extends LTSpriteGroup
	Global ServiceSprite:LTSprite = New LTSprite
	
	Field Body:b2Body
	
	
	
	Method GetClassTitle:String()
		Return "Box2D sprite group"
	End Method
	
	
	
	Method Init()
		Local BodyDefinition:b2BodyDef = New b2BodyDef
		BodyDefinition.SetPosition( Vec2( X, Y ) )
		BodyDefinition.SetAngle( Angle )
		
		If ParameterExists( "linear_damping" ) Then BodyDefinition.SetLinearDamping( GetParameter( "linear_damping" ).ToFloat() )
		If ParameterExists( "angular_damping" ) Then BodyDefinition.SetAngularDamping( GetParameter( "angular_damping" ).ToFloat() )
		
		Body = LTBox2DPhysics.Box2DWorld.CreateBody( BodyDefinition )
		Body.SetLinearVelocity( Vec2( Velocity * Cos( Angle ), Velocity * Sin( Angle ) ) )
		If ParameterExists( "angular_velocity" ) Then Body.SetAngularVelocity( GetParameter( "angular_velocity" ).ToFloat() )
		
		Local Parameters:LTBox2DShapeParameters = LTBox2DShapeParameters.FromShape( Self )
		For Local Sprite:LTSprite = Eachin Children
			ServiceSprite.Width = Sprite.Width * Width
			ServiceSprite.Height = Sprite.Height * Height
			ServiceSprite.ShapeType = Sprite.ShapeType
			LTBox2DSprite.AttachSpriteShapesToBody( ServiceSprite, Parameters, Body, Sprite.X * Width, Sprite.Y * Height )
		Next
		
		Body.SetMassFromShapes()
	End Method
	
	
	
	Method SetCoords( NewX:Double, NewY:Double )
		If Body Then
		Else
			Super.SetCoords( NewX, NewY )
		End If
	End Method
	
	
	
	Method Clone:LTShape()
		Local NewSpriteGroup:LTBox2DSpriteGroup = New LTBox2DSpriteGroup
		CopySpriteTo( NewSpriteGroup )
		For Local Sprite:LTSprite = Eachin Children
			NewSpriteGroup.Children.AddLast( Sprite.Clone() )
		Next
		Return NewSpriteGroup
	End Method
	
	
	
	Method Update()
		If Body Then
			Local Vector:b2Vec2 = Body.GetPosition()
			X = Vector.X()
			Y = Vector.Y()
			Angle = Body.GetAngle()
		End If
	End Method
	
	
	
	Method Physics:Int()
		Return True
	End Method
End Type