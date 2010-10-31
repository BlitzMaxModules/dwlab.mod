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
		Local IXSize:Int = PixmapWidth( Pixmap ) / 3
		Local IYSize:Int = PixmapHeight( Pixmap ) / 3
		For Local XN:Int = 0 To 2
			For Local YN:Int = 0 To 2
				Images[ XN, YN ] = CreateImage( IXSize, IYSize )
				Images[ XN, YN ].Pixmaps[ 0 ] = Pixmap.Window( IXSize * XN, IYSize * YN, IXSize, IYSize )
			Next
		Next
	End Method
	
	
	
	Method DrawToRectangle( X:Float, Y:Float, XSize:Float, YSize:Float )
		'If XSize > 400 Then debugstop

    Local SX:Float, SY:Float, SXSize:Float, SYSize:Float
    L_CurrentCamera.FieldToScreen( X, Y, SX, SY )
    L_CurrentCamera.SizeFieldToScreen( XSize, YSize, SXSize, SYSize )
		L_NormalizeSize( SX, SY, SXSize, SYSize )
		
		Local XXSize:Int, YYSize:Int
		
		Local XX:Float = SX
		For Local XN:Int = 0 To 2
			Select XN
				Case 0; XXSize = ImageWidth( Images[ 0, 0 ] )
				Case 1; XXSize = SXSize - ImageWidth( Images[ 0, 0 ] ) - ImageWidth( Images[ 2, 2 ] )
				Case 2; XXSize = ImageWidth( Images[ 2, 2 ] )
			End Select
			Local YY:Float = SY
			For Local YN:Int = 0 To 2
				Select YN
					Case 0; YYSize = ImageHeight( Images[ 0, 0 ] )
					Case 1; YYSize = SYSize - ImageHeight( Images[ 0, 0 ] ) - ImageHeight( Images[ 2, 2 ] )
					Case 2; YYSize = ImageHeight( Images[ 2, 2 ] )
				End Select
				
				SetScale 1.0 * XXSize / ImageWidth( Images[ XN, YN ] ), 1.0 * YYSize / ImageHeight( Images[ XN, YN ] )
				DrawImage Images[ XN, YN ], XX, YY
				
				YY :+ YYSize
			Next
			XX :+ XXSize
		Next
		SetScale 1, 1
	End Method 
End Type


' =========================== Functions ===============================


Function L_NormalizeSize( X:Float, Y:Float, XSize:Float, YSize:Float )
	If XSize < 0 Then
		X = X - XSize
		XSize = -XSize
	End If
	
	If YSize < 0 Then
		Y = Y - YSize
		YSize = -YSize
	End If
End Function