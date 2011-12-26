SuperStrict
Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers
Import dwlab.audiodrivers
L_InitGraphics()
L_PrintText( "Press ESC to switch examples", 0, 0, LTAlign.ToCenter, LTAlign.ToCenter )
Flip
Waitkey
EndGraphics()


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
		L_InitGraphics()
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
		CollisionsWithSprite( L_Cursor )
	End Method
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int = 0 )
		If MouseDown( 1 ) Then Active = False
		If MouseDown( 2 ) Then Visible = False
	End Method
End Type
EndGraphics()


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
		L_InitGraphics()
	End Method
	
	Method Logic()
		If KeyDown( Key_Space ) Then
			If StartingTime = 0 Then StartingTime = Time
			Player.Animate( Self, 0.1, 3, 1, StartingTime, PingPong )
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
EndGraphics()


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
		L_InitGraphics()
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
EndGraphics()



'CorrectHeight.bmx
L_CurrentCamera = LTCamera.Create()
Global Example4:TExample4 = New TExample4
Example4.Execute()

Type TExample4 Extends LTProject
	Const SpritesQuantity:Int = 50
	
	Field Layer:LTLayer = New LTLayer
	
	Method Init()
		L_InitGraphics()
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
EndGraphics()



'DirectAs.bmx
L_CurrentCamera = LTCamera.Create()
Global Example5:TExample5 = New TExample5
Example5.Execute()

Type TExample5 Extends LTProject
	Const SpritesQuantity:Int = 50
	
	Field Layer:LTLayer = New LTLayer
	Field Cursor:TCursor5 = New TCursor5
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
		L_InitGraphics()
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



Type TCursor5 Extends LTSprite
	Method Act()
		SetMouseCoords()
		If MouseHit( 1 ) Then CollisionsWithLayer( Example5.Layer, 0 )
		If MouseHit( 2 ) Then CollisionsWithLayer( Example5.Layer, 1 )
	End Method
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int = 0 )
		If CollisionType Then
			SetSizeAs( Sprite )
		Else
			DirectAs( Sprite )
		End If
	End Method
End Type
EndGraphics()



'DirectTo.bmx
L_CurrentCamera = LTCamera.Create()
Global Example6:TExample6 = New TExample6
Example6.Execute()

Type TExample6 Extends LTProject
	Const KoloboksQuantity:Int = 50
	
	Field Layer:LTLayer = New LTLayer
	Field KolobokImage:LTImage = LTImage.FromFile( "incbin::kolobok.png" )
	
	Method Init()
		For Local N:Int = 1 To KoloboksQuantity
			Local Kolobok:TKolobok6 = New TKolobok6
			Kolobok.SetCoords( Rnd( -15, 15 ), Rnd( -11, 11 ) )
			Kolobok.SetDiameter( Rnd( 1, 3 ) )
			Kolobok.ShapeType = LTSprite.Oval
			Kolobok.Visualizer.SetRandomColor()
			Kolobok.Visualizer.Image = KolobokImage
			Layer.AddLast( Kolobok )
		Next
		L_InitGraphics()
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



Type TKolobok6 Extends LTSprite
	Method Act()
		DirectTo( L_Cursor )
	End Method
End Type
EndGraphics()


'DistanceToPoint.bmx
L_CurrentCamera = LTCamera.Create()
Global Example7:TExample7 = New TExample7
Example7.Execute()

Type TExample7 Extends LTProject
	Const SpritesQuantity:Int = 20
	
	Field Layer:LTLayer = New LTLayer
	Field Line:LTLine = New LTLine
	Field MinSprite:LTSprite

	Method Init()
		L_InitGraphics()
		For Local N:Int = 1 To SpritesQuantity
			Local Sprite:LTSprite = LTSprite.FromShape( Rnd( -15, 15 ), Rnd( -11, 11 ), , , LTSprite.Oval )
			Sprite.SetDiameter( Rnd( 0.5, 1.5 ) )
			Sprite.Visualizer.SetRandomColor()
			Layer.AddLast( Sprite )
		Next
		L_Cursor = LTSprite.FromShape( 0, 0, 0.5, 0.5, LTSprite.Oval )
		Line.Pivot[ 0 ] = L_Cursor
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
		Line.Pivot[ 1 ] = MinSprite
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		
		Line.Draw()
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
EndGraphics()


'DrawCircle.bmx
L_CurrentCamera = LTCamera.Create()
Global Example8:TExample8 = New TExample8
Example8.Execute()

Type TExample8 Extends LTProject
	Const MapSize:Int = 128
	Const MapScale:Double = 4.0
	Const PicScale:Double = 5.0

	Field DoubleMap:LTDoubleMap = LTDoubleMap.Create( MapSize, MapSize )
	
	Method Init()
		L_InitGraphics()
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
End Type
EndGraphics()


Incbin "tiles.png"
Incbin "hit.ogg"

'DrawTile.bmx
L_CurrentCamera = LTCamera.Create()
Global Example9:TExample9 = New TExample9
Example9.Execute()

