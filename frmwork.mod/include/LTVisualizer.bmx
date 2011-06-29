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
bbdoc: Global variable for default visualizer.
End Rem
Global L_DefaultVisualizer:LTVisualizer = New LTVisualizer

Rem
bbdoc: Visualizer is object which contains parameters for drawing the shape.
End Rem
Type LTVisualizer Extends LTObject
	Rem
	bbdoc: Red color intensity for drawing.
	about: See also: #SetColorFromHex, #SetColorFromRGB, #AlterColor, #ApplyColor, #ResetColor
	End Rem
	Field Red:Double = 1.0
	
	Rem
	bbdoc: Green color intensity for drawing.
	about: See also: #SetColorFromHex, #SetColorFromRGB, #AlterColor, #ApplyColor, #ResetColor
	End Rem
	Field Green:Double = 1.0
	
	Rem
	bbdoc: Blue color intensity for drawing.
	about: See also: #SetColorFromHex, #SetColorFromRGB, #AlterColor, #ApplyColor, #ResetColor
	End Rem
	Field Blue:Double = 1.0
	
	Rem
	bbdoc: Alpha (transparency) value for drawing.
	about: #ApplyColor, #ResetColor
	End Rem
	Field Alpha:Double = 1.0
	
	Rem
	bbdoc: Horizontal shift of displaying image from the center of drawing shape in units .
	about: See also: #SetDXDY
	End Rem
	FIeld DX:Double = 0.0
	
	Rem
	bbdoc: Vertical shift of displaying image from the center of drawing shape in units .
	about: See also: #SetDXDY
	End Rem
	Field DY:Double = 0.0
	
	Rem
	bbdoc: Horizontal scaling of displaying image relative to the width of the drawing shape.
	about: See also: #SetVisualizerScale
	End Rem
	Field XScale:Double = 1.0
	
	Rem
	bbdoc: Vertical scaling of displaying image relative to the height of the drawing shape.
	about: See also: #SetVisualizerScale
	End Rem
	Field YScale:Double = 1.0
	
	Rem
	bbdoc: Scaling flag.
	about: If False then image will be drawn with no scaling at all.
	End Rem
	Field Scaling:Int = True
	
	Rem
	bbdoc: Rotation angle of displaying image relative to the angle of drawing AngularVector (other sprites will be drawed just using visualizer angle).
	End Rem
	Field Angle:Double = 0.0
	
	Rem
	bbdoc: Rotating flag.
	about: If False then Angle parameter will not be used.
	End Rem
	Field Rotating:Int = True

	' ==================== Parameters ====================
	
	Rem
	bbdoc: Sets shifts of the visualizer.
	End Rem
	Method SetDXDY( NewDX:Double, NewDY:Double )
		DX = NewDX
		DY = NewDY
	End Method
	
	
	
	Rem
	bbdoc: Sets scaling parameters of the visualizer
	End Rem
	Method SetVisualizerScale( NewXScale:Double, NewYScale:Double )
		XScale = NewXScale
		YScale = NewYScale
	End Method
	
	
	
	Rem
	bbdoc: Returns visualizer image.
	returns: Visualizer image.
	about: Only for ImageVisualizer, other visualizers will return Null.
	
	See also: #SetImage
	End Rem
	Method GetImage:LTImage()
	End Method
	
	
	
	Rem
	bbdoc: Sets visualizer image.
	about: Only for ImageVisualizer, for other visualizers this method will do nothing.
	
	See also: #GetImage
	End Rem
	Method SetImage( NewImage:LTImage )
	End Method
	
	' ==================== Drawing ===================	
	
	Rem
	bbdoc: Draws given sprite using this visualizer.
	about: Change this method if you are making your own visualizer.
	End Rem
	Method DrawUsingSprite( Sprite:LTSprite )
		?debug
		L_SpritesDisplayed :+ 1
		?
		
		ApplyColor()
		
		Local SX:Double, SY:Double, SWidth:Double, SHeight:Double
		L_CurrentCamera.FieldToScreen( Sprite.X + DX, Sprite.Y + DY, SX, SY )
		L_CurrentCamera.SizeFieldToScreen( Sprite.Width * XScale, Sprite.Height * YScale, SWidth, SHeight )
		
		Select Sprite.ShapeType
			Case LTSprite.Pivot
				DrawOval( SX - 2, SY - 2, 5, 5 )
			Case LTSprite.Circle
				DrawOval( SX - 0.5 * SWidth, SY - 0.5 * SHeight, SWidth, SHeight )
			Case LTSprite.Rectangle
				DrawRect( SX - 0.5 * SWidth, SY - 0.5 * SHeight, SWidth, SHeight )
		End Select
		
		ResetColor()
	End Method
	
	
	
	Rem
	bbdoc: Draws given line using this visualizer.
	about: Change this method if you are making your own visualizer.
	End Rem
	Method DrawUsingLine( Line:LTLine )
		ApplyColor()
		
		Local SX1:Double, SY1:Double, SX2:Double, SY2:Double
		L_CurrentCamera.FieldToScreen( Line.Pivot[ 0 ].X, Line.Pivot[ 0 ].Y, SX1, SY1 )
		L_CurrentCamera.FieldToScreen( Line.Pivot[ 1 ].X, Line.Pivot[ 1 ].Y, SX2, SY2 )
		
		DrawLine( SX1, SY1, SX2, SY2 )
		
		ResetColor()
	End Method
	
	

	Rem
	bbdoc: Draws given tilemap using this visualizer.
	about: Change this method if you are making your own visualizer.
	End Rem
	Method DrawUsingTileMap( TileMap:LTTileMap )
		Local TileSet:LTTileSet = TileMap.TileSet
		If Not TileSet Then Return
		
		Local Image:LTImage = TileSet.Image
		If Not Image Then Return
	
		SetColor 255.0 * Red, 255.0 * Green, 255.0 * Blue
		SetAlpha Alpha
	
		Local SWidth:Double, SHeight:Double
		Local CellWidth:Double = TileMap.GetTileWidth()
		Local CellHeight:Double = TileMap.GetTileHeight()
		L_CurrentCamera.SizeFieldToScreen( CellWidth, CellHeight, SWidth, SHeight )
		SetScale( SWidth / ImageWidth( Image.BMaxImage ), SHeight / ImageHeight( Image.BMaxImage ) )
		
		Local SX:Double, SY:Double
		L_CurrentCamera.FieldToScreen( TileMap.X - 0.5 * TileMap.Width, TileMap.Y - 0.5 * TileMap.Height, SX, SY )

		Local X1:Double = L_CurrentCamera.ViewPort.X - 0.5 * L_CurrentCamera.ViewPort.Width
		Local Y1:Double = L_CurrentCamera.ViewPort.Y - 0.5 * L_CurrentCamera.ViewPort.Height
		Local X2:Double = X1 + L_CurrentCamera.ViewPort.Width + SWidth * 0.5
		Local Y2:Double = Y1 + L_CurrentCamera.ViewPort.Height + SHeight * 0.5
		
		Local StartXFrame:Int = Int( ( L_CurrentCamera.X - TileMap.X - 0.5 * ( L_CurrentCamera.Width - TileMap.Width ) ) / CellWidth )
		Local StartYFrame:Int = Int( ( L_CurrentCamera.Y - TileMap.Y - 0.5 * ( L_CurrentCamera.Height - TileMap.Height ) ) / CellHeight )
		Local StartX:Double = SX + SWidth * ( Int( ( X1 - SX ) / SWidth ) ) + SWidth * 0.5
		Local StartY:Double = SY + SHeight * ( Int( ( Y1 - SY ) / SHeight ) ) + SHeight * 0.5
		
		If Not TileMap.Wrapped Then
			If StartXFrame < 0 Then 
				StartX :- StartXFrame * SWidth
				StartXFrame = 0
			End If
			Local EndX:Double = StartX + SWidth * ( TileMap.XQuantity - StartXFrame ) - 0.001
			If  EndX < X2  Then X2 = EndX
			
			If StartYFrame < 0 Then 
				StartY :- StartYFrame * SHeight
				StartYFrame = 0
			End If
			Local EndY:Double = StartY + SHeight * ( TileMap.YQuantity - StartYFrame ) - 0.001
			If  EndY < Y2  Then Y2 = EndY
		End If
		
		Local YY:Double = StartY
		Local YFrame:Int = StartYFrame
		While YY < Y2
			Local XX:Double = StartX
			Local XFrame:Int = StartXFrame
			While XX < X2
				If TileMap.Masked Then
					DrawTile( TileMap, XX, YY, XFrame & TileMap.XMask, YFrame & TileMap.YMask )
				Else
					DrawTile( TileMap, XX, YY, TileMap.WrapX( XFrame ), TileMap.WrapY( YFrame ) )
				End If
				XX = XX + SWidth
				XFrame :+ 1
			Wend
			YY = YY + SHeight
			YFrame :+ 1
		Wend
		
		SetColor( 255, 255, 255 )
		SetScale( 1.0, 1.0 )
		SetAlpha( 1.0 )
	End Method
	
	
	
	Rem
	bbdoc: Draws tile of given tilemap with given coordinates using this visualizer.
	about: Change this method if you are making your own visualizer.
	If you are making visualizer for tilemaps, you will probably need to modify only this method.
	
	See also: #DrawTileMap
	End Rem
	Method DrawTile( TileMap:LTTileMap, X:Double, Y:Double, TileX:Int, TileY:Int )
		?debug
		L_TilesDisplayed :+ 1
		?
		
		Local Value:Int = TileMap.Value[ TileX, TileY ]
		If Value <> Tilemap.EmptyTile Then Drawimage( TileMap.TileSet.Image.BMaxImage, X, Y, Value )
	End Method
	
	' ==================== Other ====================
	
	Rem
	bbdoc: Applies color given in hex string to visualizer.
	about: See also: #SetColorFromRGB, #AlterColor, #ApplyColor, #ResetColor
	End Rem
	Method SetColorFromHex( S:String )
		Red = 1.0 * L_HexToInt( S[ 0..2 ] ) / 255.0
		Green = 1.0 * L_HexToInt( S[ 2..4 ] ) / 255.0
		Blue = 1.0 * L_HexToInt( S[ 4..6 ] ) / 255.0
	End Method
	
	
	
	Rem
	bbdoc: Applies color given in color intensities to visualizer.
	about: Every intensity should be in range from 0.0 to 1.0.
	
	See also: #SetColorFromHex, #AlterColor, #ApplyColor, #ResetColor
	End Rem
	Method SetColorFromRGB( NewRed:Double, NewGreen:Double, NewBlue:Double )
		?debug
		If NewRed < 0.0 Or NewRed > 1.0 Then L_Error( "Red component must be between 0.0 and 1.0 inclusive" )
		If NewGreen < 0.0 Or NewGreen > 1.0 Then L_Error( "Green component must be between 0.0 and 1.0 inclusive" )
		If NewBlue < 0.0 Or NewBlue > 1.0 Then L_Error( "Blue component must be between 0.0 and 1.0 inclusive" )
		?
		
		Red = NewRed
		Green = NewGreen
		Blue = NewBlue
	End Method
	
	
	
	Rem
	bbdoc: Alters color randomly with given increments.
	about: Every color channel will be altered by random value in D1...D2 interval (value(s) can be negative).
	
	See also: #SetColorFromHex, #SetColorFromRGB, #ApplyColor, #ResetColor
	End Rem
	Method AlterColor( D1:Double, D2:Double )
		Red = L_LimitDouble( Red + Rnd( D1, D2 ), 0.0, 1.0 )
		Green = L_LimitDouble( Green + Rnd( D1, D2 ), 0.0, 1.0 )
		Blue = L_LimitDouble( Blue + Rnd( D1, D2 ), 0.0, 1.0 )
	End Method
	
	
	
	Rem
	bbdoc: Sets the color of visualizer as drawing color.
	about: See also: #SetColorFromHex, #SetColorFromRGB, #AlterColor, #ResetColor
	End Rem
	Method ApplyColor()
		SetColor( 255.0 * Red, 255.0 * Green, 255.0 * Blue )
		SetAlpha( Alpha )
	End Method
	
	
	
	Rem
	bbdoc: Resets drawing color to white.
	about: See also: #SetColorFromHex, #SetColorFromRGB, #AlterColor, #ApplyColor
	End Rem
	Method ResetColor()
		SetColor( 255, 255, 255 )
		SetAlpha( 1.0 )
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageDoubleAttribute( "red", Red, 1.0 )
		XMLObject.ManageDoubleAttribute( "green", Green, 1.0 )
		XMLObject.ManageDoubleAttribute( "blue", Blue, 1.0 )
		XMLObject.ManageDoubleAttribute( "alpha", Alpha, 1.0 )
		XMLObject.ManageDoubleAttribute( "xscale", XScale, 1.0 )
		XMLObject.ManageDoubleAttribute( "yscale", YScale, 1.0 )
		XMLObject.ManageIntAttribute( "scaling", Scaling, 1 )
		XMLObject.ManageDoubleAttribute( "angle", Angle )
		XMLObject.ManageIntAttribute( "rotating", Rotating, 1 )
	End Method
End Type