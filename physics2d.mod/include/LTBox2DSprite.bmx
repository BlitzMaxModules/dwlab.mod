Rem
bbdoc: 
about: 

See also: #LTVectorSprite
End Rem
Type LTBox2DSprite Extends LTVectorSprite
	Field Body:b2Body
	Field ListLink:TLink
	
	
	Method Init()
		UpdateFromAngularModel()
		ListLink = LTBox2DPhysics.Objects.AddLast( Self )
		
		Local BodyDefinition:b2BodyDef = New b2BodyDef
		Select GetParameter( "type" )
			Case "kinematic"
				BodyDefinition.SetType( b2_kinematicBody )
			Case "static"
				BodyDefinition.SetType( b2_staticBody )
			Default
				BodyDefinition.SetType( b2_dynamicBody )
		End Select
		BodyDefinition.SetPosition( New b2Vec2.Create( X, Y ) )
		BodyDefinition.SetLinearVelocity( New b2Vec2.Create( DX, DY ) )
		BodyDefinition.SetAngle( DisplayingAngle )
		
		If ParameterExists( "linear_damping" ) Then BodyDefinition.SetLinearDamping( GetParameter( "linear_damping" ).ToFloat() )
		If ParameterExists( "linear_damping" ) Then BodyDefinition.SetLinearDamping( GetParameter( "linear_damping" ).ToFloat() )
		If ParameterExists( "angular_velocity" ) Then BodyDefinition.SetAngularVelocity( GetParameter( "angular_velocity" ).ToFloat() )
		If ParameterExists( "angular_damping" ) Then BodyDefinition.SetAngularDamping( GetParameter( "angular_damping" ).ToFloat() )
		
		Body = LTBox2DPhysics.World.CreateBody( BodyDefinition )
		
		Select ShapeType
			Case Pivot
				Local Shape:b2CircleShape = New b2CircleShape
				Shape.Create()
				Shape.SetRadius( 0 )
				AttachShape( Shape )
			Case Oval
				If Width = Height Then
					Local Shape:b2CircleShape = New b2CircleShape
					Shape.Create()
					Shape.SetAsBox
					Shape.SetRadius( Width )
					AttachShape( Shape )
				ElseIf Width > Height
					Local Shape:b2CircleShape = New b2CircleShape
					Shape.Create()
					Shape.SetRadius( Height )
					AttachShape( Shape )
					
					Local BoxShape:b2PolygonShape = New b2PolygonShape
					BoxShape.Create()
					BoxShape.SetAsBox( 0.5 * ( Width - Height ), 0.5 * Height )
					AttachShape( BoxShape  )
					
					Shape = New b2CircleShape
					Shape.Create()
					Shape.SetRadius( Height )
					AttachShape( Shape  )
				Else
				
				End If
			Case Rectangle
				Local Shape:b2PolygonShape = New b2PolygonShape
				Shape.Create()
				Shape.SetAsBox( 0.5 * Width, 0.5 * Height )
				AttachShape( Shape )
		End Select
	End Method
	
	
	
	Method AttachShape( Shape:b2Shape )
		Local FixtureDefinition:b2FixtureDef = New b2FixtureDef
		FixtureDefinition.SetShape( Shape )
		Body.CreateFixture( FixtureDefinition )
	End Method
	
	
	
	Method SetCoords( NewX:Double, NewY:Double )

	End Method
	
	
	
	Method Update()
		Local Vector:b2Vec2 = Body.GetPosition()
		X = Vector.X()
		Y = Vector.Y()
		Vector = Body.GetLinearVelocity()
		DX = Vector.X()
		DY = Vector.Y()
		UpdateAngularModel()
		DisplayingAngle = Body.GetAngle()
	End Method
	
	
	
	Method Destroy()
		ListLink.Remove()
	End Method
End Type