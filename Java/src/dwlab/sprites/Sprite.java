package dwlab.sprites;
import dwlab.base.Project;
import java.util.HashMap;
import dwlab.base.XMLObject;
import java.lang.Math;
import dwlab.layers.Layer;
import dwlab.shapes.Shape;
import dwlab.maps.SpriteMap;
import dwlab.shapes.LineSegment;
import dwlab.shapes.Line;
import dwlab.maps.TileSet;
import dwlab.maps.TileMap;
import dwlab.visualizers.Visualizer;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

/**
 * Sprite is the main basic shape of the framework to draw, move and check collisions.
 * @see #lTVectorSprite
 */
public class Sprite extends Shape {
	private Sprite servicePivot = new Sprite( ShapeType.PIVOT, 0, 0, 0, 0 );
	private Sprite serviceOval = new Sprite( ShapeType.OVAL );
	private Sprite serviceRectangle = new Sprite( ShapeType.RECTANGLE );
	private Sprite serviceTriangle = new Sprite( ShapeType.TOP_LEFT_TRIANGLE );

	
	public enum ShapeType {
		/**
		* Type of the sprite shape: pivot. It's a point on game field with (X, Y) coordinates.
		*/
		PIVOT,

		/**
		* Type of the sprite shape: oval which is inscribed in shape's rectangle.
		*/
		OVAL,

		/**
		* Type of the sprite shape: rectangle.
		*/
		RECTANGLE,

		/**
		* Type of the sprite shape: ray which starts in (X, Y) and directed as Angle.
		*/
		RAY,

		/**
		* Type of the sprite shape: right triangle which is inscribed in shape's rectangle and have right angle situated in corresponding corner.
		*/
		TOP_LEFT_TRIANGLE,
		TOP_RIGHT_TRIANGLE,
		BOTTOM_LEFT_TRIANGLE,
		BOTTOM_RIGHT_TRIANGLE,

		/**
		* Type of the sprite shape: mask of raster image which is inscribed in shape's rectangle.
		*/
		RASTER
	}

	
	/**
	 * Type of the sprite shape.
	 * @see #pivot, #oval, #rectangle
	 */
	public ShapeType shapeType = ShapeType.RECTANGLE;


	/**
	 * Direction of the sprite
	 * @see #moveForward, #moveTowards
	 */
	public double angle;

	/**
	 * Angle of displaying image.
	 * Displaying angle is relative to sprite's direction if visualizer's rotating flag is set to True.
	 */
	public double displayingAngle;

	/**
	 * Velocity of the sprite in units per second.
	 * @see #moveForward, #moveTowards
	 */
	public double velocity = 1.0;

	/**
	 * Frame of the sprite image.
	 * Can only be used with visualizer which have images.
	 */
	public int frame;

	public SpriteMap spriteMap;



	@Override
	public String getClassTitle() {
		return "Sprite";
	}

	// ==================== Creating ===================	

	public Sprite() {
	}

	/**
	 * Creates sprite using given shape type.
	 * @return Created sprite.
	 */
	public Sprite( ShapeType shapeType ) {
		this.shapeType = shapeType;
	}


