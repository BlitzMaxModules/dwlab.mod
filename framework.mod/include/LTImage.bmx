'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTImage Extends LTObject
	Field BMaxImage:TImage
	
	
	
	Function FromFile:LTImage( Filename:String, XCells:Int = 1, YCells:Int = 1 )
		?debug
		L_Assert( XCells > 0 And YCells > 0, "Cells quantity must be 1 or more" )
		?
		
		Local Image:LTImage = New LTImage
			
		Local FirstToken:Int = FileName.Find( "#" )
		Local LastToken:Int = FileName.FindLast( "#" )
		Local NumLen:Int = LastToken - FirstToken + 1
		
		Local NewPixmap:TPixmap	
		Local PixmapList:TList = New TList
		Local Num:Int = 0
		
		Repeat
			Local NewFile:String = FileName
			
			If FirstToken >= 0 Then
				Local NumString:String = Num
				For Local K:Int = Len( NumString ) Until NumLen
					NumString = "0" + NumString
				Next
				NewFile = FileName[ ..FirstToken ] + NumString + FileName[ LastToken + 1.. ]
			End If
					
			NewFile = L_TryExtensions( NewFile, [ "png", "jpg", "bmp" ] )
			If Not FileType( NewFile ) Then Exit
				
			NewPixmap = LoadPixmap( NewFile )
	
			PixmapList.AddLast( NewPixmap )
			
			If FirstToken < 0 Then Exit
			Num :+ 1
		Forever
		
		?debug
		L_Assert( NewPixmap <> Null, "Cannot load file named " )
		?
		
		Image.BMaxImage = CreateImage( NewPixmap.Width, NewPixmap.Height, PixmapList.Count() )
		Num = 0
		For Local Pixmap:TPixmap = Eachin PixmapList
			Image.BMaxImage.SetPixmap( Num, Pixmap )
			Num :+ 1
		Next
	
		If XCells > 1 Or YCells > 1 Then Image.Split( XCells, YCells )
		
		SetImageHandle( Image.BMaxImage, 0.5 * ( ImageWidth( Image.BMaxImage ) - 1 ), 0.5 * ( ImageHeight( Image.BMaxImage ) - 1 ) )
		
		Return Image
	End Function
		
	
	
	Method Split( XCells:Int, YCells:Int )
		Local XSize:Float = ImageWidth( BMaxImage ) / XCells
		Local YSize:Float = ImageHeight( BMaxImage ) / YCells
		
		?debug
		L_Assert( Int( XSize ) = XSize And Int( YSize ) = YSize, "Incorrect cells quantity for splitting" )
		?
		
		Local NewBMaxImage:TImage = CreateImage( XSize, YSize, BMaxImage.Pixmaps.Dimensions()[ 0 ] * XCells * YCells )
		SetImageHandle( NewBMaxImage, 0.5 * ( XSize - 1 ), 0.5 * ( YSize - 1 ) )

		Local Num:Int = 0
		For Local Pixmap:TPixmap = Eachin BMaxImage.Pixmaps
			Local IntermediateImage:TImage = LoadAnimImage( Pixmap, XSize, YSize, 0, XCells * YCells )
			For Local IntermediatePixmap:TPixmap = Eachin IntermediateImage.Pixmaps
				NewBMaxImage.SetPixmap( Num, IntermediatePixmap )
				Num :+ 1
			Next
		Next
		
		BMaxImage = NewBMaxImage
	End Method
	
	
	
	Method SetHandle( X:Float, Y:Float )
		SetImageHandle( BMaxImage, X * ImageWidth( BMaxImage ), Y * ImageHeight( BMaxImage ) )
	End Method
End Type