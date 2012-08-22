/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */

package dwlab.layers;

import dwlab.base.Graphics;
import dwlab.base.Project;
import dwlab.maps.TileMap;
import dwlab.shapes.Shape;
import dwlab.sprites.Sprite;
import dwlab.sprites.SpriteAndTileCollisionHandler;
import dwlab.sprites.SpriteCollisionHandler;
import dwlab.visualizers.Visualizer;
import java.util.LinkedList;

/**
 * Layer is the group of sprites which have bounds.
 * See also #directTo example.
 */
public class Layer extends Shape {
	/**
	 * List of shapes.
	 */
	public LinkedList<Shape> children = new LinkedList<Shape>();

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
	public boolean mixContent;


	@Override
	public String getClassTitle() {
		return "Layer";
	}

	// ==================== Drawing ===================	

	@Override
	public void draw() {
		drawUsingVisualizer( visualizer );
	}


	@Override
	public void drawUsingVisualizer( Visualizer vis ) {
		if( ! visible ) return;

		if( mixContent ) {
			LinkedList shapes = new LinkedList();
			TileMap mainTileMap = null;
			for( Shape shape: children ) {
				TileMap tileMap = shape.toTileMap();
				if( tileMap != null ) {
					if( tileMap.tileSet.image != null ) {
						mainTileMap = tileMap;
						shapes.addLast( shape );
					}
				} else if( shape.toSpriteMap() != null ) {
					shapes.addLast( shape );
				}
			}
			if( mainTileMap != null ) {
				if( shapes.size() == 1 ) shapes = null;
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
	@Override
	public void init() {
		for( Shape obj: children ) {
			obj.init();
		}
	}


	/**
	 * Acting method.
	 * Every child shape will be acted.
	 */
	@Override
	public void act() {
		if( active ) {
			super.act();
			for( Shape obj: children ) {
				if( obj.active ) {
					Project.spriteActed = false;

					obj.act();

					if( obj.toSprite() != null && ! Project.spriteActed ) Project.spritesActed += 1;
				}
			}
		}
	}


	@Override
	public void update() {
		for( Shape obj: children ) {
			obj.update();
		}
	}

	// ==================== Collisions ===================

	@Override
	public Sprite layerFirstSpriteCollision( Sprite sprite ) {
		return sprite.firstCollidedSpriteOfLayer( this );
	}


	@Override
	public void spriteLayerCollisions( Sprite sprite, SpriteCollisionHandler handler ) {
		sprite.collisionsWithLayer( this, handler );
	}


	@Override
	public void tileShapeCollisionsWithSprite( Sprite sprite, double dX, double dY, double xScale, double yScale, TileMap tileMap, int tileX, int tileY, SpriteAndTileCollisionHandler handler ) {
		for( Shape groupShape: children ) {
			Sprite groupSprite = groupShape.toSprite();
			if( groupSprite.tileSpriteCollidesWithSprite( sprite, dX, dY, xScale, yScale ) ) {
				handler.handleCollision( sprite, tileMap, tileX, tileY, groupSprite );
				return;
			}
		}
	}

	// ==================== Other ===================	

	@Override
	public void setCoords( double newX, double newY ) {
		for( Shape shape: children ) shape.alterCoords( newX - x, newY - y );
		setCoords( newX, newY );
		update();
	}


	/**
	 * Sets the bounds of layer to given shape.
	 */
	public void setBounds( Shape shape ) {
		if( bounds == null ) {
			bounds = new Shape();
			bounds.visualizer = null;
		}
		bounds.jumpTo( shape );
		bounds.setSizeAs( shape );
	}


	/**
	 * Counts quantity of sprites inside the layer.
	 * @return Quantity of sprites inside layer and included layers.
	 * 
	 */
	@Override
	public int countSprites() {
		int count = 0;
		for( Shape shape: children ) {
			count += shape.countSprites();
		}
		return count;
	}


	/**
	 * Shows all behavior models attached to shape with their status.
	 */
	public int showModels( int y, String shift ) {
		if( behaviorModels.isEmpty() ) {
			if( children.isEmpty() ) return y;
			Graphics.drawText( shift + getTitle() + " ", 0, y );
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

	public void addFirst( Shape shape ) {
		children.addFirst( shape );
	}




	public void addLast( Shape shape ) {
		children.addLast( shape );
	}



	public void clear() {
		children.clear();
	}



	public Shape get( int index ) {
		return children.get( index );
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
