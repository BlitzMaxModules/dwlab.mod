package dwlab.layers;
import java.util.LinkedList;
import dwlab.base.XMLObject;
import dwlab.sprites.SpriteAndTileCollisionHandler;
import dwlab.shapes.Shape;
import dwlab.maps.SpriteMap;
import dwlab.sprites.SpriteCollisionHandler;
import dwlab.maps.TileMap;
import dwlab.visualizers.Visualizer;
import dwlab.sprites.Sprite;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php\r\n */




/**
 * Layer is the group of sprites which have bounds.
 * See also #directTo example.
 */
public class Layer extends Shape {
	/**
	 * List of shapes.
	 */
	public LinkedList children = new LinkedList();

	/**
	 * Rectangular shape of layer bounds.
	 */
	public Shape bounds;

	/**
	 * Flag which defines if layer content should be mixed while displaying.
	 * Some conditions should be met to display mixed content correctly:
	 * <ul><li>Mixed content layer should contain at least one tile map.
	 * <li>All maps in layer should have equal tile/cell size.
	 * <li>All tile maps in layer should have equal corner coordinates like ( N * CellWidth, M * CellHeight ) where N and M is integer.
	 * <li>All tile maps in layer should have equal horizontal and vertical size in tiles.</ul>
	 * If this layer contains sprites or other layers they will not be drawn.
	 */
	public int mixContent;



	public String getClassTitle() {
		return "Layer";
	}

	// ==================== Drawing ===================	

	public void draw() {
		drawUsingVisualizer( visualizer );
	}



	public void drawUsingVisualizer( Visualizer vis ) {
		if( ! visible ) return;

		if( mixContent ) {
			LinkedList shapes = new LinkedList();
			TileMap mainTileMap;
			for( Shape shape: children ) {
				TileMap tileMap = TileMap( shape );
				if( tileMap ) {
					if( tileMap.tileSet.image ) {
						mainTileMap = TileMap( shape );
						shapes.addLast( shape );
					}
				} else if( SpriteMap( shape ) then ) {
					shapes.addLast( shape );
				}
			}
			if( mainTileMap ) {
				if( shapes.count() = 1 ) shapes == null;
				vis.drawUsingTileMap( mainTileMap, shapes );
				return;
			}
		}

		if( vis == visualizer ) {
			for( Shape shape: children ) {
				shape.draw();
			}
		} else {
			for( Shape shape: children ) {
				shape.drawUsingVisualizer( vis );
			}
		}
	}

	// ==================== Managing ===================

	/**
	 * Initialization method.
	 * Every child shape will be initialized by default.
	 */
	public void init() {
		for( Shape obj: children ) {
			obj.init();
		}
	}



	/**
	 * Acting method.
	 * Every child shape will be acted.
	 */
	public void act() {
		if( active ) {
			super.act();
			for( Shape obj: children ) {
				if( obj.active ) {
					spriteActed = false;

					obj.act();

					if( Sprite( obj ) && ! spriteActed ) spritesActed += 1;
				}
			}
		}
	}



	public void update() {
		for( Shape obj: children ) {
			obj.update();
		}
	}

	// ==================== Collisions ===================

	public Sprite layerFirstSpriteCollision( Sprite sprite ) {
		return sprite.firstCollidedSpriteOfLayer( this );
	}



	public void spriteLayerCollisions( Sprite sprite, SpriteCollisionHandler handler ) {
		sprite.collisionsWithLayer( this, handler );
	}



	public void tileShapeCollisionsWithSprite( Sprite sprite, double dX, double dY, double xScale, double yScale, TileMap tileMap, int tileX, int tileY, SpriteAndTileCollisionHandler handler ) {
		for( Sprite groupSprite: children ) {
			if( groupSprite.tileSpriteCollidesWithSprite( sprite, dX, dY, xScale, yScale ) ) {
				handler.handleCollision( sprite, tileMap, tileX, tileY, groupSprite );
				return;
			}
		}
	}

	// ==================== Other ===================	

	public void setCoords( double newX, double newY ) {
		for( Shape shape: children ) {
			shape.setCoords( shape.x + newX - x, shape.y + newY - y );
		}
		x = newX;
		y = newY;
		update();
	}



	/**
	 * Sets the bounds of layer to given shape.
	 */
	public void setBounds( Shape shape ) {
		if( ! bounds ) {
			bounds = new Shape();
			bounds.visualizer = null;
		}
		bounds.x = shape.x;
		bounds.y = shape.y;
		bounds.width = shape.width;
		bounds.height = shape.height;
	}