Type TExample9 Extends LTProject
	Const TileMapWidth:Int = 16
	Const TileMapHeight:Int = 12
	Const ShakingPeriod:Double = 1.0
	Const PeriodBetweenShakes:Double = 3.0
	
	Field TileMap:LTTileMap = LTTileMap.Create( LTTileSet.Create( LTImage.FromFile( "incbin::tiles.png", 8, 4 ) ), TileMapWidth, TileMapHeight )
	Field HitSound:TSound = TSound.Load( "incbin::hit.ogg", False )
	Field ShakingK:Double
	Field LastShakingTime:Double = -100
	
	Method Init()
		L_InitGraphics()
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
		
		SetRotation( Rnd( -DAngle * Example9.ShakingK, DAngle * Example9.ShakingK ) )
		X :+ Rnd( -DCoord * Example9.ShakingK, DCoord * Example9.ShakingK )
		Y :+ Rnd( -DCoord * Example9.ShakingK, DCoord * Example9.ShakingK )
		
		Local SX:Double, SY:Double
		L_CurrentCamera.FieldToScreen( X, Y, SX, SY )
		
		TileSet.Image.Draw( SX, SY, Width, Height, TileValue )		
		
		SetRotation( 0 )
	End Method
End Type
EndGraphics()


'DrawUsingLine.bmx
L_CurrentCamera = LTCamera.Create()
Global Example10:TExample10 = New TExample10
Example10.Execute()

