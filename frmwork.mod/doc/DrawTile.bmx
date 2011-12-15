SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers
Import dwlab.audiodrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const TileMapWidth:Int = 16
	Const TileMapHeight:Int = 12
	Const ShakingPeriod:Double = 1.0
	Const PeriodBetweenShakes:Double = 3.0
	
	Field TileMap:LTTileMap = LTTileMap.Create( LTTileSet.Create( LTImage.FromFile( "tiles.png", 8, 4 ) ), TileMapWidth, TileMapHeight )
	Field HitSound:TSound = TSound.Load( "hit.ogg", False )
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
	End Method
End Type

Type TShakingVisualizer Extends LTVisualizer
	Const DAngle:Double = 15
	Const DCoord:Double = 0.2
	
	Method DrawTile( TileMap:LTTileMap, X:Double, Y:Double, Width:Double, Height:Double, TileX:Int, TileY:Int )
		Local TileSet:LTTileSet =Tilemap.TileSet
		Local TileValue:Int = GetTileValue( TileMap, TileX, TileY )
		If TileValue = TileSet.EmptyTile Then Return
		
		SetRotation( Rnd( -DAngle * Example.ShakingK, DAngle * Example.ShakingK ) )
		X :+ Rnd( -DCoord * Example.ShakingK, DCoord * Example.ShakingK )
		Y :+ Rnd( -DCoord * Example.ShakingK, DCoord * Example.ShakingK )
		
		Local SX:Double, SY:Double
		L_CurrentCamera.FieldToScreen( X, Y, SX, SY )
		
		TileSet.Image.Draw( SX, SY, Width, Height, TileValue )		
		
		SetRotation( 0 )
	End Method
End Type