/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.shapes.sprites;

import dwlab.base.*;
import dwlab.shapes.Line;
import dwlab.shapes.LineSegment;
import dwlab.shapes.Shape;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.maps.SpriteMap;
import dwlab.shapes.maps.TileMap;
import dwlab.shapes.maps.TileSet;
import dwlab.visualizers.Visualizer;
import java.util.HashSet;

/**
 * Sprite is the main basic shape of the framework to draw, move and check collisions.
 * @see #lTVectorSprite
 */
public class Sprite extends Shape {
	private static Vector serviceVector = new Vector();
	private static Sprite servicePivot = new Sprite();
	private static Sprite serviceOval = new Sprite( ShapeType.OVAL );
	private static Sprite serviceRectangle = new Sprite( ShapeType.RECTANGLE );
	private static Sprite serviceTriangle = new Sprite( ShapeType.TOP_LEFT_TRIANGLE );

	
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
	public double velocity;

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
		this.shapeType = ShapeType.PIVOT;
	}

	/**
	 * Creates sprite using given shape type.
	 * @return Created sprite.
	 */
	public Sprite( ShapeType shapeType ) {
		this.shapeType = shapeType;
		this.x = 0d;
		this.y = 0d;
		if( shapeType == ShapeType.PIVOT ) {
			this.width = 0d;
			this.height = 0d;
		} else {
			this.width = 1d;
			this.height = 1d;
		}
	}

	public Sprite( double x, double y ) {
		this.x = x;
		this.y = y;
		this.shapeType = ShapeType.PIVOT;
	}

	public Sprite( double x, double y, double radius ) {
		this.x = x;
		this.y = y;
		this.width = radius;
		this.height = radius;
		this.shapeType = ShapeType.OVAL;
	}

	public Sprite( double x, double y, double width, double height ) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.shapeType = ShapeType.RECTANGLE;
	}

	public Sprite( Sprite sprite ) {
		sprite.copySpriteTo( this );
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
	public boolean collidesWithSprite( Sprite sprite ) {
		if( Sys.debug ) Project.collisionChecks += 1;
		switch( shapeType ) {
			case PIVOT:
				switch( sprite.shapeType ) {
					case OVAL:
						return Collision.pivotWithOval( this, sprite );
					case RECTANGLE:
						return Collision.pivotWithRectangle( this, sprite );
					case PIVOT:
					case RAY:
					case RASTER:
						break;
					default:
						return Collision.pivotWithTriangle( this, sprite );
				}
			case OVAL:
				switch( sprite.shapeType ) {
					case PIVOT:
						return Collision.pivotWithOval( sprite, this );
					case OVAL:
						return Collision.ovalWithOval( this, sprite );
					case RECTANGLE:
						return Collision.ovalWithRectangle( this, sprite );
					case RAY:
						return Collision.ovalWithRay( this, sprite );
					case RASTER:
						break;
					default:
						return Collision.ovalWithTriangle( this, sprite );
				}
			case RECTANGLE:
				switch( sprite.shapeType ) {
					case PIVOT:
						return Collision.pivotWithRectangle( sprite, this );
					case OVAL:
						return Collision.ovalWithRectangle( sprite, this );
					case RECTANGLE:
						return Collision.rectangleWithRectangle( this, sprite );
					case RAY:
						return Collision.rectangleWithRay( this, sprite );
					default:
						return Collision.rectangleWithTriangle( this, sprite );
				}
			case RAY:
				switch( sprite.shapeType ) {
					case PIVOT:
						break;
					case OVAL:
						return Collision.ovalWithRay( sprite, this );
					case RECTANGLE:
						return Collision.rectangleWithRay( sprite, this );
					case RAY:
						return Collision.rayWithRay( this, sprite );
					default:
						return Collision.triangleWithRay( sprite, this );
				}
			case RASTER:
				if( sprite.shapeType == ShapeType.RASTER ) return Collision.rasterWithRaster( this, sprite );
			default:
				switch( sprite.shapeType ) {
					case PIVOT:
						return Collision.pivotWithTriangle( sprite, this );
					case OVAL:
						return Collision.ovalWithTriangle( sprite, this );
					case RECTANGLE:
						return Collision.rectangleWithTriangle( sprite, this );
					case RAY:
						return Collision.triangleWithRay( this, sprite );
					case RASTER:
						break;
					default:
						return Collision.triangleWithTriangle( this, sprite );
				}
		}
		return false;
	}


	/**
	 * Checks if the sprite collides with given line.
	 * @return True if the sprite collides with given line, otherwise false.
	 * Only collision of line and Oval is yet implemented.
	 */
	public boolean collidesWithLineSegment( LineSegment lineSegment ) {
		if( Sys.debug ) Project.collisionChecks += 1;
		switch( shapeType ) {
			case PIVOT:
			case RASTER:
				break;
			case OVAL:
				return Collision.ovalWithLineSegment( this, lineSegment.pivot[ 0 ], lineSegment.pivot[ 1 ] );
			case RECTANGLE:
				return Collision.rectangleWithLineSegment( this, lineSegment.pivot[ 0 ], lineSegment.pivot[ 1 ] );
			case RAY:
				return Collision.rayWithLineSegment( this, lineSegment.pivot[ 0 ], lineSegment.pivot[ 1 ] );
			default:
				return Collision.triangleWithLineSegment( this, lineSegment.pivot[ 0 ], lineSegment.pivot[ 1 ] );
		}
		return false;
	}


	public boolean tileSpriteCollidesWithSprite( Sprite sprite, double dX, double dY, double xScale, double yScale ) {
		if( Sys.debug ) Project.collisionChecks += 1;
		switch( shapeType ) {
			case PIVOT:
				servicePivot.x = x * xScale + dX;
				servicePivot.y = y * yScale + dY;
				switch( sprite.shapeType ) {
					case PIVOT:
					case RASTER:
					case RAY:
						break;
					case OVAL:
						return Collision.pivotWithOval( servicePivot, sprite );
					case RECTANGLE:
						return Collision.pivotWithRectangle( servicePivot, sprite );
					default:
						return Collision.pivotWithTriangle( servicePivot, sprite );
				}
			case OVAL:
				serviceOval.x = x * xScale + dX;
				serviceOval.y = y * yScale + dY;
				serviceOval.width = width * xScale;
				serviceOval.height = height * yScale;
				switch( sprite.shapeType ) {
					case PIVOT:
						return Collision.pivotWithOval( sprite, serviceOval );
					case OVAL:
						return Collision.ovalWithOval( serviceOval, sprite );
					case RECTANGLE:
						return Collision.ovalWithRectangle( serviceOval, sprite );
					case RAY:
						return Collision.ovalWithRay( serviceOval, sprite );
					case RASTER:
						break;
					default:
						return Collision.ovalWithTriangle( serviceOval, sprite );
				}
			case RECTANGLE:
				serviceRectangle.x = x * xScale + dX;
				serviceRectangle.y = y * yScale + dY;
				serviceRectangle.width = width * xScale;
				serviceRectangle.height = height * yScale;
				switch( sprite.shapeType ) {
					case PIVOT:
						return Collision.pivotWithRectangle( sprite, serviceRectangle );
					case OVAL:
						return Collision.ovalWithRectangle( sprite, serviceRectangle );
					case RECTANGLE:
						return Collision.rectangleWithRectangle( serviceRectangle, sprite );
					case RAY:
						return Collision.rectangleWithRay( serviceRectangle, sprite );
					case RASTER:
						break;
					default:
						return Collision.rectangleWithTriangle( serviceRectangle, sprite );
				}
			case RAY:
				break;
			case RASTER:
				if( sprite.shapeType == ShapeType.RASTER ) return Collision.rasterWithRaster( this, sprite );
			default:
				serviceTriangle.x = x * xScale + dX;
				serviceTriangle.y = y * yScale + dY;
				serviceTriangle.width = width * xScale;
				serviceTriangle.height = height * yScale;
				serviceTriangle.shapeType = shapeType;
				switch( sprite.shapeType ) {
					case PIVOT:
						return Collision.pivotWithTriangle( sprite, serviceTriangle );
					case OVAL:
						return Collision.ovalWithTriangle( sprite, serviceTriangle );
					case RECTANGLE:
						return Collision.rectangleWithTriangle( sprite, serviceTriangle );
					case RAY:
						return Collision.triangleWithRay( serviceTriangle, sprite );
					case RASTER:
						break;
					default:
						return Collision.triangleWithTriangle( serviceTriangle, sprite );
				}
		}
		return false;
	}


	/**
	 * Checks if the sprite overlaps given sprite.
	 * @return True if the sprite overlaps given sprite, otherwise false.
	 * Pivot overlapping is not supported.
	 */
	public boolean overlaps( Sprite sprite ) {
		if( Sys.debug ) Project.collisionChecks += 1;
		switch( shapeType ) {
			case OVAL:
				if( width != height ) error( "Only circle supports overlapping." );
				switch( sprite.shapeType ) {
					case PIVOT:
						return Overlap.circleAndPivot( this, sprite );
					case OVAL:
						return Overlap.circleAndOval( this, sprite );
					case RECTANGLE:
						return Overlap.circleAndRectangle( this, sprite );
					case RAY:
					case RASTER:
						break;
					default:
						return Overlap.circleAndTriangle( this, sprite );
				}
			case RECTANGLE:
				switch( sprite.shapeType ) {
					case PIVOT:
						return Overlap.rectangleAndPivot( this, sprite );
					case RAY:
					case RASTER:
						break;
					default:
						return Overlap.rectangleAndRectangle( this, sprite );
				}
			default:
				error( "Only Circle And Rectangle shapes supports overlapping." );
		}
		return false;
	}


	/**
	 * Searches the layer for first sprite which collides with given.
	 * @return First found sprite which collides with given.
	 * Included layers will be also checked.
	 * 
	 * @see #clone example
	 */	
	public Sprite firstCollidedSpriteOfLayer( Layer layer ) {
		for( Shape shape: layer.children ) {
			if( shape != this ) {
				Sprite collided = shape.layerFirstSpriteCollision( this );
				if( collided != null ) return collided;
			}
		}
		return null;
	}


	@Override
	public Sprite layerFirstSpriteCollision( Sprite sprite ) {
		if( collidesWithSprite( sprite ) ) return this; else return null;
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
		for( Shape shape: layer.children ) {
			if( shape != this ) shape.spriteLayerCollisions( this, handler );
		}
	}


	@Override
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


	public static final double smallNum = 0.00000000001;
	
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
		TileSet tileset = tileMap.tileSet;

		switch( shapeType ) {
			case PIVOT:
				int tileX = Service.floor( ( x - x0 ) / cellWidth );
				int tileY = Service.floor( ( y - y0 ) / cellHeight );

				if( tileX >= 0 && tileY >= 0 && tileX < xQuantity && tileY < yQuantity ) {
					Shape shape = tileset.collisionShape[ tileMap.value[ tileY ][ tileX ] ];
					if( shape != null  ) shape.tileShapeCollisionsWithSprite( this, x0 + cellWidth * tileX, y0 + cellHeight * tileY, cellWidth, cellHeight, 
							tileMap, tileX, tileY, handler );
				}
				break;
			case RAY:
				break;
			default:
				int x1 = Service.floor( ( x - 0.5d * width - x0 ) / cellWidth );
				int y1 = Service.floor( ( y - 0.5d * height - y0 ) / cellHeight );
				int x2 = Service.floor( ( x + 0.5d * width - x0 - smallNum ) / cellWidth );
				int y2 = Service.floor( ( y + 0.5d * height - y0 - smallNum ) / cellHeight );

				if( x2 >= 0 && y2 >= 0 && x1 < xQuantity && y1 < yQuantity ) {
					x1 = Service.limit( x1, 0, xQuantity - 1 );
					y1 = Service.limit( y1, 0, yQuantity - 1 );
					x2 = Service.limit( x2, 0, xQuantity - 1 );
					y2 = Service.limit( y2, 0, yQuantity - 1 );

					for( tileY = y1; tileY <= y2; tileY++ ) {
						for( tileX = x1; tileX <= x2; tileX++ ) {
							Shape shape = tileset.collisionShape[ tileMap.value[ tileY ][ tileX ] ];
							if( shape != null ) shape.tileShapeCollisionsWithSprite( this, x0 + cellWidth * tileX, y0 + cellHeight * tileY, cellWidth, cellHeight,
									tileMap, tileX, tileY, handler );
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
	public void collisionsWithSpriteMap( SpriteMap spriteMap, SpriteCollisionHandler handler, HashSet<Sprite> set ) {
		if( set == null ) set = new HashSet<Sprite>();
		switch( shapeType ) {
			case PIVOT:
				for( Sprite mapSprite: spriteMap.lists[ Service.floor( y / spriteMap.cellHeight ) & spriteMap.yMask ][ Service.floor( x / spriteMap.cellWidth ) & spriteMap.xMask ] ) {
					if( this == mapSprite ) continue;
					if( collidesWithSprite( mapSprite ) ) {
						if( !set.contains( mapSprite ) ) {
							set.add( mapSprite );
							handler.handleCollision( this, mapSprite );
						}
					}
				}
			case RAY:
				break;
			default:
				int mapX1 = Service.floor( ( x - 0.5d * width ) / spriteMap.cellWidth );
				int mapY1 = Service.floor( ( y - 0.5d * height ) / spriteMap.cellHeight );
				int mapX2 = Service.floor( ( x + 0.5d * width - smallNum ) / spriteMap.cellWidth );
				int mapY2 = Service.floor( ( y + 0.5d * height - smallNum ) / spriteMap.cellHeight );

				for( int cellY=mapY1; cellY <= mapY2; cellY++ ) {
					for( int cellX=mapX1; cellX <= mapX2; cellX++ ) {
						for( Sprite mapSprite: spriteMap.lists[ cellY & spriteMap.yMask ][ cellX & spriteMap.xMask ] ) {
							if( this == mapSprite ) continue;
							if( collidesWithSprite( mapSprite ) ) {
								if( ! set.contains( mapSprite ) ) {
									set.add( mapSprite );
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
	public void wedgeOffWithSprite( Sprite sprite, double selfMovingResistance, double spriteMovingResistance ) {
		boolean swap = false;
		switch( shapeType ) {
			case PIVOT:
				switch( sprite.shapeType ) {
					case PIVOT:
						return;
					case OVAL:
						Wedge.pivotAndOval( this, sprite, serviceVector );
						break;
					case RECTANGLE:
						Wedge.pivotAndRectangle( this, sprite, serviceVector );
						break;
					case RAY:
					case RASTER:
						break;
					default:
						Wedge.pivotAndTriangle( this, sprite, serviceVector );
						break;
				}
			case OVAL:
				switch( sprite.shapeType ) {
					case PIVOT:
						Wedge.pivotAndOval( sprite, this, serviceVector );
						swap = true;
						break;
					case OVAL:
						Wedge.ovalAndOval( this, sprite, serviceVector );
						break;
					case RECTANGLE:
						Wedge.ovalAndRectangle( this, sprite, serviceVector );
						break;
					case RAY:
					case RASTER:
						break;
					default:
						Wedge.ovalAndTriangle( this, sprite, serviceVector );
				}
			case RECTANGLE:
				switch( sprite.shapeType ) {
					case PIVOT:
						Wedge.pivotAndRectangle( sprite, this, serviceVector );
						swap = true;
						break;
					case OVAL:
						Wedge.ovalAndRectangle( sprite, this, serviceVector );
						swap = true;
						break;
					case RECTANGLE:
						Wedge.rectangleAndRectangle( this, sprite, serviceVector );
						break;
					case RAY:
					case RASTER:
						break;
					default:
						Wedge.rectangleAndTriangle( this, sprite, serviceVector );
						break;
				}
			case RAY:
			case RASTER:
				break;
			default:
				swap = true;
				switch( sprite.shapeType ) {
					case PIVOT:
						Wedge.pivotAndTriangle( sprite, this, serviceVector );
						break;
					case OVAL:
						Wedge.ovalAndTriangle( sprite, this, serviceVector );
						break;
					case RECTANGLE:
						Wedge.rectangleAndTriangle( sprite, this, serviceVector );
						break;
					case RAY:
					case RASTER:
						break;
					default:
						Wedge.triangleAndTriangle( sprite, this, serviceVector );
						break;
				}
		}
		if( swap ) {
			Wedge.separate( sprite, this, serviceVector, spriteMovingResistance, selfMovingResistance );
		} else {
			Wedge.separate( this, sprite, serviceVector, selfMovingResistance, spriteMovingResistance );
		}
	}
	
	public void wedgeOffWithSprite( Sprite sprite ) {
		wedgeOffWithSprite( sprite, 0.5d, 0.5d );
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
		double xx = tileMap.leftX() + cellWidth * tileX;
		double yy = tileMap.topY() + cellHeight * tileY;
		Shape shape = tileMap.getTileCollisionShape( tileX, tileY );
		Sprite sprite = shape.toSprite();
		if( sprite != null ) {
			pushFromTileSprite( sprite, xx, yy, cellWidth, cellHeight );
		} else {
			for( Shape childShape : shape.toLayer().children ) {
				sprite = childShape.toSprite();
				if( sprite.tileSpriteCollidesWithSprite( this, xx, yy, cellWidth, cellHeight ) ) {
					pushFromTileSprite( sprite, tileMap.leftX() + cellWidth * tileX, tileMap.topY() + cellHeight * tileY, cellWidth, cellHeight );
				}
			}
		}
	}


	public void pushFromTileSprite( Sprite tileSprite, double dX, double dY, double xScale, double yScale ) {
		switch( tileSprite.shapeType ) {
			case PIVOT:
				serviceOval.x = tileSprite.x * xScale + dX;
				serviceOval.y = tileSprite.y * yScale + dY;
				switch( shapeType ) {
					case PIVOT:
						return;
					case OVAL:
						Wedge.ovalAndOval( this, serviceOval, serviceVector );
					case RECTANGLE:
						Wedge.rectangleAndRectangle( this, serviceOval, serviceVector );
				}
			case OVAL:
				serviceOval.x = tileSprite.x * xScale + dX;
				serviceOval.y = tileSprite.y * yScale + dY;
				serviceOval.width = tileSprite.width * xScale;
				serviceOval.height = tileSprite.height * yScale;
				switch( shapeType ) {
					case PIVOT:
						serviceOval.x = x;
						serviceOval.y = y;
						Wedge.ovalAndOval( serviceOval, serviceOval, serviceVector );
					case OVAL:
						Wedge.ovalAndOval( this, serviceOval, serviceVector );
					case RECTANGLE:
						Wedge.ovalAndRectangle( serviceOval, this, serviceVector );
						Wedge.separate( serviceOval, this, serviceVector, 1.0, 0.0 );
						return;
				}
			case RECTANGLE:
				serviceRectangle.x = tileSprite.x * xScale + dX;
				serviceRectangle.y = tileSprite.y * yScale + dY;
				serviceRectangle.width = tileSprite.width * xScale;
				serviceRectangle.height = tileSprite.height * yScale;
				switch( shapeType ) {
					case PIVOT:
						serviceOval.x = x;
						serviceOval.y = y;
						Wedge.rectangleAndRectangle( serviceOval, serviceRectangle, serviceVector );
					case OVAL:
						Wedge.ovalAndRectangle( this, serviceRectangle, serviceVector );
					case RECTANGLE:
						Wedge.rectangleAndRectangle( this, serviceRectangle, serviceVector );
				}
		}
		Wedge.separate( this, tileSprite, serviceVector, 0.0, 1.0 );
	}


	/**
	 * Forces sprite to bounce off the inner bounds of the shape.
	 * @see #active example
	 */
	public Sprite bounceInside( Sprite sprite, boolean leftSide, boolean topSide, boolean rightSide, boolean bottomSide, SpriteCollisionHandler handler ) {
		if( leftSide ) {
			if( leftX() < sprite.leftX() ) {
				x = sprite.leftX() + 0.5 * width;
				angle = 180 - angle;
				if( handler != null ) handler.handleCollision( this, sprite );
			}
		}
		if( topSide ) {
			if( topY() < sprite.topY() ) {
				y = sprite.topY() + 0.5 * height;
				angle = -angle;
				if( handler != null ) handler.handleCollision( this, sprite );
			}
		}
		if( rightSide ) {
			if( rightX() > sprite.rightX() ) {
				x = sprite.rightX() - 0.5 * width;
				angle = 180 - angle;
				if( handler != null ) handler.handleCollision( this, sprite );
			}
		}
		if( bottomSide ) {
			if( bottomY() > sprite.bottomY() ) {
				y = sprite.bottomY() - 0.5 * height;
				angle = -angle;
				if( handler != null ) handler.handleCollision( this, sprite );
			}
		}
		return this;
	}
	
	public Sprite bounceInside( Sprite sprite, SpriteCollisionHandler handler ) {
		bounceInside( sprite, true, true, true, true, handler );
		return this;
	}
	
	public Sprite bounceInside( Sprite sprite ) {
		bounceInside( sprite, true, true, true, true, null );
		return this;
	}

	// ==================== Position and size ====================

	@Override
	public Shape setCoords( double newX, double newY ) {
		if( spriteMap != null ) spriteMap.removeSprite( this, false );

		x = newX;
		y = newY;

		update();
		if( spriteMap != null ) spriteMap.insertSprite( this, false );
		return this;
	}


	@Override
	public Shape setCoordsAndSize( double x1, double y1, double x2, double y2 ) {
		if( spriteMap != null ) spriteMap.removeSprite( this, false );

		x = 0.5d * ( x1 + x2 );
		y = 0.5d * ( y1 + y2 );
		width = x2 - x1;
		height = y2 - y1;

		update();
		if( spriteMap != null ) spriteMap.insertSprite( this, false );
		return this;
	}


	/**
	 * Moves sprite forward.
	 * @see #move, #moveBackward, #turn example
	 */
	public Sprite moveForward() {
		setCoords( x + Math.cos( angle ) * velocity * Project.deltaTime, y + Math.sin( angle ) * velocity * Project.deltaTime );
		return this;
	}


	/**
	 * Moves sprite backward.
	 * @see #move, #moveForward, #turn example
	 */
	public Sprite moveBackward() {
		setCoords( x - Math.cos( angle ) * velocity * Project.deltaTime, y - Math.sin( angle ) * velocity * Project.deltaTime );
		return this;
	}


	@Override
	public Shape setSize( double newWidth, double newHeight ) {
		if( spriteMap != null ) spriteMap.removeSprite( this, false );

		width = newWidth;
		height = newHeight;

		update();
		if( spriteMap != null ) spriteMap.insertSprite( this, false );
		return this;
	}



	/**
	 * Sets the sprite as a tile.
	 * Position, size, visualizer and frame will be changed. This method can be used to cover other shapes with the tile or voluntary moving the tile.
	 * 
	 * @see #getTileForPoint example
	 */
	public Sprite setAsTile( TileMap tileMap, int tileX, int tileY ) {
		width = tileMap.getTileWidth();
		height = tileMap.getTileHeight();
		x = tileMap.leftX() + width * ( 0.5 + tileX );
		y = tileMap.topY() + height * ( 0.5 + tileY );
		visualizer = tileMap.visualizer.clone();
		visualizer.image = tileMap.tileSet.image;
		frame = tileMap.getTile( tileX, tileY );
		return this;
	}

	// ==================== Limiting ====================

	@Override
	public Shape limitLeftWith( Shape rectangle, SpriteCollisionHandler handler ) {
		double rectLeftX = rectangle.leftX();
		if( leftX() < rectLeftX ) {
			setX( rectLeftX + 0.5 * width );
			if( handler != null ) handler.handleCollision( this, null );
		}
		return this;
	}



	@Override
	public Shape limitTopWith( Shape rectangle, SpriteCollisionHandler handler ) {
		double rectTopY = rectangle.topY();
		if( topY() < rectTopY ) {
			setY( rectTopY + 0.5 * height );
			if( handler != null ) handler.handleCollision( this, null );
		}
		return this;
	}



	@Override
	public Shape limitRightWith( Shape rectangle, SpriteCollisionHandler handler ) {
		double rectRightX = rectangle.rightX();
		if( rightX() > rectRightX ) {
			setX( rectRightX - 0.5 * width );
			if( handler != null ) handler.handleCollision( this, null );
		}
		return this;
	}



	@Override
	public Shape limitBottomWith( Shape rectangle, SpriteCollisionHandler handler ) {
		double rectBottomY = rectangle.bottomY();
		if( bottomY() > rectBottomY ) {
			setY( rectBottomY - 0.5 * height );
			if( handler != null ) handler.handleCollision( this, null );
		}
		return this;
	}

	// ==================== Angle ====================

	/**
	 * Directs sprite as given angular sprite. 
	 * @see #directTo
	 */
	public Sprite directAs( Sprite sprite ) {
		angle = sprite.angle;
		return this;
	}



	/**
	 * Turns the sprite.
	 * Turns the sprite with given speed per second.
	 */
	public Sprite turn( double turningSpeed ) {
		angle += Project.deltaTime * turningSpeed;
		return this;
	}



	/**
	 * Direct the sprite to center of the given shape.
	 * @see #directAs
	 */
	public Sprite directTo( Shape shape ) {
		angle = Math.atan2( shape.getY() - y, shape.getX() - x );
		return this;
	}



	public Sprite reverseDirection() {
		angle = angle + 180;
		return this;
	}



	/**
	 * Alters angle by given value.
	 * @see #clone example
	 */
	public Sprite alterAngle( double dAngle ) {
		angle += dAngle;
		return this;
	}

	// ==================== Animation ====================

	/**
	 * Animates the sprite.
	 */
	public Sprite animate( double speed, int framesQuantity, int frameStart, double startingTime, boolean pingPong ) {
		if( framesQuantity == 0 ) framesQuantity = visualizer.getImage().framesQuantity();
		int modFactor = framesQuantity;
		if( pingPong ) modFactor = framesQuantity * 2 - 2;
		frame =  ( int ) Math.floor( ( Project.current.time - startingTime ) / speed ) % modFactor;
		if( pingPong && frame >= framesQuantity ) frame = modFactor - frame;
		frame += frameStart;
		return this;
	}

	// ==================== Methods for oval ====================	

	public Sprite toCircle( Sprite pivot1, Sprite circleSprite ) {
		if( width == height ) return this;
		if( circleSprite !=null ) circleSprite = new Sprite( ShapeType.OVAL );
		if( width > height ) {
			circleSprite.x = Service.limit( pivot1.x, x - 0.5 * ( width - height ), x + 0.5 * ( width - height ) );
			circleSprite.y = y;
			circleSprite.width = height;
			circleSprite.height = height;
		} else {
			circleSprite.x = x;
			circleSprite.y = Service.limit( pivot1.y, y - 0.5 * ( height - width ), y + 0.5 * ( height - width ) );
			circleSprite.width = width;
			circleSprite.height = width;
		}
		return circleSprite;
	}



	public Sprite toCircleUsingLine( Line line, Sprite circleSprite ) {
		if( width == height ) return circleSprite;
		if( width > height ) {
			double dWidth = 0.5 * ( width - height );
			double o1 = line.a * ( x - dWidth ) + line.b * y + line.c;
			double o2 = line.a * ( x + dWidth ) + line.b * y + line.c;
			if( Math.signum( o1 ) != Math.signum( o2 ) ) {
				circleSprite.x = -( line.b * y + line.c ) / line.a;
			} else if( Math.abs( o1 ) < Math.abs( o2 ) ) {
				circleSprite.x = x - dWidth;
			} else {
				circleSprite.x = x + dWidth;
			}
			circleSprite.y = y;
		} else {
			double dHeight = 0.5 * ( height - width );
			double o1 = line.a * x + line.b * ( y - dHeight ) + line.c;
			double o2 = line.a * x + line.b * ( y + dHeight ) + line.c;
			if( Math.signum( o1 ) != Math.signum( o2 ) ) {
				circleSprite.y = -( line.a * x + line.c ) / line.b;
			} else if( Math.abs( o1 ) < Math.abs( o2 ) ) {
				circleSprite.y = y - dHeight;
			} else {
				circleSprite.y = y + dHeight;
			}
			circleSprite.x = x;
		}
		return circleSprite;
	}
	
	public Sprite toCircleUsingLine( Line line ) {
		return toCircleUsingLine( line, new Sprite( ShapeType.OVAL ) );
	}

	// ==================== Methods for ray ====================	

	public void toLine( Line line ) {
		line.usePoints( x, y, x + Math.cos( angle ), y + Math.sin( angle ) );
	}
	
	public Line toLine() {
		Line line = new Line();
		toLine( line );
		return line;
	}



	public boolean hasPoint( double x1, double y1 ) {
		double ang = Service.wrap( angle, 360.0 );
		if( ang < 45.0 || ang >= 315.0 ) {
			return x1 >= x;
		} else if( ang < 135.0 ) {
			return y1 >= y;
		} else if( ang < 225.0 ) {
			return x1 <= x;
		} else {
			return y1 <= y;
		}
	}
	

	public boolean hasPivot( Sprite pivot ) {
		return hasPoint( pivot.x, pivot.y );
	}

	// ==================== Methods for triangle ====================	

	public static void getMedium( Sprite pivot1, Sprite pivot2, Sprite medium ) {
		medium.setCoords( 0.5 * ( pivot1.x + pivot2.x ), 0.5 * ( pivot1.y + pivot2.y ) );
	}

	public static Sprite getMedium( Sprite pivot1, Sprite pivot2 ) {
		Sprite medium = new Sprite();
		getMedium( pivot1, pivot2, medium );
		return medium;
	}


	public void getHypotenuse( Line line ) {
		switch( shapeType ) {
			case TOP_LEFT_TRIANGLE:
			case BOTTOM_RIGHT_TRIANGLE:
				line.usePoints( x, y, x - width, y + height );
				break;
			case TOP_RIGHT_TRIANGLE:
			case BOTTOM_LEFT_TRIANGLE:
				line.usePoints( x, y, x + width, y + height );
				break;
		}
	}
	
	public Line getHypotenuse() {
		Line line = new Line();
		getHypotenuse( line );
		return line;
	}



	public void getRightAngleVertex( Sprite vertex ) {
		switch( shapeType ) {
			case TOP_LEFT_TRIANGLE:
			case BOTTOM_LEFT_TRIANGLE:
				vertex.setX( x - 0.5 * width );
				break;
			case BOTTOM_RIGHT_TRIANGLE:
			case TOP_RIGHT_TRIANGLE:
				vertex.setX( x + 0.5 * width );
				break;
		}
		switch( shapeType ) {
			case TOP_LEFT_TRIANGLE:
			case TOP_RIGHT_TRIANGLE:
				vertex.setY( y - 0.5 * height );
				break;
			case BOTTOM_LEFT_TRIANGLE:
			case BOTTOM_RIGHT_TRIANGLE:
				vertex.setY( y + 0.5 * height );
				break;
		}
	}
	
	public Sprite getRightAngleVertex() {
		Sprite vertex = new Sprite();
		getRightAngleVertex( vertex );
		return vertex;
	}



	public void getOtherVertices( Sprite pivot1, Sprite pivot2 ) {
		if( shapeType == ShapeType.TOP_RIGHT_TRIANGLE || shapeType == ShapeType.BOTTOM_LEFT_TRIANGLE ) {
			getPivots( pivot1, null, pivot2, null );
		} else {
			getPivots( null, pivot1, null, pivot2 );
		}
	}

	// ==================== Cloning ===================	

	@Override
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



	@Override
	public void copyTo( Shape shape ) {
		copySpriteTo( shape.toSprite() );
	}
	

	@Override
	public Sprite toSprite() {
		return this;
	}

	// ==================== Other ====================

	public void updateFromAngularModel() {
	}


	@Override
	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		shapeType = xMLObject.manageEnumAttribute( "shape", shapeType );
		angle = xMLObject.manageDoubleAttribute( "angle", angle );
		displayingAngle = xMLObject.manageDoubleAttribute( "disp_angle", displayingAngle );
		velocity = xMLObject.manageDoubleAttribute( "velocity", velocity, 1.0 );
		frame = xMLObject.manageIntAttribute( "frame", frame );
	}
}