Type TExample10 Extends LTProject
	Field Lines:LTLayer = New LTLayer
	
	Method Init()
		L_InitGraphics( 800, 600, 75 )
		Local Visualizer:TBlazing = New TBlazing
		For Local Pivots:Int[] = Eachin [ [ -4, -2, -2, -2 ], [ -4, -2, -4, 0 ], [ -4, 0, -4, 2 ], [ -4, 0, -3, 0 ], [ 1, -2, -1, -2 ], [ -1, -2, -1, 0 ], [ -1, 0, 1, 0 ], ..
				[ 1, 0, 1, 2 ], [ 1, 2, -1, 2 ], [ 4, -2, 2, -2 ], [ 2, -2, 2, 0 ], [ 2, 0, 2, 2 ], [ 2, 0, 3, 0 ] ]
			Local Line:LTLine = LTLine.FromPivots( LTSprite.FromShape( Pivots[ 0 ], Pivots[ 1 ] ), LTSprite.FromShape( Pivots[ 2 ], Pivots[ 3 ] ) )
			Line.Visualizer = Visualizer
			Lines.AddLast( Line )
		Next
	End Method
	
	Method Logic()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Lines.Draw()
		DrawText( "Free Software Forever!", 0, 0 )
		L_PrintText( "DrawUsingLine example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TBlazing Extends LTVisualizer
	Const ChunkSize:Double = 25
	Const DeformationRadius:Double = 15
	Method DrawUsingLine( Line:LTLine )
		Local SX1:Double, SY1:Double, SX2:Double, SY2:Double
		L_CurrentCamera.FieldToScreen( Line.Pivot[ 0 ].X, Line.Pivot[ 0 ].Y, SX1, SY1 )
		L_CurrentCamera.FieldToScreen( Line.Pivot[ 1 ].X, Line.Pivot[ 1 ].Y, SX2, SY2 )
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
EndGraphics()


'DrawUsingSprite.bmx
L_CurrentCamera = LTCamera.Create()
Global Example11:TExample11 = New TExample11
Example11.Execute()

Type TExample11 Extends LTProject
	Const FlowersQuantity:Int = 12
	Const FlowerCircleDiameter:Double = 9
	Const FlowerDiameter:Double = 1.8
	
	Field Flowers:LTSprite[] = New LTSprite[ FlowersQuantity ]
	Field FlowerVisualizer:TFlowerVisualizer = New TFlowerVisualizer
	
	Method Init()
		L_InitGraphics()
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
	
	Method DrawUsingSprite( Sprite:LTSprite )
		Local SpriteDiameter:Double = Sprite.GetDiameter()
		Local CircleDiameter:Double = L_CurrentCamera.DistFieldToScreen( 2.0 * Pi * SpriteDiameter / CirclesQuantity ) * 1.5
		For Local N:Int = 0 Until CirclesQuantity
			Local Angle:Double = 360.0 * N / CirclesQuantity
			Local Angles:Double = Sprite.Angle + Angle
			Local Distance:Double = SpriteDiameter * ( 1.0 + Amplitude * Sin( 360.0 * Example11.Time + 360.0 * N / CirclesQuantity * CirclesPer360 ) )
			Local SX:Double, SY:Double
			L_CurrentCamera.FieldToScreen( Sprite.X + Distance * Cos( Angles ), Sprite.Y + Distance * Sin( Angles ), SX, SY )
			DrawOval( SX - 0.5 * CircleDiameter, SY - 0.5 * CircleDiameter, CircleDiameter, CircleDiameter )
		Next
	End Method
End Type
EndGraphics()


Const MapSize12:Int = 64
Const MapScale12:Double = 8
Const FilledTileNum12:Int = 20

Incbin "tileset.lw"
Incbin "curved_areas.png"

'Enframe.bmx
L_CurrentCamera = LTCamera.Create()
Ex12()
Function Ex12()
L_InitGraphics()
SetClsColor( 64, 128, 0 )

Cls
Local DoubleMap:LTDoubleMap = New LTDoubleMap
DoubleMap.SetResolution( MapSize12, MapSize12 )
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
Local TileSet:LTTileSet = LTTileSet( World.Tilesets.First() )
Local TileMap:LTTileMap = LTTileMap.Create( TileSet, MapSize12, MapSize12 )
TileMap.SetSize( MapSize12 * MapScale12 / 25.0, MapSize12 * MapScale12 / 25.0 )
DrawText( "Step 3: loading world, extract tileset from there and", 0, 0 )
DrawText( "creating tilemap with same size and this tileset", 0, 16 )
DrawDoubleMap( DoubleMap )
Flip
Waitkey


Cls
DoubleMap.ExtractTo( TileMap, 0.5, 1.0, FilledTileNum12 )
DrawText( "Step 4: setting tiles number of tilemap to FilledTileNum12", 0, 0 )
DrawText( "if corresponding value of Double map is higher than 0.5", 0, 16 )
TileMap.Draw()
DrawSignature()
Flip
Waitkey

Cls
For Local Y:Int = 0 Until MapSize12
	For Local X:Int = 0 Until MapSize12
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

    

End Function
Function DrawDoubleMap( Map:LTDoubleMap )
	Local Image:TImage = CreateImage( MapSize12, MapSize12 )
	Local Pixmap:TPixmap = Lockimage( Image )
	ClearPixels( Pixmap, $FF000000 )
	Map.PasteToPixmap( Pixmap )
	Unlockimage( Image )
	SetScale( MapScale12, MapScale12 )
	DrawImage( Image, 400 - 0.5 * MapScale12 * MapSize12, 300 - 0.5 * MapScale12 * MapSize12 )
	SetScale( 1, 1 )
	DrawSignature()
End Function



Function DrawSignature()
	L_PrintText( "PerlinNoise, ExtractTo, Enframe, L_ProlongTiles, example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
End Function



Function Fix( TileMap:LTTileMap, X:Int, Y:Int )
	If TileMap.Value[ X, Y ] = FilledTileNum12 Then Return
	Local DoFix:Int = False
	
	Local FixHorizontal:Int = True
	If X > 0 And X < MapSize12 - 1 Then
		If TileMap.Value[ X - 1, Y ] = FilledTileNum12 And TileMap.Value[ X + 1, Y ] = FilledTileNum12 Then DoFix = True
	Else
		FixHorizontal = False
	End If
	
	Local FixVertical:Int = True
	If Y > 0 And Y < MapSize12 - 1 Then
		If TileMap.Value[ X, Y - 1 ] = FilledTileNum12 And TileMap.Value[ X, Y + 1 ] = FilledTileNum12 Then DoFix = True
	Else
		FixVertical = False
	End If
	
	If DoFix Then
		TileMap.Value[ X, Y ] = FilledTileNum12
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
EndGraphics()



'GetTileForPoint.bmx
L_CurrentCamera = LTCamera.Create()
Global Example13:TExample13 = New TExample13
Example13.Execute()

Type TExample13 Extends LTProject
	Const TileMapWidth:Int = 16
	Const TileMapHeight:Int = 12
	
	Field TileSet:LTTileSet = LTTileSet.Create( LTImage.FromFile( "incbin::tiles.png", 8, 4 ) )
	Field TileMap:LTTileMap = LTTileMap.Create( TileSet, TileMapWidth, TileMapHeight )
	Field Cursor:LTSprite = LTSprite.FromShape( 0, 0, 2, 2 )
	
	Method Init()
		L_InitGraphics()
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
		if MouseDown( 1 ) Then TileMap.SetTile( TileX, TileY, Cursor.Frame )
		If MouseHit( 2 ) Then Cursor.SetAsTile( TileMap, TileX, TileY )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		TileMap.Draw()
		Cursor.Draw()
		DrawText( "Press right mouse button to select brush, left button to draw.", 0, 0 )
		L_PrintText( "GetTileForPoint, SetTile, SetAsTile example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
EndGraphics()



'GetTileValue.bmx
L_CurrentCamera = LTCamera.Create()
Global Example14:TExample14 = New TExample14
Example14.Execute()

Type TExample14 Extends LTProject
	Const TileMapWidth:Int = 16
	Const TileMapHeight:Int = 12
	
	Field TileMap:LTTileMap = LTTileMap.Create( LTTileSet.Create( LTImage.FromFile( "incbin::tiles.png", 8, 4 ) ), TileMapWidth, TileMapHeight )
	
	Method Init()
		L_InitGraphics()
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
EndGraphics()


'LeftX.bmx
L_CurrentCamera = LTCamera.Create()
Global Example15:TExample15 = New TExample15
Example15.Execute()

Type TExample15 Extends LTProject
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 0, 8, 6 )
	Field Ball:LTSprite = LTSprite.FromShape( 0, 0, 1, 1, LTSprite.Oval )
	
	Method Init()
		L_InitGraphics()
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
EndGraphics()


'LimitByWindowShape.bmx
L_CurrentCamera = LTCamera.Create()
Global Example16:TExample16 = New TExample16
Example16.Execute()

Type TExample16 Extends LTProject
	Field Ball1:LTSprite = LTSprite.FromShape( 0, 0, 3, 3, LTSprite.Oval )
	Field Ball2:LTSprite = LTSprite.FromShape( 0, 0, 2, 2, LTSprite.Oval )
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 0, 10, 10 )
	
	Method Init()
		L_InitGraphics()
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
EndGraphics()


'LimitWith.bmx
L_CurrentCamera = LTCamera.Create()
Global Example17:TExample17 = New TExample17
Example17.Execute()

Type TExample17 Extends LTProject
	Field Ball:LTSprite[] = New LTSprite[ 7 ]
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 0, 22, 14 )
	
	Method Init()
		L_InitGraphics()
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
EndGraphics()



