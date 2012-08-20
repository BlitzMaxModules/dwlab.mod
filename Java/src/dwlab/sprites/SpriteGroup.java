package dwlab.sprites;
import java.util.LinkedList;
import dwlab.base.XMLObject;
import java.lang.Math;
import dwlab.shapes.Shape;
import dwlab.visualizers.Visualizer;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php


/**
 * Group of sprites.
 * It has a lot of methods duplicating methods of TList.
 */
public class SpriteGroup extends Sprite {
	public Sprite spriteShape = new Sprite();

	/**
	 * List of sprites.
	 */
	public LinkedList children = new LinkedList();



	public String getClassTitle() {
		return "Sprite group";
	}



	public Object getChildrenEnumerator() {
		return children;
	}



	public void insertSprite( Sprite sprite ) {
		sprite.x = ( sprite.x - x ) / width;
		sprite.y = ( sprite.y - y ) / height;
		sprite.width /= width;
		sprite.height /= height;
		children.addLast( sprite );
	}



	public void removeSprite( Sprite sprite ) {
		tLink link = children.findLink( sprite );

		if( ! link ) error( "Removing sprite is not found in the group" );

		sprite.x = sprite.x * width + x;
		sprite.y = sprite.y * height + y;
		sprite.width *= width;
		sprite.height *= height;

		link.remove();
	}

	// ==================== Drawing ===================

	public void draw() {
		drawGroup( null, this );
	}



	public void drawUsingVisualizer( Visualizer vis ) {
		drawGroup( vis, this );
	}



	public void drawGroup( Visualizer vis, Sprite parentShape ) {
		for( Sprite sprite: children ) {
			setShape( spriteShape, sprite, parentShape );
			SpriteGroup childSpriteGroup = SpriteGroup( sprite );
			if( childSpriteGroup ) {
				Sprite newParentShape = new Sprite();
				setShape( newParentShape, childSpriteGroup, parentShape );
				childSpriteGroup.drawGroup( vis, newParentShape );
			} else if( vis then ) {
				vis.drawUsingSprite( sprite, spriteShape );
			} else {
				sprite.visualizer.drawUsingSprite( sprite, spriteShape );
			}
		}
	}



	public void setShape( Sprite shape, Sprite sprite, Sprite parentShape ) {
		if( angle == 0 ) {
			shape.x = sprite.x * parentShape.width + parentShape.x;
			shape.y = sprite.y * parentShape.height + parentShape.y;
		} else {
			double relativeX = sprite.x * parentShape.width;
			double relativeY = sprite.y * parentShape.height;
			shape.x = relativeX * Math.cos( angle ) - relativeY * Math.sin( angle ) + parentShape.x;
			shape.y = relativeX * Math.sin( angle ) + relativeY * Math.cos( angle ) + parentShape.y;
		}
		shape.width = parentShape.width * sprite.width;
		shape.height = parentShape.height * sprite.height;
		shape.angle = parentShape.angle + sprite.angle;
	}

	// ==================== List wrapping methods ====================

	public tListEnum objectEnumerator() {
		return children.objectEnumerator();
	}



	public tLink addFirst( Shape sprite ) {
		return children.addFirst( sprite );
	}



	public tLink addLast( Sprite sprite ) {
		return children.addLast( sprite );
	}



	public void clear() {
		children.clear();
	}



	public Shape get( int index ) {
		return Sprite( children.get( index ) );
	}

	// ==================== Shape management ====================

	public Shape load() {
		SpriteGroup newSpriteGroup = SpriteGroup( loadShape() );
		for( Sprite sprite: children ) {
			newSpriteGroup.addLast( Sprite( sprite.load() ) );
		}
		return newSpriteGroup;
	}



	public Shape findShapeWithParameterID( String parameterName, String parameterValue, tTypeID shapeTypeID, int ignoreError = false ) {
		for( Shape childShape: children ) {
			if( ! shapeTypeID || tTypeId.forObject( childShape ) == shapeTypeID ) {
				if( ! parameterName || childShape.getParameter( parameterName ) == parameterValue ) return this;
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
				if( Sprite( shape ) ) children.insertBeforeLink( shape, link );
				if( shapesList ) {
					for( Sprite listSprite: shapesList ) {
						children.insertBeforeLink( listSprite, link );
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

	// ==================== Cloning ====================

	public Shape clone() {
		SpriteGroup newSpriteGroup = new SpriteGroup();
		copySpriteTo( newSpriteGroup );
		for( Sprite sprite: children ) {
			newSpriteGroup.children.addLast( sprite.clone() );
		}
		return newSpriteGroup;
	}



	public void copyTo( Shape shape ) {
		SpriteGroup spriteGroup = SpriteGroup( shape );

		if( ! spriteGroup ) error( "Trying to copy sprite group \"" + shape.getTitle() + "\" data to non-sprite-group" );

		copySpriteTo( spriteGroup );
	}

	// ==================== Saving / loading ====================

	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );
		xMLObject.manageChildList( children );
	}
}
