SuperStrict

Import dwlab.frmwork

Local N:Int = 0
Local Sprites:TList = New TList
Local MaxWidth:Int, Maxheight:Int
Local EmptyCol:Int
Local SpriteHeight:Int[] = New Int[ 1000 ]
For Local N:Int = 0 To 459
	Local FileName:String = "pre2-sprites\sprite-" + N + ".png"
	Local Pixmap:TPixmap
	If FileType( FileName ) = 1 Then
		Pixmap = LoadPixmap( FileName )
		If N = 0 Then EmptyCol = ReadPixel( Pixmap, 0, 0 )
	Else
		Pixmap = CreatePixmap( 1, 1, PF_RGBA8888 )
	End If
	MaxWidth = Max( MaxWidth, PixmapWidth( Pixmap ) )
	MaxHeight = Max( MaxHeight, PixmapHeight( Pixmap ) )
	SpriteHeight[ N ] = PixmapHeight( Pixmap )
	Sprites.AddLast( Pixmap )
Next

Local BigPixmap:TPixmap = CreatePixmap( MaxWidth * 16, MaxHeight * Ceil( 1.0 * Sprites.Count() / 16 ), PF_RGBA8888 )
ClearPixels( BigPixmap, 0 )
Local X:Int = 0, Y:Int = 0
For Local Pixmap:TPixmap = Eachin Sprites
	BigPixmap.Paste( Pixmap, X + 0.5 * ( MaxWidth - PixmapWidth( Pixmap ) ), Y + 0.5 * ( MaxHeight - PixmapHeight( Pixmap ) ) )
	X :+ MaxWidth
	If X = MaxWidth * 16 Then
		X = 0
		Y :+ MaxHeight
	End If
Next
For Local YY:Int = 0 Until PixmapHeight( BigPixmap )
	For Local XX:Int = 0 Until PixmapWidth( BigPixmap )
		If ReadPixel( BigPixmap, XX, YY ) = EmptyCol Then WritePixel( BigPixmap, XX, YY, 0 )
	Next
Next
SavePixmapPNG( BigPixmap, "sprites.png" )

Local SpriteImages:LTImage = LTImage.FromFile( "sprites.png", -MaxWidth, - MaxHeight )	


Local World:LTWorld = New LTWorld
L_CurrentCamera.SetMagnification( 8 )
World.Camera = L_CurrentCamera

For Local N:Int = 1 To 16
	Local Layer:LTLayer = New LTLayer
	Local Pixmap:TPixmap = LoadPixmap( "tileset-level-" + N + ".png" )
	For Local Y:Int = 0 Until PixmapHeight( Pixmap )
		For Local X:Int = 0 Until PixmapWidth( Pixmap )
			If ReadPixel( Pixmap, X, Y ) = EmptyCol Then WritePixel( Pixmap, X, Y, 0 )
		Next
	Next
	SavePixmapPNG( Pixmap, "tileset" + N + ".png" )
	
	Local Image:LTImage = LTImage.FromFile( "tileset" + N + ".png", -16, -16 )
	World.Images.AddLast( Image )
	local TileSet:LTTileSet = New LTTileSet
	TileSet.Image = Image
	DebugLog Image.FramesQuantity()
	TileSet.RefreshTilesQuantity()
	World.Tilesets.AddLast( TileSet )
	
	Local File:TStream = ReadFile( "data-level-" + N + ".txt" )
	Local Width:Int = ReadShort( File )
	Local Height:Int = ReadShort( File )
	ReadShort( File )
	ReadShort( File )
	
	Local Map:LTTileMap = LTTileMap.Create( TileSet, Width, Height )
	Map.SetSize( Width, Height )
	For Local X:Int = 0 Until Width
		For Local Y:Int = 0 Until Height
			Map.Value[ X, Y ] = ReadShort( File )
			If Map.Value[ X, Y ] >= Image.FramesQuantity() Then Map.Value[ X, Y ] = Image.FramesQuantity() - 1
		Next
	Next
	
	CloseFile( File )
	
	Local SpriteMap:LTSpriteMap = LTSpriteMap.CreateForShape( Map, 4.0, 4.0 )
	
	For Local Group:String = Eachin [ "start", "items", "enemies" ]
		File:TStream = ReadFile( Group + "-level-" + N + ".txt" )
		While Not Eof( File )
			Local Sprite:LTSprite = New LTSprite
			Sprite.SetSize( 0.0625 * MaxWidth, 0.0625 * MaxHeight )
			Local X:Double = 0.0625 * ReadShort( File ) - 0.5 * Map.Width
			Local Y:Double = 0.0625 * ReadShort( File ) - 0.5 * Map.Height
			Sprite.Visualizer.Image =SpriteImages
			Sprite.Frame = ReadShort( File )
			If Sprite.Frame <= 459 Then
				Sprite.SetCoords( X, Y )
				Sprite.SetY( Sprite.Y - 0.03125 * SpriteHeight[ Sprite.Frame ] )
				SpriteMap.InsertSprite( Sprite )
			Else
				DebugLog Sprite.Frame
			End If 
		WEnd
		CloseFile( File )
	Next
	
	Layer.AddLast( Map )
	Layer.AddLast( SpriteMap )
	
	Layer.Bounds = New LTShape
	Layer.Bounds.JumpTo( Map )
	Layer.Bounds.SetSizeAs( Map )
	Layer.AddParameter( "name", "Level " + N )
	World.AddLast( Layer )
Next

World.SaveToFile( "prehistorik.lw" )

