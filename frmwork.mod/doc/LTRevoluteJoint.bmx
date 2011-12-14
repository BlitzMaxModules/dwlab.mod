SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const Period:Double = 2.0
	Field World:LTWorld = LTWorld.FromFile( "human.lw" )
	Field Layer:LTLayer = LTLayer( World.FindShapeWithType( "LTLayer" ) )
	Field Body:LTSprite = LTSprite( Layer.FindShape( "body" ) )
	Field UpperArm:LTSprite[] = New LTSprite[ 2 ]
	Field LowerArm:LTSprite[] = New LTSprite[ 2 ]
	Field UpperLeg:LTSprite[] = New LTSprite[ 2 ]
	Field LowerLeg:LTSprite[] = New LTSprite[ 2 ]
	Field Foot:LTSprite[] = New LTSprite[ 2 ]

	Method Init()
		Layer.FindShape( "head" ).AttachModel( LTFixedJoint.Create( Body ) )
		For local N:Int = 0 To 1
			Local Prefix:String = [ "inner_", "outer_" ][ N ]
			UpperArm[ N ] = LTSprite( Layer.FindShape( Prefix + "upper_arm" ) )
			LowerArm[ N ] = LTSprite( Layer.FindShape( Prefix + "lower_arm" ) )
			UpperArm[ N ].AttachModel( LTRevoluteJoint.Create( Body, 0, -0.333 ) )
			LowerArm[ N ].AttachModel( LTRevoluteJoint.Create( UpperArm[ N ], 0, -0.333 ) )
			Layer.FindShape( Prefix + "fist" ).AttachModel( LTFixedJoint.Create( LowerArm[ N ]  ) )
			UpperLeg[ N ] = LTSprite( Layer.FindShape( Prefix + "upper_leg" ) )
			LowerLeg[ N ] = LTSprite( Layer.FindShape( Prefix + "lower_leg" ) )
			Foot[ N ] = LTSprite( Layer.FindShape( Prefix + "foot" ) )
			UpperLeg[ N ].AttachModel( LTRevoluteJoint.Create( Body, 0, -0.375 ) )
			LowerLeg[ N ].AttachModel( LTRevoluteJoint.Create( UpperLeg[ N ], 0, -0.375 ) )
			Foot[ N ].AttachModel( LTFixedJoint.Create( LowerLeg[ N ] ) )
		Next
		L_CurrentCamera.JumpTo( Body )
		L_InitGraphics()
		Body.Angle = 16
	End Method
	
	Method Logic()

		Local Angle:Double = 360 / Period * Time
		Body.Y = -Sin( Angle * 2 + 240 ) * 0.25 - 5.5
			
		UpperArm[ 0 ].Angle = -Sin( Angle + 90 ) * 60
		LowerArm[ 0 ].Angle = UpperArm[ 0 ].Angle - 45 - Sin( Angle + 90 ) * 30
		UpperLeg[ 0 ].Angle = Cos( Angle ) * 45
		LowerLeg[ 0 ].Angle = UpperLeg[ 0 ].Angle + Sin( Angle + 60 ) * 60 + 60
		
		UpperArm[ 1 ].Angle = Sin( Angle + 90 ) * 60
		LowerArm[ 1 ].Angle = UpperArm[ 1 ].Angle - 45 + Sin( Angle + 90 ) * 30
		UpperLeg[ 1 ].Angle = Cos( Angle + 180 ) * 45
		LowerLeg[ 1 ].Angle = UpperLeg[ 1 ].Angle + Sin( Angle + 240 ) * 60 + 60
		
		Layer.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
	End Method
End Type