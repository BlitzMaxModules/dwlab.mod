SuperStrict
Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers
Import dwlab.audiodrivers
L_InitGraphics()
L_PrintText( "Press ESC to switch examples", 0, 0, LTAlign.ToCenter, LTAlign.ToCenter )
Flip
Waitkey


'Active.bmx
L_CurrentCamera = LTCamera.Create()
Global Example1:TExample1 = New TExample1
Example1.Execute()

Type TExample1 Extends LTProject
	Const SpritesQuantity:Int = 50
	
	Field Layer:LTLayer = New LTLayer
	Field Rectangle:LTShape = LTSprite.FromShape( 0, 0, 30, 20 )
	
	Method Init()
		For Local N:Int = 1 To SpritesQuantity
			TBall1.Create()
		Next
		Rectangle.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.1, "FF0000" )
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		Layer.Act()
		If KeyHit( Key_Space ) Then
			For Local Sprite:LTSprite = Eachin Layer
				Sprite.Active = True
				Sprite.Visible = True
			Next
		End If
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		Rectangle.Draw()
		DrawText( "Press left mouse button on circle to make it inactive, right button to make it invisible.", 0, 0 )
		DrawText( "Press space to restore all back.", 0, 16 )
		L_PrintText( "Active, BounceInside, CollisionsWisthSprite, HandleCollisionWithSprite, Visible example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type

Type TBall1 Extends LTSprite
	Field Handler:TCollisionHandler1 = New TCollisionHandler1

	Function Create:TBall1()
		Local Ball:TBall1 = New TBall1
		Ball.SetCoords( Rnd( -13, 13 ), Rnd( -8, 8 ) )
		Ball.SetDiameter( Rnd( 0.5, 1.5 ) )
		Ball.Angle = Rnd( 360 )
		Ball.Velocity = Rnd( 3, 7 )
		Ball.ShapeType = LTSprite.Oval
		Ball.Visualizer.SetRandomColor()
		Example1.Layer.AddLast( Ball )
		Return Ball
	End Function
	
	Method Act()
		MoveForward()
		BounceInside( Example1.Rectangle )
		CollisionsWithSprite( L_Cursor, Handler )
	End Method
End Type

Type TCollisionHandler1 Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		If MouseDown( 1 ) Then Sprite1.Active = False
		If MouseDown( 2 ) Then Sprite1.Visible = False
	End Method
End Type
Cls


Incbin "mario.png"

'Animate.bmx
L_CurrentCamera = LTCamera.Create()
Global Example2:TExample2 = New TExample2
Example2.Execute()

Type TExample2 Extends LTProject
	Field Player:LTSprite = LTSprite.FromShape( 0, 0, 1, 2 )
	Field StartingTime:Double
	Field PingPong:Int
	
	Method Init()
		Player.Visualizer.Image = LTImage.FromFile( "incbin::mario.png", 4 )
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		If KeyDown( Key_Space ) Then
			If StartingTime = 0 Then StartingTime = Time
			Player.Animate( 0.1, 3, 1, StartingTime, PingPong )
		Else
			Player.Frame = 0
			StartingTime = 0
		End If
		If KeyHit( Key_P ) Then PingPong = Not PingPong
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Player.Draw()
		DrawText( "Press space to animate sprite, P to toggle ping-pong animation (now it's " + PingPong + ")", 0, 0 )
		L_PrintText( "Animate example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls


Incbin "kolobok.png"

'Clone.bmx
L_CurrentCamera = LTCamera.Create()
Global Example3:TExample3 = New TExample3
Example3.Execute()

Type TExample3 Extends LTProject
	Const SpritesQuantity:Int = 50
	
	Field Sprites:LTLayer = New LTLayer
	Field SpriteImage:LTImage = LTImage.FromFile( "incbin::kolobok.png" )
	
	Method Init()
		For Local N:Int = 1 To SpritesQuantity
			Local Sprite:LTSprite = LTSprite.FromShape( Rnd( -15, 15 ), Rnd( -11, 11 ), , , LTSprite.Oval )
			Sprite.SetDiameter( Rnd( 1, 3 ) )
			Sprite.Visualizer.SetRandomColor()
			Sprite.Visualizer.Angle = Rnd( 360 )
			Sprite.Visualizer.Image = SpriteImage
			Sprite.Visualizer.SetVisualizerScales( 1.3 )
			Sprites.AddLast( Sprite )
		Next
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		If MouseHit( 1 ) Then
			Local Sprite:LTSprite = L_Cursor.FirstCollidedSpriteOfLayer( Sprites )
			If Sprite Then
				Local NewSprite:LTSprite = LTSprite( Sprite.Clone() )
				NewSprite.AlterCoords( Rnd( -2, 2 ), Rnd( -2, 2 ) )
				NewSprite.AlterDiameter( Rnd( 0.75, 1.5 ) )
				NewSprite.AlterAngle( Rnd( -45, 45 ) ) 
				Sprites.AddLast( NewSprite )
			End If
		End If
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Sprites.Draw()
		DrawText( "Clone sprites with left mouse button", 0, 0 )
		L_PrintText( "AlterAngle, AlterCoords, AlterDiameter, Clone example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls


'CollidesWithSprite.bmx
L_CurrentCamera = LTCamera.Create()
Global Example4:TExample4 = New TExample4
Example4.Execute()

Incbin "spaceship.png"

Type TExample4 Extends LTProject
	Field Sprites:LTLayer = New LTLayer
	Field Image:LTImage = LTImage.FromFile( "incbin::spaceship.png" )
	
	Method Init()
		For Local N:Int = 0 Until 9
			Local Sprite:LTSprite = New LTSprite.FromShape( ( N Mod 3 ) * 8.0 - 8.0, Floor( N / 3 ) * 6.0 - 6.0, 6.0, 4.0, N )
			If N = LTSprite.Raster Then Sprite.Visualizer.Image = Image
			Sprite.Visualizer.SetColorFromHex( "7FFF7F" )
			Sprite.Angle = 60
			Sprites.AddLast( Sprite )
		Next
		L_CurrentCamera = LTCamera.Create()
		L_Cursor = New LTSprite.FromShape( 0.0, 0.0, 5.0, 7.0, LTSprite.Pivot )
		L_Cursor.Angle = 45
		L_Cursor.Visualizer.SetColorFromHex( "7F7F7FFF" )
		L_Cursor.ShapeType = LTSprite.Ray
	End Method
	
	Method Logic()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
		If MouseHit( 2 ) Then
			L_Cursor.ShapeType = ( L_Cursor.ShapeType + 1 ) Mod 9
			If L_Cursor.ShapeType = LTSprite.Raster Then L_Cursor.Visualizer.Image = Image Else L_Cursor.Visualizer.Image = Null
		End If
		'L_Cursor.Angle :+ 0.5
	End Method

	Method Render()
		Sprites.Draw()
		For Local Sprite:LTSprite = Eachin Sprites.Children
			'If Sprite.ShapeType < 4 Then Continue
			if L_Cursor.CollidesWithSprite( Sprite ) Then
				Sprite.Visualizer.SetColorFromHex( "FF7F7F" )
				Local WedgedCursor:LTSprite = LTSprite( L_Cursor.Clone() )
				WedgedCursor.WedgeOffWithSprite( Sprite, 0, 1 )
				WedgedCursor.Visualizer.SetColorFromHex( "7F7FFFFF" )
				WedgedCursor.Draw()
			Else
				Sprite.Visualizer.SetColorFromHex( "7FFF7F" )
			End If
		Next
		L_Cursor.Draw()
		
		L_PrintText( "Press right mouse button to change shape ", 0, -12, LTAlign.ToCenter, LTAlign.ToTop )
		L_PrintText( "ColldesWithSprite example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls



'CorrectHeight.bmx
L_CurrentCamera = LTCamera.Create()
Global Example5:TExample5 = New TExample5
Example5.Execute()

Type TExample5 Extends LTProject
	Const SpritesQuantity:Int = 50
	
	Field Layer:LTLayer = New LTLayer
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		Local SpriteVisualizer:LTVisualizer = LTVisualizer.FromFile( "incbin::mario.png", 4 )
		For Local N:Int = 1 To SpritesQuantity
			Local Sprite:LTSprite = LTSprite.FromShape( Rnd( -15, 15 ), Rnd( -11, 11 ), Rnd( 0.5, 2 ), Rnd( 0.5, 2 ) )
			Sprite.Visualizer = SpriteVisualizer
			Layer.AddLast( Sprite )
		Next
	End Method
	
	Method Logic()
		If KeyHit( Key_Space ) Then
			For Local Sprite:LTSprite = EachIn Layer
				Sprite.CorrectHeight()
			Next
		End If
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		DrawText( "Press space to correct height", 0, 0 )
		L_PrintText( "CorrectHeight example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls



'DirectAs.bmx
L_CurrentCamera = LTCamera.Create()
Global Example6:TExample6 = New TExample6
Example6.Execute()

Type TExample6 Extends LTProject
	Const SpritesQuantity:Int = 50
	
	Field Layer:LTLayer = New LTLayer
	Field Cursor:TCursor6 = New TCursor6
	Field SpriteImage:LTImage = LTImage.FromFile( "incbin::kolobok.png" )
	Field Selected:LTSprite
	
	Method Init()
		For Local N:Int = 1 To SpritesQuantity
			Local Sprite:LTSprite = LTSprite.FromShape( Rnd( -15, 15 ), Rnd( -11, 11 ), , , LTSprite.Oval, Rnd( 360 ) )
			Sprite.SetDiameter( Rnd( 1, 3 ) )
			Sprite.Visualizer.SetRandomColor()
			Sprite.Visualizer.Image = SpriteImage
			Layer.AddLast( Sprite )
		Next
		
		Cursor.Visualizer.Image = SpriteImage
		Cursor.ShapeType = LTSprite.Pivot
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		Cursor.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		Cursor.Draw()
		DrawText( "Click left mouse button on sprite to direct cursor sprite as it", 0, 0 )
		DrawText( "and right button to set size equal to sprite's", 0, 16 )
		L_PrintText( "DirectAs, SetSizeAs example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TCursor6 Extends LTSprite
	Field SizeHandler:TSizeCollisionHandler = New TSizeCollisionHandler
	Field DirectionHandler:TDirectionCollisionHandler = new TDirectionCollisionHandler
	
	Method Act()
		SetMouseCoords()
		If MouseHit( 1 ) Then CollisionsWithLayer( Example6.Layer, DirectionHandler )
		If MouseHit( 2 ) Then CollisionsWithLayer( Example6.Layer, SizeHandler )
	End Method
End Type



Type TSizeCollisionHandler Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Sprite1.SetSizeAs( Sprite2 )
	End Method
End Type



Type TDirectionCollisionHandler Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Sprite1.DirectAs( Sprite2 )
	End Method
End Type
Cls



'DirectTo.bmx
L_CurrentCamera = LTCamera.Create()
Global Example7:TExample7 = New TExample7
Example7.Execute()

Type TExample7 Extends LTProject
	Const KoloboksQuantity:Int = 50
	
	Field Layer:LTLayer = New LTLayer
	Field KolobokImage:LTImage = LTImage.FromFile( "incbin::kolobok.png" )
	
	Method Init()
		For Local N:Int = 1 To KoloboksQuantity
			Local Kolobok:TKolobok7 = New TKolobok7
			Kolobok.SetCoords( Rnd( -15, 15 ), Rnd( -11, 11 ) )
			Kolobok.SetDiameter( Rnd( 1, 3 ) )
			Kolobok.ShapeType = LTSprite.Oval
			Kolobok.Visualizer.SetRandomColor()
			Kolobok.Visualizer.Image = KolobokImage
			Layer.AddLast( Kolobok )
		Next
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		Layer.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		L_PrintText( "DirectTo example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TKolobok7 Extends LTSprite
	Method Act()
		DirectTo( L_Cursor )
	End Method
End Type
Cls


'DistanceToPoint.bmx
L_CurrentCamera = LTCamera.Create()
Global Example8:TExample8 = New TExample8
Example8.Execute()

Type TExample8 Extends LTProject
	Const SpritesQuantity:Int = 20
	
	Field Layer:LTLayer = New LTLayer
	Field LineSegment:LTLineSegment = New LTLineSegment
	Field MinSprite:LTSprite

	Method Init()
		L_CurrentCamera = LTCamera.Create()
		For Local N:Int = 1 To SpritesQuantity
			Local Sprite:LTSprite = LTSprite.FromShape( Rnd( -15, 15 ), Rnd( -11, 11 ), , , LTSprite.Oval )
			Sprite.SetDiameter( Rnd( 0.5, 1.5 ) )
			Sprite.Visualizer.SetRandomColor()
			Layer.AddLast( Sprite )
		Next
		L_Cursor = LTSprite.FromShape( 0, 0, 0.5, 0.5, LTSprite.Oval )
		LineSegment.Pivot[ 0 ] = L_Cursor
	End Method
	
	Method Logic()
		MinSprite = Null
		Local MinDistance:Double
		For Local Sprite:LTSprite = Eachin Layer
			If L_Cursor.DistanceTo( Sprite ) < MinDistance Or Not MinSprite Then
				MinSprite = Sprite
				MinDistance = L_Cursor.DistanceTo( Sprite )
			End If
		Next
		LineSegment.Pivot[ 1 ] = MinSprite
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		
		LineSegment.Draw()
		L_PrintText( L_TrimDouble( L_Cursor.DistanceTo( MinSprite ) ), 0.5 * ( L_Cursor.X + MinSprite.X ), 0.5 * ( L_Cursor.Y + MinSprite.Y ) )
		
		Local SX:Double, SY:Double
		L_CurrentCamera.FieldToScreen( L_Cursor.X, L_Cursor.Y, SX, SY )
		DrawLine( SX, SY, 400, 300 )
		L_PrintText( L_TrimDouble( L_Cursor.DistanceToPoint( 0, 0 ) ), 0.5 * L_Cursor.X, 0.5 * L_Cursor.Y )
		
		DrawText( "Direction to field center is " + L_TrimDouble( L_Cursor.DirectionToPoint( 0, 0 ) ), 0, 0 )
		DrawText( "Direction to nearest sprite is " + L_TrimDouble( L_Cursor.DirectionTo( MinSprite ) ), 0, 16 )
		L_PrintText( "DirectionTo, DirectionToPoint, DistanceTo, DistanceToPoint example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls


'DrawCircle.bmx
L_CurrentCamera = LTCamera.Create()
Global Example9:TExample9 = New TExample9
Example9.Execute()

Type TExample9 Extends LTProject
	Const MapSize:Int = 128
	Const MapScale:Double = 4.0
	Const PicScale:Double = 5.0

	Field DoubleMap:LTDoubleMap = LTDoubleMap.Create( MapSize, MapSize )
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		SetClsColor( 0, 0, 255 )
		Local Array:Float[][][] = [ [ [ 0.0, -7.0, 5.0 ], [ 0.0, -1.5, 7.0 ], [ -4.0, -3.0, 2.0 ], [ 4.0, -3.0, 2.0 ], [ 0.0, 6.0, 9.0 ] ], ..
				[ [ 0.0, -7.0, 1.5 ], [ -1.0, -8.0, 1.0 ], [ 1.0, -8.0, 1.0 ], [ 0.0, -3.5, 1.0 ], [ 0.0, -2.0, 1.0 ], [ 0.0, -0.5, 1.0 ] ] ]
		For Local Col:Int = 0 to 1
			For Local Shape:Float[] = Eachin Array[ Col ]
				DoubleMap.DrawCircle( Shape[ 0 ] * PicScale + 0.5 * MapSize, Shape[ 1 ] * PicScale + 0.5 * MapSize, 0.5 * Shape[ 2 ] * PicScale, 1.0 - 0.7 * Col )
			Next
		Next
	End Method
	
	Method Logic()
		if KeyHit( Key_Space ) Then DoubleMap.Blur()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		SetScale( MapScale, MapScale )
		DrawImage( DoubleMap.ToNewImage().BMaxImage, 400, 300 )
		SetScale( 1, 1 )
		DrawText( "Press space to blur map", 0, 0 )
		L_PrintText( "DrawCircle, Blur example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
	
	Method DeInit()
		SetClsColor( 0, 0, 0 )
	End Method
End Type
Cls


Incbin "tiles.png"
Incbin "hit.ogg"

'DrawTile.bmx
L_CurrentCamera = LTCamera.Create()
Global Example10:TExample10 = New TExample10
Example10.Execute()

Type TExample10 Extends LTProject
	Const TileMapWidth:Int = 16
	Const TileMapHeight:Int = 12
	Const ShakingPeriod:Double = 1.0
	Const PeriodBetweenShakes:Double = 3.0
	
	Field TileMap:LTTileMap = LTTileMap.Create( LTTileSet.Create( LTImage.FromFile( "incbin::tiles.png", 8, 4 ) ), TileMapWidth, TileMapHeight )
	Field HitSound:TSound = TSound.Load( "incbin::hit.ogg", False )
	Field ShakingK:Double
	Field LastShakingTime:Double = -100
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		TileMap.SetSize( TileMapWidth * 2, TileMapHeight * 2 )
		For Local Y:Int = 0 Until TileMapHeight
			For Local X:Int = 0 Until TileMapWidth
				TileMap.SetTile( X, Y, Rand( 1, 31 ) )
			Next
		Next
		TileMap.Visualizer = New TShakingVisualizer
	End Method
	
	Method Logic()
		If Time - LastShakingTime > PeriodBetweenShakes Then
			LastShakingTime = Time
			HitSound.Play()
		End If
		If Time - LastShakingTime < ShakingPeriod Then
			ShakingK = ( 1.0 - ( Time - LastShakingTime ) / ShakingPeriod ) ^ 2
		Else
			ShakingK = 0.0
		End If
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		TileMap.Draw()
		L_PrintText( "DrawTile example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type

Type TShakingVisualizer Extends LTVisualizer
	Const DAngle:Double = 15
	Const DCoord:Double = 0.2
	
	Method DrawTile( TileMap:LTTileMap, X:Double, Y:Double, Width:Double, Height:Double, TileX:Int, TileY:Int )
		Local TileSet:LTTileSet =Tilemap.TileSet
		Local TileValue:Int = GetTileValue( TileMap, TileX, TileY )
		If TileValue = TileSet.EmptyTile Then Return
		
		SetRotation( Rnd( -DAngle * Example10.ShakingK, DAngle * Example10.ShakingK ) )
		X :+ Rnd( -DCoord * Example10.ShakingK, DCoord * Example10.ShakingK )
		Y :+ Rnd( -DCoord * Example10.ShakingK, DCoord * Example10.ShakingK )
		
		Local SX:Double, SY:Double
		L_CurrentCamera.FieldToScreen( X, Y, SX, SY )
		
		TileSet.Image.Draw( SX, SY, Width, Height, TileValue )		
		
		SetRotation( 0 )
	End Method
End Type
Cls


'DrawUsingLine.bmx
L_CurrentCamera = LTCamera.Create()
Global Example11:TExample11 = New TExample11
Example11.Execute()

Type TExample11 Extends LTProject
	Field LineSegments:LTLayer = New LTLayer
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		L_CurrentCamera.SetMagnification( 75.0 )
		Local Visualizer:TBlazing = New TBlazing
		For Local Pivots:Int[] = Eachin [ [ -4, -2, -2, -2 ], [ -4, -2, -4, 0 ], [ -4, 0, -4, 2 ], [ -4, 0, -3, 0 ], [ 1, -2, -1, -2 ], [ -1, -2, -1, 0 ], [ -1, 0, 1, 0 ], ..
				[ 1, 0, 1, 2 ], [ 1, 2, -1, 2 ], [ 4, -2, 2, -2 ], [ 2, -2, 2, 0 ], [ 2, 0, 2, 2 ], [ 2, 0, 3, 0 ] ]
			Local LineSegment:LTLineSegment = LTLineSegment.FromPivots( LTSprite.FromShape( Pivots[ 0 ], Pivots[ 1 ] ), LTSprite.FromShape( Pivots[ 2 ], Pivots[ 3 ] ) )
			LineSegment.Visualizer = Visualizer
			LineSegments.AddLast( LineSegment )
		Next
	End Method
	
	Method Logic()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		LineSegments.Draw()
		DrawText( "Free Software Forever!", 0, 0 )
		L_PrintText( "DrawUsingLine example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TBlazing Extends LTVisualizer
	Const ChunkSize:Double = 25
	Const DeformationRadius:Double = 15
	Method DrawUsingLineSegment( LineSegment:LTLineSegment )
		Local SX1:Double, SY1:Double, SX2:Double, SY2:Double
		L_CurrentCamera.FieldToScreen( LineSegment.Pivot[ 0 ].X, LineSegment.Pivot[ 0 ].Y, SX1, SY1 )
		L_CurrentCamera.FieldToScreen( LineSegment.Pivot[ 1 ].X, LineSegment.Pivot[ 1 ].Y, SX2, SY2 )
		Local ChunkQuantity:Int = Max( 1, L_Round( 1.0 * L_Distance( SX2 - SX1, SY2 - SY1 ) / ChunkSize ) )
		Local OldX:Double, OldY:Double
		For Local N:Int = 0 To ChunkQuantity
			Local Radius:Double = 0
			If N > 0 And N < ChunkQuantity Then Radius = Rnd( 0.0, DeformationRadius )
			
			Local Angle:Double = Rnd( 0.0, 360.0 )
			Local X:Int = SX1 + ( SX2 - SX1 ) * N / ChunkQuantity + Cos( Angle ) * Radius
			Local Y:Int = SY1 + ( SY2 - SY1 ) * N / ChunkQuantity + Sin( Angle ) * Radius
			
			SetLineWidth( 9 )
			SetColor( 0, 255, 255 )
			DrawOval( X - 4, Y - 4, 9, 9 )
			If N > 0 Then 
				DrawOval( OldX - 4, OldY - 4, 9, 9 )
				DrawLine( X, Y, OldX, OldY )
			End If
			SetLineWidth( 4 )
			SetColor( 255, 255, 255 )
			DrawOval( X - 2, Y - 2, 5, 5 )
			If N > 0 Then
				DrawOval( OldX - 2, OldY - 2, 5, 5 )
				DrawLine( X, Y, OldX, OldY )
			End If
			
			OldX = X
			OldY = Y
		Next
	End Method
End Type
Cls


'DrawUsingSprite.bmx
L_CurrentCamera = LTCamera.Create()
Global Example12:TExample12 = New TExample12
Example12.Execute()

Type TExample12 Extends LTProject
	Const FlowersQuantity:Int = 12
	Const FlowerCircleDiameter:Double = 9
	Const FlowerDiameter:Double = 1.8
	
	Field Flowers:LTSprite[] = New LTSprite[ FlowersQuantity ]
	Field FlowerVisualizer:TFlowerVisualizer = New TFlowerVisualizer
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		For Local N:Int = 0 Until FlowersQuantity
			Flowers[ N ] = New LTSprite
			Flowers[ N ].SetDiameter( FlowerDiameter )
		Next
	End Method
	
	Method Logic()
		For Local N:Int = 0 Until FlowersQuantity
			Local Angle:Double = N * 360 / FlowersQuantity + 45 * Time
			Flowers[ N ].SetCoords( Cos( Angle ) * FlowerCircleDiameter, Sin( Angle ) * FlowerCircleDiameter )
			Flowers[ N ].Angle = 90 * Time
		Next
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		For Local N:Int = 0 Until FlowersQuantity
			Flowers[ N ].DrawUsingVisualizer( FlowerVisualizer )
		Next
		L_PrintText( "DrawUsingSprite example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type

Type TFlowerVisualizer Extends LTVisualizer
	Const CirclesQuantity:Int = 30
	Const CirclesPer360:Int = 7
	Const Amplitude:Double = 0.15
	
	Method DrawUsingSprite( Sprite:LTSprite, SpriteShape:LTSprite = Null )
		Local SpriteDiameter:Double = Sprite.GetDiameter()
		Local CircleDiameter:Double = L_CurrentCamera.DistFieldToScreen( 2.0 * Pi * SpriteDiameter / CirclesQuantity ) * 1.5
		For Local N:Int = 0 Until CirclesQuantity
			Local Angle:Double = 360.0 * N / CirclesQuantity
			Local Angles:Double = Sprite.Angle + Angle
			Local Distance:Double = SpriteDiameter * ( 1.0 + Amplitude * Sin( 360.0 * Example12.Time + 360.0 * N / CirclesQuantity * CirclesPer360 ) )
			Local SX:Double, SY:Double
			L_CurrentCamera.FieldToScreen( Sprite.X + Distance * Cos( Angles ), Sprite.Y + Distance * Sin( Angles ), SX, SY )
			DrawOval( SX - 0.5 * CircleDiameter, SY - 0.5 * CircleDiameter, CircleDiameter, CircleDiameter )
		Next
	End Method
End Type
Cls


Const MapSize13:Int = 64
Const MapScale13:Double = 8
Const FilledTileNum13:Int = 20

Incbin "tileset.lw"
Incbin "curved_areas.png"

'Enframe.bmx
L_CurrentCamera = LTCamera.Create()
Ex13()
Function Ex13()
L_CurrentCamera = LTCamera.Create()
L_EditorData = New LTEditorData
SetClsColor( 64, 128, 0 )

Cls
Local DoubleMap:LTDoubleMap = New LTDoubleMap
DoubleMap.SetResolution( MapSize13, MapSize13 )
DrawDoubleMap( DoubleMap )
DrawText( "Step 1: creating Double map and set its resolution", 0, 0 )
Flip
Waitkey

Cls
DoubleMap.PerlinNoise( 16, 16, 0.25, 0.5, 4 )
DrawDoubleMap( DoubleMap )
DrawText( "Step 2: filling DoubleMap with Perlin noise", 0, 0 )
Flip
Waitkey

Cls
L_SetIncbin( True )
Local World:LTWorld = LTWorld.FromFile( "tileset.lw" )
L_SetIncbin( False )
Local TileSet:LTTileSet = LTTileSet( L_EditorData.Tilesets.First() )
Local TileMap:LTTileMap = LTTileMap.Create( TileSet, MapSize13, MapSize13 )
TileMap.SetSize( MapSize13 * MapScale13 / 25.0, MapSize13 * MapScale13 / 25.0 )
DrawText( "Step 3: loading world, extract tileset from there and", 0, 0 )
DrawText( "creating tilemap with same size and this tileset", 0, 16 )
DrawDoubleMap( DoubleMap )
Flip
Waitkey


Cls
DoubleMap.ExtractTo( TileMap, 0.5, 1.0, FilledTileNum13 )
DrawText( "Step 4: setting tiles number of tilemap to FilledTileNum13", 0, 0 )
DrawText( "if corresponding value of Double map is higher than 0.5", 0, 16 )
TileMap.Draw()
DrawSignature()
Flip
Waitkey

Cls
For Local Y:Int = 0 Until MapSize13
	For Local X:Int = 0 Until MapSize13
		Fix( TileMap, X, Y )
	Next
Next
DrawText( "Step 5: preparing tilemap by fixing some unmanaged cell positions", 0, 0 )
TileMap.Draw()
DrawSignature()
Flip
Waitkey

Cls
TileMap.Enframe()
DrawText( "Step 6a: enframing tile map", 0, 0 )
TileMap.Draw()
DrawSignature()
Flip
Waitkey


Cls
L_ProlongTiles = False
TileMap.Enframe() 
DrawText( "Step 6b: enframing tile map with prolonging tiles off", 0, 0 )
TileMap.Draw()
DrawSignature()
Flip
Waitkey


SetClsColor( 0, 0, 0 )
    

End Function
Function DrawDoubleMap( Map:LTDoubleMap )
	Local Image:TImage = CreateImage( MapSize13, MapSize13 )
	Local Pixmap:TPixmap = Lockimage( Image )
	ClearPixels( Pixmap, $FF000000 )
	Map.PasteToPixmap( Pixmap )
	Unlockimage( Image )
	SetScale( MapScale13, MapScale13 )
	DrawImage( Image, 400 - 0.5 * MapScale13 * MapSize13, 300 - 0.5 * MapScale13 * MapSize13 )
	SetScale( 1, 1 )
	DrawSignature()
End Function



Function DrawSignature()
	L_PrintText( "PerlinNoise, ExtractTo, Enframe, L_ProlongTiles, example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
End Function



Function Fix( TileMap:LTTileMap, X:Int, Y:Int )
	If TileMap.Value[ X, Y ] = FilledTileNum13 Then Return
	Local DoFix:Int = False
	
	Local FixHorizontal:Int = True
	If X > 0 And X < MapSize13 - 1 Then
		If TileMap.Value[ X - 1, Y ] = FilledTileNum13 And TileMap.Value[ X + 1, Y ] = FilledTileNum13 Then DoFix = True
	Else
		FixHorizontal = False
	End If
	
	Local FixVertical:Int = True
	If Y > 0 And Y < MapSize13 - 1 Then
		If TileMap.Value[ X, Y - 1 ] = FilledTileNum13 And TileMap.Value[ X, Y + 1 ] = FilledTileNum13 Then DoFix = True
	Else
		FixVertical = False
	End If
	
	If DoFix Then
		TileMap.Value[ X, Y ] = FilledTileNum13
		If FixHorizontal Then
			Fix( TileMap, X - 1, Y )
			Fix( TileMap, X + 1, Y )
		End If
		If FixVertical Then
			Fix( TileMap, X, Y - 1 )
			Fix( TileMap, X, Y + 1 )
		End If
	End If
End Function
Cls



'GetTileForPoint.bmx
L_CurrentCamera = LTCamera.Create()
Global Example14:TExample14 = New TExample14
Example14.Execute()

Type TExample14 Extends LTProject
	Const TileMapWidth:Int = 16
	Const TileMapHeight:Int = 12
	
	Field TileSet:LTTileSet = LTTileSet.Create( LTImage.FromFile( "incbin::tiles.png", 8, 4 ) )
	Field TileMap:LTTileMap = LTTileMap.Create( TileSet, TileMapWidth, TileMapHeight )
	Field Cursor:LTSprite = LTSprite.FromShape( 0, 0, 2, 2 )
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		TileMap.SetSize( TileMapWidth * 2, TileMapHeight * 2 )
		For Local Y:Int = 0 Until TileMapHeight
			For Local X:Int = 0 Until TileMapWidth
				TileMap.SetTile( X, Y, Rand( 1, 31 ) )
			Next
		Next
		Cursor.Visualizer.Image = TileMap.TileSet.Image
		Cursor.Frame = 1
	End Method
		
	Method Logic()
		Cursor.SetMouseCoords()
		Local TileX:Int, TileY:Int
		TileMap.GetTileForPoint( Cursor.X, Cursor.Y, TileX, TileY )
		If TileX >= 0 And TileY >= 0 And TileX < TileMap.XQuantity And TileY < TileMap.YQuantity Then
			if MouseDown( 1 ) Then TileMap.SetTile( TileX, TileY, Cursor.Frame )
			If MouseHit( 2 ) Then Cursor.SetAsTile( TileMap, TileX, TileY )
		End If
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		TileMap.Draw()
		Cursor.Draw()
		DrawText( "Press right mouse button to select brush, left button to draw.", 0, 0 )
		L_PrintText( "GetTileForPoint, SetTile, SetAsTile example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls



'GetTileValue.bmx
L_CurrentCamera = LTCamera.Create()
Global Example15:TExample15 = New TExample15
Example15.Execute()

Type TExample15 Extends LTProject
	Const TileMapWidth:Int = 16
	Const TileMapHeight:Int = 12
	
	Field TileMap:LTTileMap = LTTileMap.Create( LTTileSet.Create( LTImage.FromFile( "incbin::tiles.png", 8, 4 ) ), TileMapWidth, TileMapHeight )
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		TileMap.SetSize( TileMapWidth * 2, TileMapHeight * 2 )
		TileMap.Visualizer = New TLighntingVisualizer
	End Method
	
	Method Logic()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		TileMap.Draw()
		L_PrintText( "GetTileValue example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type

Type TLighntingVisualizer Extends LTVisualizer
	Const Radius:Double = 4
	
	Method GetTileValue:Int( TileMap:LTTileMap, TileX:Int, TileY:Int )
		Local X0:Int, Y0:Int
		TileMap.GetTileForPoint( L_Cursor.X, L_Cursor.Y, X0, Y0 )
		If L_Distance( TileX - X0, TileY - Y0 ) <= Radius Then Return 18 Else Return 26
	End Method
End Type
Cls


'LeftX.bmx
L_CurrentCamera = LTCamera.Create()
Global Example16:TExample16 = New TExample16
Example16.Execute()

Type TExample16 Extends LTProject
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 0, 8, 6 )
	Field Ball:LTSprite = LTSprite.FromShape( 0, 0, 1, 1, LTSprite.Oval )
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		Rectangle.Visualizer.SetColorFromHex( "FF0000" )
		Ball.Visualizer.SetColorFromHex( "FFFF00" )
	End Method
	
	Method Logic()
		Rectangle.SetMouseCoords()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Rectangle.Draw()
		Ball.SetCoords( Rectangle.LeftX(), Rectangle.Y )
		Ball.Draw()
		Ball.SetCoords( Rectangle.X, Rectangle.TopY() )
		Ball.Draw()
		Ball.SetCoords( Rectangle.RightX(), Rectangle.Y )
		Ball.Draw()
		Ball.SetCoords( Rectangle.X, Rectangle.BottomY() )
		Ball.Draw()
		L_PrintText( "LeftX, TopY, RightX, BottomY example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls


'LimitByWindowShape.bmx
L_CurrentCamera = LTCamera.Create()
Global Example17:TExample17 = New TExample17
Example17.Execute()

Type TExample17 Extends LTProject
	Field Ball1:LTSprite = LTSprite.FromShape( 0, 0, 3, 3, LTSprite.Oval )
	Field Ball2:LTSprite = LTSprite.FromShape( 0, 0, 2, 2, LTSprite.Oval )
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 0, 10, 10 )
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		Ball1.Visualizer.SetColorFromHex( "FF0000" )
		Ball2.Visualizer.SetColorFromHex( "FFFF00" )
		Ball1.LimitByWindowShape( Rectangle )
		Rectangle.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.1, "00FF00" )
	End Method
	
	Method Logic()
		Ball1.SetMouseCoords()
		Ball2.SetMouseCoords()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Rectangle.Draw()
		Ball1.Draw()
		Ball2.Draw()
		DrawText( "Move cursor to see how ball is limited by rectangle", 0, 0 )
		L_PrintText( "LimitByWindowShape example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls


'LimitWith.bmx
L_CurrentCamera = LTCamera.Create()
Global Example18:TExample18 = New TExample18
Example18.Execute()

Type TExample18 Extends LTProject
	Field Ball:LTSprite[] = New LTSprite[ 7 ]
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 0, 22, 14 )
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		Rectangle.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.1, "FF0000" )
		For Local N:Int = 0 To 6
			Ball[ N ] = New LTSprite
			Ball[ N ].ShapeType = LTSprite.Oval
			Ball[ N ].SetDiameter( 0.5 * ( 7 - N ) )
			Ball[ N ].Visualizer.SetRandomColor()
		Next
	End Method
	
	Method Logic()
		For Local N:Int = 0 To 6
			Ball[ N ].SetMouseCoords()
		Next
		Ball[ 0 ].LimitWith( Rectangle )
		Ball[ 1 ].LimitHorizontallyWith( Rectangle )
		Ball[ 2 ].LimitVerticallyWith( Rectangle )
		Ball[ 3 ].LimitLeftWith( Rectangle )
		Ball[ 4 ].LimitTopWith( Rectangle )
		Ball[ 5 ].LimitRightWith( Rectangle )
		Ball[ 6 ].LimitBottomWith( Rectangle )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Rectangle.Draw()
		For Local N:Int = 0 To 6
			Ball[ N ].Draw()
		Next
		DrawText( "Move cursor to see how the balls are limited in movement", 0, 0 )
		L_PrintText( "Limit...With example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls



'LTAction.bmx
L_CurrentCamera = LTCamera.Create()
Global Example19:TExample19 = New TExample19
Example19.Execute()

Type TExample19 Extends LTProject
	Const SpritesQuantity:Int = 50
	
	Field Sprites:LTLayer = New LTLayer
	Field SpriteImage:LTImage = LTImage.FromFile( "incbin::kolobok.png" )
	Field Drag:TMoveDrag = New TMoveDrag
	
	Method Init()
		For Local N:Int = 1 To SpritesQuantity
			Local Sprite:LTSprite = LTSprite.FromShape( Rnd( -15, 15 ), Rnd( -11, 11 ), , , LTSprite.Oval )
			Sprite.SetDiameter( Rnd( 1, 3 ) )
			Sprite.Visualizer.SetRandomColor()
			Sprite.Visualizer.Angle = Rnd( 360 )
			Sprite.Visualizer.Image = SpriteImage
			Sprite.Visualizer.SetVisualizerScales( 1.3 )
			Sprites.AddLast( Sprite )
		Next
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		Drag.Execute()
		
		L_PushActionsList()
		If KeyDown( Key_LControl ) Or KeyDown( Key_RControl ) Then
			If KeyHit( Key_Z ) Then L_Undo()
			If KeyHit( Key_Y ) Then L_Redo()
		End If
		
		If KeyHit( Key_F2 ) Then Sprites.SaveToFile( "sprites2.lw" )
		If KeyHit( Key_F3 ) Then Sprites = LTLayer( LTObject.LoadFromFile( "sprites2.lw" ) )
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Sprites.Draw()
		DrawText( "Drag sprites with left mouse button, press CTRL-Z to undo, CTRL-Y to redo, F2 to save, F3 to load", 0, 0 )
		L_PrintText( "LTAction, L_Undo, L_Redo, L_PushActionsList, LTDrag example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TMoveDrag Extends LTDrag
	Field Shape:LTShape
	Field Action:TMoveAction
	Field DX:Double, DY:Double

	Method DragKey:Int()
		Return MouseDown( 1 )
	End Method

	Method StartDragging()
		Shape = L_Cursor.FirstCollidedSpriteOfLayer( Example19.Sprites )
		If Shape Then
			Action = TMoveAction.Create( Shape )
			DX = Shape.X - L_Cursor.X
			DY = Shape.Y - L_Cursor.Y
		Else
			DraggingState = False
		End If
	End Method

	Method Dragging()
		Shape.SetCoords( L_Cursor.X + DX, L_Cursor.Y + DY )
	End Method

	Method EndDragging()
		Action.NewX = Shape.X
		Action.NewY = Shape.Y
		Action.Do()
	End Method
End Type



Type TMoveAction Extends LTAction
	Field Shape:LTShape
	Field OldX:Double, OldY:Double
	Field NewX:Double, NewY:Double
	
	Function Create:TMoveAction( Shape:LTShape )
		Local Action:TMoveAction = New TMoveAction
		Action.Shape = Shape
		Action.OldX = Shape.X
		Action.OldY = Shape.Y
		Return Action
	End Function
	
	Method Do()
		Shape.SetCoords( NewX, NewY )
		Super.Do()
	End Method
	
	Method Undo()
		Shape.SetCoords( OldX, OldY )
		Super.Undo()
	End Method
End Type
Cls


Incbin "jellys.lw"
Incbin "tileset.png"
Incbin "superjelly.png"
Incbin "awpossum.png"
Incbin "scheme1.png"
Incbin "scheme2.png"

'LTBehaviorModel.bmx
L_CurrentCamera = LTCamera.Create()
Global Example20:TExample20 = New TExample20
Example20.Execute()

Type TExample20 Extends LTProject
	Const Bricks:Int = 1
	Const DeathPeriod:Double = 1.0
	
	Field World:LTWorld
	Field Layer:LTLayer
	Field TileMap:LTTileMap
	Field SelectedSprite:LTSprite
	Field MarchingAnts:LTMarchingAnts = New LTMarchingAnts
	
	Field BumpingWalls:TBumpingWalls = New TBumpingWalls
	Field PushFromWalls:TPushFromWalls = New TPushFromWalls
	Field DestroyBullet:TDestroyBullet = New TDestroyBullet
	Field AwPossumHurtingCollision:TAwPossumHurtingCollision = New TAwPossumHurtingCollision
	Field AwPossumHitCollision:TAwPossumHitCollision = New TAwPossumHitCollision
	
	'Field HitArea:LTSprite
	Field Score:Int
	
	Method Init()
		L_SetIncbin( True )
	 	World = LTWorld.FromFile( "jellys.lw" )
	 	L_SetIncbin( False )
		
		L_CurrentCamera = LTCamera.Create()
		
		Repeat
			DrawImage( LoadImage( "incbin::scheme2.png" ), 0, 0 )
			Flip
		Until KeyHit( Key_Escape )
		
		Repeat
			DrawImage( LoadImage( "incbin::scheme1.png" ), 0, 0 )
			Flip
		Until KeyHit( Key_Escape )
		
		InitLevel()
	End Method
	
	Method InitLevel()
		LoadAndInitLayer( Layer, LTLayer( World.FindShape( "Level" ) ) )
		TileMap = LTTileMap( Layer.FindShape( "Field" ) )
	End Method
	
	Method Logic()
		L_CurrentCamera.JumpTo( TileMap )
		If MouseHit( 1 ) Then SelectedSprite = L_Cursor.FirstCollidedSpriteOfLayer( Layer )
		Layer.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		If SelectedSprite Then
			SelectedSprite.ShowModels( 100 )
			SelectedSprite.DrawUsingVisualizer( MarchingAnts )
		End If
		'If HitArea Then HitArea.Draw()
		ShowDebugInfo()
		L_PrintText( "Guide AwesomePossum to exit from maze using arrow and space keys", TileMap.RightX(), TileMap.TopY() - 12, LTAlign.ToRight, LTAlign.ToTop )
		L_PrintText( "You can view sprite behavior models by clicking left mouse button on it", TileMap.RightX(), TileMap.TopY() - 0.5, LTAlign.ToRight, LTAlign.ToTop )
		L_PrintText( "Score: " + L_FirstZeroes( Score, 6 ), TileMap.RightX() - 0.1, TileMap.BottomY() - 0.1, LTAlign.ToRight, LTAlign.ToBottom, True )
		L_PrintText( "LTBehaviorModel example", TileMap.X, TileMap.BottomY(), LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TGameObject Extends LTVectorSprite
	Field OnLand:TOnLand = New TOnLand
	Field Gravity:TGravity = New TGravity
	Field JumpingAnimation:LTAnimationModel
	Field FallingAnimation:LTAnimationModel
	
	Field Health:Double = 100.0
End Type



Type TJelly Extends TGameObject
	Const JumpingAnimationSpeed:Double = 0.2
	Const FiringAnimationSpeed:Double = 0.1
	Const WalkingAnimationSpeed:Double = 0.2
	Const IdleAnimationSpeed:Double = 0.4
	Const MinAttack:Double = 10.0
	Const MaxAttack:Double = 20.0
	Const HurtingTime:Double = 0.2
	
	Const JumpingPause:Double = JumpingAnimationSpeed * 2.0
	Const BulletPause:Double = FiringAnimationSpeed * 5.0
	
	Field Score:Int = 100

	Method Init()
		AttachModel( Gravity )

		Local AnimationStack:LTModelStack = New LTModelStack
		AttachModel( AnimationStack )
		
		JumpingAnimation = LTAnimationModel.Create( False, JumpingAnimationSpeed, 8, 8 )
		FallingAnimation = LTAnimationModel.Create( True, JumpingAnimationSpeed, 3, 13, True )
		Local FiringAnimation:LTAnimationModel = LTAnimationModel.Create( False, FiringAnimationSpeed, 8, 16 )
		
		
		Local HorizontalMovement:THorizontalMovement = THorizontalMovement.Create( Example20.BumpingWalls )
		
				
		Local Jumping:String = GetParameter( "jumping" )
		If Jumping Then
			Local Parameters:String[] = Jumping.Split( "-" )
			Local WaitingForJump:LTRandomWaitingModel = LTRandomWaitingModel.Create( Parameters[ 0 ].ToDouble(), Parameters[ 1 ].ToDouble() )
			AttachModel( WaitingForJump )
			
			Local OnLandCondition:LTIsModelActive = LTIsModelActive.Create( OnLand )
			WaitingForJump.NextModels.AddLast( OnLandCondition )
			
			Local AnimationActive:LTIsModelActive = LTIsModelActive.Create( FiringAnimation )
			OnLandCondition.TrueModels.AddLast( AnimationActive )
			OnLandCondition.FalseModels.AddLast( WaitingForJump )
			
			AnimationActive.TrueModels.AddLast( WaitingForJump )
			AnimationActive.FalseModels.AddLast( LTModelActivator.Create( JumpingAnimation ) )
			AnimationActive.FalseModels.AddLast( LTModelDeactivator.Create( HorizontalMovement ) )
			AnimationActive.FalseModels.AddLast( LTModelDeactivator.Create( Gravity ) )
			
			JumpingAnimation.NextModels.AddLast( LTModelActivator.Create( FallingAnimation ) )
			
			Parameters = GetParameter( "jumping_strength" ).Split( "-" )
			Local PauseBeforeJump:LTFixedWaitingModel = LTFixedWaitingModel.Create( JumpingPause )
			PauseBeforeJump.NextModels.AddLast( TJump.Create( Parameters[ 0 ].ToDouble(), Parameters[ 1 ].ToDouble() ) )
			PauseBeforeJump.NextModels.AddLast( LTModelActivator.Create( HorizontalMovement ) )
			PauseBeforeJump.NextModels.AddLast( LTModelActivator.Create( Gravity ) )
			PauseBeforeJump.NextModels.AddLast( WaitingForJump )
			AnimationActive.FalseModels.AddLast( PauseBeforeJump )
			
			AnimationStack.Add( JumpingAnimation, False )
			Score :+ 200
		End If
		
		
		AnimationStack.Add( FallingAnimation )
		
		
		Local Firing:String = GetParameter( "firing" )
		If Firing Then
			Local Parameters:String[] = Firing.Split( "-" )
			Local WaitingForFire:LTRandomWaitingModel = LTRandomWaitingModel.Create( Parameters[ 0 ].ToDouble(), Parameters[ 1 ].ToDouble() )
			AttachModel( WaitingForFire )
			
			Local OnLandCondition:LTIsModelActive = LTIsModelActive.Create( OnLand )
			WaitingForFire.NextModels.AddLast( OnLandCondition )
			
			Local AnimationActive:LTIsModelActive = LTIsModelActive.Create( JumpingAnimation )
			OnLandCondition.TrueModels.AddLast( AnimationActive )
			OnLandCondition.FalseModels.AddLast( WaitingForFire )
			
			AnimationActive.TrueModels.AddLast( WaitingForFire )
			AnimationActive.FalseModels.AddLast( LTModelActivator.Create( FiringAnimation ) )
			AnimationActive.FalseModels.AddLast( LTModelDeactivator.Create( HorizontalMovement ) )

			FiringAnimation.NextModels.AddLast( LTModelActivator.Create( HorizontalMovement ) )
			
			Parameters = GetParameter( "firing_speed" ).Split( "-" )
			Local PauseBeforeBullet:LTFixedWaitingModel = LTFixedWaitingModel.Create( BulletPause )
			PauseBeforeBullet.NextModels.AddLast( TCreateBullet.Create( Parameters[ 0 ].ToDouble(), Parameters[ 1 ].ToDouble() ) )
			PauseBeforeBullet.NextModels.AddLast( WaitingForFire )
			AnimationActive.FalseModels.AddLast( PauseBeforeBullet )
			
			AnimationStack.Add( FiringAnimation, False )
			Score :+ 300
		End If
		
		Local MovementAnimation:LTAnimationModel = LTAnimationModel.Create( True, WalkingAnimationSpeed, 3, 3, True )
		Local Moving:String = GetParameter( "moving" )
		If Moving Then
			Local Parameters:String[] = GetParameter( "moving" ).Split( "-" )
			DX :* Rnd( Parameters[ 0 ].ToDouble(), Parameters[ 1 ].ToDouble() )
			AttachModel( HorizontalMovement )
			AnimationStack.Add( MovementAnimation )
			Score :+ 100
		End If
		
		
		AttachModel( LTModelDeactivator.Create( OnLand, True ) )
		AttachModel( TVerticalMovement.Create( False ) )
		
		
		Local StandingAnimation:LTAnimationModel = LTAnimationModel.Create( True, IdleAnimationSpeed, 3, 0, True )
		AnimationStack.Add( StandingAnimation )
		
		Local ScoreParameter:String = GetParameter( "score" )
		If ScoreParameter Then Score = ScoreParameter.ToInt()
		
		Local HealthParameter:String = GetParameter( "health" )
		If HealthParameter Then Health = HealthParameter.ToDouble()
	End Method
End Type



Type TAwPossum Extends TGameObject
	Const JumpingAnimationSpeed:Double = 0.2
	Const WalkingAnimationSpeed:Double = 0.2
	Const IdleAnimationSpeed:Double = 0.4
	
	Const JumpingPause:Double = JumpingAnimationSpeed
	Const JumpingStrength:Double = 6.0
	Const WalkingSpeed:Double = 5.0
	
	Const MinAttack:Double = 20.0
	Const MaxAttack:Double = 35.0
	Const MinHealthGain:Double = 3.0
	Const MaxHealthGain:Double = 6.0
	
	Const KnockOutPeriod:Double = 0.3
	Const ImmortalPeriod:Double = 1.5
	Const HitPeriod:Double = 0.2
	Const KnockOutStrength:Double = 2.0
	Const HitPauseTime:Double = 0.5
	
	Field MovementAnimation:LTAnimationModel = LTAnimationModel.Create( True, WalkingAnimationSpeed, 4, 4 )
	Field HurtingAnimation:LTAnimationModel = LTAnimationModel.Create( False, KnockOutPeriod, 1, 14 )
	Field PunchingAnimation:LTAnimationModel = LTAnimationModel.Create( False, HitPeriod, 1, 15 )
	Field KickingAnimation:LTAnimationModel = LTAnimationModel.Create( False, HitPeriod, 1, 11 )
	
	Field MovementControl:TMovementControl = New TMovementControl
	Field HitPause:LTFixedWaitingModel = LTFixedWaitingModel.Create( HitPauseTime )
	
	Field MoveLeftKey:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Left ), "Move left" )
	Field MoveRightKey:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Right ), "Move right" )
	Field JumpKey:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Up ), "Jump" )
	Field HitKey:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Space ), "Hit" )
	
	Method Init()
		AttachModel( Gravity )

		
		Local AnimationStack:LTModelStack = New LTModelStack
		AttachModel( AnimationStack )
		
		AnimationStack.Add( HurtingAnimation, False )
		AnimationStack.Add( PunchingAnimation, False )
		AnimationStack.Add( KickingAnimation, False )
		
		JumpingAnimation = LTAnimationModel.Create( False, JumpingAnimationSpeed, 3, 8 )
		AnimationStack.Add( JumpingAnimation )
		
		FallingAnimation = LTAnimationModel.Create( True, JumpingAnimationSpeed, 1, 10 )
		JumpingAnimation.NextModels.AddLast( LTModelActivator.Create( FallingAnimation ) )
		AnimationStack.Add( FallingAnimation )

		AnimationStack.Add( MovementAnimation )

		
		AttachModel( MovementControl )
		
		
		Local JumpKeyDown:LTIsButtonActionDown = LTIsButtonActionDown.Create( JumpKey )
		AttachModel( JumpKeyDown )
		JumpKeyDown.FalseModels.AddLast( JumpKeyDown )
		
		Local OnLandCondition:LTIsModelActive = LTIsModelActive.Create( OnLand )
		JumpKeyDown.TrueModels.AddLast( OnLandCondition )
		
		OnLandCondition.TrueModels.AddLast( LTModelActivator.Create( JumpingAnimation ) )
		OnLandCondition.TrueModels.AddLast( LTModelDeactivator.Create( Gravity ) )
		OnLandCondition.FalseModels.AddLast( JumpKeyDown )
		
		Local PauseBeforeJump:LTFixedWaitingModel = LTFixedWaitingModel.Create( JumpingPause )
		PauseBeforeJump.NextModels.AddLast( TJump.Create( JumpingStrength, JumpingStrength ) )
		PauseBeforeJump.NextModels.AddLast( LTModelActivator.Create( Gravity ) )
		PauseBeforeJump.NextModels.AddLast( JumpKeyDown )
		OnLandCondition.TrueModels.AddLast( PauseBeforeJump )
		
		AnimationStack.Add( JumpingAnimation, False )

		
		Local HitKeyDown:LTIsButtonActionDown = LTIsButtonActionDown.Create( HitKey )
		AttachModel( HitKeyDown )
		HitKeyDown.FalseModels.AddLast( HitKeyDown )
		
		Local HitPauseCondition:LTIsModelActive = LTIsModelActive.Create( HitPause )
		HitPauseCondition.FalseModels.AddLast( HitPause )
		HitPauseCondition.TrueModels.AddLast( HitKeyDown )
		HitKeyDown.TrueModels.AddLast( HitPauseCondition )
				
		Local OnLandCondition2:LTIsModelActive = LTIsModelActive.Create( OnLand )
		OnLandCondition2.TrueModels.AddLast( LTModelActivator.Create( PunchingAnimation ) )
		OnLandCondition2.TrueModels.AddLast( THittingArea.Create2( True ) )
		OnLandCondition2.TrueModels.AddLast( HitKeyDown )
		OnLandCondition2.FalseModels.AddLast( LTModelActivator.Create( KickingAnimation ) )
		OnLandCondition2.FalseModels.AddLast( THittingArea.Create2( False ) )
		OnLandCondition2.FalseModels.AddLast( HitKeyDown )
		HitPauseCondition.FalseModels.AddLast( OnLandCondition2 )
		
		
		AttachModel( THorizontalMovement.Create( Example20.PushFromWalls ) )
		
		
		AttachModel( LTModelDeactivator.Create( OnLand, True ) )
		AttachModel( TVerticalMovement.Create( True ) )
		
		
		Local StandingAnimation:LTAnimationModel = LTAnimationModel.Create( True, IdleAnimationSpeed, 4, 0, True )
		AnimationStack.Add( StandingAnimation )
	End Method
	
	Method Act()
		Super.Act()
		CollisionsWithLayer( Example20.Layer, Example20.AwPossumHurtingCollision )
		If X > Example20.TileMap.RightX() Then Example20.SwitchTo( New TRestart )
	End Method
	
	Method Draw()
		Super.Draw()
		L_DrawEmptyRect( 5, 580, 104, 15 )
		If Health >= 50.0 Then
			SetColor( ( 100.0 - Health ) * 255.0 / 50.0 , 255, 0 )
		Else
			SetColor( 255, Health * 255.0 / 50.0, 0 )
		End If
		DrawRect( 7, 582, Health, 11 )
		LTVisualizer.ResetColor()
	End Method
End Type



Type TOnLand Extends LTBehaviorModel
End Type



Type TGravity Extends LTBehaviorModel
	Const Gravity:Double = 8.0
	
	Method ApplyTo( Shape:LTShape )
		LTVectorSprite( Shape ).DY :+ L_PerSecond( Gravity )
	End Method
End Type



Type THorizontalMovement Extends LTBehaviorModel
	Field CollisionHandler:LTSpriteAndTileCollisionHandler

	Function Create:THorizontalMovement( CollisionHandler:LTSpriteAndTileCollisionHandler )
		Local HorizontalMovement:THorizontalMovement = New THorizontalMovement
		HorizontalMovement.CollisionHandler = CollisionHandler
		Return HorizontalMovement
	End Function
	
	Method ApplyTo( Shape:LTShape )
		Local Sprite:LTVectorSprite = LTVectorSprite( Shape )
		Sprite.Move( Sprite.DX, 0 )
		Sprite.CollisionsWithTileMap( Example20.TileMap, CollisionHandler )
	End Method
	
	Method Info:String( Shape:LTShape )
		Return L_TrimDouble( LTVectorSprite( Shape ).DX )
	End Method
End Type



Type TBumpingWalls Extends LTSpriteAndTileCollisionHandler
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionSprite:LTSprite )
		Sprite.PushFromTile( TileMap, TileX, TileY )
		LTVectorSprite( Sprite ).DX :* -1
		Sprite.Visualizer.XScale :* -1
	End Method
End Type



Type TPushFromWalls Extends LTSpriteAndTileCollisionHandler
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionSprite:LTSprite )
		If TileMap.GetTile( TileX, TileY ) = Example20.Bricks Then Sprite.PushFromTile( TileMap, TileX, TileY )
	End Method
End Type



Type TVerticalMovement Extends LTBehaviorModel
	Field Handler:TVerticalCollisionHandler20 = New TVerticalCollisionHandler20

	Function Create:TVerticalMovement( ForPlayer:Int )
		Local VerticalMovement:TVerticalMovement = New TVerticalMovement
		VerticalMovement.Handler.ForPlayer = ForPlayer
		Return VerticalMovement
	End Function
	
	Method ApplyTo( Shape:LTShape )
		Local Sprite:LTVectorSprite = LTVectorSprite( Shape )
		Sprite.Move( 0, Sprite.DY )
		Sprite.CollisionsWithTileMap( Example20.TileMap, Handler )
	End Method
	
	Method Info:String( Shape:LTShape )
		Return L_TrimDouble( LTVectorSprite( Shape ).DY )
	End Method
End Type



Type TVerticalCollisionHandler20 Extends LTSpriteAndTileCollisionHandler
	Field ForPlayer:Int
	
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionSprite:LTSprite )
		If ForPlayer Then If TileMap.GetTile( TileX, TileY ) <> Example20.Bricks Then Return
		Local GameObject:TGameObject = TGameObject( Sprite )
		GameObject.PushFromTile( TileMap, TileX, TileY )
		If GameObject.DY > 0 Then
			GameObject.OnLand.ActivateModel( Sprite )
			GameObject.FallingAnimation.DeactivateModel( Sprite )
			GameObject.JumpingAnimation.DeactivateModel( Sprite )
		End If
		GameObject.DY = 0
	End Method
End Type



Type TJump Extends LTBehaviorModel
	Field FromStrength:Double, ToStrength:Double
	
	Function Create:TJump( FromStrength:Double, ToStrength:Double )
		Local Jump:TJump = New TJump
		Jump.FromStrength = FromStrength
		Jump.ToStrength = ToStrength
		Return Jump
	End Function
	
	Method ApplyTo( Shape:LTShape )
		LTVectorSprite( Shape ).DY = -Rnd( FromStrength, ToStrength )
		Remove( Shape )
	End Method
End Type



Type TCreateBullet Extends LTBehaviorModel
	Field FromSpeed:Double, ToSpeed:Double
	
	Function Create:TCreateBullet( FromSpeed:Double, ToSpeed:Double )
		Local CreateBullet:TCreateBullet = New TCreateBullet
		CreateBullet.FromSpeed = FromSpeed
		CreateBullet.ToSpeed = ToSpeed
		Return CreateBullet
	End Function
	
	Method ApplyTo( Shape:LTShape )
		TBullet20.Create( LTVectorSprite( Shape ), Rnd( FromSpeed, ToSpeed ) )
		Remove( Shape )
	End Method
End Type



Type TBullet20 Extends LTVectorSprite
	Const MinAttack:Double = 5.0
	Const MaxAttack:Double = 10.0
	
	Field Collisions:Int = True
	
	Function Create( Jelly:LTVectorSprite, Speed:Double )
		Local Bullet:TBullet20 = New TBullet20
		Bullet.SetCoords( Jelly.X + Sgn( Jelly.DX ) * Jelly.Width * 2.2, Jelly.Y - 0.15 * Jelly.Height )
		Bullet.SetSize( 0.45 * Jelly.Width, 0.45 * Jelly.Width )
		Bullet.ShapeType = LTSprite.Oval
		Bullet.DX = Sgn( Jelly.DX ) * Speed
		Bullet.Visualizer.SetVisualizerScale( 12, 4 )
		Bullet.Visualizer.Image = Jelly.Visualizer.Image
		Bullet.Frame = 6
		Example20.Layer.AddLast( Bullet )
	End Function
	
	Method Act()
		MoveForward()
		If Collisions Then CollisionsWithTileMap( Example20.TileMap, Example20.DestroyBullet )
		Super.Act()
	End Method
	
	Function Disable( Sprite:LTSprite )
		Local Bullet:TBullet20 = TBullet20( Sprite )
		if Bullet.Collisions Then 
			Bullet.AttachModel( New TDeath )
			Bullet.AttachModel( New TGravity )
			Bullet.ReverseDirection()
			Bullet.Collisions = False
			Bullet.DX :* 0.25
		End If
	End Function
End Type



Type TDestroyBullet Extends LTSpriteAndTileCollisionHandler
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionSprite:LTSprite )
		If TileMap.GetTile( TileX, TileY ) = Example20.Bricks Then TBullet20.Disable( Sprite )
	End Method
End Type



Type TMovementControl Extends LTBehaviorModel
	Method ApplyTo( Shape:LTShape )
		Local AwPossum:TAwPossum = TAwPossum( Shape )
		If AwPossum.Gravity.Active Then
			If AwPossum.MoveLeftKey.IsDown() Then
				AwPossum.SetFacing( LTSprite.LeftFacing )
				AwPossum.DX = -AwPossum.WalkingSpeed
			ElseIf AwPossum.MoveRightKey.IsDown() Then
				AwPossum.SetFacing( LTSprite.RightFacing )
				AwPossum.DX = AwPossum.WalkingSpeed
			Else
				AwPossum.DX = 0
			End If
		Else
			AwPossum.DX = 0
		End If
		
		If AwPossum.DX And AwPossum.OnLand.Active Then
			AwPossum.MovementAnimation.ActivateModel( Shape )
		Else
			AwPossum.MovementAnimation.DeactivateModel( Shape )
		End If
	End Method
End Type




Type TAwPossumHurtingCollision Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		If Sprite1.FindModel( "TImmortality" ) Then Return
		If Sprite2.FindModel( "TDeath" ) Then Return
		
		Local Damage:Double = 0
		If TJelly( Sprite2 ) Then Damage = Rnd( TJelly.MinAttack, TJelly.MaxAttack )
		Local Bullet:TBullet20 = TBullet20( Sprite2 )
		If Bullet Then
			If Bullet.Collisions Then
				Damage = Rnd( TBullet20.MinAttack, TBullet20.MaxAttack ) * Sprite2.GetDiameter() / 0.45
				Example20.Layer.Remove( Sprite2 )
			End If
		End If
		If Damage Then
			Local AwPossum:TAwPossum = TAwPossum( Sprite1 )
			AwPossum.Health :- Damage
			If AwPossum.Health > 0.0 Then
				Sprite1.AttachModel( New TImmortality )
				Sprite1.AttachModel( New TKnockOut )
			ElseIf Not Sprite1.FindModel( "TDeath" ) Then
				Sprite1.BehaviorModels.Clear()
				Sprite1.AttachModel( New TDeath )
			End If
		End If
	End Method
End Type



Type TImmortality Extends LTFixedWaitingModel
	Const BlinkingSpeed:Double = 0.05
	
	Method Init( Shape:LTShape )
		Period = TAwPossum.ImmortalPeriod
	End Method
	
	Method ApplyTo( Shape:LTShape )
		Shape.Visible = Floor( L_CurrentProject.Time / BlinkingSpeed ) Mod 2
		Super.ApplyTo( Shape )
	End Method
	
	Method Deactivate( Shape:LTShape )
		Shape.Visible = True
	End Method
End Type



Type TKnockOut Extends LTFixedWaitingModel
	Method Init( Shape:LTShape )
		Local AwPossum:TAwPossum = TAwPossum( Shape )
		Period = AwPossum.KnockOutPeriod
		AwPossum.DX = -AwPossum.GetFacing() * AwPossum.KnockOutStrength
		AwPossum.MovementControl.DeactivateModel( Shape )
		AwPossum.HurtingAnimation.ActivateModel( Shape )
	End Method
	
	Method ApplyTo( Shape:LTShape )
		LTVectorSprite( Shape ).DX :* 0.9
		Super.ApplyTo( Shape )
	End Method
	
	Method Deactivate( Shape:LTShape )
		Local AwPossum:TAwPossum = TAwPossum( Shape )
		AwPossum.HurtingAnimation.DeactivateModel( Shape )
		AwPossum.MovementControl.ActivateModel( Shape )
	End Method
End Type



Type THittingArea Extends LTFixedWaitingModel
	Field Area:LTSprite
	Field Punch:Int
	
	Function Create2:THittingArea( Punch:Int )
		Local Area:THittingArea = New THittingArea
		Area.Punch = Punch
		Return Area
	End Function
	
	Method Init( Shape:LTShape )
		Area = New LTSprite
		Area.ShapeType = LTSprite.Oval
		Area.SetDiameter( 0.3 )
		Period = TAwPossum.HitPeriod
		Example20.AwPossumHitCollision.Collided = False
	End Method
	
	Method ApplyTo( Shape:LTShape )
		If Punch then
			Area.SetCoords( Shape.X + Shape.GetFacing() * 0.95, Shape.Y + 0.15 )
		Else
			Area.SetCoords( Shape.X + Shape.GetFacing() * 0.95, Shape.Y - 0.1 )
		End If
		'Example20.HitArea = Area
		Area.CollisionsWithLayer( Example20.Layer, Example20.AwPossumHitCollision )
		If Example20.AwPossumHitCollision.Collided Then Remove( Shape )
		Super.ApplyTo( Shape )
	End Method
	
	'Method Deactivate( Shape:LTShape )
	'	Example20.HitArea = Null
	'End Method
End Type



Type TAwPossumHitCollision Extends LTSpriteCollisionHandler
	Field Collided:Int 
	
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Local Jelly:TJelly = TJelly( Sprite2 )
		If Jelly Then
			Jelly.Health :- Rnd( TAwPossum.MinAttack, TAwPossum.MaxAttack )
			If Jelly.Health > 0 Then
				Jelly.AttachModel( New TJellyHurt )
			ElseIf Not Jelly.FindModel( "TDeath" ) Then
				TScore.Create( Jelly, Jelly.Score )
				
				Local AwPossum:TAwPossum = TAwPossum( Example20.Layer.FindShapeWithType( "TAwPossum" ) )
				AwPossum.Health = Min( AwPossum.Health + Rnd( TAwPossum.MinHealthGain, TAwPossum.MaxHealthGain ), 100.0 )
				
				Jelly.BehaviorModels.Clear()
				Jelly.AttachModel( New TDeath )
			End If
			Collided = True
		ElseIf TBullet20( Sprite2 )
			If Not Sprite2.FindModel( "TDeath" ) Then
				TBullet20.Disable( Sprite2 )
				TScore.Create( Sprite2, 50 )
			End If
		End If
	End Method
End Type



Type TJellyHurt Extends LTFixedWaitingModel
	Method Init( Shape:LTShape )
		Period = TJelly.HurtingTime
		Shape.DeactivateModel( "THorizontalMovement" )
	End Method

	Method ApplyTo( Shape:LTShape )
		Super.ApplyTo( Shape )
		Local Intensity:Double = ( L_CurrentProject.Time - StartingTime ) / Period
		If Intensity <= 1.0 Then Shape.Visualizer.SetColorFromRGB( 1.0, Intensity, Intensity )
	End Method
	
	Method Deactivate( Shape:LTShape )
		Shape.ActivateModel( "THorizontalMovement" )
		Shape.Visualizer.SetColorFromHex( "FFFFFF" )
	End Method
End Type



Type TDeath Extends LTFixedWaitingModel
	Method Init( Shape:LTShape )
		Period = Example20.DeathPeriod
	End Method

	Method ApplyTo( Shape:LTShape )
		Super.ApplyTo( Shape )
		Local Alpha:Double = 1.0 - ( L_CurrentProject.Time - StartingTime ) / Period
		If Alpha >= 0.0 Then Shape.Visualizer.Alpha = Alpha
	End Method
	
	Method Deactivate( Shape:LTShape )
		Example20.Layer.Remove( Shape )
	End Method
End Type



Type TScore Extends LTSprite
	Const Speed:Double = 2.0
	Const Period:Double = 3.0
	
	Field Amount:Int
	Field StartingTime:Double
	
	Function Create( Sprite:LTSprite, Amount:Int )
		Local Score:TScore = New TScore
		Score.SetCoords( Sprite.X, Sprite.TopY() )
		Score.Amount = Amount
		Score.SetDiameter( 0 )
		Score.StartingTime = L_CurrentProject.Time
		Example20.Score :+ Amount
		Example20.Layer.AddLast( Score )
	End Function
	
	Method Act()
		Move( 0, -Speed )
		If L_CurrentProject.Time > StartingTime + Period Then Example20.Layer.Remove( Self )
	End Method
	
	Method Draw()
		PrintText( "+" + Amount, , LTAlign.ToBottom, , , True )
	End Method
End Type



Type TRestart Extends LTProject
	Field StartingTime:Int = Millisecs()
	Field Initialized:Int
	
	Method Render()
		If Millisecs() < StartingTime + 2000 Then
			Example20.Render()
			L_CurrentCamera.Darken( 0.0005 * ( Millisecs() - StartingTime ) )
		ElseIf Millisecs() < StartingTime + 4000
			If Not Initialized Then
				Example20.InitLevel()
				Initialized = True
			End If
			Example20.Render()
			L_CurrentCamera.Darken( 0.0005 * ( 4000 - Millisecs() + StartingTime ) )
		Else
			Exiting = True
		End If
	End Method
End Type
Cls


Incbin "font.png"
Incbin "font.lfn"

'LTBitmapFont.bmx
L_CurrentCamera = LTCamera.Create()
Ex21()
Function Ex21()
L_CurrentCamera = LTCamera.Create()
Local Font:LTBitmapFont = LTBitmapFont.FromFile( "incbin::font.png", 32,127, 16, True )

SetClsColor 0, 128, 0
Cls

Repeat
	If AppTerminate() Or KeyHit( Key_Escape ) Then Exit
	Font.Print( "Hello!", Rnd( -15, 15 ), Rand( -11, 11 ), Rnd( 0.5, 2.0 ), Rand( 0, 2 ), Rand( 0, 2 ) )
	L_PrintText( "LTBitmapFont example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	Flip
Forever

SetClsColor 0, 0, 0
End Function
Cls


'LTButtonAction.bmx
L_CurrentCamera = LTCamera.Create()
Global Example22:TExample22 = New TExample22
Example22.Execute()


Type TExample22 Extends LTProject
	Field Velocity:Double = 5.0
	Field BulletVelocity:Double = 10.0

	Field MoveLeft:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Left ), "move left" )
	Field MoveRight:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Right ), "move right" )
	Field MoveUp:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Up ), "move up" )
	Field MoveDown:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Down ), "move down" )
	Field Fire:LTButtonAction = LTButtonAction.Create( LTMouseButton.Create( 1 ), "fire" )
	Field Actions:LTButtonAction[] = [ MoveLeft, MoveRight, MoveUp, MoveDown, Fire ]
	
	Field Player:LTSprite = LTSprite.FromShape( 0, 0, 1, 1, LTSprite.Oval )
	Field Bullets:LTLayer = New LTLayer
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		Player.Visualizer.SetColorFromHex( "7FBFFF" )
	End Method
	
	Method Logic()
		If MoveLeft.IsDown() Then Player.Move( -Velocity, 0 )
		If MoveRight.IsDown() Then Player.Move( Velocity, 0 )
		If MoveUp.IsDown() Then Player.Move( 0, -Velocity )
		If MoveDown.IsDown() Then Player.Move( 0, Velocity )
		If Fire.IsDown() Then TBullet22.Create()
		
		Bullets.Act()
		
		If KeyDown( Key_LControl ) Or KeyDown( Key_RControl ) Then If KeyDown( Key_D ) Then SwitchTo( New TDefineKeys )
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Bullets.Draw()
		Player.Draw()
		DrawText( "Press Ctrl-D to define keys", 0, 0 )
		L_PrintText( "LTButtonAction, SwitchTo, Move example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TBullet22 Extends LTSprite
	Function Create:TBullet22()
		Local Bullet:TBullet22 = New TBullet22
		Bullet.SetCoords( Example22.Player.X, Example22.Player.Y )
		Bullet.SetDiameter( 0.25 )
		Bullet.ShapeType = LTSprite.Oval
		Bullet.Angle = Example22.Player.DirectionTo( L_Cursor )
		Bullet.Velocity = Example22.BulletVelocity
		Bullet.Visualizer.SetColorFromHex( "7FFFBF" )
		Example22.Bullets.AddLast( Bullet )
	End Function
	
	Method Act()
		MoveForward()
	End Method
End Type



Type TDefineKeys Extends LTProject
	Field ActionNum:Int = 0
	Field Z:Int
	
	Method Init()
		FlushKeys()
		FlushMouse()
	End Method
	
	Method Logic()
		If Example22.Actions[ ActionNum ].Define() Then
			ActionNum :+ 1
			If ActionNum = Example22.Actions.Dimensions()[ 0 ] Then Exiting = True
		End If
	End Method
	
	Method Render()
		Example22.Render()
		DrawText( "Press key for " + Example22.Actions[ ActionNum ].Name, 0, 16 )
	End Method
End Type
Cls



'LTCamera.bmx
L_CurrentCamera = LTCamera.Create()
Global Example23:TExample23 = New TExample23
Example23.Execute()

Type TExample23 Extends LTProject
	Const TileMapWidth:Int = 64
	Const TileMapHeight:Int = 64
	
	Field TileMap:LTTileMap = LTTileMap.Create( LTTileSet.Create( LTImage.FromFile( "incbin::tiles.png", 8, 4 ) ), TileMapWidth, TileMapHeight )
	Field Cursor:LTSprite = LTSprite.FromShape( 0, 0, 0.5, 0.5, LTSprite.Oval )
	Field Z:Double, BaseK:Double
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		TileMap.SetSize( TileMapWidth * 2, TileMapHeight * 2 )
		For Local Y:Int = 0 Until TileMapHeight
			For Local X:Int = 0 Until TileMapWidth
				TileMap.SetTile( X, Y, Rand( 1, 31 ) )
			Next
		Next
		Cursor.Visualizer.SetColorFromHex( "FFBF7F" )
		BaseK = L_CurrentCamera.K
	End Method
	
	Method Logic()
		Cursor.MoveUsingArrows( 10.0 )
		L_CurrentCamera.ShiftCameraToShape( Cursor, 10.0 )
		
		If KeyDown( Key_A ) Then Z :+ L_PerSecond( 8.0 )
		If KeyDown( Key_Z ) Then Z :- L_PerSecond( 8.0 )
		L_CurrentCamera.AlterCameraMagnification( Z, BaseK, 8.0 )
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		TileMap.Draw()
		Cursor.Draw()
		DrawText( "Shift cursor by arrow keys and alter magnigication by A and Z keys.", 0, 0 )
		Local Message:String = "LTCamera, AlterCameraMagnification, ShiftCameraToShape example"
		DrawText( Message, 400 - 4 * Len( Message ), 584 )
	End Method
End Type
Cls



'LTDistanceJoint.bmx
L_CurrentCamera = LTCamera.Create()
Local Example24:TExample24 = New TExample24
Example24.Execute()

Type TExample24 Extends LTProject
	Field Hinge:LTSprite = LTSprite.FromShape( 0, -8, 1, 1, LTSprite.Oval )
	Field Weight1:LTVectorSprite = LTVectorSprite.FromShapeAndVector( -8, -6, 3, 3, LTSprite.Oval )
	Field Weight2:LTVectorSprite = LTVectorSprite.FromShapeAndVector( -12, -9, 3, 3, LTSprite.Oval )
	Field Rope1:LTLineSegment = LTLineSegment.FromPivots( Hinge, Weight1 )
	Field Rope2:LTLineSegment = LTLineSegment.FromPivots( Weight1, Weight2 )
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		Hinge.Visualizer = LTVisualizer.FromHexColor( "FF0000" )
		Weight1.Visualizer = LTVisualizer.FromHexColor( "00FF00" )
		Weight2.Visualizer = LTVisualizer.FromHexColor( "FFFF00" )
		Rope1.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.25, "0000FF", 1.0 , 2.0 )
		Rope2.Visualizer = Rope1.Visualizer
		Weight1.AttachModel( LTDistanceJoint.Create( Hinge ) )
		Weight2.AttachModel( LTDistanceJoint.Create( Weight1 ) )
	End Method

	Method Render()
		Hinge.Draw()
		Weight1.Draw()
		Weight2.Draw()
		Rope1.Draw()
		Rope2.Draw()
		L_PrintText( "LTDistanceJoint example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
	
	Method Logic()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
		Weight1.Act()
		Weight1.DY :+ L_PerSecond( 2.0 )
		Weight1.MoveForward()
		Weight2.Act()
		Weight2.DY :+ L_PerSecond( 2.0 )
		Weight2.MoveForward()
	End Method	
End Type

Cls


'LTGraph.bmx
L_CurrentCamera = LTCamera.Create()
Global Example25:TExample25 = New TExample25
Example25.Execute()

Type TExample25 Extends LTProject
	Const PivotsQuantity:Int = 150
	Const MaxDistance:Double = 3.0
	Const MinDistance:Double = 1.0
	
	Field Graph:LTGraph = New LTGraph
	Field SelectedPivot:LTSprite
	Field Path:TList
	Field PivotVisualizer:LTVisualizer = LTVisualizer.FromHexColor( "4F4FFF" )
	Field LineSegmentVisualizer:LTVisualizer = LTContourVisualizer.FromWidthAndHexColor( 0.15, "FF4F4F", , 3.0 )
	Field PathVisualizer:LTVisualizer = LTContourVisualizer.FromWidthAndHexColor( 0.15, "4FFF4F", , 4.0 )
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		L_Cursor = LTSprite.FromShape( 0, 0, 0.5, 0.5, LTSprite.Oval )
		For Local N:Int = 0 Until PivotsQuantity
			Repeat
				Local X:Double = Rnd( -15,15 )
				Local Y:Double = Rnd( -11, 11 )
				Local Passed:Int = True
				For Local Pivot:LTSprite = Eachin Graph.Pivots.Keys()
					If Pivot.DistanceToPoint( X, Y ) < MinDistance Then
						Passed = False 
						Exit
					End If
				Next
				If Passed Then
					Graph.AddPivot( LTSprite.FromShape( X, Y, 0.3, 0.3, LTSprite.Oval ) )
					Exit
				End If
			Forever
		Next
		For Local Pivot1:LTSprite = Eachin Graph.Pivots.Keys()
			For Local Pivot2:LTSprite = Eachin Graph.Pivots.Keys()
				If Pivot1 <> Pivot2 And Pivot1.DistanceTo( Pivot2 ) <= MaxDistance Then
					Local Passed:Int = True
					Local NewLineSegment:LTLineSegment = LTLineSegment.FromPivots( Pivot1, Pivot2 )
					For Local LineSegment:LTLineSegment = Eachin Graph.LineSegments.Keys()
						If LineSegment.CollidesWithLineSegment( NewLineSegment, False ) Then
							Passed = False
							Exit
						End If
					Next
					If Passed Then Graph.AddLineSegment( NewLineSegment, False )
				End If
			Next
		Next
	End Method
	
	Method Logic()
		If MouseHit( 1 ) Then
			SelectedPivot = Graph.FindPivotCollidingWithSprite( L_Cursor )
			Path = Null
		End If
		If MouseHit( 2 ) And SelectedPivot Then
			Local SelectedPivot2:LTSprite = Graph.FindPivotCollidingWithSprite( L_Cursor )
			If SelectedPivot2 Then Path = Graph.FindPath( SelectedPivot, SelectedPivot2 )
		End If
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Graph.DrawLineSegmentsUsing( LineSegmentVisualizer )
		LTGraph.DrawPath( Path, PathVisualizer )
		Graph.DrawPivotsUsing( PivotVisualizer )
		If SelectedPivot Then SelectedPivot.DrawUsingVisualizer( PathVisualizer )
		DrawText( "Select first pivot with left mouse button and second with right one", 0, 0 )
		L_PrintText( "LTGraph, FindPath, CollidesWithLineSegment example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls



'LTMarchingAnts.bmx
L_CurrentCamera = LTCamera.Create()
Global Example26:TExample26 = New TExample26
Example26.Execute()

Type TExample26 Extends LTProject
	Const SpritesQuantity:Int = 50
	
	Field Layer:LTLayer = New LTLayer
	Field Cursor:TCursor26 = New TCursor26
	Field SpriteImage:LTImage = LTImage.FromFile( "incbin::kolobok.png" )
	Field Selected:LTSprite
	Field MarchingAnts:LTMarchingAnts = New LTMarchingAnts
	
	Method Init()
		For Local N:Int = 1 To SpritesQuantity
			Local Sprite:LTSprite = LTSprite.FromShape( Rnd( -15, 15 ), Rnd( -11, 11 ), , , LTSprite.Oval, Rnd( 360 ) )
			Sprite.SetDiameter( Rnd( 1, 3 ) )
			Sprite.Visualizer.SetRandomColor()
			Sprite.Visualizer.Image = SpriteImage
			Layer.AddLast( Sprite )
		Next
		
		Cursor.SetDiameter( 0.5 )
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		Cursor.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		If Selected Then Selected.DrawUsingVisualizer( Example26.MarchingAnts )
		DrawText( "Select Sprite by left-clicking on it", 0, 0 )
		L_PrintText( "LTMarchingAnts example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TCursor26 Extends LTSprite
	Field Handler:TSelectionHandler = New TSelectionHandler
	
	Method Act()
		SetMouseCoords()
		If MouseHit( 1 ) Then
			Example26.Selected = Null
			CollisionsWithLayer( Example26.Layer, Handler )
		End If
	End Method
End Type



Type TSelectionHandler Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Example26.Selected = Sprite2
	End Method
End Type
Cls


Incbin "border.png"

'LTRasterFrame.bmx
L_CurrentCamera = LTCamera.Create()
Global Example27:TExample27 = New TExample27
Example27.Execute()

Type TExample27 Extends LTProject
	Field Frame:LTSprite
	Field FrameImage:LTRasterFrame = LTRasterFrame.FromFileAndBorders( "incbin::border.png", 8, 8, 8, 8 )
	Field Layer:LTLayer = New LTLayer
	Field CreateFrame:TCreateFrame = New TCreateFrame
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		CreateFrame.Execute()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		If Frame Then Frame.Draw()
		DrawText( "Drag left mouse button to create frames", 0, 0 )
		L_PrintText( "LTRasterFrame, LTDrag example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TCreateFrame Extends LTDrag
	Field StartingX:Double, StartingY:Double
	
	Method DragKey:Int()
		Return MouseDown( 1 )
	End Method

	Method StartDragging()
		StartingX = L_Cursor.X
		StartingY = L_Cursor.Y
		Example27.Frame = LTSprite.FromShape( L_Cursor.X, L_Cursor.Y, 0, 0 )
		Example27.Frame.Visualizer.SetRandomColor()
		Example27.Frame.Visualizer.Image = Example27.FrameImage
	End Method

	Method Dragging()
		Local CornerX:Double, CornerY:Double
		If StartingX < L_Cursor.X Then CornerX = StartingX Else CornerX = L_Cursor.X
		If StartingY < L_Cursor.Y Then CornerY = StartingY Else CornerY = L_Cursor.Y
		Example27.Frame.SetSize( Abs( StartingX - L_Cursor.X ), Abs( StartingY - L_Cursor.Y ) )
		Example27.Frame.SetCornerCoords( CornerX, CornerY )
	End Method
	
	Method EndDragging()
		Example27.Layer.AddLast( Example27.Frame )
		Example27.Frame = Null
	End Method
End Type
Cls


Incbin "human.lw"
Incbin "part.png"

'LTRevoluteJoint.bmx
L_CurrentCamera = LTCamera.Create()
Global Example28:TExample28 = New TExample28
Example28.Execute()

Type TExample28 Extends LTProject
	Const Period:Double = 2.0
	Field World:LTWorld
	Field Layer:LTLayer
	Field Body:LTSprite
	Field UpperArm:LTSprite[] = New LTSprite[ 2 ]
	Field LowerArm:LTSprite[] = New LTSprite[ 2 ]
	Field UpperLeg:LTSprite[] = New LTSprite[ 2 ]
	Field LowerLeg:LTSprite[] = New LTSprite[ 2 ]
	Field Foot:LTSprite[] = New LTSprite[ 2 ]

	Method Init()
		L_SetIncbin( True )
		World = LTWorld.FromFile( "human.lw" )
		L_SetIncbin( False )
		Layer = LTLayer( World.FindShapeWithType( "LTLayer" ) )
		Body = LTSprite( Layer.FindShape( "body" ) )
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
		L_CurrentCamera = LTCamera.Create()
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
		L_PrintText( "LTFixedJoint, LTRevoluteJoint example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls


'LTSpriteMap.bmx
L_CurrentCamera = LTCamera.Create()
Global Example29:TExample29 = New TExample29
Example29.Execute()

Const MapSize29:Int = 192

Type TExample29 Extends LTProject
	Const SpritesQuantity:Int = 800
	
	Field Rectangle:LTShape = LTSprite.FromShape( 0, 0, MapSize29, MapSize29 )
	Field Cursor:LTSprite = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
	Field SpriteMap:LTSpriteMap = LTSpriteMap.CreateForShape( Rectangle, 2.0 )
	Field CollisionHandler:TCollisionHandler29 = New TCollisionHandler29
	
	Method Init()
		For Local N:Int = 1 To SpritesQuantity
			TBall29.Create()
		Next
		Rectangle.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.1, "FF0000" )
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		L_CurrentCamera.Move( 0.1 * ( MouseX() - 400 ), 0.1 * ( MouseY() - 300 ) )
		SpriteMap.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		SpriteMap.Draw()
		Rectangle.Draw()
		DrawOval( 398, 298, 5, 5 )
		L_Cursor.Draw()
		L_PrintText( "LTSpriteMap, CollisionsWithSpriteMap example", L_CurrentCamera.X, L_CurrentCamera.Y + 12, LTAlign.ToCenter, LTAlign.ToBottom )
		ShowDebugInfo()
	End Method
End Type



Type TBall29 Extends LTSprite
	Function Create:TBall29()
		Local Ball:TBall29 = New TBall29
		Ball.SetCoords( Rnd( -0.5 * ( MapSize29 - 2 ), 0.5 * ( MapSize29 - 2 ) ), Rnd( -0.5 * ( MapSize29 - 2 ), 0.5 * ( MapSize29 - 2 ) ) )
		Ball.SetDiameter( Rnd( 0.5, 1.5 ) )
		Ball.Angle = Rnd( 360 )
		Ball.Velocity = Rnd( 3, 7 )
		Ball.ShapeType = LTSprite.Oval
		Ball.Visualizer.SetRandomColor()
		Example29.SpriteMap.InsertSprite( Ball )
		Return Ball
	End Function
	
	Method Act()
		Super.Act()
		L_CurrentCamera.BounceInside( Example29.Rectangle )
		MoveForward()
		BounceInside( Example29.Rectangle )
		CollisionsWithSpriteMap( Example29.SpriteMap, Example29.CollisionHandler )
	End Method
End Type



Type TCollisionHandler29 Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		If TParticleArea( Sprite2 ) Then Return
		Sprite1.PushFromSprite( Sprite2 )
		Sprite1.Angle = Sprite2.DirectionTo( Sprite1 )
		Sprite2.Angle = Sprite1.DirectionTo( Sprite2 )
		TParticleArea.Create( Sprite1, Sprite2 )
	End Method
End Type



Type TParticleArea Extends LTSprite
	Const ParticlesQuantity:Int = 30
	Const FadingTime:Double = 1.0
	
	Field Particles:TList = New TList
	Field StartingTime:Double

	Function Create( Ball1:LTSprite, Ball2:LTSprite )
		Local Area:TParticleArea = New TParticleArea
		Local Diameters:Double = Ball1.GetDiameter() + Ball2.GetDiameter()
		Area.SetCoords( Ball1.X + ( Ball2.X - Ball1.X ) * Ball1.GetDiameter() / Diameters, Ball1.Y + ( Ball2.Y - Ball1.Y ) * Ball1.GetDiameter() / Diameters )
		Area.SetSize( 4, 4 )
		Area.StartingTime = Example29.Time
		Local Angle:Double = Ball1.DirectionTo( Ball2 ) + 90
		For Local N:Int = 0 Until ParticlesQuantity
			Local Particle:LTSprite = New LTSprite
			Particle.JumpTo( Area )
			Particle.Angle = Angle + Rnd( -15, 15 ) + ( N Mod 2 ) * 180
			Particle.SetDiameter( Rnd( 0.2, 0.6 ) )
			Particle.Velocity = Rnd( 0.5, 3 )
			Area.Particles.AddLast( Particle )
		Next
		Example29.SpriteMap.InsertSprite( Area )
	End Function
	
	Method Draw()
		Local A:Double = 1.0 - ( Example29.Time - StartingTime ) / FadingTime
		If A >= 0 Then
			SetAlpha( A )
			SetColor( 255, 192, 0 )
			For Local Sprite:LTSprite = Eachin Particles
				Local DX:Double = Cos( Sprite.Angle ) * Sprite.GetDiameter() * 0.5
				Local DY:Double = Sin( Sprite.Angle ) * Sprite.GetDiameter() * 0.5
				Local SX1:Double, SY1:Double, SX2:Double, SY2:Double
				L_CurrentCamera.FieldToScreen( Sprite.X - DX, Sprite.Y - DY, SX1, SY1 )
				L_CurrentCamera.FieldToScreen( Sprite.X + DX, Sprite.Y + DY, SX2, SY2 )
				DrawLine( SX1, SY1, SX2, SY2 )
				Sprite.MoveForward()
			Next
			LTVisualizer.ResetColor()
		End If
	End Method
	
	Method Act()
		If Example29.Time > StartingTime + FadingTime Then Example29.SpriteMap.RemoveSprite( Self )

		If CollidesWithSprite( L_CurrentCamera ) Then
			For Local Sprite:LTSprite = Eachin Particles
				Sprite.MoveForward()
			Next
		End If
	End Method
End Type
Cls



'LTVectorSprite.bmx
L_CurrentCamera = LTCamera.Create()
Global Example30:TExample30 = New TExample30
Example30.Execute()

Type TExample30 Extends LTProject
	Const CoinsQuantity:Int = 100
	Const PlatformsQuantity:Int = 100
	Const MinPlatformLength:Int = 3
	Const MaxPlatformLength:Int = 12
	Const MapSize:Int = 128
	
	Const Void:Int = 0
	Const Bricks:Int = 1
	Const Coin:Int = 2
	
	Field Player:TPlayer = TPlayer.Create()
	Field TileMap:LTTileMap = LTTileMap.Create( LTTileSet.Create( LTImage.FromFile( "incbin::tileset.png", 4, 1 ), 0 ), MapSize, MapSize )
	Field Coins:Int
	
	Method Init()
		TileMap.SetSize( MapSize, MapSize )
		For Local N:Int = 0 Until CoinsQuantity
			TileMap.Value[ Rand( 1, MapSize - 2 ), Rand( 1, MapSize - 2 ) ] = Coin
		Next
		For Local N:Int = 0 Until PlatformsQuantity
			Local Size:Int = Rand( MinPlatformLength, MaxPlatformLength )
			Local X:Int = Rand( 1, MapSize - 1 - Size )
			Local Y:Int = Rand( 1, MapSize - 2 )
			For Local DX:Int = 0 Until Size
				TileMap.Value[ X + DX, Y ] = Bricks
			Next
		Next
		For Local N:Int = 0 Until MapSize 
			TileMap.Value[ N, 0 ] = Bricks
			TileMap.Value[ N, MapSize - 1 ] = Bricks
			TileMap.Value[ 0, N ] = Bricks
			TileMap.Value[ MapSize - 1, N ] = Bricks
		Next
		TileMap.TileSet.CollisionShape = New LTShape[ 3 ]
		TileMap.TileSet.CollisionShape[ 1 ] = LTSprite.FromShape( 0.5, 0.5 )
		TileMap.TileSet.CollisionShape[ 2 ] = LTSprite.FromShape( 0.5, 0.5, , , LTSprite.Oval )
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		L_CurrentCamera.JumpTo( Player )
		L_CurrentCamera.LimitWith( TileMap )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
		Player.Act()
	End Method

	Method Render()
		TileMap.Draw()
		Player.Draw()
		DrawText( "Move player with arrow keys", 0, 0 )
		DrawText( "Coins: " + Coins, 0, 16 )
		L_PrintText( "LTVectorSprite, CollisionsWithTileMap, HandleCollisionWithTile example", L_CurrentCamera.X, L_CurrentCamera.Y + 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type




Type TPlayer Extends LTVectorSprite
	Const Gravity:Double = 10.0
	Const HorizontalSpeed:Double = 5.0
	Const JumpStrength:Double = 15.0
	
	Field OnLand:Int
	Field HorizontalCollisionHandler:THorizontalCollisionHandler = New THorizontalCollisionHandler
	Field VerticalCollisionHandler:TVerticalCollisionHandler30 = New TVerticalCollisionHandler30
	
	Function Create:TPlayer()
		Local Player:TPlayer = New TPlayer
		Player.SetSize( 0.8, 1.8 )
		Player.SetCoords( 0, 2 -0.5 * Example30.MapSize )
		Player.Visualizer.Image = LTImage.FromFile( "incbin::mario.png", 4 )
		Return Player
	End Function
	
	Method Act()
		Move( DX, 0 )
		CollisionsWithTileMap( Example30.TileMap, HorizontalCollisionHandler )
		
		OnLand = False
		Move( 0, DY )
		DY = DY + Example30.PerSecond( Gravity )
		CollisionsWithTileMap( Example30.TileMap, VerticalCollisionHandler )
		
		DX = 0.0
		If KeyDown( Key_Left ) Then
			DX = -HorizontalSpeed
			SetFacing( LeftFacing )
		ElseIf KeyDown( Key_Right ) Then
			DX = HorizontalSpeed
			SetFacing( RightFacing )
		End If 
		
		If OnLand Then If KeyDown( Key_Up ) Then DY = -JumpStrength
	End Method
End Type



Type THorizontalCollisionHandler Extends LTSpriteAndTileCollisionHandler
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionSprite:LTSprite )
		If Bricks( TileMap, TileX, TileY ) Then Sprite.PushFromTile( TileMap, TileX, TileY )
	End Method
End Type



Type TVerticalCollisionHandler30 Extends LTSpriteAndTileCollisionHandler
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionSprite:LTSprite )
		If Bricks( TileMap, TileX, TileY ) Then 
			Sprite.PushFromTile( TileMap, TileX, TileY )
			Local Player:TPlayer = TPlayer( Sprite )
			If Player.DY > 0 Then Player.OnLand = True
			Player.DY = 0
		End If
	End Method
End Type



Function Bricks:Int( TileMap:LTTileMap, TileX:Int, TileY:Int )
	Local TileNum:Int = TileMap.GetTile( TileX, TileY )
	If TileNum = Example30.Coin Then
		TileMap.Value[ TileX, TileY ] = Example30.Void
		Example30.Coins :+ 1
	ElseIf TileNum = Example30.Bricks Then
		Return True
	End If
	Return False
End Function
Cls


'L_Distance.bmx
L_CurrentCamera = LTCamera.Create()
Global Example31:TExample31 = New TExample31
Example31.Execute()

Type TExample31 Extends LTProject
	Field X:Int = 400
	Field Y:Int = 300
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		If MouseHit( 1 ) Then
			X = MouseX()
			Y = MouseY()
		End If
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		DrawOval( X - 2, Y - 2, 5, 5 )
		DrawLine( X, Y, MouseX(), MouseY() )
		DrawText( "Distance is " + L_TrimDouble( L_Distance( Y - MouseY(), X - MouseX() ) ) + " pixels", 0, 0 )
		L_PrintText( "L_Distance example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls


'L_DrawEmptyRect.bmx
L_CurrentCamera = LTCamera.Create()
Ex32()
Function Ex32()
L_CurrentCamera = LTCamera.Create()
Repeat
	If AppTerminate() Or KeyHit( Key_Escape ) Then Exit
	For Local N:Int = 1 To 10
		Local Width:Double = Rnd( 700 )
		Local Height:Double = Rnd( 500 )
		SetColor( Rnd( 128, 255 ), Rnd( 128, 255 ), Rnd( 128, 255 ) )
		L_DrawEmptyRect( Rnd( 800 - Width ), Rnd( 600 - Height ), Width, Height )
	Next
	SetColor( 0, 0, 0 )
	SetAlpha( 0.04 )
	DrawRect( 0, 0, 800, 600 )
	LTVisualizer.ResetColor() 
	L_PrintText( "L_DrawEmptyRect example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	Flip
Forever
End Function
Cls


'L_IntInLimits.bmx
L_CurrentCamera = LTCamera.Create()
Global Example33:TExample33 = New TExample33
Example33.Execute()

Type TExample33 Extends LTProject
	Field Word:String
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		If L_IntInLimits( MouseX(), 200, 600 ) Then Word = "" Else Word = "not "
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		SetColor( 255, 0, 0 )
		DrawLine( 200, 0, 200, 599 )
		DrawLine( 600, 0, 600, 599 )
		SetColor( 255, 255, 255 )
		DrawText( MouseX() + " is " + Word + "in limits of [ 200, 600 ]", 0, 0 )
		DrawOval( MouseX() - 2, MouseY() - 2, 5, 5 )
		L_PrintText( "L_IntInLimits example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls


'L_LimitInt.bmx
L_CurrentCamera = LTCamera.Create()
Global Example34:TExample34 = New TExample34
Example34.Execute()

Type TExample34 Extends LTProject
	Method Init()
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		SetColor( 255, 0, 0 )
		DrawLine( 200, 0, 200, 599 )
		DrawLine( 600, 0, 600, 599 )
		SetColor( 255, 255, 255 )
		Local X:Int = L_LimitInt( MouseX(), 200, 600 )
		DrawOval( X - 2, MouseY() - 2, 5, 5 )
		DrawText( "LimitInt(MouseX(),200,600) = " + X, 0, 0 )
		L_PrintText( "L_LimitInt example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls
' First sprite is moving at constant speed regardles of LogicFPS because it use delta-timing PerSecond() method to determine
' on which distance to move in particular logic frame.Second sprite use simple coordinate addition.



'L_LogicFPS.bmx
L_CurrentCamera = LTCamera.Create()
Global Example35:TExample35 = New TExample35
Example35.Execute()

Type TExample35 Extends LTProject
	Field Sprite1:LTSprite = LTSprite.FromShape( -10, -2, 2, 2, LTSprite.Oval )
	Field Sprite2:LTSprite = LTSprite.FromShape( -10, 2, 2, 2, LTSprite.Oval )

	Method Init()
		L_CurrentCamera = LTCamera.Create()
		Sprite1.Visualizer = LTVisualizer.FromRGBColor( 1, 1, 0 )
		Sprite2.Visualizer = LTVisualizer.FromRGBColor( 0, 0.5, 1 )
		L_LogicFPS = 100
	End Method
	
	Method Logic()
		Sprite1.X :+ L_PerSecond( 8 )
		If Sprite1.X > 10 Then Sprite1.X :- 20
		
		Sprite2.X :+ 0.08
		If Sprite2.X > 10 Then Sprite2.X :- 20
		
		If KeyDown( Key_NumAdd ) Then L_LogicFPS :+ L_PerSecond( 100 )
		If KeyDown( Key_NumSubtract ) And L_LogicFPS > 20 Then L_LogicFPS :- L_PerSecond( 100 )
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Sprite1.Draw()
		Sprite2.Draw()
		DrawText( "Logic FPS: " + L_TrimDouble( L_LogicFPS ) + ", press num+ / num- to change", 0, 0 )
		L_PrintText( "L_LogicFPS example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls


'L_WrapInt.bmx
L_CurrentCamera = LTCamera.Create()
Global Example36:TExample36 = New TExample36
Example36.Execute()

Type TExample36 Extends LTProject
	Method Init()
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		SetColor( 255, 0, 0 )
		L_DrawEmptyRect( -1, -1, 102, 102 )
		L_DrawEmptyRect( 299, 249, 202, 102 )
		SetColor( 0, 255, 0 )
		DrawOval( L_WrapInt( MouseX(), 100 ) - 2, L_WrapInt( MouseY(), 100 ) - 2, 5, 5 )
		DrawText( "L_WrapInt(" + MouseX() + ", 100)=" + L_WrapInt( MouseX(), 100 ), 0, 102 )
		SetColor( 0, 0, 255 )
		DrawOval( L_WrapInt2( MouseX(), 300, 500 ) - 2, L_WrapInt2( MouseY(), 250, 350 ) - 2, 5, 5 )
		DrawText( "L_WrapInt2(" + MouseX() + ", 300, 500)=" + L_WrapInt2( MouseX(), 300, 500 ), 300, 352 )
		DrawText( "", 0, 0 )
		SetColor( 255, 255, 255 )
		L_PrintText( "L_WrapInt and L_WrapInt2 example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls


'MoveTowards.bmx
L_CurrentCamera = LTCamera.Create()
Global Example37:TExample37 = New TExample37
Example37.Execute()

Type TExample37 Extends LTProject
	Field Ball:LTSprite = LTSprite.FromShape( 0, 0, 3, 3, LTSprite.Oval, 0, 5 )
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		Ball.Visualizer = LTVisualizer.FromHexColor( "3F3F7F" )
		L_Cursor = LTSprite.FromShape( 0, 0, 1, 1, LTSprite.Oval )
		L_Cursor.Visualizer = LTVisualizer.FromHexColor( "7FFF3F" )
	End Method
	
	Method Logic()
		Ball.MoveTowards( L_Cursor, Ball.Velocity )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Ball.Draw()
		L_Cursor.Draw()
		If Ball.IsAtPositionOf( L_Cursor ) Then DrawText( "Ball is at position of cursor", 0, 0 )
		L_PrintText( "IsAtPositionOf, MoveTowards example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls


'MoveUsingKeys.bmx
L_CurrentCamera = LTCamera.Create()
Global Example38:TExample38 = New TExample38
Example38.Execute()

Type TExample38 Extends LTProject
	Field Ball1:LTSprite = LTSprite.FromShape( -8, 0, 1, 1, LTSprite.Oval, 0, 7 )
	Field Ball2:LTSprite = LTSprite.FromShape( 0, 0, 2, 2, LTSprite.Oval, 0, 3 )
	Field Ball3:LTSprite = LTSprite.FromShape( 8, 0, 1.5, 1.5, LTSprite.Oval, 0, 5 )
	
	Method Init()
		Ball1.Visualizer = LTVisualizer.FromHexColor( "FF0000" )
		Ball2.Visualizer = LTVisualizer.FromHexColor( "00FF00" )
		Ball3.Visualizer = LTVisualizer.FromHexColor( "0000FF" )
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		Ball1.MoveUsingWSAD( Ball1.Velocity )
		Ball2.MoveUsingArrows( Ball2.Velocity )
		Ball3.MoveUsingKeys( Key_I, Key_K, Key_J, Key_L, Ball3.Velocity )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		DrawText( "Move red ball using WSAD keys", 0, 0 )
		DrawText( "Move green ball using arrow keys", 0, 16 )
		DrawText( "Move blue ball using IJKL keys", 0, 32 )
		Ball1.Draw()
		Ball2.Draw()
		Ball3.Draw()
		L_PrintText( "MoveUsingKeys example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls


'Overlaps.bmx
L_CurrentCamera = LTCamera.Create()
Global Example39:TExample39 = New TExample39
Example39.Execute()

Type TExample39 Extends LTProject
	Field Sprite1:LTSprite = LTSprite.FromShape( 6, 0, 0, 0, LTSprite.Pivot )
	Field Sprite2:LTSprite = LTSprite.FromShape( -4, -2, 3, 5, LTSprite.Oval )
	Field Sprite3:LTSprite = LTSprite.FromShape( 0, 5, 4, 4, LTSprite.Rectangle )
	Field Cursor:LTSprite = LTSprite.FromShape( 0, 0, 16, 12 )
	Field Text:String
	
	Method Init()
		Sprite1.Visualizer.SetColorFromHex( "FF0000" )
		Sprite2.Visualizer.SetColorFromHex( "00FF00" )
		Sprite3.Visualizer.SetColorFromHex( "0000FF" )
		Cursor.Visualizer.Alpha = 0.5
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		Cursor.SetMouseCoords()
		Text = ""
		If Cursor.Overlaps( Sprite1 ) Then Text = ", pivot"
		If Cursor.Overlaps( Sprite2 ) Then Text :+ ", oval"
		If Cursor.Overlaps( Sprite3 ) Then Text :+ ", rectangle"
		If Not Text Then Text = ", nothing"
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Sprite1.Draw()
		Sprite2.Draw()
		Sprite3.Draw()
		Cursor.Draw()
		DrawText( "Cursor rectangle fully overlaps " + Text[ 2.. ], 0, 0 )
		L_PrintText( "Overlaps example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls


Incbin "parallax.lw"
Incbin "water_and_snow.png"
Incbin "grid.png"
Incbin "clouds.png"

'Parallax.bmx
L_CurrentCamera = LTCamera.Create()
Global Example40:TExample40 = New TExample40
Example40.Execute()

Type TExample40 Extends LTProject
  Field Ground:LTTileMap
  Field Grid:LTTileMap
  Field Clouds:LTTileMap
  
  Method Init()
    L_CurrentCamera = LTCamera.Create()
	L_CurrentCamera.SetMagnification( 32.0 )
    
	L_SetIncbin( True )
    Local Layer:LTLayer = LoadLayer( LTLayer( LTWorld.FromFile( "parallax.lw" ).FindShapeWithType( "LTLayer" ) ) )
	L_SetIncbin( False )
  
    Ground = LTTileMap( Layer.FindShape( "Ground" ) )
    Grid = LTTileMap( Layer.FindShape( "Grid" ) )
    Clouds = LTTileMap( Layer.FindShape( "Clouds" ) )
  End Method
  
  Method Logic()
    L_CurrentCamera.MoveUsingArrows( 8.0 )
    L_CurrentCamera.LimitWith( Grid )
    Ground.Parallax( Grid )
    Clouds.Parallax( Grid )
    If KeyHit( Key_Escape ) Then Exiting = True
  End Method

  Method Render()
    Ground.Draw()
    Grid.Draw()
    Clouds.Draw()
	DrawText( "Move camera with arrow keys", 0, 0 )
	L_PrintText( "Parallax example", L_CurrentCamera.X, L_CurrentCamera.Y + 9, LTAlign.ToCenter, LTAlign.ToBottom )
  End Method
End Type
Cls


Const MapSize41:Int = 128

'Paste.bmx
L_CurrentCamera = LTCamera.Create()
Ex41()
Function Ex41()
L_CurrentCamera = LTCamera.Create()

Local SourceMap:LTDoubleMap = LTDoubleMap.Create( MapSize41, MapSize41 )
SourceMap.DrawCircle( MapSize41 * 0.375, MapSize41 * 0.375, MapSize41 * 0.35, 0.6 )
Draw( SourceMap.ToNewImage(), "Source map" )

Local TargetMap:LTDoubleMap = LTDoubleMap.Create( MapSize41, MapSize41 )
TargetMap.DrawCircle( MapSize41 * 0.625, MapSize41 * 0.625, MapSize41 * 0.35, 0.8 )
Draw( TargetMap.ToNewImage(), "Target map" )

Local DoubleMap:LTDoubleMap = LTDoubleMap.Create( MapSize41, MapSize41 )
DoubleMap.Paste( TargetMap )
DoubleMap.Paste( SourceMap, 0, 0, LTDoubleMap.Add )
DoubleMap.Limit()
Draw( DoubleMap.ToNewImage(), "Adding source map to target map" )

DoubleMap.Paste( TargetMap )
DoubleMap.Paste( SourceMap, 0, 0, LTDoubleMap.Multiply )
Draw( DoubleMap.ToNewImage(), "Multiplying source map with target map" )

DoubleMap.Paste( TargetMap )
DoubleMap.Paste( SourceMap, 0, 0, LTDoubleMap.Maximum )
Draw( DoubleMap.ToNewImage(), "Maximum of source map and target map" )

DoubleMap.Paste( TargetMap )
DoubleMap.Paste( SourceMap, 0, 0, LTDoubleMap.Minimum )
Draw( DoubleMap.ToNewImage(), "Minimum of source map and target map" )

SetScale( 4.0, 4.0 )
Local Image:LTImage = SourceMap.ToNewImage( LTDoubleMap.Red )
TargetMap.PasteToImage( Image, 0, 0, 0, LTDoubleMap.Green )
Draw( Image, "Pasting maps to different color channels" )


End Function
Function Draw( Image:LTImage, Text:String )
	SetScale ( 4.0, 4.0 )
	DrawImage( Image.BMaxImage, 400, 300 )
	SetScale( 1.0, 1.0 )
	DrawText( Text, 0, 0 )
	L_PrintText( "Paste example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	Flip
	Waitkey
	Cls
End Function
Cls


Const MapSize42:Int = 256

'PerlinNoise.bmx
L_CurrentCamera = LTCamera.Create()
Ex42()
Function Ex42()
L_CurrentCamera = LTCamera.Create()

Local DoubleMap:LTDoubleMap = New LTDoubleMap
DoubleMap.SetResolution( MapSize42, MapSize42 )

Local Frequency:Int = 16
Local Amplitude:Double = 0.25
Local DAmplitude:Double = 0.5
Local Layers:Int = 4

Repeat
	Cls
	DoubleMap.PerlinNoise( Frequency, Frequency, Amplitude, DAmplitude, Layers )
	Local Pixmap:TPixmap = DoubleMap.ToNewPixmap()
	DrawPixmap( Pixmap, 400 - 0.5 * PixmapWidth( Pixmap ), 300 - 0.5 * PixmapHeight( Pixmap ) )		
	DrawText( "Starting frequency: " + Frequency + " ( +/- to change )", 0, 0 )
	DrawText( "Starting amplitude: " + L_TrimDouble( Amplitude ) + " ( left / right arrow to change )", 0, 16 )
	DrawText( "Starting amplitude increment: " + L_TrimDouble( DAmplitude ) + " ( up / down arrow to change )", 0, 32 )
	DrawText( "Layers quantity: " + Layers + " ( page up / page down arrow to change )", 0, 48 )
	L_PrintText( "PerlinNoise example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	Flip

	Repeat
		If KeyHit( Key_NumAdd ) Then
			If Frequency < 256 Then Frequency :* 2
			Exit
		ElseIf KeyHit( Key_NumSubtract ) Then
			If Frequency > 1 Then Frequency :/ 2
			Exit
		ElseIf KeyHit( Key_Left ) Then
			If Amplitude > 0.05 Then Amplitude :/ 2
			Exit
		ElseIf KeyHit( Key_Right ) Then
			If Amplitude < 1.0 Then Amplitude :* 2
			Exit
		ElseIf KeyHit( Key_Down ) Then
			If DAmplitude > 0.05 Then DAmplitude :/ 2
			Exit
		ElseIf KeyHit( Key_Up ) Then
			If DAmplitude < 2.0 Then DAmplitude :* 2
			Exit
		ElseIf KeyHit( Key_PageUp ) Then
			If Layers < 8 Then Layers :+ 1
			Exit
		ElseIf KeyHit( Key_PageDown ) Then
			If Layers > 1 Then Layers :- 1
			Exit
		End If
	Until KeyDown( Key_Escape )
Until KeyDown( Key_Escape )
End Function
Cls


'PlaceBetween.bmx
L_CurrentCamera = LTCamera.Create()
Global Example43:TExample43 = New TExample43
Example43.Execute()

Type TExample43 Extends LTProject
	Field Pivot1:LTSprite = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
	Field Pivot2:LTSprite = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
	Field Oval1:LTSprite = LTSprite.FromShape( 0, 0, 0.75, 0.75, LTSprite.Oval )
	Field Oval2:LTSprite = LTSprite.FromShape( 0, 0, 0.75, 0.75, LTSprite.Oval )
	Field LineSegment:LTLineSegment = LTLineSegment.FromPivots( Pivot1, Pivot2 )
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		LineSegment.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.2, "0000FF", 1.0, 2.0 )
		Oval1.Visualizer.SetColorFromHex( "FF0000" )
		Oval2.Visualizer.SetColorFromHex( "00FF00" )
	End Method
	
	Method Logic()
		Pivot2.SetMouseCoords()
		Oval1.PlaceBetween( Pivot1, Pivot2, 0.5 )
		Oval2.PlaceBetween( Pivot1, Pivot2, 0.3 )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		LineSegment.Draw()
		Oval1.Draw()
		Oval2.Draw()
		L_PrintText( "PlaceBetween example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls


'PrintText.bmx
L_CurrentCamera = LTCamera.Create()
Global Example44:TExample44 = New TExample44
Example44.Execute()

Type TExample44 Extends LTProject
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 0, 16, 12 )
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		Rectangle.SetMouseCoords()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Rectangle.DrawContour( 2 )
		Rectangle.PrintText( "topleft corner", LTAlign.ToLeft, LTAlign.ToTop )
		Rectangle.PrintText( "top", LTAlign.ToCenter, LTAlign.ToTop )
		Rectangle.PrintText( "topright corner", LTAlign.ToRight, LTAlign.ToTop )
		Rectangle.PrintText( "left side", LTAlign.ToLeft, LTAlign.ToCenter )
		Rectangle.PrintText( "center", LTAlign.ToCenter, LTAlign.ToCenter )
		Rectangle.PrintText( "right side", LTAlign.ToRight, LTAlign.ToCenter )
		Rectangle.PrintText( "bottomleft corner", LTAlign.ToLeft, LTAlign.ToBottom )
		Rectangle.PrintText( "bottom", LTAlign.ToCenter, LTAlign.ToBottom )
		Rectangle.PrintText( "bottomright corner", LTAlign.ToRight, LTAlign.ToBottom )
		L_PrintText( "PrintText example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls



'SaveToFile.bmx
L_CurrentCamera = LTCamera.Create()
Global Example45:TExample45 = New TExample45
Example45.Execute()

Type TExample45 Extends LTProject
	Const SpritesQuantity:Int = 70

	Field Layer:LTLayer = New LTLayer
	Field Ang:Double
	Field OldSprite:LTSprite

	Method Init()
		L_CurrentCamera = LTCamera.Create()
		For Local N:Int = 1 To SpritesQuantity
			OldSprite = LTSprite.FromShape( Rnd( -15, 15 ), Rnd( -11, 11 ), , , LTSprite.Oval, Rnd( 360 ), 5 )
			OldSprite.SetDiameter( Rnd( 0.5, 1.5 ) )
			OldSprite.Visualizer.SetRandomColor()
			Layer.AddLast( OldSprite )
		Next
	End Method
	
	Method Logic()
		Ang = 1500 * Sin( 7 * Time )
		For Local Sprite:LTSprite = Eachin Layer
			OldSprite.DirectTo( Sprite )
			OldSprite.Angle :+ L_PerSecond( Ang ) + Rnd( -45, 45 )
			Sprite.MoveForward()
			OldSprite = Sprite
		Next
		
		If KeyHit( Key_F2 ) Then Layer.SaveToFile( "sprites.lw" )
		If KeyHit( Key_F3 ) Then Layer = LTLayer( LTObject.LoadFromFile( "sprites.lw" ) )
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		DrawText( "Press F2 to save and F3 to load position of sprites", 0, 0 )
		L_PrintText( "LoadFromFile, SaveToFile example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls



'SetAsTile.bmx
L_CurrentCamera = LTCamera.Create()
Global Example46:TExample46 = New TExample46
Example46.Execute()

Type TExample46 Extends LTProject
	Const TileMapWidth:Int = 16
	Const TileMapHeight:Int = 12
	
	Field TileSet:LTTileSet = LTTileSet.Create( LTImage.FromFile( "incbin::tiles.png", 8, 4 ) )
	Field TileMap:LTTileMap = LTTileMap.Create( TileSet, TileMapWidth, TileMapHeight )
	Field Pieces:LTLayer = New LTLayer
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		TileMap.SetSize( TileMapWidth * 2, TileMapHeight * 2 )
		For Local Y:Int = 0 Until TileMapHeight
			For Local X:Int = 0 Until TileMapWidth
				TileMap.SetTile( X, Y, Rand( 1, 31 ) )
			Next
		Next
	End Method
	
	Method Logic()
		If MouseHit( 1 ) Then 
			Local TileX:Int, TileY:Int
			TileMap.GetTileForPoint( L_Cursor.X, L_Cursor.Y, TileX, TileY )
			If TileMap.GetTile( TileX, TileY ) > 0 Then
				Local Piece:TPiece = TPiece.Create()
				Piece.SetAsTile( TileMap, TileX, TileY )
				TileMap.SetTile( TileX, TileY, 0 )
			End If
		End If
		Pieces.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		TileMap.Draw()
		Pieces.Draw()
		DrawText( "Click on tiles to make them fall", 0, 0 )
		L_PrintText( "SetAsTile example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TPiece Extends LTVectorSprite
	Const Gravity:Double = 8.0
	
	Field StartingTime:Double = 0
	Field AngularDirection:Double = 0
	
	Function Create:TPiece()
		Local Piece:TPiece = New TPiece
		Piece.StartingTime = Example46.Time
		Piece.AngularDirection = -1 + 2 * Rand( 0, 1 )
		Example46.Pieces.AddFirst( Piece )
		Return Piece
	End Function
	
	Method Act()
		MoveForward()
		Angle = ( Example46.Time - StartingTime ) * 45 * AngularDirection
		DY :+ L_PerSecond( Gravity )
		If TopY() > Example46.TileMap.BottomY() Then Example46.Pieces.Remove( Self )
	End Method
End Type
Cls


'SetAsViewport.bmx
L_CurrentCamera = LTCamera.Create()
Global Example47:TExample47 = New TExample47
Example47.Execute()

Type TExample47 Extends LTProject
	Const SpritesQuantity:Int = 100
	
	Field Layer:LTLayer = New LTLayer
	Field Rectangle:LTShape = LTSprite.FromShape( 0, 0, 30, 20 )
	
	Method Init()
		L_Cursor = LTSprite.FromShape( 0, 0, 8, 6 )
		For Local N:Int = 1 To SpritesQuantity
			Local Sprite:LTSprite = LTSprite.FromShape( Rnd( -13, 13 ), Rnd( -8, 8 ), , , LTSprite.Oval, Rnd( 360 ), Rnd( 3, 7 ) )
			Sprite.Visualizer.SetRandomColor()
			Layer.AddLast( Sprite )
		Next
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		For Local Sprite:LTSprite = Eachin Layer
			Sprite.MoveForward()
			Sprite.BounceInside( Rectangle )
		Next
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		L_Cursor.SetAsViewport()
		Layer.Draw()
		Rectangle.DrawContour( 2 )
		L_CurrentCamera.ResetViewport()
		L_Cursor.DrawContour( 2 )
		L_PrintText( "SetAsViewport, ResetViewport example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls


'SetCornerCoords.bmx
L_CurrentCamera = LTCamera.Create()
Global Example48:TExample48 = New TExample48
Example48.Execute()

Type TExample48 Extends LTProject
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 0, 8, 6 )
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		Rectangle.SetCornerCoords( L_Cursor.X, L_Cursor.Y )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Rectangle.Draw()
		L_PrintText( "SetCornerCoords example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls



'SetFacing.bmx
L_CurrentCamera = LTCamera.Create()
Global Example49:TExample49 = New TExample49
Example49.Execute()

Type TExample49 Extends LTProject
	Field Sprite:LTSprite = LTSprite.FromShape( 0, 0, 8, 8 )
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		Sprite.Visualizer.Image = LTImage.FromFile( "incbin::kolobok.png" )
	End Method
	
	Method Logic()
		If KeyHit( Key_Left ) Then Sprite.SetFacing( LTSprite.LeftFacing )
		If KeyHit( Key_Right ) Then Sprite.SetFacing( LTSprite.RightFacing )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Sprite.Draw()
		DrawText( "Press left and right arrows to change sprite facing", 0, 0 )
		L_PrintText( "SetFacing example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls



Const TileMapWidth50:Int = 4
Const TileMapHeight50:Int = 3

'Stretch.bmx
L_CurrentCamera = LTCamera.Create()
Ex50()
Function Ex50()
Local TileSet:LTTileSet = LTTileSet.Create( LTImage.FromFile( "incbin::tiles.png", 8, 4 ) )
Local TileMap:LTTileMap = LTTileMap.Create( TileSet, TileMapWidth50, TileMapHeight50 )

L_CurrentCamera = LTCamera.Create()
TileMap.SetSize( TileMapWidth50 * 2, TileMapHeight50 * 2 )
For Local Y:Int = 0 Until TileMapHeight50
	For Local X:Int = 0 Until TileMapWidth50
		TileMap.SetTile( X, Y, Rand( 1, 31 ) )
	Next
Next

For Local N:Int = 1 To 3
	Cls
	TileMap.Draw()
	DrawText( "Press any key to stretch tilemap by 2 times", 0, 0 )
	L_PrintText( "Stretch example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	Flip
	WaitKey
	TileMap.Stretch( 2, 2 )
	TileMap.AlterSize( 2, 2 )
Next
End Function
Cls


Incbin "tank.png"

'Turn.bmx
L_CurrentCamera = LTCamera.Create()
Global Example51:TExample51 = New TExample51
Example51.Execute()

Type TExample51 Extends LTProject
	Const TurningSpeed:Double = 90

	Field Tank:LTSprite = LTSprite.FromShape( 0, 0, 2, 2, LTSprite.Rectangle, 0, 5 )
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		Tank.Visualizer = LTVisualizer.FromFile( "incbin::tank.png" )
	End Method
	
	Method Logic()
		If KeyDown( Key_Left ) Then Tank.Turn( -TurningSpeed )
		If KeyDown( Key_Right ) Then Tank.Turn( TurningSpeed )
		If KeyDown( Key_Up ) Then Tank.MoveForward()
		If KeyDown( Key_Down ) Then Tank.MoveBackward()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Tank.Draw()
		DrawText( "Press arrow keys to move tank", 0, 0 )
		L_PrintText( "Turn, MoveForward, MoveBackward example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
Cls



'WedgeOffWithSprite.bmx
L_CurrentCamera = LTCamera.Create()
Global Example52:TExample52 = New TExample52
Example52.Execute()

Type TExample52 Extends LTProject
	Const KoloboksQuantity:Int = 50
	
	Field Koloboks:LTLayer = New LTLayer
	Field KolobokImage:LTImage = LTImage.FromFile( "incbin::kolobok.png" )
	Field Player:TKolobok52
	Field DebugMode:Int
	Field CollisionHandler:TCollisionHandler52 = New TCollisionHandler52
	
	Method Init()
		For Local N:Int = 1 To KoloboksQuantity
			TKolobok52.CreateKolobok()
		Next
		Player = TKolobok52.CreatePlayer()
		L_CurrentCamera = LTCamera.Create()
	End Method
	
	Method Logic()
		Koloboks.Act()
		
		If KeyDown( Key_Left ) Then Player.Turn( -Player.TurningSpeed )
		If KeyDown( Key_Right ) Then Player.Turn( Player.TurningSpeed )
		If KeyDown( Key_Up ) Then Player.MoveForward()
		If KeyDown( Key_Down ) Then Player.MoveBackward()
		
		If KeyHit( Key_D ) Then DebugMode = Not DebugMode
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		if DebugMode Then
			Koloboks.DrawUsingVisualizer( L_DebugVisualizer )
			ShowDebugInfo()
		Else
			Koloboks.Draw()
			DrawText( "Move white kolobok with arrow keys and push other koloboks and press D for debug mode", 0, 0 )
			L_PrintText( "WedgeOffWithSprite example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
		End If
	End Method
End Type



Type TKolobok52 Extends LTSprite
	Const TurningSpeed:Double = 180.0
	
	Function CreatePlayer:TKolobok52()
		Local Player:TKolobok52 = Create()
		Player.SetDiameter( 2 )
		Player.Velocity = 7
		Return Player
	End Function
	
	Function CreateKolobok:TKolobok52()
		Local Kolobok:TKolobok52 = Create()
		Kolobok.SetCoords( Rnd( -15, 15 ), Rnd( -11, 11 ) )
		Kolobok.SetDiameter( Rnd( 1, 3 ) )
		Kolobok.Angle = Rnd( 360 )
		Kolobok.Visualizer.SetRandomColor()
		Return Kolobok
	End Function
	
	Function Create:TKolobok52()
		Local Kolobok:TKolobok52 = New TKolobok52
		Kolobok.ShapeType = LTSprite.Oval
		Kolobok.Visualizer.Image = Example52.KolobokImage
		Kolobok.Visualizer.SetVisualizerScale( 1.3, 1.3 )
		Example52.Koloboks.AddLast( Kolobok )
		Return Kolobok
	End Function
	
	Method Act()
		CollisionsWithLayer( Example52.Koloboks, Example52.CollisionHandler )
	End Method
End Type



Type TCollisionHandler52 Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Sprite1.WedgeOffWithSprite( Sprite2, Sprite1.Width ^ 2, Sprite2.Width ^ 2 )
	End Method
End Type
Cls


'XMLIO.bmx
L_CurrentCamera = LTCamera.Create()
Global Example53:TExample53 = New TExample53
Example53.Execute()

Type TExample53 Extends LTProject
	Field People:TList = New TList
	Field Professions:TList = New TList
	
	Method Init()
		L_CurrentCamera = LTCamera.Create()
		For Local Name:String = Eachin [ "director", "engineer", "dispatcher", "driver", "secretary", "bookkeeper", "supply agent", "bookkeeper chief", ..
				"lawyer", "programmer", "administrator", "courier" ]
			TProfession.Create( Name )
		Next
	End Method
	
	Method Logic()
		If KeyHit( Key_G ) Then
			People.Clear()
			For Local N:Int = 1 To 10
				TWorker.Create()
			Next
		ElseIf KeyHit( Key_C ) Then
			People.Clear()
		ElseIf KeyHit( Key_F2 ) Then
			SaveToFile( "people.dat" )
		ElseIf KeyHit( Key_F3 ) Then
			LoadFromFile( "people.dat" )
		End If
			
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		DrawText( "Press G to generate data, C to clear, F2 to save, F3 to load", 0, 0 )
		Local Y:Int = 16
		For Local Worker:TWorker = Eachin People
			DrawText( Worker.FirstName + " " + Worker.LastName + ", " + Worker.Age + " years, " + L_TrimDouble( Worker.Height, 1 ) + " cm, " + ..
					L_TrimDouble( Worker.Weight, 1 ) + " kg, " + Worker.Profession.Name , 0, Y )
			Y :+ 16
		Next
		L_PrintText( "XMLIO, Manage... example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageListField( "professions", Example53.Professions )
		XMLObject.ManageChildList( Example53.People )
	End Method
End Type



Type TProfession Extends LTObject
	Field Name:String
	
	Function Create:TProfession( Name:String )
		Local Profession:TProfession = New TProfession
		Profession.Name = Name
		Example53.Professions.AddLast( Profession )
	End Function
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageStringAttribute( "name", Name )
	End Method
End Type



Type TWorker Extends LTObject
	Field FirstName:String
	Field LastName:String
	Field Age:Int
	Field Height:Double
	Field Weight:Double
	Field Profession:TProfession
	
	Function Create()
		Local Worker:TWorker = New TWorker
		Worker.FirstName = [ "Alexander", "Alex", "Dmitry", "Sergey", "Andrey", "Anton", "Artem", "Vitaly", "Vladimir", "Denis", "Eugene", ..
				"Igor", "Constantine", "Max", "Michael", "Nicholas", "Paul", "Roman", "Stanislaw", "Anatoly", "Boris", "Vadim", "Valentine", ..
				"Valery", "Victor", "Vladislav", "Vyacheslav", "Gennady", "George", "Gleb", "Egor", "Ilya", "Cyril", "Leonid", "Nikita", "Oleg", ..
				"Peter", "Feodor", "Yury", "Ian", "Jaroslav" ][ Rand( 0, 40 ) ]
		Worker.LastName = [ "Ivanov", "Smirnov", "Kuznetsov", "Popov", "Vasiliev", "Petrov", "Sokolov", "Mikhailov", "Novikov", ..
				"Fedorov", "Morozov", "Volkov", "Alekseev", "Lebedev", "Semenov", "Egorov", "Pavlov", "Kozlov", "Stepanov", "Nikolaev", ..
				"Orlovv", "Andreev", "Makarov", "Nikitin", "Zakharov" ][ Rand( 0, 24 ) ]
		Worker.Age = Rand( 20, 50 )
		Worker.Height = Rnd( 155, 180 )
		Worker.Weight = Rnd( 50, 90 )
		Worker.Profession = TProfession( Example53.Professions.ValueAtIndex( Rand( 0, Example53.Professions.Count() - 1 ) ) )
		Example53.People.AddLast( Worker )
	End Function
	
	Method XMLIO( XMLObject:LTXMLObject )
		' !!!!!! Remember to always include this string at the beginning of the method !!!!!!
		
		Super.XMLIO( XMLObject )
		
		' !!!!!! !!!!!! 
		
		XMLObject.ManageStringAttribute( "first-name", FirstName )
		XMLObject.ManageStringAttribute( "last-name", LastName )
		XMLObject.ManageIntAttribute( "age", Age )
		XMLObject.ManageDoubleAttribute( "height", Height )
		XMLObject.ManageDoubleAttribute( "weight", Weight )
		
		' !!!!!! Remember to equate object to to result of ManageObjectAttribute !!!!!!
		
		Profession = TProfession( XMLObject.ManageObjectField( "profession", Profession ) )
		
		' !!!!!! A = TA( XMLObject.ManageObjectAttribute( "name", A ) ) !!!!!!
	End Method
End Type
Cls
L_PrintText( "Press ESC to end", 0, 0, LTAlign.ToCenter, LTAlign.ToCenter )
Flip
Waitkey