'LTAction.bmx
L_CurrentCamera = LTCamera.Create()
Global Example18:TExample18 = New TExample18
Example18.Execute()

Type TExample18 Extends LTProject
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
		L_InitGraphics()
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
		Shape = L_Cursor.FirstCollidedSpriteOfLayer( Example18.Sprites )
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
EndGraphics()


Incbin "font.png"
Incbin "font.lfn"

'LTBitmapFont.bmx
L_CurrentCamera = LTCamera.Create()
Ex19()
Function Ex19()
L_InitGraphics()
Local Font:LTBitmapFont = LTBitmapFont.FromFile( "incbin::font.png", 32,127, 16, True )

SetClsColor 0, 128, 0
Cls

Repeat
	If AppTerminate() Or KeyHit( Key_Escape ) Then Exit
	Font.Print( "Hello!", Rnd( -15, 15 ), Rand( -11, 11 ), Rnd( 0.5, 2.0 ), Rand( 0, 2 ), Rand( 0, 2 ) )
	L_PrintText( "LTBitmapFont example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	Flip
Forever
EndGraphics()
End Function


'LTButtonAction.bmx
L_CurrentCamera = LTCamera.Create()
Global Example20:TExample20 = New TExample20
Example20.Execute()


Type TExample20 Extends LTProject
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
		L_InitGraphics()
		Player.Visualizer.SetColorFromHex( "7FBFFF" )
	End Method
	
	Method Logic()
		If MoveLeft.IsDown() Then Player.Move( -Velocity, 0 )
		If MoveRight.IsDown() Then Player.Move( Velocity, 0 )
		If MoveUp.IsDown() Then Player.Move( 0, -Velocity )
		If MoveDown.IsDown() Then Player.Move( 0, Velocity )
		If Fire.IsDown() Then TBullet.Create()
		
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



Type TBullet Extends LTSprite
	Function Create:TBullet()
		Local Bullet:TBullet = New TBullet
		Bullet.SetCoords( Example20.Player.X, Example20.Player.Y )
		Bullet.SetDiameter( 0.25 )
		Bullet.ShapeType = LTSprite.Oval
		Bullet.Angle = Example20.Player.DirectionTo( L_Cursor )
		Bullet.Velocity = Example20.BulletVelocity
		Bullet.Visualizer.SetColorFromHex( "7FFFBF" )
		Example20.Bullets.AddLast( Bullet )
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
		If Example20.Actions[ ActionNum ].Define() Then
			ActionNum :+ 1
			If ActionNum = Example20.Actions.Dimensions()[ 0 ] Then Exiting = True
		End If
	End Method
	
	Method Render()
		Example20.Render()
		DrawText( "Press key for " + Example20.Actions[ ActionNum ].Name, 0, 16 )
	End Method
End Type
EndGraphics()



'LTCamera.bmx
L_CurrentCamera = LTCamera.Create()
Global Example21:TExample21 = New TExample21
Example21.Execute()

Type TExample21 Extends LTProject
	Const TileMapWidth:Int = 64
	Const TileMapHeight:Int = 64
	
	Field TileMap:LTTileMap = LTTileMap.Create( LTTileSet.Create( LTImage.FromFile( "incbin::tiles.png", 8, 4 ) ), TileMapWidth, TileMapHeight )
	Field Cursor:LTSprite = LTSprite.FromShape( 0, 0, 0.5, 0.5, LTSprite.Oval )
	Field Z:Double, BaseK:Double
	
	Method Init()
		L_InitGraphics()
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
EndGraphics()



'LTDistanceJoint.bmx
L_CurrentCamera = LTCamera.Create()
Local Example22:TExample22 = New TExample22
Example22.Execute()

Type TExample22 Extends LTProject
	Field Hinge:LTSprite = LTSprite.FromShape( 0, -8, 1, 1, LTSprite.Oval )
	Field Weight1:LTVectorSprite = LTVectorSprite.FromShapeAndVector( -8, -6, 3, 3, LTSprite.Oval )
	Field Weight2:LTVectorSprite = LTVectorSprite.FromShapeAndVector( -12, -9, 3, 3, LTSprite.Oval )
	Field Rope1:LTLine = LTLine.FromPivots( Hinge, Weight1 )
	Field Rope2:LTLine = LTLine.FromPivots( Weight1, Weight2 )
	
	Method Init()
		L_InitGraphics()
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

EndGraphics()


'LTGraph.bmx
L_CurrentCamera = LTCamera.Create()
Global Example23:TExample23 = New TExample23
Example23.Execute()

Type TExample23 Extends LTProject
	Const PivotsQuantity:Int = 150
	Const MaxDistance:Double = 3.0
	Const MinDistance:Double = 1.0
	
	Field Graph:LTGraph = New LTGraph
	Field SelectedPivot:LTSprite
	Field Path:TList
	Field PivotVisualizer:LTVisualizer = LTVisualizer.FromHexColor( "4F4FFF" )
	Field LineVisualizer:LTVisualizer = LTContourVisualizer.FromWidthAndHexColor( 0.15, "FF4F4F", , 3.0 )
	Field PathVisualizer:LTVisualizer = LTContourVisualizer.FromWidthAndHexColor( 0.15, "4FFF4F", , 4.0 )
	
	Method Init()
		L_InitGraphics()
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
					Local NewLine:LTLine = LTLine.FromPivots( Pivot1, Pivot2 )
					For Local Line:LTLine = Eachin Graph.Lines.Keys()
						If Line.CollidesWithLine( NewLine, False ) Then
							Passed = False
							Exit
						End If
					Next
					If Passed Then Graph.AddLine( NewLine, False )
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
		Graph.DrawLinesUsing( LineVisualizer )
		LTGraph.DrawPath( Path, PathVisualizer )
		Graph.DrawPivotsUsing( PivotVisualizer )
		If SelectedPivot Then SelectedPivot.DrawUsingVisualizer( PathVisualizer )
		DrawText( "Select first pivot with left mouse button and second with right one", 0, 0 )
		L_PrintText( "LTGraph, FindPath, CollidesWithLine example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
EndGraphics()



'LTMarchingAnts.bmx
L_CurrentCamera = LTCamera.Create()
Global Example24:TExample24 = New TExample24
Example24.Execute()

Type TExample24 Extends LTProject
	Const SpritesQuantity:Int = 50
	
	Field Layer:LTLayer = New LTLayer
	Field Cursor:TCursor24 = New TCursor24
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
		L_InitGraphics()
	End Method
	
	Method Logic()
		Cursor.Act()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		If Selected Then Selected.DrawUsingVisualizer( Example24.MarchingAnts )
		DrawText( "Select Sprite by left-clicking on it", 0, 0 )
		L_PrintText( "LTMarchingAnts example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TCursor24 Extends LTSprite
	Method Act()
		SetMouseCoords()
		If MouseHit( 1 ) Then
			Example24.Selected = Null
			CollisionsWithLayer( Example24.Layer )
		End If
	End Method
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int = 0 )
		Example24.Selected = Sprite
	End Method
End Type
EndGraphics()


Incbin "border.png"

'LTRasterFrame.bmx
L_CurrentCamera = LTCamera.Create()
Global Example25:TExample25 = New TExample25
Example25.Execute()

Type TExample25 Extends LTProject
	Field Frame:LTSprite
	Field FrameImage:LTRasterFrame = LTRasterFrame.FromFileAndBorders( "incbin::border.png", 8, 8, 8, 8 )
	Field Layer:LTLayer = New LTLayer
	Field CreateFrame:TCreateFrame = New TCreateFrame
	
	Method Init()
		L_InitGraphics()
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
		Example25.Frame = LTSprite.FromShape( L_Cursor.X, L_Cursor.Y, 0, 0 )
		Example25.Frame.Visualizer.SetRandomColor()
		Example25.Frame.Visualizer.Image = Example25.FrameImage
	End Method

	Method Dragging()
		Local CornerX:Double, CornerY:Double
		If StartingX < L_Cursor.X Then CornerX = StartingX Else CornerX = L_Cursor.X
		If StartingY < L_Cursor.Y Then CornerY = StartingY Else CornerY = L_Cursor.Y
		Example25.Frame.SetSize( Abs( StartingX - L_Cursor.X ), Abs( StartingY - L_Cursor.Y ) )
		Example25.Frame.SetCornerCoords( CornerX, CornerY )
	End Method
	
	Method EndDragging()
		Example25.Layer.AddLast( Example25.Frame )
		Example25.Frame = Null
	End Method
End Type
EndGraphics()


Incbin "human.lw"
Incbin "part.png"

'LTRevoluteJoint.bmx
L_CurrentCamera = LTCamera.Create()
Global Example26:TExample26 = New TExample26
Example26.Execute()

Type TExample26 Extends LTProject
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
		L_PrintText( "LTFixedJoint, LTRevoluteJoint example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
EndGraphics()


'LTSpriteMap.bmx
L_CurrentCamera = LTCamera.Create()
Global Example27:TExample27 = New TExample27
Example27.Execute()

Const MapSize27:Int = 192

Type TExample27 Extends LTProject
	Const SpritesQuantity:Int = 800
	
	Field Rectangle:LTShape = LTSprite.FromShape( 0, 0, MapSize27, MapSize27 )
	Field Cursor:LTSprite = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
	Field SpriteMap:LTSpriteMap = LTSpriteMap.CreateForShape( Rectangle, 2.0 )
	
	Method Init()
		For Local N:Int = 1 To SpritesQuantity
			TBall27.Create()
		Next
		Rectangle.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.1, "FF0000" )
		L_InitGraphics()
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



Type TBall27 Extends LTSprite
	Function Create:TBall27()
		Local Ball:TBall27 = New TBall27
		Ball.SetCoords( Rnd( -0.5 * ( MapSize27 - 2 ), 0.5 * ( MapSize27 - 2 ) ), Rnd( -0.5 * ( MapSize27 - 2 ), 0.5 * ( MapSize27 - 2 ) ) )
		Ball.SetDiameter( Rnd( 0.5, 1.5 ) )
		Ball.Angle = Rnd( 360 )
		Ball.Velocity = Rnd( 3, 7 )
		Ball.ShapeType = LTSprite.Oval
		Ball.Visualizer.SetRandomColor()
		Example27.SpriteMap.InsertSprite( Ball )
		Return Ball
	End Function
	
	Method Act()
		Super.Act()
		L_CurrentCamera.BounceInside( Example27.Rectangle )
		MoveForward()
		BounceInside( Example27.Rectangle )
		CollisionsWithSpriteMap( Example27.SpriteMap )
	End Method
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int = 0 )
		If TParticleArea( Sprite ) Then Return
		PushFromSprite( Sprite )
		Angle = Sprite.DirectionTo( Self )
		Sprite.Angle = DirectionTo( Sprite )
		TParticleArea.Create( Self, Sprite )
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
		Area.StartingTime = Example27.Time
		Local Angle:Double = Ball1.DirectionTo( Ball2 ) + 90
		For Local N:Int = 0 Until ParticlesQuantity
			Local Particle:LTSprite = New LTSprite
			Particle.JumpTo( Area )
			Particle.Angle = Angle + Rnd( -15, 15 ) + ( N Mod 2 ) * 180
			Particle.SetDiameter( Rnd( 0.2, 0.6 ) )
			Particle.Velocity = Rnd( 0.5, 3 )
			Area.Particles.AddLast( Particle )
		Next
		Example27.SpriteMap.InsertSprite( Area )
	End Function
	
	Method Draw()
		Local A:Double = 1.0 - ( Example27.Time - StartingTime ) / FadingTime
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
		If Example27.Time > StartingTime + FadingTime Then Example27.SpriteMap.RemoveSprite( Self )

		If CollidesWithSprite( L_CurrentCamera ) Then
			For Local Sprite:LTSprite = Eachin Particles
				Sprite.MoveForward()
			Next
		End If
	End Method
End Type
EndGraphics()


Incbin "tileset.png"

'LTVectorSprite.bmx
L_CurrentCamera = LTCamera.Create()
Global Example28:TExample28 = New TExample28
Example28.Execute()

Type TExample28 Extends LTProject
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
		L_InitGraphics()
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
	
	Function Create:TPlayer()
		Local Player:TPlayer = New TPlayer
		Player.SetSize( 0.8, 1.8 )
		Player.SetCoords( 0, 2 -0.5 * Example28.MapSize )
		Player.Visualizer.Image = LTImage.FromFile( "incbin::mario.png", 4 )
		Return Player
	End Function
	
	Method Act()
		Move( DX, 0 )
		CollisionsWithTileMap( Example28.TileMap, Horizontal )
		OnLand = False
		Move( 0, DY )
		DY = DY + Example28.PerSecond( Gravity )
		CollisionsWithTileMap( Example28.TileMap, Vertical )
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
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int = 0 )
		Local TileNum:Int = TileMap.GetTile( TileX, TileY )
		If TileNum = Example28.Coin Then
			TileMap.Value[ TileX, TileY ] = Example28.Void
			Example28.Coins :+ 1
		ElseIf TileNum = Example28.Bricks Then
			PushFromTile( TileMap, TileX, TileY )
			If CollisionType = Vertical Then
				If DY > 0 Then OnLand = True
				DY = 0
			End If
		End If
	End Method
