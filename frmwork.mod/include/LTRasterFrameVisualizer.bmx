'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: Visualizes raster frame in given object's shape.
about: After creating this visualizer you have to load image. This image should consist of 9 images aligned by 3x3 grid.
When raster frame visualizer have been drawn as the rectangular shape which represents sprite on the screen, this shape will be constructed following
way: corner images will be put in corners of the shape, side images will be stretched horizontaly or vertically to fit side bars between them and center
image will be stretched in both direction to fully cover remaining center rectangle.
End Rem
Type LTRasterFrameVisualizer Extends LTVisualizer
	Field Images:TImage[ 3, 3 ]
	Field ImageFile:String
	
	
	
	Rem
	bbdoc: Creates raster frame visualizer from image file name.
	returns: Created visualizer.
	about: See also: FromPixmap
	End Rem
	Function GetFromFile:LTRasterFrameVisualizer( Filename:String )
		FromPixmap( LoadPixmap( L_Incbin + Filename ) )
	End Function
	
	
	
	Rem
	bbdoc: Creates raster frame visualizer from existing pixmap.
	returns: Created visualizer.
	End Rem
	Function FromPixmap:LTRasterFrameVisualizer( Pixmap:TPixmap )
		Local Vis:LTRasterFrameVisualizer = New LTRasterFrameVisualizer
		Local IXSize:Int = PixmapWidth( Pixmap ) / 3
		Local IYSize:Int = PixmapHeight( Pixmap ) / 3
		For Local XN:Int = 0 To 2
			For Local YN:Int = 0 To 2
				Vis.Images[ XN, YN ] = CreateImage( IXSize, IYSize )
				Vis.Images[ XN, YN ].Pixmaps[ 0 ] = Pixmap.Window( IXSize * XN, IYSize * YN, IXSize, IYSize )
			Next
		Next
		Return Vis
	End Function
	
	
	
	Method DrawUsingSprite( Sprite:LTSprite )
	    Local SX:Double, SY:Double, SXSize:Double, SYSize:Double
	    L_CurrentCamera.FieldToScreen( Sprite.LeftX(), Sprite.TopY(), SX, SY )
	    L_CurrentCamera.SizeFieldToScreen( Sprite.Width, Sprite.Height, SXSize, SYSize )
		
		If SXSize < 0 Then
			SX = SX - SXSize
			SXSize = -SXSize
		End If
		
		If SYSize < 0 Then
			SY = SY - SYSize
			SYSize = -SYSize
		End If
		
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