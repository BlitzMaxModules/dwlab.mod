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
	
	Rem
	bbdoc: Image (LTImage) field.
	End Rem
	Field Image:LTImage

	' ==================== Creating ====================
	
	Rem
	bbdoc: Creates new image visualizer from image file.
	returns: New visualizer.
	about: See also: #FromImage
	End Rem
	Function FromFile:LTVisualizer( Filename:String, XCells:Int = 1, YCells:Int = 1 )
		Local Visualizer:LTVisualizer = New LTVisualizer
		Visualizer.Image = LTImage.FromFile( Filename, XCells, YCells )
		Return Visualizer
	End Function
	
	
	
	Rem
	bbdoc: Creates new image visualizer from existing image (LTImage).
	returns: New visualizer.
	about: See also: #FromFile
	End Rem
	Function FromImage:LTVisualizer( Image:LTImage )
		Local Visualizer:LTVisualizer = New LTVisualizer
		Visualizer.Image = Image
		Return Visualizer
	End Function

	' ==================== Parameters ====================
	
	Rem
	bbdoc: Sets shifts of the visualizer.
	about: Works only with images.
	End Rem
	Method SetDXDY( NewDX:Double, NewDY:Double )
		DX = NewDX
		DY = NewDY
	End Method
	
	
	
	Rem
	bbdoc: Sets scaling parameters of the visualizer
	about: Works only with images.
	End Rem
	Method SetVisualizerScale( NewXScale:Double, NewYScale:Double )
		XScale = NewXScale
		YScale = NewYScale
	End Method
	
	
	
	' Deprecated
	Method GetImage:LTImage()
		Return Image
	End Method
	
	
	
	' Deprecated
	Method SetImage( NewImage:LTImage )
		Image = NewImage
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
		
		If Image Then
			SetColor 255.0 * Red, 255.0 * Green, 255.0 * Blue
			SetAlpha Alpha
		
			L_CurrentCamera.FieldToScreen( Sprite.X, Sprite.Y, SX, SY )
			
			Local AngularSprite:LTAngularSprite = LTAngularSprite( Sprite )
			If Rotating And AngularSprite Then
				SetRotation( Angle + AngularSprite.Angle )
			Else
				SetRotation( Angle )
			End If
			
			If Scaling Then
				L_CurrentCamera.SizeFieldToScreen( Sprite.Width, Sprite.Height, SWidth, SHeight )
				SetScale( XScale * SWidth / ImageWidth( Image.BMaxImage ), YScale * SHeight / ImageHeight( Image.BMaxImage ) )
			Else
				SetScale XScale, YScale
			End If
			
			?debug
			If Sprite.Frame < 0 Or Sprite.Frame >= Image.FramesQuantity() Then L_Error( "Incorrect frame number ( " + Sprite.Frame + " ) for sprite ~q" + Sprite.Name + "~q, must be less than " + Image.FramesQuantity() )
			?
			
			DrawImage( Image.BMaxImage, SX + DX * SWidth, SY + DY * SHeight, Sprite.Frame )
			
			SetScale( 1.0, 1.0 )
			SetRotation( 0.0 )
		Else
			L_CurrentCamera.FieldToScreen( Sprite.X, Sprite.Y, SX, SY )
			L_CurrentCamera.SizeFieldToScreen( Sprite.Width * XScale, Sprite.Height * YScale, SWidth, SHeight )
			SX :+ DX * SWidth
			SY :+ DY * SHeight
			
			Select Sprite.ShapeType
				Case LTSprite.Pivot
					DrawOval( SX - 2, SY - 2, 5, 5 )
				Case LTSprite.Circle
					DrawOval( SX - 0.5 * SWidth, SY - 0.5 * SHeight, SWidth, SHeight )
				Case LTSprite.Rectangle
					DrawRect( SX - 0.5 * SWidth, SY - 0.5 * SHeight, SWidth, SHeight )
			End Select
		End If
		
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
	Method DrawUsingTileMap( TileMap:LTTileMap, Shapes:TList = Null )
		Local TileSet:LTTileSet = TileMap.TileSet
		If Not TileSet Then Return
		
		Local Image:LTImage = TileSet.Image
		If Not Image Then Return
	
		SetColor 255.0 * Red, 255.0 * Green, 255.0 * Blue
		SetAlpha Alpha
		
		Local CellWidth:Double = TileMap.GetTileWidth()
		Local CellHeight:Double = TileMap.GetTileHeight()
		Local Viewport:LTShape = L_CurrentCamera.Viewport
		
		If L_CurrentCamera.Isometric Or Shapes Then
			If Not Shapes Then
				Shapes = New TList
				Shapes.AddLast( TileMap )
			End If
			
			Local X00:Double, Y00:Double, X01:Double, Y01:Double
			Local X10:Double, Y10:Double, X11:Double, Y11:Double
			L_CurrentCamera.ScreenToField( Viewport.X - Viewport.Width * 0.5, Viewport.Y - Viewport.Height * 0.5, X00, Y00 )
			L_CurrentCamera.ScreenToField( Viewport.X + Viewport.Width * 0.5, Viewport.Y - Viewport.Height * 0.5, X10, Y10 )
			L_CurrentCamera.ScreenToField( Viewport.X - Viewport.Width * 0.5, Viewport.Y + Viewport.Height * 0.5, X01, Y01 )
			L_CurrentCamera.ScreenToField( Viewport.X + Viewport.Width * 0.5, Viewport.Y + Viewport.Height * 0.5, X11, Y11 )
			Local MinX:Double = Min( Min( X00, X10 ), Min( X01, X11 ) )
			Local MinY:Double = Min( Min( Y00, Y10 ), Min( Y01, Y11 ) )
			Local MaxX:Double = Max( Max( X00, X10 ), Max( X01, X11 ) )
			Local MaxY:Double = Max( Max( Y00, Y10 ), Max( Y01, Y11 ) )
			Local CornerX:Double = TileMap.X - 0.5 * TileMap.Width
			Local CornerY:Double = TileMap.Y - 0.5 * TileMap.Height
			Local StartingTileX:Int = L_LimitInt( Floor( ( MinX - CornerX ) / CellWidth ), 0, TileMap.XQuantity - 1 )
			Local StartingTileY:Int = L_LimitInt( Floor( ( MinY - CornerY ) / CellHeight ), 0, TileMap.YQuantity - 1 )
			Local MaxTileX:Int = L_LimitInt( Ceil( ( MaxX - CornerX ) / CellWidth ), 0, TileMap.XQuantity - 1 )
			Local MaxTileY:Int = L_LimitInt( Ceil( ( MaxY - CornerY ) / CellHeight ), 0, TileMap.YQuantity - 1 )
			Local StartingX:Double, StartingY:Double
			L_CurrentCamera.FieldToScreen( StartingTileX, StartingTileY, StartingX, StartingY )
			Local VX1:Double = L_CurrentCamera.VX1 * L_CurrentCamera.K
			Local VY1:Double = L_CurrentCamera.VY1 * L_CurrentCamera.K
			
			Local TileY:Int = StartingTileY
			While TileY < MaxTileY
				Local WrappedTileY:Int
				Local X:Double, Y:Double
				L_CurrentCamera.FieldToScreen( CornerX + CellWidth * TileX, CornerY + CellHeight * TileY )
				
				Local TileY:Int = StartingTileY
				If TileMap.Masked Then
					WrappedTileY = YFrame & TileMap.YMask
				Else
					WrappedTileY = TileMap.WrapY( YFrame )
				End If
				While TileX < MaxTileX
					Local WrappedTileX:Int 
					If TileMap.Masked Then
						WrappedTileX = XFrame & TileMap.XMask
					Else
						WrappedTileX = TileMap.WrapX( XFrame )
					End If
					
					For Local Shape:LTShape = Eachin Shapes
						Shape.DrawIsoTile( X, Y, TileX, TileY, TileMap )
					Next
					
					X :+ VX1
					Y:+ VY1
				Wend
			Wend
			
		Else
			Local SWidth:Double, SHeight:Double
			L_CurrentCamera.SizeFieldToScreen( CellWidth, CellHeight, SWidth, SHeight )
			SetScale( SWidth / ImageWidth( Image.BMaxImage ), SHeight / ImageHeight( Image.BMaxImage ) )
			
			Local SX:Double, SY:Double
			L_CurrentCamera.FieldToScreen( TileMap.X - 0.5 * TileMap.Width, TileMap.Y - 0.5 * TileMap.Height, SX, SY )
	
			Local X1:Double = ViewPort.X - 0.5 * L_CurrentCamera.ViewPort.Width
			Local Y1:Double = ViewPort.Y - 0.5 * L_CurrentCamera.ViewPort.Height
			Local X2:Double = X1 + ViewPort.Width + SWidth * 0.5
			Local Y2:Double = Y1 + ViewPort.Height + SHeight * 0.5
			
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
					XX :+ SWidth
					XFrame :+ 1
				Wend
				YY :+ SHeight
				YFrame :+ 1
			Wend
		End If
		
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
	
	
	
	Rem
	bbdoc: Clones the visualizer.
	returns: Clone of the visualizer.
	End Rem
	Method Clone:LTVisualizer()
		Local Visualizer:LTVisualizer = New LTVisualizer
		CopyTo( Visualizer )
		Return Visualizer
	End Method
	
	
	
	Method CopyTo( Visualizer:LTVisualizer )
		Visualizer.Red = Red
		Visualizer.Green = Green
		Visualizer.Blue = Blue
		Visualizer.Alpha = Alpha
		Visualizer.DX = DX
		Visualizer.DY = DY
		Visualizer.Angle = Angle
		Visualizer.Rotating = Rotating
		Visualizer.XScale = XScale
		Visualizer.YScale = YScale
		Visualizer.Scaling = Scaling
		Visualizer.Image = Image
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageDoubleAttribute( "red", Red, 1.0 )
		XMLObject.ManageDoubleAttribute( "green", Green, 1.0 )
		XMLObject.ManageDoubleAttribute( "blue", Blue, 1.0 )
		XMLObject.ManageDoubleAttribute( "alpha", Alpha, 1.0 )
		XMLObject.ManageDoubleAttribute( "dx", DX )
		XMLObject.ManageDoubleAttribute( "dy", DY )
		XMLObject.ManageDoubleAttribute( "xscale", XScale, 1.0 )
		XMLObject.ManageDoubleAttribute( "yscale", YScale, 1.0 )
		XMLObject.ManageIntAttribute( "scaling", Scaling, 1 )
		XMLObject.ManageDoubleAttribute( "angle", Angle )
		XMLObject.ManageIntAttribute( "rotating", Rotating, 1 )
		Image = LTImage( XMLObject.ManageObjectField( "image", Image ) )
	End Method
End Type





' Deprecated
Type LTImageVisualizer Extends LTVisualizer
End type