	/**
	 * Counts quantity of sprites inside the layer.
	 * @return Quantity of sprites inside layer and included layers.
	 * 
	 */
	public int countSprites() {
		int count = 0;
		for( Shape shape: children ) {
			if( Sprite( shape ) ) {
				count += 1;
			} else if( Layer( shape ) then ) {
				count += Layer( shape ).countSprites();
			}
		}
		return count;
	}



	/**
	 * Shows all behavior models attached to shape with their status.
	 */
	public int showModels( int y = 0, String shift = "" ) {
		if( behaviorModels.isEmpty() ) {
			if( children.isEmpty() ) return y;
			drawText( shift + getTitle() + " ", 0, y );
	    	y += 16;
		} else {
			y = super.showModels( y, shift );
		}
		for( Shape shape: children ) {
			y = shape.showModels( y, shift + " " );
		}
		return y;
	}

	// ==================== List wrapping methods ====================

	public tLink addFirst( Shape shape ) {
		return children.addFirst( shape );
	}




	public tLink addLast( Shape shape ) {
		return children.addLast( shape );
	}



	public void clear() {
		children.clear();
	}



	public Shape get( int index ) {
		return Shape( children.get( index ) );
	}



	public tListEnum objectEnumerator() {
		return children.objectEnumerator();
	}

	// ==================== Shape management ====================

	public Shape load() {
		Layer newLayer = Layer( loadShape() );
		for( Shape shape: children ) {
			newLayer.addLast( shape.load() );
		}
		return newLayer;
	}



	public Shape findShapeWithParameterID( String parameterName, String parameterValue, tTypeID shapeTypeID, int ignoreError = false ) {
		for( Shape childShape: children ) {
			if( ! shapeTypeID || tTypeId.forObject( childShape ) == shapeTypeID ) {
				if( ! parameterName || childShape.getParameter( parameterName ) == parameterValue ) return childShape;
			}

			Shape shape = childShape.findShapeWithParameterID( parameterName, parameterValue, shapeTypeID, true );
			if( shape ) return shape;
		}

		super.findShapeWithParameterID( parameterName, parameterValue, shapeTypeID, ignoreError );
	}



	public int insertBeforeShape( Shape shape = null, LinkedList shapesList = null, Shape beforeShape ) {
		tLink link = children.firstLink();
		while( link != null ) {
			Object value = link.value();
			if( value == beforeShape ) {
				if( shape ) children.insertBeforeLink( shape, link );
				if( shapesList ) {
					for( Sprite listShape: shapesList ) {
						children.insertBeforeLink( listShape, link );
					}
				}
				return true;
			} else {
				if( Shape( value ).insertBeforeShape( shape, shapesList, beforeShape ) ) return true;
			}
			link = link.nextLink();
		}
	}



	public void remove( Shape shape ) {
		tLink link = children.firstLink();
		while( link != null ) {
			Object value = link.value();
			if( value == shape ) {
				link.remove();
			} else {
				Shape( value ).remove( shape );
			}
			link = link.nextLink();
		}
	}



	public void removeAllOfTypeID( tTypeID typeID ) {
		tLink link = children.firstLink();
		while( link != null ) {
			Object value = link.value();
			if( tTypeId.forObject( value ) == typeID ) {
				link.remove();
			} else {
				Shape( value ).removeAllOfTypeID( typeID );
			}
			link = link.nextLink();
		}
	}

	// ==================== Cloning ===================	

	public Shape clone() {
		Layer newLayer = new Layer();
		copyLayerTo( newLayer );
		for( Shape shape: children ) {
			newLayer.children.addLast( shape.clone() );
		}
		return newLayer;
	}



	public void copyLayerTo( Layer layer ) {
		copyShapeTo( layer );

		if( bounds ) {
			layer.bounds = new Shape();
			bounds.copyTo( layer.bounds );
		}
		layer.mixContent = mixContent;
	}



	public void copyTo( Shape shape ) {
		Layer layer = Layer( shape );

		if( ! layer ) error( "Trying to copy layer \"" + shape.getName() + "\" data to non-layer" );

		copyLayerTo( layer );
	}

	// ==================== Saving / loading ===================

	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		xMLObject.manageChildList( children );
		bounds = Shape( xMLObject.manageObjectField( "bounds", bounds ) );
		xMLObject.manageIntAttribute( "mix-content", mixContent );
	}
}
