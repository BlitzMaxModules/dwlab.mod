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
	Field ListLink:TLink
	
	
	
	Method GetClassTitle:String()
		Return "Box2D sprite"
	End Method
	
	
	
	Method Init()
		UpdateFromAngularModel()
		ListLink = LTBox2DPhysics.Objects.AddLast( Self )
		
		Local BodyDefinition:b2BodyDef = New b2BodyDef
		BodyDefinition.SetPosition( Vec2( X, Y ) )
		BodyDefinition.SetAngle( DisplayingAngle )
		
		If ParameterExists( "linear_damping" ) Then BodyDefinition.SetLinearDamping( GetParameter( "linear_damping" ).ToFloat() )
		If ParameterExists( "angular_damping" ) Then BodyDefinition.SetAngularDamping( GetParameter( "angular_damping" ).ToFloat() )
		
		Body = LTBox2DPhysics.Box2DWorld.CreateBody( BodyDefinition )
		Body.SetLinearVelocity( Vec2( Velocity * Cos( Angle ), Velocity * Sin( Angle ) ) )
		If ParameterExists( "angular_velocity" ) Then Body.SetAngularVelocity( GetParameter( "angular_velocity" ).ToFloat() )
		
		AttachSpriteShapesToBody( Self, LTBox2DShapeParameters.FromShape( Self ), Body )
		Body.SetMassFromShapes()
	End Method
	
	
	
	Function AttachSpriteShapesToBody( Sprite:LTSprite, ShapeParameters:LTBox2DShapeParameters, Body:b2Body )
		Select Sprite.ShapeType
			Case Pivot
				CircleDefinition.SetRadius( 0.0 )
				AttachToBody( Body, CircleDefinition, ShapeParameters )
			Case Oval
				If Sprite.Width = Sprite.Height Then
					CircleDefinition.SetRadius( 0.5 * Sprite.Width )
					AttachToBody( Body, CircleDefinition, ShapeParameters )
				Else
					Local DX:Float = Sprite.Width - Sprite.Height
					If DX > 0 Then
						PolygonDefinition.SetAsBox( DX, Sprite.Height )
					Else
						PolygonDefinition.SetAsBox( Sprite.Width, -DX )
					End IF
					AttachToBody( Body, PolygonDefinition, ShapeParameters )
					
					For Local Sign:Int = -1 To 1 Step 2					
						If DX > 0 Then
							CircleDefinition.SetRadius( 0.5 * Sprite.Height )
							CircleDefinition.SetLocalPosition( Vec2( 0.5 * DX * Sign, 0.0 ) )
						Else
							CircleDefinition.SetRadius( 0.5 * Sprite.Width )
							CircleDefinition.SetLocalPosition( Vec2( 0.0, -0.5 * DX * Sign ) )
						End If
						AttachToBody( Body, CircleDefinition, ShapeParameters )
					Next
					CircleDefinition.SetLocalPosition( Vec2( 0.0, 0.0 ) )
				End If
			Case Rectangle
				PolygonDefinition.SetAsBox( 0.5 * Sprite.Width, 0.5 * Sprite.Height )
				AttachToBody( Body, PolygonDefinition, ShapeParameters )
			Case Ray, Raster
			Default
				Sprite.GetOtherVertices( Pivot1, Pivot2 )
				Sprite.GetRightAngleVertex( Pivot3  )
				PolygonDefinition.SetVertices( [ PivotToVertex( Pivot1 ), PivotToVertex( Pivot2 ), PivotToVertex( Pivot3 ) ] )
				AttachToBody( Body, PolygonDefinition, ShapeParameters )
		End Select
	End Function
	
	
	
	
	Function PivotToVertex:b2Vec2( Pivot:LTSprite )
		Return Vec2( Pivot.X, Pivot.Y )
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
		CopyTo( NewSprite )
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
	
	
	
	Method Destroy()
		ListLink.Remove()
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