End Type
EndGraphics()


'L_Distance.bmx
L_CurrentCamera = LTCamera.Create()
Global Example29:TExample29 = New TExample29
Example29.Execute()

Type TExample29 Extends LTProject
	Field X:Int = 400
	Field Y:Int = 300
	
	Method Init()
		L_InitGraphics()
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
EndGraphics()


'L_DrawEmptyRect.bmx
L_CurrentCamera = LTCamera.Create()
Ex30()
Function Ex30()
L_InitGraphics
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
EndGraphics()
End Function


'L_IntInLimits.bmx
L_CurrentCamera = LTCamera.Create()
Global Example31:TExample31 = New TExample31
Example31.Execute()

Type TExample31 Extends LTProject
	Field Word:String
	
	Method Init()
		L_InitGraphics()
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
EndGraphics()


'L_LimitInt.bmx
L_CurrentCamera = LTCamera.Create()
Global Example32:TExample32 = New TExample32
Example32.Execute()

Type TExample32 Extends LTProject
	Method Init()
		L_InitGraphics()
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
EndGraphics()
' First sprite is moving at constant speed regardles of LogicFPS because it use delta-timing PerSecond() method to determine
' on which distance to move in particular logic frame.Second sprite use simple coordinate addition.



'L_LogicFPS.bmx
L_CurrentCamera = LTCamera.Create()
Global Example33:TExample33 = New TExample33
Example33.Execute()

