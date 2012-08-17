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
about: 
End Rem

Type LTBox2DSprite Extends LTSprite
	Global Pivot1:LTSprite = New LTSprite
	Global Pivot2:LTSprite = New LTSprite
	Global Pivot3:LTSprite = New LTSprite
	Global CircleDefinition:b2CircleDef = New b2CircleDef
	Global PolygonDefinition:b2PolygonDef = New b2PolygonDef
	Global ShapeParameters:b2ShapeDef = New b2ShapeDef
	
	Field Body:b2Body
	
	
	
	Method GetClassTitle:String()
		Return "Box2D sprite"
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
		
		AttachSpriteShapesToBody( Self, LTBox2DShapeParameters.FromShape( Self ), Body )
		Body.SetMassFromShapes()
	End Method
	
	
	
	Function AttachSpriteShapesToBody( Sprite:LTSprite, ShapeParameters:LTBox2DShapeParameters, Body:b2Body, X:Float = 0.0, Y:Float = 0.0 )
		Select Sprite.ShapeType
			Case Pivot
				CircleDefinition.SetLocalPosition( Vec2( X, Y ) )
				CircleDefinition.SetRadius( 0.0 )
				AttachToBody( Body, CircleDefinition, ShapeParameters )
			Case Oval
				If Sprite.Width = Sprite.Height Then
					CircleDefinition.SetLocalPosition( Vec2( X, Y ) )
					CircleDefinition.SetRadius( 0.5 * Sprite.Width )
					AttachToBody( Body, CircleDefinition, ShapeParameters )
				Else
					Local DX:Float = Sprite.Width - Sprite.Height
					If DX > 0 Then
						PolygonDefinition.SetAsOrientedBox( 0.5 * DX, 0.5 * Sprite.Height, Vec2( X, Y ), 0.0 )
					Else
						PolygonDefinition.SetAsOrientedBox( 0.5 * Sprite.Width, -0.5 * DX, Vec2( X, Y ), 0.0 )
					End IF
					AttachToBody( Body, PolygonDefinition, ShapeParameters )
					
					For Local Sign:Int = -1 To 1 Step 2					
						If DX > 0 Then
							CircleDefinition.SetLocalPosition( Vec2( X + 0.5 * DX * Sign, Y ) )
							CircleDefinition.SetRadius( 0.5 * Sprite.Height )
						Else
							CircleDefinition.SetLocalPosition( Vec2( X, Y + 0.5 * DX * Sign ) )
							CircleDefinition.SetRadius( 0.5 * Sprite.Width )
						End If
						AttachToBody( Body, CircleDefinition, ShapeParameters )
					Next
				End If
			Case Rectangle
				PolygonDefinition.SetAsOrientedBox( 0.5 * Sprite.Width, 0.5 * Sprite.Height, Vec2( X, Y ), 0.0 )
				AttachToBody( Body, PolygonDefinition, ShapeParameters )
			Case Ray, Raster
			Default
				Local HalfWidth:Double = 0.5 * Sprite.Width
				Local HalfHeight:Double = 0.5 * Sprite.Height
				Select Sprite.ShapeType
					Case LTSprite.TopLeftTriangle
						PolygonDefinition.SetVertices( [ Vec2( X - HalfWidth, Y - HalfHeight ), Vec2( X + HalfWidth, Y - HalfHeight ), Vec2( X - HalfWidth, Y + HalfHeight ) ] )
					Case LTSprite.TopRightTriangle
						PolygonDefinition.SetVertices( [ Vec2( X - HalfWidth, Y - HalfHeight ), Vec2( X + HalfWidth, Y - HalfHeight ), Vec2( X + HalfWidth, Y + HalfHeight ) ] )
					Case LTSprite.BottomLeftTriangle
						PolygonDefinition.SetVertices( [ Vec2( X - HalfWidth, Y - HalfHeight ), Vec2( X + HalfWidth, Y + HalfHeight ), Vec2( X - HalfWidth, Y + HalfHeight ) ] )
					Case LTSprite.BottomRightTriangle
						PolygonDefinition.SetVertices( [ Vec2( X - HalfWidth, Y + HalfHeight ), Vec2( X + HalfWidth, Y - HalfHeight ), Vec2( X + HalfWidth, Y + HalfHeight ) ] )
				End Select
				AttachToBody( Body, PolygonDefinition, ShapeParameters )
		End Select
	End Function
	
	
	
	Function AttachToBody( Body:b2Body, ShapeDefinition:b2ShapeDef, ShapeParameters:LTBox2DShapeParameters )
		ShapeDefinition.SetFriction( ShapeParameters.Friction )
		ShapeDefinition.SetDensity( ShapeParameters.Density )
		ShapeDefinition.SetRestitution( ShapeParameters.Restitution )
		Body.CreateShape( ShapeDefinition )
	End Function
	
	
	
	Method SetCoords( NewX:Double, NewY:Double )
		If Body Then
		Else
			Super.SetCoords( NewX, NewY )
		End If
	End Method
	
	
	
	Method Clone:LTShape()
		Local NewSprite:LTBox2DSprite = New LTBox2DSprite
		CopySpriteTo( NewSprite )
		Return NewSprite
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





Type LTBox2DShapeParameters
	Field Friction:Float = 0.5
	Field Density:Float = 1.0
	Field Restitution:Float = 0.1
	
	
	
	Function FromShape:LTBox2DShapeParameters( Shape:LTShape )
		Local Parameters:LTBox2DShapeParameters = New LTBox2DShapeParameters
		If Shape.ParameterExists( "friction" ) Then Parameters.Friction = Shape.GetParameter( "friction" ).ToFloat()
		If Shape.ParameterExists( "density" ) Then Parameters.Density = Shape.GetParameter( "density" ).ToFloat()
		If Shape.ParameterExists( "restitution" ) Then Parameters.Restitution = Shape.GetParameter( "restitution" ).ToFloat()
		Return Parameters
	End Function
End Type