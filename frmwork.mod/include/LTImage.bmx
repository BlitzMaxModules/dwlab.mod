'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_LoadImages:Int = 1

Type LTImage Extends LTObject
	Field BMaxImage:TImage
	Field Filename:String
	Field XCells:Int = 1
	Field YCells:Int = 1
	
	
	
	Function FromFile:LTImage( Filename:String, XCells:Int = 1, YCells:Int = 1 )
		?debug
		If XCells <= 0 Or YCells <= 0 Then L_Error( "Cells quantity must be 1 or more" )
		?
		
		Local Image:LTImage = New LTImage
		Image.Filename = Filename
		Image.XCells = XCells
		Image.YCells = YCells
		Image.Init()
		
		Return Image
	End Function
		
	
	
	Method Split()
		?debug
		'If ImageWidth( BMaxImage ) Mod XCells <> 0 Or ImageHeight( BMaxImage ) Mod YCells <> 0 Then L_Error( "Incorrect cells quantity for splitting" )
		?
		
		Local Width:Int = ImageWidth( BMaxImage ) / XCells
		Local Height:Int = ImageHeight( BMaxImage ) / YCells
		
		Local NewBMaxImage:TImage = CreateImage( Width, Height, BMaxImage.Pixmaps.Dimensions()[ 0 ] * XCells * YCells )
		'SetImageHandle( NewBMaxImage, 0.5 * ( Width - 1 ), 0.5 * ( Height - 1 ) )
		MidHandleImage( NewBMaxImage )

		Local Num:Int = 0
		For Local Pixmap:TPixmap = EachIn BMaxImage.Pixmaps
			Local IntermediateImage:TImage = LoadAnimImage( Pixmap, Width, Height, 0, XCells * YCells )
			For Local IntermediatePixmap:TPixmap = EachIn IntermediateImage.Pixmaps
				NewBMaxImage.SetPixmap( Num, IntermediatePixmap )
				Num :+ 1
			Next
		Next
		
		BMaxImage = NewBMaxImage
	End Method
	
	
	
	Method Init()
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
		If NewPixmap = Null Then L_Error( "Cannot load file named " + FileName )
		?
		
		BMaxImage = CreateImage( NewPixmap.Width, NewPixmap.Height, PixmapList.Count() )
		Num = 0
		For Local Pixmap:TPixmap = EachIn PixmapList
			BMaxImage.SetPixmap( Num, Pixmap )
			Num :+ 1
		Next
	
		If XCells > 1 Or YCells > 1 Then Split()
		
		'SetImageHandle( BMaxImage, 0.5 * ( ImageWidth( BMaxImage ) - 1.0 ), 0.5 * ( ImageHeight( BMaxImage ) - 1.0 ) )
		MidHandleImage( BMaxImage )
	End Method
	
	
	
	Method SetHandle( X:Double, Y:Double )
		SetImageHandle( BMaxImage, X * ImageWidth( BMaxImage ), Y * ImageHeight( BMaxImage ) )
	End Method
	
	
	
	Function Create:LTImage( Width:Int, Height:Int, Frames:Int = 1 )
		Local Image:LTImage = New LTImage
		Image.BMaxImage = CreateImage( Width, Height, Frames )
		Return Image
	End Function
	
	
	
	Method CopyFrame( Frame:Int, FromImage:LTImage, FromFrame:Int )
		Local Pixmap:TPixmap = LockImage( FromImage.BMaxImage, FromFrame )
		BMaxImage.SetPixmap( Frame, Pixmap )
		UnlockImage( FromImage.BMaxImage )
	End Method
	
	
	
	Method FramesQuantity:Int()
		Return BMaxImage.frames.Dimensions()[ 0 ]
	End Method
	
	
	
	Method Width:Double()
		Return BMaxImage.width
	End Method
	
	
	
	Method Height:Double()
		Return BMaxImage.height
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageStringAttribute( "filename", Filename )
		XMLObject.ManageIntAttribute( "xcells", XCells, 1 )
		XMLObject.ManageIntAttribute( "ycells", YCells, 1 )
		
		If L_XMLMode = L_XMLGet And L_LoadImages Then Init()
	End Method
End Type