Type TExample33 Extends LTProject
	Field Sprite1:LTSprite = LTSprite.FromShape( -10, -2, 2, 2, LTSprite.Oval )
	Field Sprite2:LTSprite = LTSprite.FromShape( -10, 2, 2, 2, LTSprite.Oval )

	Method Init()
		L_InitGraphics()
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
EndGraphics()


'L_WrapInt.bmx
L_CurrentCamera = LTCamera.Create()
Global Example34:TExample34 = New TExample34
Example34.Execute()

Type TExample34 Extends LTProject
	Method Init()
		L_InitGraphics()
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
EndGraphics()


'MoveTowards.bmx
L_CurrentCamera = LTCamera.Create()
Global Example35:TExample35 = New TExample35
Example35.Execute()

Type TExample35 Extends LTProject
	Field Ball:LTSprite = LTSprite.FromShape( 0, 0, 3, 3, LTSprite.Oval, 0, 5 )
	
	Method Init()
		L_InitGraphics()
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
EndGraphics()


'MoveUsingKeys.bmx
L_CurrentCamera = LTCamera.Create()
Global Example36:TExample36 = New TExample36
Example36.Execute()

Type TExample36 Extends LTProject
	Field Ball1:LTSprite = LTSprite.FromShape( -8, 0, 1, 1, LTSprite.Oval, 0, 7 )
	Field Ball2:LTSprite = LTSprite.FromShape( 0, 0, 2, 2, LTSprite.Oval, 0, 3 )
	Field Ball3:LTSprite = LTSprite.FromShape( 8, 0, 1.5, 1.5, LTSprite.Oval, 0, 5 )
	
	Method Init()
		Ball1.Visualizer = LTVisualizer.FromHexColor( "FF0000" )
		Ball2.Visualizer = LTVisualizer.FromHexColor( "00FF00" )
		Ball3.Visualizer = LTVisualizer.FromHexColor( "0000FF" )
		L_InitGraphics()
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
EndGraphics()


