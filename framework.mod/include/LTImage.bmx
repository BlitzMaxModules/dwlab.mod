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
	Field Handle:TImage
	
	
	
	Function FromFile:LTImage( Filename:String, XCells:Int = 0, YCells:Int = 0 )
		Filename = L_TryExtensions( Filename, [ "png", "jpg", "bmp" ] )
		
		Local FirstToken:Int = FileName.Find( "#" )
		Local LastToken:Int = FileName.FindLast( "#" )
		Local NumLen:Int = LastToken - FirstToken + 1
		
		
		
		If FirstToken = 0 Then
			AddPixmapsToImage
		Else
			Local Num:Int = 0
			Repeat
				Local SingleFileName:String = Filename[ ..FirstToken ] + Num
			Forever
		End If
	
		Local Image:LTImage = New LTImage
		If XCells Then
			Local Pixmap:TPixmap = LoadPixmap( Filename )
			
			?debug
			L_Assert( Pixmap <> Null, "Cannot load file named " + Filename + "." )
			?
			
			Image.Handle = LoadAnimImage( Pixmap, Pixmap.Width / XCells, Pixmap.Height / YCells, 0, XCells * YCells )
		Else
			Image.Handle = LoadImage( Filename )
		End If
		Image.SetHandle( 0.5, 0.5 )
		Return Image
	End Function
	
	
	
	Method SetHandle( X:Float, Y:Float )
		SetImageHandle( Handle, X * ImageWidth( Handle ), Y * ImageHeight( Handle ) )
	End Method
End Type