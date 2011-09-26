'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTImage.bmx"
Include "LTRasterFrameVisualizer.bmx"
Include "LTAnimatedTileMapVisualizer.bmx"
Include "LTEmptyPrimitive.bmx"
Include "LTMarchingAnts.bmx"
Include "LTWindowedVisualizer.bmx"
Include "LTDebugVisualizer.bmx"

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
	bbdoc: Sets vertical and horizontal scaling of the visualizer
	about: Works only with images.
	End Rem
	Method SetVisualizerScale( NewXScale:Double, NewYScale:Double )
		XScale = NewXScale
		YScale = NewYScale
	End Method
	
	
	
	Rem
	bbdoc: Sets scalings of the visualizer to one value
	about: Works only with images.
	End Rem
	Method SetVisualizerScales( NewScale:Double )
		XScale = NewScale
		YScale = NewScale
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
			L_CurrentCamera.FieldToScreen( Sprite.X, Sprite.Y, SX, SY )
			
			Local AngularSprite:LTAngularSprite = LTAngularSprite( Sprite )
			If Rotating And AngularSprite Then
				SetRotation( Angle + AngularSprite.Angle )
			Else
				SetRotation( Angle )
			End If
			
			?debug
			If Sprite.Frame < 0 Or Sprite.Frame >= Image.FramesQuantity() Then L_Error( "Incorrect frame number ( " + Sprite.Frame + " ) for sprite ~q" + Sprite.GetTitle() + "~q, must be less than " + Image.FramesQuantity() )
			?
		
			If Scaling Then
				L_CurrentCamera.SizeFieldToScreen( Sprite.Width, Sprite.Height, SWidth, SHeight )
				Local ScaledWidth:Double = SWidth * XScale
				Local ScaledHeight:Double = SHeight * YScale
				Image.Draw( SX + DX * ScaledWidth, SY + DY * ScaledHeight, ScaledWidth, ScaledHeight, Sprite.Frame )
			Else
				Local ScaledWidth:Double = ImageWidth( Image.BMaxImage ) * XScale
				Local ScaledHeight:Double = ImageHeight( Image.BMaxImage ) * YScale
				Image.Draw( SX + DX * ScaledWidth, SY + DY * ScaledHeight, ScaledWidth, ScaledHeight, Sprite.Frame )
			End If
			
			SetScale( 1.0, 1.0 )
			SetRotation( 0.0 )
		Else
			DrawSpriteShape( Sprite )
		End If
		
		ResetColor()
	End Method
	
	
	
	Method DrawSpriteShape( Sprite:LTSprite )
		Local SX:Double, SY:Double, SWidth:Double, SHeight:Double
		If Sprite.ShapeType = LTSprite.Pivot Then
			L_CurrentCamera.FieldToScreen( Sprite.X, Sprite.Y, SX, SY )
			DrawOval( SX - 2, SY - 2, 5, 5 )
		Else If L_CurrentCamera.Isometric Then
			Select Sprite.ShapeType
				Case LTSprite.Circle
					DrawIsoOval( Sprite.X, Sprite.Y, Sprite.Width, Sprite.Height )
				Case LTSprite.Rectangle
					DrawIsoRectangle( Sprite.X, Sprite.Y, Sprite.Width, Sprite.Height )
			End Select
		Else
			L_CurrentCamera.FieldToScreen( Sprite.X, Sprite.Y, SX, SY )
			L_CurrentCamera.SizeFieldToScreen( Sprite.Width * XScale, Sprite.Height * YScale, SWidth, SHeight )
			SX :+ DX * SWidth
			SY :+ DY * SHeight
			
			Select Sprite.ShapeType
				Case LTSprite.Circle
					DrawOval( SX - 0.5 * SWidth, SY - 0.5 * SHeight, SWidth, SHeight )
				Case LTSprite.Rectangle
					DrawRect( SX - 0.5 * SWidth, SY - 0.5 * SHeight, SWidth, SHeight )
			End Select
		End If
	End Method
	
	
	
	Rem
	bbdoc: Draws rectangle for isometric camera using given field coordinates and size.
	End Rem
	Method DrawIsoRectangle( X:Double, Y:Double, Width:Double, Height:Double )
		Local S:Float[] = New Float[ 8 ]
		L_CurrentCamera.FieldToScreenFloat( X - 0.5 * Width, Y - 0.5 * Height, S[ 0 ], S[ 1 ] )
		L_CurrentCamera.FieldToScreenFloat( X - 0.5 * Width, Y + 0.5 * Height, S[ 2 ], S[ 3 ] )
		L_CurrentCamera.FieldToScreenFloat( X + 0.5 * Width, Y + 0.5 * Height, S[ 4 ], S[ 5 ] )
		L_CurrentCamera.FieldToScreenFloat( X + 0.5 * Width, Y - 0.5 * Height, S[ 6 ], S[ 7 ] )
		DrawPoly( S )
	End Method
	
	
	
	Rem
	bbdoc: Draws oval for isometric camera using given field coordinates and size.
	End Rem
	Method DrawIsoOval( X:Double, Y:Double, Width:Double, Height:Double )
		Local S:Float[] = New Float[ 16 ]
		Local XRadius:Double = 0.5 * Width
		Local YRadius:Double = 0.5 * Height
		For Local N:Int = 0 Until 16 Step 2
			Local Angle:Double = 22.5 * N
			L_CurrentCamera.FieldToScreenFloat( X + XRadius * Cos( Angle ), Y + YRadius * Sin( Angle ), S[ N ], S[ N + 1 ] )
		Next
		DrawPoly( S )
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
	
		ApplyColor()
		
		Local CellWidth:Double = TileMap.GetTileWidth()
		Local CellHeight:Double = TileMap.GetTileHeight()
		
		Local MinX:Double, MinY:Double, MaxX:Double, MaxY:Double
		L_GetEscribedRectangle( TileMap.LeftMargin, TileMap.TopMargin, TileMap.RightMargin, TileMap.BottomMargin, MinX, MinY, MaxX, MaxY )
		
		Local CornerX:Double = TileMap.LeftX()
		Local CornerY:Double = TileMap.TopY()
		Local MinTileX:Int = Floor( ( MinX - CornerX ) / CellWidth )
		Local MinTileY:Int = Floor( ( MinY - CornerY ) / CellHeight )
		Local MaxTileX:Int = Ceil( ( MaxX - CornerX ) / CellWidth )
		Local MaxTileY:Int = Ceil( ( MaxY - CornerY ) / CellHeight )
		
		If Not TileMap.Wrapped Then
			MinTileX = L_LimitInt( MinTileX, 0, TileMap.XQuantity - 1 )
			MinTileY = L_LimitInt( MinTileY, 0, TileMap.YQuantity - 1 )
			MaxTileX = L_LimitInt( MaxTileX, 0, TileMap.XQuantity - 1 )
			MaxTileY = L_LimitInt( MaxTileY, 0, TileMap.YQuantity - 1 )
		End If
		
		Local TileDX:Int = TileMap.HorizontalOrder, TileDY:Int = TileMap.VerticalOrder
		Local SDX:Double = CellWidth * TileDX, SDY:Double = CellHeight * TileDY
		
		Local SWidth:Double, SHeight:Double
		L_CurrentCamera.SizeFieldToScreen( CellWidth, CellHeight, SWidth, SHeight )
		
		If Not L_CurrentCamera.Isometric Then If Not Image Then Return

		Local TileY:Int
		If TileDY = 1 Then TileY = MinTileY Else TileY = MaxTileY
		Local Y:Double = CornerY + CellHeight * ( 0.5 + TileY )
		Repeat
			If TileDY = 1 Then
				If TileY > MaxTileY Then Exit
			Else
				If TileY < MinTileY Then Exit
			End If
			
			Local TileX:Int
			If TileDX = 1 Then TileX = MinTileX Else TileX = MaxTileX
			
			Local X:Double = CornerX + CellWidth * ( 0.5 + TileX )
			
			Repeat
				If TileDX = 1 Then
					If TileX > MaxTileX Then Exit
				Else
					If TileX < MinTileX Then Exit
				End If
			
				If Shapes Then
					For Local Shape:LTShape = Eachin Shapes
						Local ChildTileMap:LTTileMap = LTTileMap( Shape )
						If ChildTileMap Then
							DrawTile( ChildTileMap, X, Y, SWidth, SHeight, TileX, TileY )
						Else
							DrawSpriteMapTile( LTSpriteMap( Shape ), X, Y )
						End If
					Next
				Else
					DrawTile( TileMap, X, Y, SWidth, SHeight, TileX, TileY )
				End If
				
				X :+ SDX
				TileX :+ TileDX
			Forever
			
			Y:+ SDY
			TileY :+ TileDY
		Forever
		
		ResetColor()
		SetScale( 1.0, 1.0 )
	End Method
	
	
	
	Rem
	bbdoc: Draws tile of given tilemap with given coordinates using this visualizer.
	about: X and Y are center coordinates of this tile on the screen.
	If you want to make your own tilemap visualizer, make class which extends LTVisualizer and rewrite this method.
	
	See also: #DrawUsingTileMap
	End Rem
	Method DrawTile( TileMap:LTTileMap, X:Double, Y:Double, Width:Double, Height:Double, TileX:Int, TileY:Int )
		ApplyColor()
		
		Local TileSet:LTTileSet =Tilemap.TileSet
		Local TileValue:Int = TileMap.Value[ TileMap.WrapX( TileX ), TileMap.WrapY( TileY ) ]
		If TileValue = TileSet.EmptyTile Then Return
		
		Local Image:LTImage = TileSet.Image
		If Not Image Then Return
		
		Local SX:Double, SY:Double
		L_CurrentCamera.FieldToScreen( X, Y, SX, SY )
		
		Local Visualizer:LTVisualizer = TileMap.Visualizer
		Width :* Visualizer.XScale
		Height :* Visualizer.YScale
		
		Image.Draw( SX + Visualizer.DX * Width, SY + Visualizer.DY * Height, Width, Height, TileValue )
		
		?debug
		L_TilesDisplayed :+ 1
		?
	End Method
	
	
	
	Method DrawSpriteMapTile( SpriteMap:LTSpriteMap, X:Double, Y:Double )
		For Local Sprite:LTSprite = Eachin SpriteMap.Lists[ Int( Floor( X / SpriteMap.CellWidth ) ) & SpriteMap.XMask, ..
				Int( Floor( Y / SpriteMap.CellHeight ) ) & SpriteMap.YMask ]
			Sprite.Draw()
		Next
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