'Overlaps.bmx
L_CurrentCamera = LTCamera.Create()
Global Example37:TExample37 = New TExample37
Example37.Execute()

Type TExample37 Extends LTProject
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
		L_InitGraphics()
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
EndGraphics()


Incbin "parallax.lw"
Incbin "water_and_snow.png"
Incbin "grid.png"
Incbin "clouds.png"

'Parallax.bmx
L_CurrentCamera = LTCamera.Create()
Global Example38:TExample38 = New TExample38
Example38.Execute()

Type TExample38 Extends LTProject
  Field Ground:LTTileMap
  Field Grid:LTTileMap
  Field Clouds:LTTileMap
  
  Method Init()
    L_InitGraphics( 512, 512, 64 )
    
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
	L_PrintText( "Parallax example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
  End Method
End Type
EndGraphics()


Const MapSize39:Int = 128

'Paste.bmx
L_CurrentCamera = LTCamera.Create()
Ex39()
Function Ex39()
L_InitGraphics()

Local SourceMap:LTDoubleMap = LTDoubleMap.Create( MapSize39, MapSize39 )
SourceMap.DrawCircle( MapSize39 * 0.375, MapSize39 * 0.375, MapSize39 * 0.35, 0.6 )
Draw( SourceMap.ToNewImage(), "Source map" )

Local TargetMap:LTDoubleMap = LTDoubleMap.Create( MapSize39, MapSize39 )
TargetMap.DrawCircle( MapSize39 * 0.625, MapSize39 * 0.625, MapSize39 * 0.35, 0.8 )
Draw( TargetMap.ToNewImage(), "Target map" )

Local DoubleMap:LTDoubleMap = LTDoubleMap.Create( MapSize39, MapSize39 )
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
EndGraphics()


Const MapSize40:Int = 256

'PerlinNoise.bmx
L_CurrentCamera = LTCamera.Create()
Ex40()
Function Ex40()
L_InitGraphics()

Local DoubleMap:LTDoubleMap = New LTDoubleMap
DoubleMap.SetResolution( MapSize40, MapSize40 )

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
EndGraphics()
End Function


'PlaceBetween.bmx
L_CurrentCamera = LTCamera.Create()
Global Example41:TExample41 = New TExample41
Example41.Execute()

Type TExample41 Extends LTProject
	Field Pivot1:LTSprite = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
	Field Pivot2:LTSprite = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
	Field Oval1:LTSprite = LTSprite.FromShape( 0, 0, 0.75, 0.75, LTSprite.Oval )
	Field Oval2:LTSprite = LTSprite.FromShape( 0, 0, 0.75, 0.75, LTSprite.Oval )
	Field Line:LTLine = LTLine.FromPivots( Pivot1, Pivot2 )
	
	Method Init()
		L_InitGraphics()
		Line.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.2, "0000FF", 1.0, 2.0 )
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
		Line.Draw()
		Oval1.Draw()
		Oval2.Draw()
		L_PrintText( "PlaceBetween example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type
EndGraphics()


'PrintText.bmx
L_CurrentCamera = LTCamera.Create()
Global Example42:TExample42 = New TExample42
Example42.Execute()

Type TExample42 Extends LTProject
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 0, 16, 12 )
	
	Method Init()
		L_InitGraphics()
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
EndGraphics()



'SaveToFile.bmx
L_CurrentCamera = LTCamera.Create()
Global Example43:TExample43 = New TExample43
Example43.Execute()

Type TExample43 Extends LTProject
	Const SpritesQuantity:Int = 70

	Field Layer:LTLayer = New LTLayer
	Field Ang:Double
	Field OldSprite:LTSprite

	Method Init()
		L_InitGraphics()
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
EndGraphics()



'SetAsTile.bmx
L_CurrentCamera = LTCamera.Create()
Global Example44:TExample44 = New TExample44
Example44.Execute()

Type TExample44 Extends LTProject
	Const TileMapWidth:Int = 16
	Const TileMapHeight:Int = 12
	
	Field TileSet:LTTileSet = LTTileSet.Create( LTImage.FromFile( "incbin::tiles.png", 8, 4 ) )
	Field TileMap:LTTileMap = LTTileMap.Create( TileSet, TileMapWidth, TileMapHeight )
	Field Pieces:LTLayer = New LTLayer
	
	Method Init()
		L_InitGraphics()
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
		Piece.StartingTime = Example44.Time
		Piece.AngularDirection = -1 + 2 * Rand( 0, 1 )
		Example44.Pieces.AddFirst( Piece )
		Return Piece
	End Function
	
	Method Act()
		MoveForward()
		Angle = ( Example44.Time - StartingTime ) * 45 * AngularDirection
		DY :+ L_PerSecond( Gravity )
		If TopY() > Example44.TileMap.BottomY() Then Example44.Pieces.Remove( Self )
	End Method
