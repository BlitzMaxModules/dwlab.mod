SuperStrict

Framework brl.basic

Import dwlab.frmwork

Local Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Hinge:LTSprite = LTSprite.FromShape( 0, -8, 1, 1, LTSprite.Oval )
	Field Weight:LTVectorSprite = LTVectorSprite.FromShapeAndVector( -8, -6, 3, 3, LTSprite.Oval )
	Field Rope:LTLine = LTLine.FromPivots( Hinge, Weight )
	
	Method Init()
		L_InitGraphics()
		Hinge.Visualizer = LTVisualizer.FromColor( 1.0, 0.0, 0.0 )
		Weight.Visualizer = LTVisualizer.FromColor( 0.0, 1.0, 0.0 )
		Rope.Visualizer = LTContourVisualizer.FromWidthAndColor( 0.25, 0.0, 0.0, 1.0, 1.0, 2.0 )
		Weight.AttachModel( LTDistanceJoint.Create( Hinge ) )
	End Method

	Method Render()
		Hinge.Draw()
		Weight.Draw()
		Rope.Draw()
	End Method
	
	Method Logic()
		If AppTerminate() Then Exiting = True
		Weight.Act()
		Weight.DY :+ PerSecond( 1.0 )
		Weight.MoveForward()
	End Method	
End Type

