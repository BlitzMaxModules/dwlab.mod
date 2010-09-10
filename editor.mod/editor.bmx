'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

Type LTEditor Extends LTProject
	Field TileMapVisual:LTImageVisual = New LTImageVisual
	Field TileMap:LTTileMap = New LTTileMap
	Field FlashingVisual:LTFlashingVisual = New LTFlashingVisual
	Field Objects:LTList = New LTList
	
	
	
	Method Init()
		TileMap.FrameMap = LTIntMap.FromFile( "levels\03.dat" )
		TileMapVisual.Image = LTImage.FromFile( "media\tiles.png", 16, 4 )
		
	End Method
	
	
	
	Method Logic()
		If KeyHit( Key_F3 ) Then
			'FrameMapFile = RequestFile( "
			TileMap.FrameMap = LTIntMap.FromFile( "levels\03.dat" )
		End If
	End Method
End Type