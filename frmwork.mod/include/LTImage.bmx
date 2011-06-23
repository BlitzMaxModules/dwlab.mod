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
		
	
	
	Method Init()
		Local Pixmap:TPixmap = LoadPixmap( Filename )
		?debug
		'If PixmapWidth( BMaxImage ) Mod XCells <> 0 Or PixmapHeight( BMaxImage ) Mod YCells <> 0 Then L_Error( "Incorrect cells quantity for splitting" )
		?
		BMaxImage = LoadAnimImage( Pixmap, PixmapWidth( Pixmap ) / XCells, PixmapHeight( Pixmap ) / YCells, 0, XCells * YCells )
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