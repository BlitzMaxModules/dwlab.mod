SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const BallsQuanity:Int = 20
	
	Field World:LTWorld = LTWorld.FromFile( "game.lw" )
	Field Layer:LTLayer
	Field TileMap:LTTileMap
	
	Method Init()
		L_InitGraphics()
		InitLevel()
	End Method
	
	Method InitLevel()
		LoadAndInitLayer( Layer, LTLayer( World.FindShape( "Level" ) ) )
		TileMap = LTTileMap( Layer.FindShapeWithType( "LTTileMap" ) )
	End Method
	
	Method Logic()
		Layer.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
	End Method
End Type



Type TBall Extends LTVectorSprite
	Const Gravity:Double = 8.0
	
	Field OnLand:Int
	
	Method Act()
		CollisionsWithGroup( Example.Layer )
		
		OnLand = False
		DY :+ Example.PerSecond( Gravity )
		Sprite.Move( 0, DY )
		CollisionsWithTileMap( Exmple.TileMap, Vertical )
	End Method
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int = 0 )
		If CollisionType = Vertical Then
			If DY > 0 Then OnLand = True
			DY = 0
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
		Sprite2.DirectTo( Sprite1 )
		Sprite2.ReverseDirection()
	End Method
EndType



Type THurt Extends LTTemporaryModel
	Method Init( Shape:LTShape )
		TBall( Shape ).Health :- 1
	End Method
End Type