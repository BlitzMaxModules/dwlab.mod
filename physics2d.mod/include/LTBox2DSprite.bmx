Rem
bbdoc: 
about: 

See also: #LTVectorSprite
End Rem

Type LTBox2DSprite Extends LTVectorSprite
	Global Pivot1:LTSprite = New LTSprite
	Global Pivot2:LTSprite = New LTSprite
	Global Pivot3:LTSprite = New LTSprite
	Global CircleDefinition:b2CircleDef = New b2CircleDef
	Global PolygonDefinition:b2PolygonDef = New b2PolygonDef
	
	Field Body:b2Body
	Field ListLink:TLink
	
	
	
	Method Init()
		UpdateFromAngularModel()
		ListLink = LTBox2DPhysics.Objects.AddLast( Self )
		
		Local BodyDefinition:b2BodyDef = New b2BodyDef
		Rem
		Select GetParameter( "type" )
			Case "kinematic"
				BodyDefinition.SetType( b2_kinematicBody )
			Case "static"
				BodyDefinition.SetType( b2_staticBody )
			Default
				BodyDefinition.SetType( b2_dynamicBody )
		End Select
		EndRem
		BodyDefinition.SetPosition( Vec2( X, Y ) )
		BodyDefinition.SetAngle( DisplayingAngle )
		
		If ParameterExists( "mass" ) Then BodyDefinition.GetMassData().SetMass( GetParameter( "mass" ).ToFloat() )
		If ParameterExists( "linear_damping" ) Then BodyDefinition.SetLinearDamping( GetParameter( "linear_damping" ).ToFloat() )
		If ParameterExists( "angular_damping" ) Then BodyDefinition.SetAngularDamping( GetParameter( "angular_damping" ).ToFloat() )
		
		Local Friction:Float = GetParameter( "friction" ).ToFloat()
		Local Density:Float = GetParameter( "density" ).ToFloat()
		Local Restitution:Float = GetParameter( "restitution" ).ToFloat()
		
		Body = LTBox2DPhysics.Box2DWorld.CreateBody( BodyDefinition )
		Body.SetLinearVelocity( Vec2( DX, DY ) )
		If ParameterExists( "angular_velocity" ) Then Body.SetAngularVelocity( GetParameter( "angular_velocity" ).ToFloat() )
		
		Select ShapeType
			Case Pivot
				CircleDefinition.SetRadius( 0.0 )
				AttachToBody( CircleDefinition, Friction, Density, Restitution )
			Case Oval
				If Width = Height Then
					CircleDefinition.SetRadius( 0.5 * Width )
					AttachToBody( CircleDefinition, Friction, Density, Restitution )
				Else
					Local DX:Float = Width - Height
					If DX > 0 Then
						PolygonDefinition.SetAsBox( DX, Height )
					Else
						PolygonDefinition.SetAsBox( Width, DY )
					End IF
					AttachToBody( PolygonDefinition, Friction, Density, Restitution )
					
					For Local Sign:Int = -1 To 1 Step 2					
						If DX > 0 Then
							CircleDefinition.SetRadius( 0.5 * Height )
							CircleDefinition.SetLocalPosition( Vec2( 0.5 * DX * Sign, 0.0 ) )
						Else
							CircleDefinition.SetRadius( 0.5 * Width )
							CircleDefinition.SetLocalPosition( Vec2( 0.0, 0.5 * DY * Sign ) )
						End If
						AttachToBody( CircleDefinition, Friction, Density, Restitution )
					Next
					CircleDefinition.SetLocalPosition( Vec2( 0.0, 0.0 ) )
				End If
			Case Rectangle
				PolygonDefinition.SetAsBox( 0.5 * Width, 0.5 * Height )
				AttachToBody( CircleDefinition, Friction, Density, Restitution )
			Case Ray, Raster
			Default
				GetOtherVertices( Pivot1, Pivot2 )
				GetRightAngleVertex( Pivot3  )
				PolygonDefinition.SetVertices( [ PivotToVertex( Pivot1 ), PivotToVertex( Pivot2 ), PivotToVertex( Pivot3 ) ] )
				AttachToBody( CircleDefinition, Friction, Density, Restitution )
		End Select
	End Method
	
	
	
	Function PivotToVertex:b2Vec2( Pivot:LTSprite )
		Return Vec2( Pivot.X, Pivot.Y )
	End Function
	
	
	
	Method AttachToBody( ShapeDefinition:b2ShapeDef, Friction:Float, Density:Float, Restitution:Float )
		ShapeDefinition.SetFriction( Friction )
		ShapeDefinition.SetDensity( Density )
		ShapeDefinition.SetRestitution( Restitution )
		Body.CreateShape( ShapeDefinition )
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