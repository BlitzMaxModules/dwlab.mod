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
Include "LTAnimatedTileMapVisualizer.bmx"
Include "LTContourVisualizer.bmx"
Include "LTMarchingAnts.bmx"
Include "LTWindowedVisualizer.bmx"
Include "LTDebugVisualizer.bmx"

Rem
bbdoc: Visualizer is object which contains parameters for drawing the shape.
End Rem
Type LTVisualizer Extends LTColor
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
	bbdoc: Creates new visualizer from image file.
	returns: New visualizer.
	about: See also: #FromImage, #FromColor, #FromHexColor
	End Rem
	Function FromFile:LTVisualizer( Filename:String, XCells:Int = 1, YCells:Int = 1 )
		Local Visualizer:LTVisualizer = New LTVisualizer
		Visualizer.Image = LTImage.FromFile( Filename, XCells, YCells )
		Return Visualizer
	End Function
	
	
	
	Rem
	bbdoc: Creates new visualizer from existing image (LTImage).
	returns: New visualizer.
	about: See also: #FromFile, #FromRGBColor, #FromHexColor
	End Rem
	Function FromImage:LTVisualizer( Image:LTImage )
		Local Visualizer:LTVisualizer = New LTVisualizer
		Visualizer.Image = Image
		Return Visualizer
	End Function

	
	
	Rem
	bbdoc: Creates new visualizer using given color RGB components and transparency.
	returns: New visualizer.
	about: See also: #FromFile, #FromImage, #FromHexColor
	End Rem
	Function FromRGBColor:LTVisualizer( Red:Double, Green:Double, Blue:Double, Alpha:Double = 1.0, Scale:Double = 1.0, Scaling:Int = True )
		Local Visualizer:LTVisualizer = New LTVisualizer
		Visualizer.SetColorFromRGB( Red, Green, Blue )
		Visualizer.Alpha = Alpha
		Visualizer.SetVisualizerScales( Scale )
		Visualizer.Scaling = Scaling
		Return Visualizer
	End Function

	

	Rem
	bbdoc: Creates new visualizer using given hexadecimal color representation and transparency.
	returns: New visualizer.
	about: See also: #FromFile, #FromImage, #FromRGBColor, #Overlaps example.
	End Rem
	Function FromHexColor:LTVisualizer( HexColor:String = "FFFFFF", Alpha:Double = 1.0, Scale:Double = 1.0, Scaling:Int = True )
		Local Visualizer:LTVisualizer = New LTVisualizer
		Visualizer.SetColorFromHex( HexColor )
		Visualizer.Alpha = Alpha
		Visualizer.SetVisualizerScales( Scale )
		Visualizer.Scaling = Scaling
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
	
	See also: #Clone example
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
	Method DrawUsingSprite( Sprite:LTSprite, SpriteShape:LTSprite = Null, DrawingAlpha:Double )
		If Not Sprite.Visible Then Return
		
		If Not SpriteShape Then SpriteShape = Sprite

		?debug
		L_SpritesDisplayed :+ 1
		?
		
		ApplyColor( DrawingAlpha )
		
		Local SX:Double, SY:Double, SWidth:Double, SHeight:Double
		
		If Sprite.ShapeType.CustomDrawing() Then
			LTSpriteHandler.HandlersArray[ Sprite.ShapeType.GetNum() ].DrawSprite( Self, Sprite, DrawingAlpha )
		ElseIf Image Then
			L_CurrentCamera.FieldToScreen( SpriteShape.X, SpriteShape.Y, SX, SY )
			
			If Rotating Then
				SetRotation( SpriteShape.DisplayingAngle + SpriteShape.Angle )
			Else
				SetRotation( SpriteShape.DisplayingAngle )
			End If
			
			?debug
			If Sprite.Frame < 0 Or Sprite.Frame >= Image.FramesQuantity() Then L_Error( "Incorrect frame number ( " + Sprite.Frame + " ) for sprite ~q" + Sprite.GetTitle() + "~q, must be less than " + Image.FramesQuantity() )
			?
		
			If Scaling Then
				L_CurrentCamera.SizeFieldToScreen( SpriteShape.Width, SpriteShape.Height, SWidth, SHeight )
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
			DrawSpriteShape( Sprite, SpriteShape )
		End If
		
		ResetColor()
	End Method
	
	
	
	Rem
	bbdoc: Draws sprite shape.
	about: Isometric camera deformations are also applied.
	End Rem
	Method DrawSpriteShape( Sprite:LTSprite, SpriteShape:LTSprite = Null )
		If Not SpriteShape Then SpriteShape = Sprite

		Local SX:Double, SY:Double, SWidth:Double, SHeight:Double
		If Sprite.ShapeType.GetNum() = LTSprite.Pivot.GetNum() Then
			L_CurrentCamera.FieldToScreen( Sprite.X, Sprite.Y, SX, SY )
			DrawOval( SX - 2.5 * XScale + 0.5, SY - 2.5 * YScale + 0.5, 5 * XScale, 5 * YScale )
		Else If L_CurrentCamera.Isometric Then
			Select Sprite.ShapeType.GetNum()
				Case LTSprite.Oval.GetNum()
					DrawIsoOval( Sprite.X, Sprite.Y, Sprite.Width, Sprite.Height )
				Case LTSprite.Rectangle.GetNum()
					DrawIsoRectangle( SpriteShape.X, Sprite.Y, SpriteShape.Width, Sprite.Height )
			End Select
		Else
			L_CurrentCamera.FieldToScreen( SpriteShape.X, SpriteShape.Y, SX, SY )
			L_CurrentCamera.SizeFieldToScreen( SpriteShape.Width, SpriteShape.Height, SWidth, SHeight )
			
			If Sprite.ShapeType = LTSprite.Raster Then
				If Image Then
					Local Blend:Int = GetBlend()
					SetBlend MASKBLEND 
					DrawUsingSprite( Sprite, , GetAlpha() )
					SetBlend Blend
				End If
			Else
				LTSpriteHandler.HandlersArray[ Sprite.ShapeType.GetNum() ].DrawShape( Sprite, SpriteShape, SX, SY, SWidth, SHeight )
			End If
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
	Method DrawUsingLineSegment( LineSegment:LTLineSegment, DrawingAlpha:Double  )
		If Not LineSegment.Visible Then Return
		
		ApplyColor( DrawingAlpha )
		
		Local SX1:Double, SY1:Double, SX2:Double, SY2:Double
		L_CurrentCamera.FieldToScreen( LineSegment.Pivot[ 0 ].X, LineSegment.Pivot[ 0 ].Y, SX1, SY1 )
		L_CurrentCamera.FieldToScreen( LineSegment.Pivot[ 1 ].X, LineSegment.Pivot[ 1 ].Y, SX2, SY2 )
		
		DrawLine( SX1, SY1, SX2, SY2 )
		
		ResetColor()
	End Method
	
	

	Rem
	bbdoc: Draws given tilemap using this visualizer.
	about: Change this method if you are making your own visualizer.
	End Rem
	Method DrawUsingTileMap( TileMap:LTTileMap, Shapes:TList = Null, DrawingAlpha:Double )
		If Not TileMap.Visible Then Return
		
		Local TileSet:LTTileSet = TileMap.TileSet
		If Not TileSet Then Return
		
		Local Image:LTImage = TileSet.Image
	
		ApplyColor( DrawingAlpha )
		
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
		Local TileSet:LTTileSet =Tilemap.TileSet
		Local TileValue:Int = GetTileValue( TileMap, TileX, TileY )
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
	
	
	Rem
	bbdoc: Function which defines which tile to draw.
	returns: Tile number for given tilemap and tile coordinates.
	End Rem
	Method GetTileValue:Int( TileMap:LTTileMap, TileX:Int, TileY:Int )
		Return TileMap.Value[ TileMap.WrapX( TileX ), TileMap.WrapY( TileY ) ]
	End Method
	
	
	
	Method DrawSpriteMapTile( SpriteMap:LTSpriteMap, X:Double, Y:Double )
		If Not SpriteMap.Visible Then Return
		Local TileX:Int = Int( Floor( X / SpriteMap.CellWidth ) ) & SpriteMap.XMask
		Local TileY:Int = Int( Floor( Y / SpriteMap.CellHeight ) ) & SpriteMap.YMask
		For Local N:Int = 0 Until SpriteMap.ListSize[ TileX, TileY ]
			SpriteMap.Lists[ TileX, TileY ][ N ].Draw()
		Next
	End Method
	
	
	
	Method GetFacing:Double()
		Return Sgn( XScale )
	End Method
	
	
	
	Method SetFacing( NewFacing:Double )
		XScale = Abs( XScale ) * NewFacing
	End Method
	
	' ==================== Other ====================
	
	Rem
	bbdoc: Clones the visualizer.
	returns: Clone of the visualizer.
	End Rem
	Method Clone:LTVisualizer()
		Local Visualizer:LTVisualizer = New LTVisualizer
		CopyVisualizerTo( Visualizer )
		Return Visualizer
	End Method
	
	
	
	Method CopyVisualizerTo( Visualizer:LTVisualizer )
		CopyColorTo( Visualizer )
		
		Visualizer.DX = DX
		Visualizer.DY = DY
		Visualizer.XScale = XScale
		Visualizer.YScale = YScale
		Visualizer.Scaling = Scaling
		Visualizer.Rotating = Rotating
		Visualizer.Image = Image
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageDoubleAttribute( "dx", DX )
		XMLObject.ManageDoubleAttribute( "dy", DY )
		XMLObject.ManageDoubleAttribute( "xscale", XScale, 1.0 )
		XMLObject.ManageDoubleAttribute( "yscale", YScale, 1.0 )
		XMLObject.ManageIntAttribute( "scaling", Scaling, 1 )
		XMLObject.ManageIntAttribute( "rotating", Rotating, 1 )
		Image = LTImage( XMLObject.ManageObjectField( "image", Image ) )
	End Method
End Type