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
bbdoc: Special image subclass to display raster frame.
about: After creating this LTImage sub-class you have to load image. This image should consist of 9 images aligned by 3x3 grid.
When raster frame have been drawn as the rectangular shape which represents sprite on the screen, this shape will be constructed following
way: corner images will be put in corners of the shape, side images will be stretched horizontaly or vertically to fit side bars between them and center
image will be stretched in both direction to fully cover remaining center rectangle.
End Rem
Type LTRasterFrame Extends LTImage
	Field Images:TImage[ , , ]
	
	Rem
	bbdoc: Width of the left column of 3x3 grid part which will be used for left frame side.
	End Rem
	Field LeftBorder:Int = 1
	
	Rem
	bbdoc: Width of the right column of 3x3 grid which will be used for right frame side.
	End Rem
	Field RightBorder:Int = 1
	
	Rem
	bbdoc: Width of the top row of 3x3 grid which will be used for frame's top.
	End Rem
	Field TopBorder:Int = 1
	
	Rem
	bbdoc: Width of the bottom row of 3x3 grid which will be used for frame's bottom.
	End Rem
	Field BottomBorder:Int = 1
	
	Rem
	bbdoc: Flag which switches to another frame displaying algorhytm.
	End Rem
	Field Proportional:Int
	
	
	Rem
	bbdoc: Raster frame creation function.
	about: You should provide image file name and 4 values for borders (optional, 1 by default).
	End Rem
	Function FromFileAndBorders:LTRasterFrame( FileName:String, LeftBorder:Int = 1, TopBorder:Int = 1, RightBorder:Int = 1, BottomBorder:Int = 1 )
		Local Frame:LTRasterFrame = New LTRasterFrame
		Frame.Filename = FileName
		Frame.LeftBorder = LeftBorder
		Frame.TopBorder = TopBorder
		Frame.RightBorder = RightBorder
		Frame.BottomBorder = BottomBorder
		Frame.Init()
		Return Frame
	End Function
	
	
	
	Rem
	bbdoc: Initialization function.
	about: Main image will be splitted into 9 images and put into array for using.
	End Rem
	Method Init()
		Super.Init()
		Local Quantity:Int = BMaxImage.pixmaps.Dimensions()[ 0 ]
		Images = New TImage[ Quantity, 3, 3 ]
		For Local N:Int = 0 Until Quantity
			Local Pixmap:TPixmap = BMaxImage.pixmaps[ N ]
			Local TotalWidth:Int = PixmapWidth( Pixmap )
			Local TotalHeight:Int = PixmapHeight( Pixmap )
			Local Y:Int = 0
			For Local YN:Int = 0 To 2	
				Local Height:Int
				Select YN
					Case 0; Height = TopBorder
					Case 1; Height = TotalHeight - TopBorder - BottomBorder
					Case 2; Height = BottomBorder
				End Select
				Local X:Int = 0
				For Local XN:Int = 0 To 2
					Local Width:Int
					Select XN
						Case 0; Width = LeftBorder
						Case 1; Width = TotalWidth - LeftBorder - RightBorder
						Case 2; Width = RightBorder
					End Select
					Images[ N, XN, YN ] = CreateImage( Width, Height )
					If Width > 0 And Height > 0 Then
						If X + Width <= TotalWidth And Y + Height <= TotalHeight Then
							Images[ N, XN, YN ].Pixmaps[ 0 ] = Pixmap.Window( X, Y, Width, Height )
						End If
					End If
					X :+ Width
				Next
				Y :+ Height
			Next
		Next
	End Method
	
	
	
	Method Draw( X:Double, Y:Double, TotalWidth:Double, TotalHeight:Double, Frame:Int )
		SetRotation( 0.0 )
		Local Width:Double, Height:Double
		Local StartX:Double = X - 0.5 * TotalWidth
		Local StartY:Double = Y - 0.5 * TotalHeight
		If Proportional Then
			If ImageWidth( Images[ Frame, 0, 1 ] ) = 0 Then
				Local Scale:Double = 1.0 * TotalWidth / ImageWidth( Images[ Frame, 1, 1 ] )
				SetScale Scale, Scale
				If Images[ Frame, 1, 0 ] Then DrawImage( Images[ Frame, 1, 0 ], StartX, StartY )
				If Images[ Frame, 2, 2 ] Then DrawImage( Images[ Frame, 1, 2 ], StartX, StartY + TotalHeight - Scale * ImageHeight( Images[ Frame, 1, 2 ] ) )
				SetScale Scale, 1.0 * ( TotalHeight - Scale * ( ImageHeight( Images[ Frame, 1, 0 ] ) + ImageHeight( Images[ Frame, 1, 2 ] ) ) ) / ..
						ImageHeight( Images[ Frame, 1, 1 ] )
				DrawImage( Images[ Frame, 1, 1 ], StartX, StartY + Scale * ImageHeight( Images[ Frame, 1, 0 ] ) )
			Else
				Local Scale:Double = 1.0 * TotalHeight / ImageHeight( Images[ Frame, 1, 1 ] )
				SetScale Scale, Scale
				If Images[ Frame, 0, 1 ] Then DrawImage( Images[ Frame, 0, 1 ], StartX, StartY )
				If Images[ Frame, 2, 1 ] Then DrawImage( Images[ Frame, 2, 1 ], StartX + TotalWidth - Scale * ImageWidth( Images[ Frame, 2, 1 ] ), StartY )
				SetScale ( TotalWidth - Scale * ( ImageWidth( Images[ Frame, 0, 1 ] ) + ImageWidth( Images[ Frame, 2, 1 ] ) ) ) / ..
						ImageWidth( Images[ Frame, 1, 1 ] ), Scale
				DrawImage( Images[ Frame, 1, 1 ], StartX + Scale * ImageWidth( Images[ Frame, 0, 1 ] ), StartY )
			End If
		Else
			Local XX:Float = StartX
			For Local XN:Int = 0 To 2
				Select XN
					Case 0; Width = ImageWidth( Images[ Frame, 0, 0 ] )
					Case 1; Width = TotalWidth - ImageWidth( Images[ Frame, 0, 0 ] ) - ImageWidth( Images[ Frame, 2, 2 ] )
					Case 2; Width = ImageWidth( Images[ Frame, 2, 2 ] )
				End Select
				
				If Width = 0 Then Continue
				
				Local YY:Float = StartY
				For Local YN:Int = 0 To 2
					Select YN
						Case 0; Height = ImageHeight( Images[ Frame, 0, 0 ] )
						Case 1; Height = TotalHeight - ImageHeight( Images[ Frame, 0, 0 ] ) - ImageHeight( Images[ Frame, 2, 2 ] )
						Case 2; Height = ImageHeight( Images[ Frame, 2, 2 ] )
					End Select
					
					If Height = 0 Then Continue
					
					SetScale 1.0 * Width / ImageWidth( Images[ Frame, XN, YN ] ), 1.0 * Height / ImageHeight( Images[ Frame, XN, YN ] )
					DrawImage( Images[ Frame, XN, YN ], XX, YY )
					
					YY :+ Height
				Next
				XX :+ Width
			Next
		End If
		SetScale 1.0, 1.0
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		XMLObject.ManageIntAttribute( "left", LeftBorder, 1 )
		XMLObject.ManageIntAttribute( "right", RightBorder, 1 )
		XMLObject.ManageIntAttribute( "top", TopBorder, 1 )
		XMLObject.ManageIntAttribute( "bottom", BottomBorder, 1 )
		XMLObject.ManageIntAttribute( "proportional", Proportional )
		
		Super.XMLIO( XMLObject )
	End Method
End Type