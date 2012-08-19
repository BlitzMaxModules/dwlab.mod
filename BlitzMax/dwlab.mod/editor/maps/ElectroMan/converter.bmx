SuperStrict

Import dwlab.frmwork

Local World:LTWorld = New LTWorld
L_CurrentCamera.SetMagnification( 8 )
World.Camera = L_CurrentCamera
Local TileSet:LTTileSet[] = New LTTileSet[ 4 ]
For Local N:Int = 0 Until 4
	Local Image:LTImage = LTImage.FromFile( "PLAN" + ( N + 1 ) + ".png", 64, 1 + 5 * ( N < 3 ) + ( N = 0 ) )
	TileSet[ N ] = New LTTileSet
	TileSet[ N ].Image = Image
	Select N
		Case 0
			TileSet[ N ].Name = "Background 1"
		Case 1
			TileSet[ N ].Name = "Background 2"
		Case 2
			TileSet[ N ].Name = "Enemies"
		Case 3
			TileSet[ N ].Name = "Foreground"
	End Select
	
	If N > 0 Then TileSet[ N ].EmptyTile = 0
	TileSet[ N ].RefreshTilesQuantity()
	World.Images.AddLast( Image )
	World.Tilesets.AddLast( TileSet[ N ] )
Next

Local ScreenWidth:Int = 13
Local ScreenHeight:Int = 8


For Local LevelNum:Int = 0 To 18
	Local Layer:LTLayer = New LTLayer
	
	Local DirName:String = "\level" + LevelNum + "\"
	
	Local Dir:Int = ReadDir( CurrentDir() + DirName )
	Local MaxX:Int, MaxY:Int, MinX:Int = 9999, MinY:Int = 9999
	'debugstop
	Repeat
		Local FileName:String = NextFile( Dir )
		If Not FileName Then Exit
		If ExtractExt( FileName ) <> "txt" or FileName[ 0 ] <> Asc( "x" ) Then Continue
		FileName = StripAll( FileName )
		
		Local YPos:Int = FileName.Find( "y" )
		Local DX:Int = ( FileName[ 1..Ypos ].ToInt() ) * ScreenWidth
		Local DY:Int = ( FileName[ Ypos + 1.. ].ToInt() ) * ScreenHeight
		MinX = Min( MinX, DX )
		MinY = Min( MinY, DY )
		MaxX = Max( MaxX, DX + ScreenWidth )
		MaxY = Max( MaxY, DY + ScreenHeight )
	Forever
	
	Local Map:LTTileMap[] = new LTTileMap[ 8 ]
	For Local N:Int = 0 Until 8
		If N < 3 Or N = 5 Then
			Map[ N ] = LTTileMap.Create( TileSet[ N - 2 * ( N = 5 ) ], MaxX - MinX, MaxY - MinY )
			Map[ N ].SetSize( MaxX - MinX, MaxY - MinY )
			Map[ N ].AddParameter( "name", Map[ N ].TileSet.Name )
			Layer.AddLast( Map[ N ] )
		End If
	Next
	
	Dir = ReadDir( CurrentDir() + DirName )
	Repeat
		Local FileName:String = NextFile( Dir )
		If Not FileName Then Exit
		If ExtractExt( FileName ) <> "txt" Then Continue
		Local StrippedFileName:String = StripAll( FileName )
		
		Local YPos:Int = StrippedFileName.Find( "y" )
		Local DX:Int = StrippedFileName[ 1..Ypos ].ToInt() * ScreenWidth - MinX
		Local DY:Int = StrippedFileName[ Ypos + 1.. ].ToInt()* ScreenHeight - MinY
		
		Local File:TStream = ReadFile( DirName[ 1.. ] + FileName )
		For Local N:Int = 0 Until 8
			For Local Y:Int = 0 Until ScreenHeight
				For Local X:Int = 0 Until ScreenWidth
					If Map[ N ] Then
						Map[ N ].Value[ X + DX, Y + DY ] = Abs( ReadLine( File ).ToInt() )
					Else
						ReadLine( File )
					End If
				Next
			Next
		Next
	Forever
	
	Layer.Bounds = New LTShape
	Layer.Bounds.JumpTo( Map[ 0 ] )
	Layer.Bounds.SetSizeAs( Map[ 0 ] )
	Layer.AddParameter( "name", "Level " + LevelNum )
	World.AddLast( Layer )
Next

World.SaveToFile( "electroman.lw" )

