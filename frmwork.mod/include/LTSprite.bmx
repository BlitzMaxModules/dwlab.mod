'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTVectorSprite.bmx"
Include "Collisions.bmx"
Include "Physics.bmx"

Rem
bbdoc: Sprite is the main basic shape of the framework to draw, move and check collisions.
about: See also: #LTVectorSprite
End Rem
Type LTSprite Extends LTShape
	Rem
	bbdoc: Type of the sprite shape.
	about: See also: #Pivot, #Oval, #Rectangle
	End Rem
	Field ShapeType:Int = Rectangle
	
	Rem
	bbdoc: Type of the sprite shape: pivot. It's a point on game field with (X, Y) coordinates.
	End Rem
	Const Pivot:Int = 0
	
	Rem
	bbdoc: Type of the sprite shape: oval / circle which is inscribed in shape's rectangle.
	End Rem
	Const Circle:Int = 1
	Const Oval:Int = 1
	
	Rem
	bbdoc: Type of the sprite shape: rectangle.
	End Rem
	Const Rectangle:Int = 2
	
	Rem
	bbdoc: Type of the sprite shape: ray which starts in (X, Y) and directed as Angle.
	End Rem
	Const Ray:Int = 3
	
	Rem
	bbdoc: Type of the sprite shape: right triangle which is inscribed in shape's rectangle and have right angle situated in corresponding corner.
	End Rem
	Const TopLeftTriangle:Int = 4
	Const TopRightTriangle:Int = 5
	Const BottomLeftTriangle:Int = 6
	Const BottomRightTriangle:Int = 7
	
	Rem
	bbdoc: Type of the sprite shape: mask of raster image which is inscribed in shape's rectangle.
	End Rem
	Const Raster:Int = 8

	Rem
	bbdoc: Direction of the sprite
	about: See also: #MoveForward, #MoveTowards
	End Rem
	Field Angle:Double
	
	Rem
	bbdoc: Velocity of the sprite in units per second.
	about: See also: #MoveForward, #MoveTowards
	End Rem
	Field Velocity:Double = 1.0
	
	Rem
	bbdoc: Frame of the sprite image.
	about: Can only be used with visualizer which have images.
	End Rem
	Field Frame:Int
	
	Field SpriteMap:LTSpriteMap
	
	
	
	Method GetClassTitle:String()
		Return "Sprite"
	End Method
	
	' ==================== Creating ===================	
	
	Rem
	bbdoc: Creates sprite using given shape type.
	returns: Created sprite.
	End Rem
	Function FromShapeType:LTSprite( ShapeType:Int = Rectangle )
		Local Sprite:LTSprite = New LTSprite
		Sprite.ShapeType = ShapeType
		Return Sprite
	End Function
	
	
	
	Rem
	bbdoc: Creates sprite using given coordinates, size, shape type, angle and velocity.
	returns: Created sprite.
	about: See also #Overlaps example.
	End Rem
	Function FromShape:LTSprite( X:Double = 0.0, Y:Double = 0.0, Width:Double = 1.0, Height:Double = 1.0, ShapeType:Int = Rectangle, Angle:Double = 0.0, Velocity:Double = 1.0 )
		Local Sprite:LTSprite = New LTSprite
		Sprite.SetCoords( X, Y )
		Sprite.SetSize( Width, Height )
		Sprite.ShapeType = ShapeType
		Sprite.Angle = Angle
		Sprite.Velocity = Velocity
		Return Sprite
	End Function
	
	' ==================== Drawing ===================	
	
	Method Draw()
		Visualizer.DrawUsingSprite( Self )
	End Method
	
	
	
	Method DrawUsingVisualizer( Vis:LTVisualizer )
		Vis.DrawUsingSprite( Self )
	End Method
	
	' ==================== Collisions ===================
	
	Method TileShapeCollisionsWithSprite( Sprite:LTSprite, DX:Double, DY:Double, XScale:Double, YScale:Double, TileMap:LTTileMap, TileX:Int, TileY:Int, Handler:LTSpriteAndTileCollisionHandler )
		If TileSpriteCollidesWithSprite( Sprite, DX, DY, XScale, YScale ) Then Handler.HandleCollision( Sprite, TileMap, TileX, TileY, Self )
	End Method
	
	

	Rem
	bbdoc: Checks if this sprite collides with given sprite.
	returns: True if the sprite collides with given sprite, False otherwise.
	End Rem
	Method CollidesWithSprite:Int( Sprite:LTSprite )
		?debug
		L_CollisionChecks :+ 1
		?
		Select ShapeType
			Case Pivot
				Select Sprite.ShapeType
					Case Pivot
						Return LTCollision.PivotWithPivot( Self, Sprite )
					Case Oval
						Return LTCollision.PivotWithOval( Self, Sprite )
					Case Rectangle, Raster
						Return LTCollision.PivotWithRectangle( Self, Sprite )
					Case Ray
					Default
						Return LTCollision.PivotWithTriangle( Self, Sprite )
				End Select
			Case Oval
				Select Sprite.ShapeType
					Case Pivot
						Return LTCollision.PivotWithOval( Sprite, Self )
					Case Oval
						Return LTCollision.OvalWithOval( Self, Sprite )
					Case Rectangle, Raster
						Return LTCollision.OvalWithRectangle( Self, Sprite )
					Case Ray
					Default
						Return LTCollision.OvalWithTriangle( Self, Sprite )
				End Select
			Case Rectangle, Raster
				Select Sprite.ShapeType
					Case Pivot
						Return LTCollision.PivotWithRectangle( Sprite, Self )
					Case Oval
						Return LTCollision.OvalWithRectangle( Sprite, Self )
					Case Rectangle, Raster
						If ShapeType = Raster Then Return LTCollision.RasterWithRaster( Self, Sprite )
						Return LTCollision.RectangleWithRectangle( Self, Sprite )
					Case Ray
					Default
						Return LTCollision.RectangleWithTriangle( Self, Sprite )
				End Select
			Case Ray
			Default
				Select Sprite.ShapeType
					Case Pivot
						Return LTCollision.PivotWithTriangle( Sprite, Self )
					Case Oval
						Return LTCollision.OvalWithTriangle( Sprite, Self )
					Case Rectangle, Raster
						Return LTCollision.RectangleWithTriangle( Sprite, Self )
					Case Ray
					Default
						Return LTCollision.TriangleWithTriangle( Self, Sprite )
				End Select
		End Select
	End Method
	
	
	
	Rem
	bbdoc: Checks if the sprite collides with given line.
	returns: True if the sprite collides with given line, otherwise false.
	about: Only collision of line and Oval is yet implemented.
	End Rem
	Method CollidesWithLine:Int( Line:LTLineSegment )
		?debug
		L_CollisionChecks :+ 1
		?
		Select ShapeType
			Case Pivot
				Return LTCollision.PivotWithLine( Self, Line )
			Case Oval
				Return LTCollision.OvalWithLine( Self, Line )
			Case Rectangle, Raster
				Return LTCollision.RectangleWithLine( Self, Line )
			Case Ray
			Default
				Return LTCollision.TriangleWithLine( Self, Line )
		End Select
	End Method
	
	
	
	Method TileSpriteCollidesWithSprite:Int( Sprite:LTSprite, DX:Double, DY:Double, XScale:Double, YScale:Double )
		?debug
		L_CollisionChecks :+ 1
		?
		Select ShapeType
			Case Pivot
				L_Pivot1.X = X * XScale + DX
				L_Pivot1.Y = Y * YScale + DY
				Select Sprite.ShapeType
					Case Pivot
						Return LTCollision.PivotWithPivot( L_Pivot1, Sprite )
					Case Oval
						Return LTCollision.PivotWithOval( L_Pivot1, Sprite )
					Case Rectangle, Raster
						Return LTCollision.PivotWithRectangle( L_Pivot1, Sprite )
					Case Ray
					Default
						Return LTCollision.PivotWithTriangle( L_Oval1, Sprite )
				End Select
			Case Oval
				L_Oval1.X = X * XScale + DX
				L_Oval1.Y = Y * YScale + DY
				L_Oval1.Width = Width * XScale
				L_Oval1.Height = Height * YScale
				Select Sprite.ShapeType
					Case Pivot
						Return LTCollision.PivotWithOval( Sprite, L_Oval1 )
					Case Oval
						Return LTCollision.OvalWithOval( L_Oval1, Sprite )
					Case Rectangle, Raster
						Return LTCollision.OvalWithRectangle( L_Oval1, Sprite )
					Case Ray
					Default
						Return LTCollision.OvalWithTriangle( L_Oval1, Sprite )
				End Select
			Case Rectangle, Raster
				If ShapeType = Raster And Sprite.ShapeType = Raster Then Return LTCollision.RasterWithRaster( Self, Sprite )
				
				L_Rectangle.X = X * XScale + DX
				L_Rectangle.Y = Y * YScale + DY
				L_Rectangle.Width = Width * XScale
				L_Rectangle.Height = Height * YScale
				Select Sprite.ShapeType
					Case Pivot
						Return LTCollision.PivotWithRectangle( Sprite, L_Rectangle )
					Case Oval
						Return LTCollision.OvalWithRectangle( Sprite, L_Rectangle )
					Case Rectangle, Raster
						Return LTCollision.RectangleWithRectangle( L_Rectangle, Sprite )
					Case Ray
					Default
						Return LTCollision.RectangleWithTriangle( L_Rectangle, Sprite )
				End Select
			Case Ray
			Default
				L_Triangle.X = X * XScale + DX
				L_Triangle.Y = Y * YScale + DY
				L_Triangle.Width = Width * XScale
				L_Triangle.Height = Height * YScale
				L_Triangle.ShapeType = ShapeType
				Select Sprite.ShapeType
					Case Pivot
						Return LTCollision.PivotWithTriangle( Sprite, L_Triangle )
					Case Oval
						Return LTCollision.OvalWithTriangle( Sprite, L_Triangle )
					Case Rectangle, Raster
						Return LTCollision.RectangleWithTriangle( Sprite, L_Triangle )
					Case Ray
					Default
						Return LTCollision.TriangleWithTriangle( L_Triangle, Sprite )
				End Select
		End Select
	End Method
	
	
	
	Rem
	bbdoc: Checks if the sprite overlaps given sprite.
	returns: True if the sprite overlaps given sprite, otherwise false.
	about: Pivot overlapping is not supported.
	End Rem
	Method Overlaps:Int( Sprite:LTSprite )
		?debug
		L_CollisionChecks :+ 1
		?
		Select ShapeType
			Case Oval
				If Sprite.Width <> Sprite.Height Then L_Error( "Only circle supports overlapping." )
				Select Sprite.ShapeType
					Case Pivot
						Return LTOverlap.CircleAndPivot( Self, Sprite )
					Case Oval
						Return LTOverlap.CircleAndOval( Self, Sprite )
					Case Rectangle, Raster
						Return LTOverlap.CircleAndRectangle( Self, Sprite )
					Case Ray
						Return False
					Case Raster
				End Select
			Case Rectangle
				Select Sprite.ShapeType
					Case Pivot
						Return LTOverlap.RectangleAndPivot( Self, Sprite )
					Case Ray
						Return False
					Default
						Return LTOverlap.RectangleAndRectangle( Self, Sprite )
				End Select
			Default
				L_Error( "Only Circle And Rectangle shapes supports overlapping." )
		End Select
	End Method
	
	
	
	Rem
	bbdoc: Searches the layer for first sprite which collides with given.
	Returns: First found sprite which collides with given.
	about: Included layers will be also checked.
	
	See also: #Clone example
	End Rem	
	Method FirstCollidedSpriteOfLayer:LTSprite( Layer:LTLayer )
		For Local Shape:LTShape = EachIn Layer
			If Shape <> Self Then
				Local Collided:LTSprite = Shape.LayerFirstSpriteCollision( Self )
				If Collided Then Return Collided
			End If
		Next
	End Method
	
	
	
	Method LayerFirstSpriteCollision:LTSprite( Sprite:LTSprite )
		If CollidesWithSprite( Sprite ) Then Return Self
	End Method
	
	
	
	Rem
	bbdoc: Executes given collision handler for collision of sprite with given sprite.
	about: If sprites collide then HandleCollisionWithSprite() method will be executed and given sprite will be passed to this method.
	You can specify collision type which will be passed to this method too.
	
	See also: #CollisionsWithLayer, #CollisionsWithTileMap, #CollisionsWithLine, #CollisionsWithSpriteMap, #Horizontal, #Vertical
	End Rem
	Method CollisionsWithSprite( Sprite:LTSprite, Handler:LTSpriteCollisionHandler )
		If CollidesWithSprite( Sprite ) Then Handler.HandleCollision( Self, Sprite )
	End Method
	
	
	
	Rem
	bbdoc: Executes given collision handler for collision of sprite with shapes in given group.
	about: For every collided shape collision handling method will be executed and corresponding parameters will be passed to this method.
	You can specify collision type which will be passed to this method too.
	
	See also: #CollisionsWithSprite, #CollisionsWithTileMap, #CollisionsWithLine, #CollisionsWithSpriteMap, #Horizontal, #Vertical
	End Rem
	Method CollisionsWithLayer( Layer:LTLayer, Handler:LTSpriteCollisionHandler )
		For Local Shape:LTShape = EachIn Layer
			If Shape <> Self Then Shape.SpriteLayerCollisions( Self, Handler )
		Next
	End Method
	
	
	
	Method SpriteLayerCollisions( Sprite:LTSprite, Handler:LTSpriteCollisionHandler )
		If Sprite.CollidesWithSprite( Self ) Then Handler.HandleCollision( Sprite, Self )
	End Method
	
	
	
	Rem
	bbdoc: Executes given collision handler for collision of sprite with given line.
	about: If sprite collides with line then HandleCollisionWithLine() method will be executed and line will be passed to this method.
	You can specify collision type which will be passed to this method too.
	
	See also: #CollisionsWithLayer, #CollisionsWithSprite, #CollisionsWithTileMap, #CollisionsWithSpriteMap, #Horizontal, #Vertical
	End Rem
	Method CollisionsWithLine( Line:LTLineSegment, Handler:LTSpriteAndLineCollisionHandler )
		If CollidesWithLine( Line ) Then Handler.HandleCollision( Self, Line )
	End Method

	
	
	
	Rem
	bbdoc: Executes given collision handler for collision of sprite with tiles in given tilemap.
	about: For every collided tile HandleCollisionWithTile() method will be executed and tilemap with tile indexes will be passed to this method.
	You can specify collision type which will be passed to this method too.
	
	See also: #CollisionsWithLayer, #CollisionsWithSprite, #CollisionsWithLine, #CollisionsWithSpriteMap, #Horizontal, #Vertical, #LTVectorSprite example
	End Rem
	Method CollisionsWithTileMap( TileMap:LTTileMap, Handler:LTSpriteAndTileCollisionHandler )
		Local X0:Double = TileMap.LeftX()
		Local Y0:Double = TileMap.TopY()
		Local CellWidth:Double = TileMap.GetTileWidth()
		Local CellHeight:Double = TileMap.GetTileHeight()
		Local XQuantity:Int = TileMap.XQuantity
		Local YQuantity:Int = TileMap.YQuantity
		Local Tileset:LTTileSet = TileMap.Tileset
				
		Select ShapeType
			Case Pivot
				Local TileX:Int = Floor( ( X - X0 ) / CellWidth )
				Local TileY:Int = Floor( ( Y - Y0 ) / CellHeight )
				
				If TileX >= 0 And TileY >= 0 And TileX < XQuantity And TileY < YQuantity Then
					Local Shape:LTShape = Tileset.CollisionShape[ TileMap.Value[ TileX, TileY ] ]
					If Shape Then Shape.TileShapeCollisionsWithSprite( Self, X0 + CellWidth * TileX, Y0 + CellHeight * TileY, CellWidth, CellHeight, TileMap, TileX, TileY, Handler )
				End If
			Case Ray
			Default
				Local X1:Int = Floor( ( X - 0.5 * Width - X0 ) / CellWidth )
				Local Y1:Int = Floor( ( Y - 0.5 * Height - Y0 ) / CellHeight )
				Local X2:Int = Floor( ( X + 0.5 * Width - X0 - L_Inaccuracy ) / CellWidth )
				Local Y2:Int = Floor( ( Y + 0.5 * Height - Y0 - L_Inaccuracy ) / CellHeight )
				
				If X2 >= 0 And Y2 >= 0 And X1 < XQuantity And Y1 < YQuantity Then
					X1 = L_LimitInt( X1, 0, XQuantity - 1 )
					Y1 = L_LimitInt( Y1, 0, YQuantity - 1 )
					X2 = L_LimitInt( X2, 0, XQuantity - 1 )
					Y2 = L_LimitInt( Y2, 0, YQuantity - 1 )
					
					For Local TileY:Int = Y1 To Y2
						For Local TileX:Int = X1 To X2
							Local Shape:LTShape = Tileset.CollisionShape[ TileMap.Value[ TileX, TileY ] ]
							If Shape Then Shape.TileShapeCollisionsWithSprite( Self, X0 + CellWidth * TileX, Y0 + CellHeight * TileY, CellWidth, CellHeight, TileMap, TileX, TileY, Handler )
						Next
					Next
				End If
		End Select
	End Method
	
	
	
	Rem
	bbdoc: Executes reaction for collision of sprite with sprites in sprite map.
	about: For every collided sprite HandleCollisionWithSprite() method will be executed and collided srite will be passed to this method.
	You can specify collision type which will be passed to this method too.
	Map parameter allows you to specify map to where collided sprites will be added as keys.
	
	See also: #CollisionsWithGroup, #CollisionsWithSprite, #CollisionsWithTileMap, #CollisionsWithLine, #Horizontal, #Vertical, #LTSpriteMap example
	End Rem
	Method CollisionsWithSpriteMap( SpriteMap:LTSpriteMap, Handler:LTSpriteCollisionHandler, Map:TMap = Null )
		If Not Map Then Map = New TMap
		Select ShapeType
			Case Pivot
				For Local MapSprite:LTSprite = EachIn SpriteMap.Lists[ Int( X / SpriteMap.CellWidth ) & SpriteMap.XMask, Int( Y / SpriteMap.CellHeight ) & SpriteMap.YMask ]
					If Self = MapSprite Then Continue
					If CollidesWithSprite( MapSprite ) Then
						If Not Map.Contains( MapSprite ) Then
							Map.Insert( MapSprite, Null )
							Handler.HandleCollision( Self, MapSprite )
						End If
					End If
				Next
			Case Ray
			Default
				Local MapX1:Int = Floor( ( X - 0.5 * Width ) / SpriteMap.CellWidth )
				Local MapY1:Int = Floor( ( Y - 0.5 * Height ) / SpriteMap.CellHeight )
				Local MapX2:Int = Floor( ( X + 0.5 * Width - L_Inaccuracy ) / SpriteMap.CellWidth )
				Local MapY2:Int = Floor( ( Y + 0.5 * Height - L_Inaccuracy ) / SpriteMap.CellHeight )
				
				For Local CellY:Int = MapY1 To MapY2
					For Local CellX:Int = MapX1 To MapX2
						For Local MapSprite:LTSprite = EachIn SpriteMap.Lists[ CellX & SpriteMap.XMask, CellY & SpriteMap.YMask ]
							If Self = MapSprite Then Continue
							If CollidesWithSprite( MapSprite ) Then
								If Not Map.Contains( MapSprite ) Then
									Map.Insert( MapSprite, Null )
									Handler.HandleCollision( Self, MapSprite )
								End If
							End If
						Next
					Next
				Next
		End Select
	End Method
	
	' ==================== Wedging off ====================
	
	Rem
	bbdoc: Wedges off sprite with given sprite.
	about: Pushes sprites from each other until they stops colliding. More the moving resistance, less the sprite will be moved.
	<ul>
	<li> If each sprite's moving resistance is zero, or each sprite's moving resistance is less than 0 then sprites will be moved on same distance.
	<li> If one of the sprite has zero moving resistance and other's moving resistance is non-zero, only zero-moving-resistance sprite will be moved
	<li> If one of the sprite has moving resistance less than 0 and other has moving resistance more or equal to 0, then only zero-or-more-moving-resistance sprite will be moved.
	</ul>
	End Rem
	Method WedgeOffWithSprite( Sprite:LTSprite, SelfMovingResistance:Double = 0.5, SpriteMovingResistance:Double = 0.5 )
		Local DX:Double, DY:Double
		Select ShapeType
			Case Pivot
				L_Pivot1.X = X
				L_Pivot1.Y = Y
				Select Sprite.ShapeType
					Case Pivot
						Return
					Case Oval
						L_WedgingValuesOfOvalAndOval( L_Pivot1, Sprite, DX, DY )
					Case Rectangle
						L_WedgingValuesOfRectangleAndRectangle( L_Pivot1, Sprite, DX, DY )
				End Select
			Case Oval
				Select Sprite.ShapeType
					Case Pivot
						L_Pivot1.X = Sprite.X
						L_Pivot1.Y = Sprite.Y
						L_WedgingValuesOfOvalAndOval( Self, L_Pivot1, DX, DY )
					Case Oval
						L_WedgingValuesOfOvalAndOval( Self, Sprite, DX, DY )
					Case Rectangle
						L_WedgingValuesOfOvalAndRectangle( Self, Sprite, DX, DY )
				End Select
			Case Rectangle
				Select Sprite.ShapeType
					Case Pivot
						L_Pivot1.X = Sprite.X
						L_Pivot1.Y = Sprite.Y
						L_WedgingValuesOfRectangleAndRectangle( Self, L_Pivot1, DX, DY )
					Case Oval
						L_WedgingValuesOfOvalAndRectangle( Sprite, Self, DX, DY )
						L_Separate( Sprite, Self, DX, DY, SpriteMovingResistance, SelfMovingResistance )
						Return
					Case Rectangle
						L_WedgingValuesOfRectangleAndRectangle( Self, Sprite, DX, DY )
				End Select
		End Select
		L_Separate( Self, Sprite, DX, DY, SelfMovingResistance, SpriteMovingResistance )
	End Method
	
	
	
	Rem
	bbdoc: Pushes sprite from given sprite.
	about: See also : #WedgeOffWithSprite, #PushFromTile
	End Rem
	Method PushFromSprite( Sprite:LTSprite )
		WedgeOffWithSprite( Sprite, 0.0, 1.0 )
	End Method
	
	
	
	Rem
	bbdoc: Pushes sprite from given tile.
	about: See also : #PushFromSprite
	End Rem
	Method PushFromTile( TileMap:LTTileMap, TileX:Int, TileY:Int )
		Local CellWidth:Double = TileMap.GetTileWidth()
		Local CellHeight:Double = TileMap.GetTileHeight()
		Local X:Double = TileMap.LeftX() + CellWidth * TileX
		Local Y:Double = TileMap.TopY() + CellHeight * TileY
		Local Shape:LTShape = TileMap.GetTileCollisionShape( TileX, TileY )
		Local Sprite:LTSprite = LTSprite( Shape )
		If Sprite Then
			PushFromTileSprite( Sprite, X, Y, CellWidth, CellHeight )
		Else
			For Sprite = EachIn LTGroup( Shape ).Children
				If Sprite.TileSpriteCollidesWithSprite( Self, X, Y, CellWidth, CellHeight ) Then
					PushFromTileSprite( Sprite, TileMap.LeftX() + CellWidth * TileX, TileMap.TopY() + CellHeight * TileY, CellWidth, CellHeight )
				End If
			Next
		End If
	End Method


	
	Method PushFromTileSprite( TileSprite:LTSprite, DX:Double, DY:Double, XScale:Double, YScale:Double )
		Local PushingDX:Double, PushingDY:Double
		Select TileSprite.ShapeType
			Case Pivot
				L_Pivot1.X = TileSprite.X * XScale + DX
				L_Pivot1.Y = TileSprite.Y * YScale + DY
				Select ShapeType
					Case Pivot
						Return
					Case Oval
						L_WedgingValuesOfOvalAndOval( Self, L_Pivot1, PushingDX, PushingDY )
					Case Rectangle
						L_WedgingValuesOfRectangleAndRectangle( Self, L_Pivot1, PushingDX, PushingDY )
				End Select
			Case Oval
				L_Oval1.X = TileSprite.X * XScale + DX
				L_Oval1.Y = TileSprite.Y * YScale + DY
				L_Oval1.Width = TileSprite.Width * XScale
				L_Oval1.Height = TileSprite.Height * YScale
				Select ShapeType
					Case Pivot
						L_Pivot1.X = X
						L_Pivot1.Y = Y
						L_WedgingValuesOfOvalAndOval( L_Pivot1, L_Oval1, PushingDX, PushingDY )
					Case Oval
						L_WedgingValuesOfOvalAndOval( Self, L_Oval1, PushingDX, PushingDY )
					Case Rectangle
						L_WedgingValuesOfOvalAndRectangle( L_Oval1, Self, PushingDX, PushingDY )
						L_Separate( L_Oval1, Self, PushingDX, PushingDY, 1.0, 0.0 )
						Return
				End Select
			Case Rectangle
				L_Rectangle.X = TileSprite.X * XScale + DX
				L_Rectangle.Y = TileSprite.Y * YScale + DY
				L_Rectangle.Width = TileSprite.Width * XScale
				L_Rectangle.Height = TileSprite.Height * YScale
				Select ShapeType
					Case Pivot
						L_Pivot1.X = X
						L_Pivot1.Y = Y
						L_WedgingValuesOfRectangleAndRectangle( L_Pivot1, L_Rectangle, PushingDX, PushingDY )
					Case Oval
						L_WedgingValuesOfOvalAndRectangle( Self, L_Rectangle, PushingDX, PushingDY )
					Case Rectangle
						L_WedgingValuesOfRectangleAndRectangle( Self, L_Rectangle, PushingDX, PushingDY )
				End Select
		End Select
		L_Separate( Self, TileSprite, PushingDX, PushingDY, 0.0, 1.0 )
	End Method
	
	
	
	Rem
	bbdoc: Forces sprite to bounce off the inner bounds of the shape.
	about: See also: #Active example
	End Rem
	Method BounceInside( Shape:LTShape, LeftSide:Int = True, TopSide:Int = True, RightSide:Int = True, BottomSide:Int = True )
		If LeftSide Then
			If LeftX() < Shape.LeftX() Then
				X = Shape.LeftX() + 0.5 * Width
				Angle = 180 - Angle
			End If
		End If
		If TopSide Then
			If TopY() < Shape.TopY() Then
				Y = Shape.TopY() + 0.5 * Height
				Angle = -Angle
			End If
		End If
		If RightSide Then
			If RightX() > Shape.RightX() Then
				X = Shape.RightX() - 0.5 * Width
				Angle = 180 - Angle
			End If
		End If
		If BottomSide Then
			If BottomY() > Shape.BottomY() Then
				Y = Shape.BottomY() - 0.5 * Height
				Angle = -Angle
			End If
		End If
	End Method

	' ==================== Position and size ====================
	
	Method SetCoords( NewX:Double, NewY:Double )
		If SpriteMap Then SpriteMap.RemoveSprite( Self, False )
		
		X = NewX
		Y = NewY
		
		Update()
		If SpriteMap Then SpriteMap.InsertSprite( Self, False )
	End Method
	
	
	
	Rem
	bbdoc: Moves sprite forward.
	about: See also: #Move, #MoveBackward, #Turn example
	End Rem
	Method MoveForward()
		SetCoords( X + Cos( Angle ) * Velocity * L_DeltaTime, Y + Sin( Angle ) * Velocity * L_DeltaTime )
	End Method
	
	
	
	Rem
	bbdoc: Moves sprite backward.
	about: See also: #Move, #MoveForward, #Turn example
	End Rem
	Method MoveBackward()
		SetCoords( X - Cos( Angle ) * Velocity * L_DeltaTime, Y - Sin( Angle ) * Velocity * L_DeltaTime )
	End Method
	
	
	
	Method SetSize( NewWidth:Double, NewHeight:Double )
		If SpriteMap Then SpriteMap.RemoveSprite( Self, False )
		
		Width = NewWidth
		Height = NewHeight

		Update()
		If SpriteMap Then SpriteMap.InsertSprite( Self, False )
	End Method
	
	
	
	Rem
	bbdoc: Sets the sprite as a tile.
	about: Position, size, visualizer and frame will be changed. This method can be used to cover other shapes with the tile or voluntary moving the tile.
	
	See also: #GetTileForPoint example
	End Rem
	Method SetAsTile( TileMap:LTTileMap, TileX:Int, TileY:Int )
		Width = TileMap.GetTileWidth()
		Height = TileMap.GetTileHeight()
		X = TileMap.LeftX() + Width * ( 0.5 + TileX )
		Y = TileMap.TopY() + Height * ( 0.5 + TileY )
		Visualizer = Tilemap.Visualizer.Clone()
		Visualizer.Image = Tilemap.TileSet.Image
		Frame = TileMap.GetTile( TileX, TileY )
	End Method

	' ==================== Limiting ====================
	
	Method LimitLeftWith( Rectangle:LTShape, AlterVelocity:Int = False )
		If LeftX() < Rectangle.LeftX() Then
			SetX( Rectangle.LeftX() + 0.5 * Width )
			If AlterVelocity Then Velocity = 0.0
		End If
	End Method
	
	
	
	Method LimitTopWith( Rectangle:LTShape, AlterVelocity:Int = False )
		If TopY() < Rectangle.TopY() Then
			SetY( Rectangle.TopY() + 0.5 * Height )
			If AlterVelocity Then Velocity = 0.0
		End If
	End Method
	
	
	
	Method LimitRightWith( Rectangle:LTShape, AlterVelocity:Int = False )
		If RightX() > Rectangle.RightX() Then
			SetX( Rectangle.RightX() - 0.5 * Width )
			If AlterVelocity Then Velocity = 0.0
		End If
	End Method
	
	
	
	Method LimitBottomWith( Rectangle:LTShape, AlterVelocity:Int = False )
		If BottomY() > Rectangle.BottomY() Then
			SetY( Rectangle.BottomY() - 0.5 * Height )
			If AlterVelocity Then Velocity = 0.0
		End If
	End Method
	
	' ==================== Angle ====================
	
	Rem
	bbdoc: Directs sprite as given angular sprite. 
	about: See also: #DirectTo
	End Rem
	Method DirectAs( Sprite:LTSprite )
		Angle = Sprite.Angle
	End Method
	
	
	
	Rem
	bbdoc: Turns the sprite.
	about: Turns the sprite with given speed per second.
	End Rem
	Method Turn( TurningSpeed:Double )
		Angle :+ L_DeltaTime * TurningSpeed
	End Method
	
	
	
	Rem
	bbdoc: Direct the sprite to center of the given shape.
	about: See also: #DirectAs
	End Rem
	Method DirectTo( Shape:LTShape )
		Angle = ATan2( Shape.Y - Y, Shape.X - X )
	End Method
	
	
	
	Method ReverseDirection()
		Angle = Angle + 180
	End Method
	
	
	
	Rem
	bbdoc: Alters angle by given value.
	about: See also: #Clone example
	End Rem
	Method AlterAngle( DAngle:Double )
		Angle :+ DAngle
	End Method
	
	' ==================== Animation ====================
	
	Rem
	bbdoc: Animates the sprite.
	End Rem
	Method Animate( Speed:Double, FramesQuantity:Int = 0, FrameStart:Int = 0, StartingTime:Double = 0.0, PingPong:Int = False )
		If FramesQuantity = 0 Then FramesQuantity = Visualizer.GetImage().FramesQuantity()
		Local ModFactor:Int = FramesQuantity
		If PingPong Then ModFactor = FramesQuantity * 2 - 2
		Frame = Floor( ( L_CurrentProject.Time - StartingTime ) / Speed ) Mod ModFactor
		If PingPong And Frame >= FramesQuantity Then Frame = ModFactor - Frame
		Frame :+ FrameStart
	End Method
	
	' ==================== Methods for oval ====================	
	
	Method ToCircle:LTSprite( Pivot:LTSprite, CircleSprite:LTSprite = Null )
		If Width = Height Then Return Self
		If Not CircleSprite Then CircleSprite = New LTSprite.FromShapeType( Circle )
		If Width > Height Then
			CircleSprite.X = L_LimitDouble( Pivot.X, X - 0.5 * ( Width - Height ), X + 0.5 * ( Width - Height ) )
			CircleSprite.Y = Y
			CircleSprite.Width = Height
			CircleSprite.Height = Height
		Else
			CircleSprite.X = X
			CircleSprite.Y = L_LimitDouble( Pivot.Y, Y - 0.5 * ( Height - Width ), Y + 0.5 * ( Height - Width ) )
			CircleSprite.Width = Width
			CircleSprite.Height = Width
		End If
		Return CircleSprite
	End Method
	
	
	
	Method ToCircleUsingLine:LTSprite( Line:LTLine, CircleSprite:LTSprite = Null )
		If Width = Height Then Return CircleSprite
		If Not CircleSprite Then CircleSprite = New LTSprite.FromShapeType( Circle )
		If Width > Height Then
			Local DWidth:Double = 0.5 * ( Width - Height )
			Local O1:Double = Line.A * ( X - DWidth ) + Line.B * Y + Line.C
			Local O2:Double = Line.A * ( X + DWidth ) + Line.B * Y + Line.C
			If Sgn( O1 ) <> Sgn( O2 ) Then
				CircleSprite.X = -( Line.B * Y + Line.C ) / Line.A
			ElseIf Abs( O1 ) < Abs( O2 ) Then
				CircleSprite.X = X - DWidth
			Else
				CircleSprite.X = X + DWidth
			End If
			CircleSprite.Y = Y
		Else
			Local DHeight:Double = 0.5 * ( Height - Width )
			Local O1:Double = Line.A * X + Line.B * ( Y - DHeight ) + Line.C
			Local O2:Double = Line.A * X + Line.B * ( Y + DHeight ) + Line.C
			If Sgn( O1 ) <> Sgn( O2 ) Then
				CircleSprite.X = -( Line.A * X + Line.C ) / Line.B
			ElseIf Abs( O1 ) < Abs( O2 ) Then
				CircleSprite.Y = Y - DHeight
			Else
				CircleSprite.Y = Y + DHeight
			End If
			CircleSprite.X = X
		End If
		Return CircleSprite
	End Method

	' ==================== Methods for rectangle ====================	
	
	Method GetBounds( LeftX:Double Var, TopY:Double Var, RightX:Double Var, BottomY:Double Var )
		Local DWidth:Double = 0.5 * Width
		Local DHeight:Double = 0.5 * Height
		LeftX = X - DWidth
		TopY = Y - DHeight
		RightX = X + DWidth
		BottomY = Y + DHeight
	End Method
	
	' ==================== Methods for triangle ====================	
	
	Method GetHypotenuse:LTLine( Line:LTLine = Null )
		If Not Line Then Line = New LTLine
		Select ShapeType
			Case LTSprite.TopLeftTriangle, LTSprite.BottomRightTriangle
				LTLine.FromPoints( X, Y, X - Width, Y + Height, Line )
			Case LTSprite.TopRightTriangle, LTSprite.BottomLeftTriangle
				LTLine.FromPoints( X, Y, X + Width, Y + Height, Line )
		End Select
		Return Line
	End Method
	
	
	
	Method GetRightAnglePivot:LTShape( Pivot:LTShape = Null )
		If Not Pivot Then Pivot = New LTShape
		Select ShapeType
			Case LTSprite.TopLeftTriangle, LTSprite.BottomLeftTriangle
				Pivot.X = X - 0.5 * Width
			Case LTSprite.BottomRightTriangle, LTSprite.TopRightTriangle
				Pivot.X = X + 0.5 * Width
		End Select
		Select ShapeType
			Case LTSprite.TopLeftTriangle, LTSprite.TopRightTriangle
				Pivot.Y = Y - 0.5 * Height
			Case LTSprite.BottomLeftTriangle, LTSprite.BottomRightTriangle
				Pivot.Y = Y + 0.5 * Height
		End Select
		Return Pivot
	End Method
	
	' ==================== Other ====================	
	
	Method Clone:LTShape()
		Local NewSprite:LTSprite = New LTSprite
		CopyTo( NewSprite )
		Return NewSprite
	End Method

	
	
	Method CopyTo( Shape:LTShape )
		Super.CopyTo( Shape )
		Local Sprite:LTSprite = LTSprite( Shape )
		
		?debug
		If Not Sprite Then L_Error( "Trying to copy sprite ~q" + Shape.GetTitle() + "~q data to non-sprite" )
		?
		
		Sprite.ShapeType = ShapeType
		Sprite.Angle = Angle
		Sprite.Velocity = Velocity
		Sprite.Frame = Frame
		Sprite.UpdateFromAngularModel()
	End Method
	
	
	
	Method UpdateFromAngularModel()
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageIntAttribute( "shape", ShapeType )
		XMLObject.ManageDoubleAttribute( "angle", Angle )
		XMLObject.ManageDoubleAttribute( "velocity", Velocity, 1.0 )
		XMLObject.ManageIntAttribute( "frame", Frame )
	End Method
End Type