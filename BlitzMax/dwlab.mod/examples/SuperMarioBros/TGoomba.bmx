Type TGoomba Extends LTVectorSprite
   Const WalkingAnimationSpeed:Double = 0.3

   Field Animation:LTAnimationModel = LTAnimationModel.Create( True, WalkingAnimationSpeed, 2 )
   
   Method Init()
       AttachModel( Animation )
       AttachModel( LTHorizontalMovementModel.Instance )
       AttachModel( LTTileMapCollisionModel.Create( Game.Tilemap, TCollisionWithWall.Instance ) )
       AttachModel( LTSpriteMapCollisionModel.Create( Game.MovingObjects, TSpritesHorizontalCollision.Instance ) )
       AttachModel( LTVerticalMovementModel.Instance )
       AttachModel( LTTileMapCollisionModel.Create( Game.Tilemap, TCollisionWithFloor.Instance ) )
       AttachModel( LTSpriteMapCollisionModel.Create( Game.MovingObjects, TSpritesVerticalCollision.Instance ) )
       AttachModel( TGravity.Instance )
       AttachModel( TRemoveIfOutside.Instance )
   End Method
End Type