End Type
EndGraphics()


'SetAsViewport.bmx
L_CurrentCamera = LTCamera.Create()
Global Example45:TExample45 = New TExample45
Example45.Execute()

Type TExample45 Extends LTProject
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
		L_InitGraphics()
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
EndGraphics()


'SetCornerCoords.bmx
L_CurrentCamera = LTCamera.Create()
Global Example46:TExample46 = New TExample46
Example46.Execute()

Type TExample46 Extends LTProject
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 0, 8, 6 )
	
	Method Init()
		L_InitGraphics()
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
EndGraphics()



'SetFacing.bmx
L_CurrentCamera = LTCamera.Create()
Global Example47:TExample47 = New TExample47
Example47.Execute()

Type TExample47 Extends LTProject
	Field Sprite:LTSprite = LTSprite.FromShape( 0, 0, 8, 8 )
	
	Method Init()
		L_InitGraphics()
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
EndGraphics()



Const TileMapWidth48:Int = 4
Const TileMapHeight48:Int = 3

'Stretch.bmx
L_CurrentCamera = LTCamera.Create()
Ex48()
Function Ex48()
Local TileSet:LTTileSet = LTTileSet.Create( LTImage.FromFile( "incbin::tiles.png", 8, 4 ) )
Local TileMap:LTTileMap = LTTileMap.Create( TileSet, TileMapWidth48, TileMapHeight48 )

L_InitGraphics()
TileMap.SetSize( TileMapWidth48 * 2, TileMapHeight48 * 2 )
For Local Y:Int = 0 Until TileMapHeight48
	For Local X:Int = 0 Until TileMapWidth48
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
EndGraphics()
End Function


Incbin "tank.png"

'Turn.bmx
L_CurrentCamera = LTCamera.Create()
Global Example49:TExample49 = New TExample49
Example49.Execute()

Type TExample49 Extends LTProject
	Const TurningSpeed:Double = 90

	Field Tank:LTSprite = LTSprite.FromShape( 0, 0, 2, 2, LTSprite.Rectangle, 0, 5 )
	
	Method Init()
		L_InitGraphics()
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
EndGraphics()



'WedgeOffWithSprite.bmx
L_CurrentCamera = LTCamera.Create()
Global Example50:TExample50 = New TExample50
Example50.Execute()

Type TExample50 Extends LTProject
	Const KoloboksQuantity:Int = 50
	
	Field Koloboks:LTLayer = New LTLayer
	Field KolobokImage:LTImage = LTImage.FromFile( "incbin::kolobok.png" )
	Field Player:TKolobok50
	Field DebugMode:Int
	
	Method Init()
		For Local N:Int = 1 To KoloboksQuantity
			TKolobok50.CreateKolobok()
		Next
		Player = TKolobok50.CreatePlayer()
		L_InitGraphics()
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



Type TKolobok50 Extends LTSprite
	Const TurningSpeed:Double = 180.0
	
	Function CreatePlayer:TKolobok50()
		Local Player:TKolobok50 = Create()
		Player.SetDiameter( 2 )
		Player.Velocity = 7
		Return Player
	End Function
	
	Function CreateKolobok:TKolobok50()
		Local Kolobok:TKolobok50 = Create()
		Kolobok.SetCoords( Rnd( -15, 15 ), Rnd( -11, 11 ) )
		Kolobok.SetDiameter( Rnd( 1, 3 ) )
		Kolobok.Angle = Rnd( 360 )
		Kolobok.Visualizer.SetRandomColor()
		Return Kolobok
	End Function
	
	Function Create:TKolobok50()
		Local Kolobok:TKolobok50 = New TKolobok50
		Kolobok.ShapeType = LTSprite.Oval
		Kolobok.Visualizer.Image = Example50.KolobokImage
		Kolobok.Visualizer.SetVisualizerScale( 1.3, 1.3 )
		Example50.Koloboks.AddLast( Kolobok )
		Return Kolobok
	End Function
	
	Method Act()
		CollisionsWithLayer( Example50.Koloboks )
	End Method
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int = 0 )
		WedgeOffWithSprite( Sprite, Width ^ 2, Sprite.Width ^ 2 )
	End Method
End Type
EndGraphics()


'XMLIO.bmx
L_CurrentCamera = LTCamera.Create()
Global Example51:TExample51 = New TExample51
Example51.Execute()

Type TExample51 Extends LTProject
	Field People:TList = New TList
	Field Professions:TList = New TList
	
	Method Init()
		L_InitGraphics()
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
		XMLObject.ManageListField( "professions", Example51.Professions )
		XMLObject.ManageChildList( Example51.People )
	End Method
End Type



Type TProfession Extends LTObject
	Field Name:String
	
	Function Create:TProfession( Name:String )
		Local Profession:TProfession = New TProfession
		Profession.Name = Name
		Example51.Professions.AddLast( Profession )
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
		Worker.Profession = TProfession( Example51.Professions.ValueAtIndex( Rand( 0, Example51.Professions.Count() - 1 ) ) )
		Example51.People.AddLast( Worker )
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
EndGraphics()
L_InitGraphics()
L_PrintText( "Press ESC to end", 0, 0, LTAlign.ToCenter, LTAlign.ToCenter )
Flip
Waitkey