	/**
	 * Creates sprite using given coordinates, size, shape type, angle and velocity.
	 * @return Created sprite.
	 * See also #overlaps example.
	 */
	public Sprite( ShapeType shapeType, double x, double y, double width, double height ) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.shapeType = shapeType;
	}


	public Sprite( ShapeType shapeType, double x, double y, double width, double height, double angle, double velocity ) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.shapeType = shapeType;
		this.angle = angle;
		this.velocity = velocity;
	}

	// ==================== Drawing ===================	

	@Override
	public void draw() {
		visualizer.drawUsingSprite( this, this );
	}



	@Override
	public void drawUsingVisualizer( Visualizer vis ) {
		vis.drawUsingSprite( this, this );
	}

	// ==================== Collisions ===================

	@Override
	public void tileShapeCollisionsWithSprite( Sprite sprite, double dX, double dY, double xScale, double yScale, TileMap tileMap, int tileX, int tileY, SpriteAndTileCollisionHandler handler ) {
		if( tileSpriteCollidesWithSprite( sprite, dX, dY, xScale, yScale ) ) handler.handleCollision( sprite, tileMap, tileX, tileY, this );
	}


	/**
	 * Checks if this sprite collides with given sprite.
	 * @return True if the sprite collides with given sprite, False otherwise.
	 */
	public int collidesWithSprite( Sprite sprite ) {
		collisionChecks += 1;
		switch( shapeType ) {
			case pivot:
				switch( sprite.shapeType ) {
					case oval:
						return Collision.pivotWithOval( this, sprite );
					case rectangle:
						return Collision.pivotWithRectangle( this, sprite );
					case pivot, ray, raster:
					default:
						return Collision.pivotWithTriangle( this, sprite );
				}
			case oval:
				switch( sprite.shapeType ) {
					case pivot:
						return Collision.pivotWithOval( sprite, this );
					case oval:
						return Collision.ovalWithOval( this, sprite );
					case rectangle:
						return Collision.ovalWithRectangle( this, sprite );
					case ray:
						return Collision.ovalWithRay( this, sprite );
					case raster:
					default:
						return Collision.ovalWithTriangle( this, sprite );
				}
			case rectangle:
				switch( sprite.shapeType ) {
					case pivot:
						return Collision.pivotWithRectangle( sprite, this );
					case oval:
						return Collision.ovalWithRectangle( sprite, this );
					case rectangle:
						return Collision.rectangleWithRectangle( this, sprite );
					case ray:
						return Collision.rectangleWithRay( this, sprite );
					default:
						return Collision.rectangleWithTriangle( this, sprite );
				}
			case ray:
				switch( sprite.shapeType ) {
					case pivot:
					case oval:
						return Collision.ovalWithRay( sprite, this );
					case rectangle:
						return Collision.rectangleWithRay( sprite, this );
					case ray:
						return Collision.rayWithRay( this, sprite );
					default:
						return Collision.triangleWithRay( sprite, this );
				}
			case raster:
				if( sprite.shapeType == raster ) return Collision.rasterWithRaster( this, sprite );
			default:
				switch( sprite.shapeType ) {
					case pivot:
						return Collision.pivotWithTriangle( sprite, this );
					case oval:
						return Collision.ovalWithTriangle( sprite, this );
					case rectangle, raster:
						return Collision.rectangleWithTriangle( sprite, this );
					case ray:
						return Collision.triangleWithRay( this, sprite );
					case raster:
					default:
						return Collision.triangleWithTriangle( this, sprite );
				}
		}
	}



	/**
	 * Checks if the sprite collides with given line.
	 * @return True if the sprite collides with given line, otherwise false.
	 * Only collision of line and Oval is yet implemented.
	 */
	public int collidesWithLineSegment( LineSegment lineSegment ) {
		collisionChecks += 1;
		switch( shapeType ) {
			case pivot, raster:
			case oval:
				return Collision.ovalWithLineSegment( this, lineSegment.pivot[ 0 ], lineSegment.pivot[ 1 ] );
			case rectangle:
				return Collision.rectangleWithLineSegment( this, lineSegment.pivot[ 0 ], lineSegment.pivot[ 1 ] );
			case ray:
				return Collision.rayWithLineSegment( this, lineSegment.pivot[ 0 ], lineSegment.pivot[ 1 ] );
			default:
				return Collision.triangleWithLineSegment( this, lineSegment.pivot[ 0 ], lineSegment.pivot[ 1 ] );
		}
	}



	public int tileSpriteCollidesWithSprite( Sprite sprite, double dX, double dY, double xScale, double yScale ) {
		collisionChecks += 1;
		switch( shapeType ) {
			case pivot:
				servicePivot.x = x * xScale + dX;
				servicePivot.y = y * yScale + dY;
				switch( sprite.shapeType ) {
					case pivot, raster, ray:
					case oval:
						return Collision.pivotWithOval( servicePivot, sprite );
					case rectangle:
						return Collision.pivotWithRectangle( servicePivot, sprite );
					default:
						return Collision.pivotWithTriangle( servicePivot, sprite );
				}
			case oval:
				serviceOval.x = x * xScale + dX;
				serviceOval.y = y * yScale + dY;
				serviceOval.width = width * xScale;
				serviceOval.height = height * yScale;
				switch( sprite.shapeType ) {
					case pivot:
						return Collision.pivotWithOval( sprite, serviceOval );
					case oval:
						return Collision.ovalWithOval( serviceOval, sprite );
					case rectangle, raster:
						return Collision.ovalWithRectangle( serviceOval, sprite );
					case ray:
						return Collision.ovalWithRay( serviceOval, sprite );
					case raster:
					default:
						return Collision.ovalWithTriangle( serviceOval, sprite );
				}
			case rectangle:
				serviceRectangle.x = x * xScale + dX;
				serviceRectangle.y = y * yScale + dY;
				serviceRectangle.width = width * xScale;
				serviceRectangle.height = height * yScale;
				switch( sprite.shapeType ) {
					case pivot:
						return Collision.pivotWithRectangle( sprite, serviceRectangle );
					case oval:
						return Collision.ovalWithRectangle( sprite, serviceRectangle );
					case rectangle, raster:
						return Collision.rectangleWithRectangle( serviceRectangle, sprite );
					case ray:
						return Collision.rectangleWithRay( serviceRectangle, sprite );
					case raster:
					default:
						return Collision.rectangleWithTriangle( serviceRectangle, sprite );
				}
			case ray:
			case raster:
				if( sprite.shapeType == raster ) return Collision.rasterWithRaster( this, sprite );
			default:
				serviceTriangle.x = x * xScale + dX;
				serviceTriangle.y = y * yScale + dY;
				serviceTriangle.width = width * xScale;
				serviceTriangle.height = height * yScale;
				serviceTriangle.shapeType = shapeType;
				switch( sprite.shapeType ) {
					case pivot:
						return Collision.pivotWithTriangle( sprite, serviceTriangle );
					case oval:
						return Collision.ovalWithTriangle( sprite, serviceTriangle );
					case rectangle:
						return Collision.rectangleWithTriangle( sprite, serviceTriangle );
					case ray:
						return Collision.triangleWithRay( serviceTriangle, sprite );
					case raster:
					default:
						return Collision.triangleWithTriangle( serviceTriangle, sprite );
				}
		}
	}



	/**
	 * Checks if the sprite overlaps given sprite.
	 * @return True if the sprite overlaps given sprite, otherwise false.
	 * Pivot overlapping is not supported.
	 */
	public int overlaps( Sprite sprite ) {
		collisionChecks += 1;
		switch( shapeType ) {
			case oval:
				if( width != height ) error( "Only circle supports overlapping." );
				switch( sprite.shapeType ) {
					case pivot:
						return Overlap.circleAndPivot( this, sprite );
					case oval:
						return Overlap.circleAndOval( this, sprite );
					case rectangle:
						return Overlap.circleAndRectangle( this, sprite );
					case ray, raster:
					default:
						return Overlap.circleAndTriangle( this, sprite );
				}
			case rectangle:
				switch( sprite.shapeType ) {
					case pivot:
						return Overlap.rectangleAndPivot( this, sprite );
					case ray, raster:
					default:
						return Overlap.rectangleAndRectangle( this, sprite );
				}
			default:
				error( "Only Circle And Rectangle shapes supports overlapping." );
		}
	}



	/**
	 * Searches the layer for first sprite which collides with given.
	 * @return First found sprite which collides with given.
	 * Included layers will be also checked.
	 * 
	 * @see #clone example
	 */	
	public Sprite firstCollidedSpriteOfLayer( Layer layer ) {
		for( Shape shape: layer ) {
			if( shape != this ) {
				Sprite collided = shape.layerFirstSpriteCollision( this );
				if( collided ) return collided;
			}
		}
	}



	public Sprite layerFirstSpriteCollision( Sprite sprite ) {
		if( collidesWithSprite( sprite ) ) return this;
	}



	/**
	 * Executes given collision handler for collision of sprite with given sprite.
	 * If sprites collide then HandleCollisionWithSprite() method will be executed and given sprite will be passed to this method.
	 * You can specify collision type which will be passed to this method too.
	 * 
	 * @see #collisionsWithLayer, #collisionsWithTileMap, #collisionsWithLine, #collisionsWithSpriteMap, #horizontal, #vertical
	 */
	public void collisionsWithSprite( Sprite sprite, SpriteCollisionHandler handler ) {
		if( collidesWithSprite( sprite ) ) handler.handleCollision( this, sprite );
	}



	/**
	 * Executes given collision handler for collision of sprite with shapes in given group.
	 * For every collided shape collision handling method will be executed and corresponding parameters will be passed to this method.
	 * You can specify collision type which will be passed to this method too.
	 * 
	 * @see #collisionsWithSprite, #collisionsWithTileMap, #collisionsWithLine, #collisionsWithSpriteMap, #horizontal, #vertical
	 */
	public void collisionsWithLayer( Layer layer, SpriteCollisionHandler handler ) {
		for( Shape shape: layer ) {
			if( shape != this ) shape.spriteLayerCollisions( this, handler );
		}
	}



	public void spriteLayerCollisions( Sprite sprite, SpriteCollisionHandler handler ) {
		if( sprite.collidesWithSprite( this ) ) handler.handleCollision( sprite, this );
	}



	/**
	 * Executes given collision handler for collision of sprite with given line.
	 * If sprite collides with line then HandleCollisionWithLine() method will be executed and line will be passed to this method.
	 * You can specify collision type which will be passed to this method too.
	 * 
	 * @see #collisionsWithLayer, #collisionsWithSprite, #collisionsWithTileMap, #collisionsWithSpriteMap, #horizontal, #vertical
	 */
	public void collisionsWithLineSegment( LineSegment lineSegment, SpriteAndLineSegmentCollisionHandler handler ) {
		if( collidesWithLineSegment( lineSegment ) ) handler.handleCollision( this, lineSegment );
	}




	/**
	 * Executes given collision handler for collision of sprite with tiles in given tilemap.
	 * For every collided tile HandleCollisionWithTile() method will be executed and tilemap with tile indexes will be passed to this method.
	 * You can specify collision type which will be passed to this method too.
	 * 
	 * @see #collisionsWithLayer, #collisionsWithSprite, #collisionsWithLine, #collisionsWithSpriteMap, #horizontal, #vertical, #lTVectorSprite example
	 */
	public void collisionsWithTileMap( TileMap tileMap, SpriteAndTileCollisionHandler handler ) {
		double x0 = tileMap.leftX();
		double y0 = tileMap.topY();
		double cellWidth = tileMap.getTileWidth();
		double cellHeight = tileMap.getTileHeight();
		int xQuantity = tileMap.xQuantity;
		int yQuantity = tileMap.yQuantity;
		TileSet tileset = tileMap.tileset;

		switch( shapeType ) {
			case pivot:
				int tileX = Math.floor( ( x - x0 ) / cellWidth );
				int tileY = Math.floor( ( y - y0 ) / cellHeight );

				if( tileX >= 0 && tileY >= 0 && tileX < xQuantity && tileY < yQuantity ) {
					Shape shape = tileset.collisionShape[ tileMap.value[ tileX, tileY ] ];
					if( shape ) shape.tileShapeCollisionsWithSprite( this, x0 + cellWidth * tileX, y0 + cellHeight * tileY, cellWidth, cellHeight, tileMap, tileX, tileY, handler );
				}
			case ray:
			default:
				int x1 = Math.floor( ( x - 0.double 5 * width - x0 ) / cellWidth );
				int y1 = Math.floor( ( y - 0.double 5 * height - y0 ) / cellHeight );
				int x2 = Math.floor( ( x + 0.double 5 * width - x0 - inaccuracy ) / cellWidth );
				int y2 = Math.floor( ( y + 0.double 5 * height - y0 - inaccuracy ) / cellHeight );

				if( x2 >= 0 && y2 >= 0 && x1 < xQuantity && y1 < yQuantity ) {
					x1 = limitInt( x1, 0, xQuantity - 1 );
					y1 = limitInt( y1, 0, yQuantity - 1 );
					x2 = limitInt( x2, 0, xQuantity - 1 );
					y2 = limitInt( y2, 0, yQuantity - 1 );

					for( int tileY=y1; tileY <= y2; tileY++ ) {
						for( int tileX=x1; tileX <= x2; tileX++ ) {
							Shape shape = tileset.collisionShape[ tileMap.value[ tileX, tileY ] ];
							if( shape ) shape.tileShapeCollisionsWithSprite( this, x0 + cellWidth * tileX, y0 + cellHeight * tileY, cellWidth, cellHeight, tileMap, tileX, tileY, handler );
						}
					}
				}
		}
	}



	/**
	 * Executes reaction for collision of sprite with sprites in sprite map.
	 * For every collided sprite HandleCollisionWithSprite() method will be executed and collided srite will be passed to this method.
	 * You can specify collision type which will be passed to this method too.
	 * Map parameter allows you to specify map to where collided sprites will be added as keys.
	 * 
	 * @see #collisionsWithGroup, #collisionsWithSprite, #collisionsWithTileMap, #collisionsWithLine, #horizontal, #vertical, #lTSpriteMap example
	 */
	public void collisionsWithSpriteMap( SpriteMap spriteMap, SpriteCollisionHandler handler, HashMap map = null ) {
		if( ! map ) map == new HashMap();
		switch( shapeType ) {
			case pivot:
				for( Sprite mapSprite: spriteMap.lists[ int( x / spriteMap.cellWidth ) & spriteMap.xMask, int( y / spriteMap.cellHeight ) & spriteMap.yMask ] ) {
					if( this == mapSprite ) continue;
					if( collidesWithSprite( mapSprite ) ) {
						if( ! map.contains( mapSprite ) ) {
							map.put( mapSprite, null );
							handler.handleCollision( this, mapSprite );
						}
					}
				}
			case ray:
			default:
				int mapX1 = Math.floor( ( x - 0.double 5 * width ) / spriteMap.cellWidth );
				int mapY1 = Math.floor( ( y - 0.double 5 * height ) / spriteMap.cellHeight );
				int mapX2 = Math.floor( ( x + 0.double 5 * width - inaccuracy ) / spriteMap.cellWidth );
				int mapY2 = Math.floor( ( y + 0.double 5 * height - inaccuracy ) / spriteMap.cellHeight );

				for( int cellY=mapY1; cellY <= mapY2; cellY++ ) {
					for( int cellX=mapX1; cellX <= mapX2; cellX++ ) {
						for( Sprite mapSprite: spriteMap.lists[ cellX & spriteMap.xMask, cellY & spriteMap.yMask ] ) {
							if( this == mapSprite ) continue;
							if( collidesWithSprite( mapSprite ) ) {
								if( ! map.contains( mapSprite ) ) {
									map.put( mapSprite, null );
									handler.handleCollision( this, mapSprite );
								}
							}
						}
					}
				}
		}
	}

	// ==================== Wedging off ====================

	/**
	 * Wedges off sprite with given sprite.
	 * Pushes sprites from each other until they stops colliding. More the moving resistance, less the sprite will be moved.
	 * <ul>
	 * <li> If each sprite's moving resistance is zero, or each sprite's moving resistance is less than 0 then sprites will be moved on same distance.
	 * <li> If one of the sprite has zero moving resistance and other's moving resistance is non-zero, only zero-moving-resistance sprite will be moved
	 * <li> If one of the sprite has moving resistance less than 0 and other has moving resistance more or equal to 0, then only zero-or-more-moving-resistance sprite will be moved.
	 * </ul>
	 */
	public void wedgeOffWithSprite( Sprite sprite, double selfMovingResistance = 0.5, double spriteMovingResistance = 0.5 ) {
		double dX, double dY;
		int swap = false;
		switch( shapeType ) {
			case pivot:
				switch( sprite.shapeType ) {
					case pivot:
						return;
					case oval:
						Wedge.pivotAndOval( this, sprite, dX, dY );
					case rectangle:
						Wedge.pivotAndRectangle( this, sprite, dX, dY );
					case ray,raster:
					default:
						Wedge.pivotAndTriangle( this, sprite, dX, dY );
				}
			case oval:
				switch( sprite.shapeType ) {
					case pivot:
						Wedge.pivotAndOval( sprite, this, dX, dY );
						swap = true;
					case oval:
						Wedge.ovalAndOval( this, sprite, dX, dY );
					case rectangle:
						Wedge.ovalAndRectangle( this, sprite, dX, dY );
					case ray,raster:
					default:
						Wedge.ovalAndTriangle( this, sprite, dX, dY );
				}
			case rectangle:
				switch( sprite.shapeType ) {
					case pivot:
						Wedge.pivotAndRectangle( sprite, this, dX, dY );
						swap = true;
					case oval:
						Wedge.ovalAndRectangle( sprite, this, dX, dY );
						swap = true;
					case rectangle:
						Wedge.rectangleAndRectangle( this, sprite, dX, dY );
					case ray,raster:
					default:
						Wedge.rectangleAndTriangle( this, sprite, dX, dY );
				}
			case ray,raster:
			default:
				swap = true;
				switch( sprite.shapeType ) {
					case pivot:
						Wedge.pivotAndTriangle( sprite, this, dX, dY );
					case oval:
						Wedge.ovalAndTriangle( sprite, this, dX, dY );
					case rectangle:
						Wedge.rectangleAndTriangle( sprite, this, dX, dY );
					case ray,raster:
					default:
						Wedge.triangleAndTriangle( sprite, this, dX, dY );
				}
		}
		if( swap ) {
			Wedge.separate( sprite, this, dX, dY, spriteMovingResistance, selfMovingResistance );
		} else {
			Wedge.separate( this, sprite, dX, dY, selfMovingResistance, spriteMovingResistance );
		}
	}



	/**
	 * Pushes sprite from given sprite.
	 * See also : #wedgeOffWithSprite, #pushFromTile
	 */
	public void pushFromSprite( Sprite sprite ) {
		wedgeOffWithSprite( sprite, 0.0, 1.0 );
	}



	/**
	 * Pushes sprite from given tile.
	 * See also : #pushFromSprite
	 */
	public void pushFromTile( TileMap tileMap, int tileX, int tileY ) {
		double cellWidth = tileMap.getTileWidth();
		double cellHeight = tileMap.getTileHeight();
		double x = tileMap.leftX() + cellWidth * tileX;
		double y = tileMap.topY() + cellHeight * tileY;
		Shape shape = tileMap.getTileCollisionShape( tileX, tileY );
		Sprite sprite = Sprite( shape );
		if( sprite ) {
			pushFromTileSprite( sprite, x, y, cellWidth, cellHeight );
		} else {
			for( sprite: Layer( shape ).children ) {
				if( sprite.tileSpriteCollidesWithSprite( this, x, y, cellWidth, cellHeight ) ) {
					pushFromTileSprite( sprite, tileMap.leftX() + cellWidth * tileX, tileMap.topY() + cellHeight * tileY, cellWidth, cellHeight );
				}
			}
		}
	}



	public void pushFromTileSprite( Sprite tileSprite, double dX, double dY, double xScale, double yScale ) {
		double pushingDX, double pushingDY;
		switch( tileSprite.shapeType ) {
			case pivot:
				servicePivot.x = tileSprite.x * xScale + dX;
				servicePivot.y = tileSprite.y * yScale + dY;
				switch( shapeType ) {
					case pivot:
						return;
					case oval:
						Wedge.ovalAndOval( this, servicePivot, pushingDX, pushingDY );
					case rectangle:
						Wedge.rectangleAndRectangle( this, servicePivot, pushingDX, pushingDY );
				}
			case oval:
				serviceOval.x = tileSprite.x * xScale + dX;
				serviceOval.y = tileSprite.y * yScale + dY;
				serviceOval.width = tileSprite.width * xScale;
				serviceOval.height = tileSprite.height * yScale;
				switch( shapeType ) {
					case pivot:
						servicePivot.x = x;
						servicePivot.y = y;
						Wedge.ovalAndOval( servicePivot, serviceOval, pushingDX, pushingDY );
					case oval:
						Wedge.ovalAndOval( this, serviceOval, pushingDX, pushingDY );
					case rectangle:
						Wedge.ovalAndRectangle( serviceOval, this, pushingDX, pushingDY );
						Wedge.separate( serviceOval, this, pushingDX, pushingDY, 1.0, 0.0 );
						return;
				}
			case rectangle:
				serviceRectangle.x = tileSprite.x * xScale + dX;
				serviceRectangle.y = tileSprite.y * yScale + dY;
				serviceRectangle.width = tileSprite.width * xScale;
				serviceRectangle.height = tileSprite.height * yScale;
				switch( shapeType ) {
					case pivot:
						servicePivot.x = x;
						servicePivot.y = y;
						Wedge.rectangleAndRectangle( servicePivot, serviceRectangle, pushingDX, pushingDY );
					case oval:
						Wedge.ovalAndRectangle( this, serviceRectangle, pushingDX, pushingDY );
					case rectangle:
						Wedge.rectangleAndRectangle( this, serviceRectangle, pushingDX, pushingDY );
				}
		}
		Wedge.separate( this, tileSprite, pushingDX, pushingDY, 0.0, 1.0 );
	}



	/**
	 * Forces sprite to bounce off the inner bounds of the shape.
	 * @see #active example
	 */
	public void bounceInside( Shape shape, int leftSide = true, int topSide = true, int rightSide = true, int bottomSide = true ) {
		if( leftSide ) {
			if( leftX() < shape.leftX() ) {
				x = shape.leftX() + 0.5 * width;
				angle = 180 - angle;
			}
		}
		if( topSide ) {
			if( topY() < shape.topY() ) {
				y = shape.topY() + 0.5 * height;
				angle = -angle;
			}
		}
		if( rightSide ) {
			if( rightX() > shape.rightX() ) {
				x = shape.rightX() - 0.5 * width;
				angle = 180 - angle;
			}
		}
		if( bottomSide ) {
			if( bottomY() > shape.bottomY() ) {
				y = shape.bottomY() - 0.5 * height;
				angle = -angle;
			}
		}
	}

	// ==================== Position and size ====================

	public void setCoords( double newX, double newY ) {
		if( spriteMap ) spriteMap.removeSprite( this, false );

		x = newX;
		y = newY;

		update();
		if( spriteMap ) spriteMap.insertSprite( this, false );
	}



	public void setCoordsAndSize( double x1, double y1, double x2, double y2 ) {
		if( spriteMap ) spriteMap.removeSprite( this, false );

		x = 0.double 5 * ( x1 + x2 );
		y = 0.double 5 * ( y1 + y2 );
		width = x2 - x1;
		height = y2 - y1;

		update();
		if( spriteMap ) spriteMap.insertSprite( this, false );
	}



	/**
	 * Moves sprite forward.
	 * @see #move, #moveBackward, #turn example
	 */
	public void moveForward() {
		setCoords( x + Math.cos( angle ) * velocity * deltaTime, y + Math.sin( angle ) * velocity * deltaTime );
	}



	/**
	 * Moves sprite backward.
	 * @see #move, #moveForward, #turn example
	 */
	public void moveBackward() {
		setCoords( x - Math.cos( angle ) * velocity * deltaTime, y - Math.sin( angle ) * velocity * deltaTime );
	}



	public void setSize( double newWidth, double newHeight ) {
		if( spriteMap ) spriteMap.removeSprite( this, false );

		width = newWidth;
		height = newHeight;

		update();
		if( spriteMap ) spriteMap.insertSprite( this, false );
	}



	/**
	 * Sets the sprite as a tile.
	 * Position, size, visualizer and frame will be changed. This method can be used to cover other shapes with the tile or voluntary moving the tile.
	 * 
	 * @see #getTileForPoint example
	 */
	public void setAsTile( TileMap tileMap, int tileX, int tileY ) {
		width = tileMap.getTileWidth();
		height = tileMap.getTileHeight();
		x = tileMap.leftX() + width * ( 0.5 + tileX );
		y = tileMap.topY() + height * ( 0.5 + tileY );
		visualizer = tileMap.visualizer.clone();
		visualizer.image = tileMap.tileSet.image;
		frame = tileMap.getTile( tileX, tileY );
	}

	// ==================== Limiting ====================

	@Override
	public void limitLeftWith( Shape rectangle, SpriteCollisionHandler handler ) {
		double rectLeftX = rectangle.leftX();
		if( leftX() < rectLeftX ) {
			setX( rectLeftX + 0.5 * width );
			if( handler != null ) handler.handleCollision( this, null );
		}
	}



	@Override
	public void limitTopWith( Shape rectangle, SpriteCollisionHandler handler ) {
		double rectTopY = rectangle.topY();
		if( topY() < rectTopY ) {
			setY( rectTopY + 0.5 * height );
			if( handler != null ) handler.handleCollision( this, null );
		}
	}



	@Override
	public void limitRightWith( Shape rectangle, SpriteCollisionHandler handler ) {
		double rectRightX = rectangle.rightX();
		if( rightX() > rectRightX ) {
			setX( rectRightX - 0.5 * width );
			if( handler != null ) handler.handleCollision( this, null );
		}
	}



	@Override
	public void limitBottomWith( Shape rectangle, SpriteCollisionHandler handler ) {
		double rectBottomY = rectangle.bottomY();
		if( bottomY() > rectBottomY ) {
			setY( rectBottomY - 0.5 * height );
			if( handler != null ) handler.handleCollision( this, null );
		}
	}

	// ==================== Angle ====================

	/**
	 * Directs sprite as given angular sprite. 
	 * @see #directTo
	 */
	public void directAs( Sprite sprite ) {
		angle = sprite.angle;
	}



	/**
	 * Turns the sprite.
	 * Turns the sprite with given speed per second.
	 */
	public void turn( double turningSpeed ) {
		angle += Project.deltaTime * turningSpeed;
	}



	/**
	 * Direct the sprite to center of the given shape.
	 * @see #directAs
	 */
	public void directTo( Shape shape ) {
		angle = Math.atan2( shape.getY() - y, shape.getX() - x );
	}



	public void reverseDirection() {
		angle = angle + 180;
	}



	/**
	 * Alters angle by given value.
	 * @see #clone example
	 */
	public void alterAngle( double dAngle ) {
		angle += dAngle;
	}

	// ==================== Animation ====================

	/**
	 * Animates the sprite.
	 */
	public void animate( double speed, int framesQuantity, int frameStart, double startingTime, boolean pingPong ) {
		if( framesQuantity == 0 ) framesQuantity = visualizer.getImage().framesQuantity();
		int modFactor = framesQuantity;
		if( pingPong ) modFactor = framesQuantity * 2 - 2;
		frame =  ( int ) Math.floor( ( Project.current.time - startingTime ) / speed ) % modFactor;
		if( pingPong && frame >= framesQuantity ) frame = modFactor - frame;
		frame += frameStart;
	}

	// ==================== Methods for oval ====================	

	public Sprite toCircle( Sprite pivot1, Sprite circleSprite = null ) {
		if( width == height ) return this;
		if( ! circleSprite ) circleSprite == new Sprite().fromShapeType( circle );
		if( width > height ) {
			circleSprite.x = limitDouble( pivot1.x, x - 0.5 * ( width - height ), x + 0.5 * ( width - height ) );
			circleSprite.y = y;
			circleSprite.width = height;
			circleSprite.height = height;
		} else {
			circleSprite.x = x;
			circleSprite.y = limitDouble( pivot1.y, y - 0.5 * ( height - width ), y + 0.5 * ( height - width ) );
			circleSprite.width = width;
			circleSprite.height = width;
		}
		return circleSprite;
	}



	public Sprite toCircleUsingLine( Line line, Sprite circleSprite = null ) {
		if( width == height ) return circleSprite;
		if( ! circleSprite ) circleSprite == new Sprite().fromShapeType( circle );
		if( width > height ) {
			double dWidth = 0.5 * ( width - height );
			double o1 = line.a * ( x - dWidth ) + line.b * y + line.c;
			double o2 = line.a * ( x + dWidth ) + line.b * y + line.c;
			if( sgn( o1 ) != sgn( o2 ) ) {
				circleSprite.x = -( line.b * y + line.c ) / line.a;
			} else if( Math.abs( o1 ) < Math.abs( o2 ) then ) {
				circleSprite.x = x - dWidth;
			} else {
				circleSprite.x = x + dWidth;
			}
			circleSprite.y = y;
		} else {
			double dHeight = 0.5 * ( height - width );
			double o1 = line.a * x + line.b * ( y - dHeight ) + line.c;
			double o2 = line.a * x + line.b * ( y + dHeight ) + line.c;
			if( sgn( o1 ) != sgn( o2 ) ) {
				circleSprite.y = -( line.a * x + line.c ) / line.b;
			} else if( Math.abs( o1 ) < Math.abs( o2 ) then ) {
				circleSprite.y = y - dHeight;
			} else {
				circleSprite.y = y + dHeight;
			}
			circleSprite.x = x;
		}
		return circleSprite;
	}

	// ==================== Methods for rectangle ====================	

	public void getBounds( double leftX var, double topY var, double rightX var, double bottomY var ) {
		double dWidth = 0.5 * width;
		double dHeight = 0.5 * height;
		leftX = x - dWidth;
		topY = y - dHeight;
		rightX = x + dWidth;
		bottomY = y + dHeight;
	}

	// ==================== Methods for ray ====================	

	public Line toLine( Line line ) {
		if( ! line ) line == new Line();
		line.usePoints( x, y, x + Math.cos( angle ), y + Math.sin( angle ) );
		return line;
	}



	public int hasPoint( double x1, double y1 ) {
		double ang = wrapDouble( angle, 360.0 );
		if( ang < 45.0 || ang >= 315.0 ) {
			return x1 >= x;
		} else if( ang < 135.0 then ) {
			return y1 >= y;
		} else if( ang < 225.0 then ) {
			return x1 <= x;
		} else {
			return y1 <= y;
		}
	}



	public int hasPivot( Sprite pivot ) {
		return hasPoint( pivot.x, pivot.y );
	}

	// ==================== Methods for triangle ====================	

	public static Sprite getMedium( Sprite pivot1, Sprite pivot2, Sprite toPivot = null ) {
		if( ! toPivot ) toPivot == new Sprite().fromShape( 0, 0, 0, 0, pivot );
		toPivot.x = 0.5 * ( pivot1.x + pivot2.x );
		toPivot.y = 0.5 * ( pivot1.y + pivot2.y );
		return toPivot;
	}



	public Line getHypotenuse( Line line = null ) {
		if( ! line ) line == new Line();
		switch( shapeType ) {
			case Sprite.topLeftTriangle, Sprite.bottomRightTriangle:
				Line.fromPoints( x, y, x - width, y + height, line );
			case Sprite.topRightTriangle, Sprite.bottomLeftTriangle:
				Line.fromPoints( x, y, x + width, y + height, line );
		}
		return line;
	}



	public Sprite getRightAngleVertex( Sprite vertex = null ) {
		if( ! vertex ) vertex == new Sprite().fromShape( 0, 0, 0, 0, pivot );
		switch( shapeType ) {
			case Sprite.topLeftTriangle, Sprite.bottomLeftTriangle:
				vertex.x = x - 0.5 * width;
			case Sprite.bottomRightTriangle, Sprite.topRightTriangle:
				vertex.x = x + 0.5 * width;
		}
		switch( shapeType ) {
			case Sprite.topLeftTriangle, Sprite.topRightTriangle:
				vertex.y = y - 0.5 * height;
			case Sprite.bottomLeftTriangle, Sprite.bottomRightTriangle:
				vertex.y = y + 0.5 * height;
		}
		return vertex;
	}



	public void getOtherVertices( Sprite pivot1, Sprite pivot2 ) {
		if( shapeType = Sprite.topRightTriangle || shapeType == Sprite.bottomLeftTriangle ) {
			getBounds( pivot1.x, pivot1.y, pivot2.x, pivot2.y );
		} else {
			getBounds( pivot1.x, pivot2.y, pivot2.x, pivot1.y );
		}
	}

	// ==================== Cloning ===================	

	public Shape clone() {
		Sprite newSprite = new Sprite();
		copySpriteTo( newSprite );
		return newSprite;
	}



	public void copySpriteTo( Sprite sprite ) {
		copyShapeTo( sprite );

		sprite.shapeType = shapeType;
		sprite.angle = angle;
		sprite.displayingAngle = displayingAngle;
		sprite.velocity = velocity;
		sprite.frame = frame;
		sprite.updateFromAngularModel();
	}



	public void copyTo( Shape shape ) {
		Sprite sprite = Sprite( shape );

		if( ! sprite ) error( "Trying to copy sprite \"" + shape.getTitle() + "\" data to non-sprite" );

		copySpriteTo( sprite );
	}

	// ==================== Other ====================

	public void updateFromAngularModel() {
	}



	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		xMLObject.manageIntAttribute( "shape", shapeType );
		xMLObject.manageDoubleAttribute( "angle", angle );
		xMLObject.manageDoubleAttribute( "disp_angle", displayingAngle );
		xMLObject.manageDoubleAttribute( "velocity", velocity, 1.0 );
		xMLObject.manageIntAttribute( "frame", frame );
	}
}
