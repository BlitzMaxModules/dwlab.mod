SuperStrict

Framework brl.basic
Import dwlab.frmwork

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const BallsQuanity:Int = 20
	
	Field Layer:LTLayer = New LTLayer
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 0, 30, 22 )
	Field Contour:LTContourVisualizer = LTContourVisualizer.FromWidthAndHexColor( 2.0, "FF0000" )
	
	Method Init()
		For Local N:Int = 0 Until BallsQuanity
			TBall.Create()
		Next
		L_InitGraphics()
	End Method
	
	Method Logic()
		Layer.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Rectangle.Draw()
		Rectangle.DrawUsingVisualizer( Contour )
		Layer.Draw()
	End Method
End Type



Type TBall Extends LTVectorSprite
	Const Gravity:Double = 8.0
	
	Field OnLand:Int
	
	Method Act()
		CollisionsWithGroup( Example.Layer )
		
		DY :+ Example.PerSecond( Gravity )
		Sprite.Move( 0, DY )
		If BottomY() > Rectangle.BottomY() Then
			Y = Rectangle.BottomY() - 0.5 * Height
			DY = 0
			OnLand = True
		Else
			OnLand = False
		End If
	End Method
End Type



Type TBullet Extends LTSprite
	Method Act()
		MoveForward()
		CollisionsWithGroup( Example.Layer )
	End Method
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int = 0 )
		Local Ball:TBall = LTBall( Sprite )
		If Ball Then
			Ball.AttachModel( New THurt )
		End If
	End Method
End Type



Type TMoving Extends LTBehaviorModel
	Method ApplyTo( Shape:LTShape )
		Shape.Move( Shape.DX, 0 )
	End Method
End Type



Type TJumping Extends LTBehaviorModel
	Field LastJumpTime:Double
	Field Period:Double
	Field JumpStrength:Double
	
	Method ApplyTo( Shape:LTShape )
		Local Sprite:LTSprite = TBall( Shape )
		If Sprite.OnLand Then If LastJumpTime + Period < Example.Time Then Sprite.DY = -JumpStrength
	End Method
End Type



Type THazardous Extends LTBehaviorModel
	Const Push:Double = 2.0

	Method HandleCollisionWithSprite( Sprite1:LTSprite, Sprite2:LTSprite, CollisionType:Int )
		Sprite2.AttachModel( new LTHurt )
		Local Angle:Double = Sprite1.DirectionTo( Sprite2 )
		Sprite1.Angle = Angle + 180
		LTVectorSprite( Sprite1 ).UpdateFromAngularModel()
		Sprite2.Angle = Angle
		LTVectorSprite( Sprite2 ).UpdateFromAngularModel()
	End Method
EndType



Type THurt Extends LTTemporaryModel
	Method Init( Shape:LTShape )
		TBall( Shape ).Health :- 1
	End Method
End Type