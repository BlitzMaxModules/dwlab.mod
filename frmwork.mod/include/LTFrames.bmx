' 2DLab - 2D application developing environment 
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3


' =========================== Raster frames ===============================


Type LTRasterFrame Extends LTRectangleVisual
	Field Images:TImage[ 3, 3 ]
	Field ImageFile:String
	
	
	
	Function FromFile:LTRasterFrame( Filename:String )
		Local Frm:LTRasterFrame = New LTRasterFrame
		Frm.LoadImages( Filename )
		Frm.ImageFile = FileName
		Return Frm
	End Function
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageStringAttribute( "file", ImageFile )
		If L_XMLMode = L_XMLGet And ImageFile Then LoadImages( ImageFile )
	End Method
	
	
	
	Method LoadImages( Filename:String )
		'debugstop
		FileName = L_TryToAddExtension( FileName )
		Local Pixmap:TPixmap = LoadPixmap( Filename )
		Local IWidth:Int = PixmapWidth( Pixmap ) / 3
		Local IHeight:Int = PixmapHeight( Pixmap ) / 3
		For Local XN:Int = 0 To 2
			For Local YN:Int = 0 To 2
				Images[ XN, YN ] = CreateImage( IWidth, IHeight )
				Images[ XN, YN ].Pixmaps[ 0 ] = Pixmap.Window( IWidth * XN, IHeight * YN, IWidth, IHeight )
			Next
		Next
	End Method
	
	
	
	Method DrawToRectangle( X:Float, Y:Float, Width:Float, Height:Float )
		'If Width > 400 Then debugstop

    Local SX:Float, SY:Float, SWidth:Float, SHeight:Float
    L_CurrentCamera.FieldToScreen( X, Y, SX, SY )
    L_CurrentCamera.SizeFieldToScreen( Width, Height, SWidth, SHeight )
		L_NormalizeSize( SX, SY, SWidth, SHeight )
		
		Local XWidth:Int, YHeight:Int
		
		Local XX:Float = SX
		For Local XN:Int = 0 To 2
			Select XN
				Case 0; XWidth = ImageWidth( Images[ 0, 0 ] )
				Case 1; XWidth = SWidth - ImageWidth( Images[ 0, 0 ] ) - ImageWidth( Images[ 2, 2 ] )
				Case 2; XWidth = ImageWidth( Images[ 2, 2 ] )
			End Select
			Local YY:Float = SY
			For Local YN:Int = 0 To 2
				Select YN
					Case 0; YHeight = ImageHeight( Images[ 0, 0 ] )
					Case 1; YHeight = SHeight - ImageHeight( Images[ 0, 0 ] ) - ImageHeight( Images[ 2, 2 ] )
					Case 2; YHeight = ImageHeight( Images[ 2, 2 ] )
				End Select
				
				SetScale 1.0 * XWidth / ImageWidth( Images[ XN, YN ] ), 1.0 * YHeight / ImageHeight( Images[ XN, YN ] )
				DrawImage Images[ XN, YN ], XX, YY
				
				YY :+ YHeight
			Next
			XX :+ XWidth
		Next
		SetScale 1, 1
	End Method 
End Type


' =========================== Functions ===============================


Function L_NormalizeSize( X:Float, Y:Float, Width:Float, Height:Float )
	If Width < 0 Then
		X = X - Width
		Width = -Width
	End If
	
	If Height < 0 Then
		Y = Y - Height
		Height = -Height
	End If
End Function