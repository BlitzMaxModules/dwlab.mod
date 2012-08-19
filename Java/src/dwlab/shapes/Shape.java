package dwlab.shapes;
import dwlab.base.Align;
import dwlab.base.DWLabObject;
import dwlab.base.XMLObject;
import dwlab.behavior_models.BehaviorModel;
import dwlab.maps.TileMap;
import dwlab.sprites.Camera;
import dwlab.sprites.Sprite;
import dwlab.sprites.SpriteAndTileCollisionHandler;
import dwlab.sprites.SpriteCollisionHandler;
import dwlab.visualizers.Image;
import dwlab.visualizers.Visualizer;
import dwlab.visualizers.WindowedVisualizer;
import java.util.LinkedList;

//
// Digital Wizard's Lab - game development framework
// Copyright (C) 2012, Matt Merkulov
//
// All rights reserved. Use of this code is allowed under the
// Artistic License 2.0 terms, as specified in the license.txt
// file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php
//

/**
 * Common object for item of game field.
 */
public class Shape extends Vector {
	public LinkedList<Parameter> parameters;


	/**
	 * Shape width in units.
	 * @see #setWidth, #getDiameter, #setDiameter, 
	 */
	public double width = 1.0d;

	/**
	 * Shape height in units.
	 * @see #setHeight, #correctHeight
	 */
	public double height = 1.0d;

	/**
	 * Shape visualizer (object which displays this shape).
	 * @see #lTVisualizer, #lTDebugVisualizer, #l_DebugVisualizer
	 */
	public Visualizer visualizer = new Visualizer();

	/**
	 * Visibility flag.
	 * If False then shape will not be drawn.
	 * 
	 * @see #draw, #drawUsingVisualizer, #active example
	 */
	public boolean visible = true;

	/**
	 * Activity flag.
	 * If False then Act() method for shape will not be executed.
	 * 
	 * @see #act
	 */
	public boolean active = true;

	/**
	 * Behavior models list.
	 * Standard Act() method will apply every behavior model in this list to the shape.
	 * 
	 * @see #lTBehaviorModel
	 */
	public LinkedList<BehaviorModel> behaviorModels = new LinkedList<BehaviorModel>();

	public int collisionLayer;

	// ==================== Drawing ===================

	/**
	 * Prints text inside the shape.
	 * Current ImageFont is used. You can specify horizontal and vertical alignment and also horizontal and vertical shift in units.
	 */
	public void printText( String text, double size = 1.0, int horizontalAlign = Align.TO_CENTER, int verticalAlign = Align.TO_CENTER, double horizontalShift = 0, double verticalShift = 0, int contour = false ) {
		double sXSize, double sYSize;
		Camera.current.sizeFieldToScreen( 0, size, sXSize, sYSize );
		double k = sYSize / textHeight( text );

		double xX, double yY;
		switch( horizontalAlign ) {
			case Align.TO_LEFT:
				xX = leftX();
			case Align.TO_CENTER:
				xX = x;
			case Align.TO_RIGHT:
				xX = rightX();
		}

		switch( verticalAlign ) {
			case Align.TO_TOP:
				yY = topY();
			case Align.TO_CENTER:
				yY = y;
			case Align.TO_BOTTOM:
				yY = bottomY();
		}

		double sX, double sY;
		Camera.current.fieldToScreen( xX + horizontalShift, yY + verticalShift, sX, sY );

		switch( horizontalAlign ) {
			case Align.TO_CENTER:
				sX -= 0.5 * textWidth( text ) * k;
			case Align.TO_RIGHT:
				sX -= textWidth( text ) * k;
		}

		switch( verticalAlign ) {
			case Align.TO_CENTER:
				sY -= 0.5 * textHeight( text ) * k;
			case Align.TO_BOTTOM:
				sY -= textHeight( text ) * k;
		}

		setScale k, k;
		if( contour ) {
			drawTextWithContour( text, sX, sY );
		} else {
			drawText( text, sX, sY );
		}
		setScale 1.0, 1.0;
	}



	/**
	 * Sets shape's rectangle as viewport.
	 */
	public void setAsViewport() {
		double vX, double vY, double vWidth, double vHeight;
		Camera.current.fieldToScreen( leftX(), topY(), vX, vY );
		Camera.current.sizeFieldToScreen( width, height, vWidth, vHeight );
		if( vX < 0 ) {
			vWidth += vX;
			vX = 0;
		}
		if( vY < 0 ) {
			vHeight += vY;
			vY = 0;
		}
		setViewport( vX, vY, vWidth, vHeight );
	}

	// ==================== Collisions ===================

	public Sprite layerFirstSpriteCollision( Sprite sprite ) {
	}



	public void spriteLayerCollisions( Sprite sprite, SpriteCollisionHandler handler ) {
	}



	public void tileShapeCollisionsWithSprite( Sprite sprite, double dX, double dY, double xScale, double yScale, TileMap tileMap, int tileX, int tileY, SpriteAndTileCollisionHandler handler ) {
	}

	// ==================== Position ====================

	/**
	 * Left side of the shape.
	 * @return X coordinate of left shape side in units.
	 * @see RightX#, TopY#, BottomY#, #x, #width
	 */
	public double leftX() {
 		return x - 0.5 * width;
 	}



	/**
	 * Top of the shape.
	 * @return Y coordinate of shape top in units.
	 * @see LeftX#, RightX#, BottomY#, #y, #height
	 */
	public double topY() {
 		return y - 0.5 * height;
 	}



	/**
	 * Right side of the shape.
	 * @return X coordinate of right shape side in units.
	 * @see #leftX, #topY, #bottomY, #x, #width
	 */
	public double rightX() {
 		return x + 0.5 * width;
 	}



	/**
	 * Bottom of the shape
	 * @return Y coordinate of shape bottom in units.
	 * @see LeftX#, RightX#, TopY#, #y, #height
	 */
	public double bottomY() {
 		return y + 0.5 * height;
 	}



	public void setCoordsAndSize( double x1, double y1, double x2, double y2 ) {
		x = 0.double 5 * ( x1 + x2 );
		y = 0.double 5 * ( y1 + y2 );
		width = x2 - x1;
		height = y2 - y1;
		update();
	}



	/**
	 * Sets top-left corner coordinates of the shape.
	 * After this operation top-left corner of the shape will be at given coordinates.
	 * 
	 * @see #setCoords, #alterCoords, #setMouseCoords
	 */
	public void setCornerCoords( double newX, double newY ) {
		setCoords( newX + width * 0.5, newY + height * 0.5 );
	}



	/**
	 * Moves shape to another one.
	 * Center coordinates of the shape will be equated to corresponding center coordinates of given shape.
	 * 
	 * @see #isAtPositionOf, #setCoords
	 */
	public void jumpTo( Shape shape ) {
		setCoords( shape.x , shape.y );
	}



	/**
	 * Moves shape to mouse position.
	 * Mouse coordinates will be transformed to field coordinates using current camera. Then shape coordinates will be equated to these.
	 * 
	 * @see #setCoords, #placeBetween example
	 */
	public void setMouseCoords( Camera camera = null ) {
		if( ! camera ) camera == Camera.current;

		double newX, double newY;
		camera.screenToField( mouseX(), mouseY(), newX, newY );
		setCoords( newX, newY );
	}



	public void setCoordsRelativeTo( Sprite sprite, double newX, double newY ) {
		double spriteAngle = directionToPoint( newX, newY ) + sprite.angle;
		double radius = Math.sqrt( newX * newX + newY * newY );
		setCoords( sprite.x + radius * Math.cos( spriteAngle ), sprite.y + radius * Math.sin( spriteAngle ) );
	}



	/**
	 * Position shape using coordinates in tilemap's coordinate system
	 * Integer TileX and TileY sets shape position to the center of given tilemap's cooresponding tile
	 */
	public void positionOnTileMap( TileMap tileMap, double tileX, double tileY ) {
		x = tileMap.leftX() + ( tileX + 0.5 ) * tileMap.getTileWidth();
		y = tileMap.topY() + ( tileY + 0.5 ) * tileMap.getTileHeight();
	}



	/**
	 * Moves the shape.
	 * The shape will be moved with given horizontal and vertical speed per second.
	 * 
	 * @see #lTButtonAction example
	 */
	public void move( double dX, double dY ) {
		setCoords( x + dX * deltaTime, y + dY * deltaTime );
	}



	/**
	 * Moves the shape with given velocity towards shape.
	 * @see #moveForward, #moveBackward
	 */
	public void moveTowards( Shape shape, double velocity ) {
		moveTowardsPoint( shape.x, shape.y, velocity );
	}



	/**
	 * Moves the shape with given velocity towards shape.
	 * @see #moveForward
	 */
	public void moveTowardsPoint( double destinationX, double destinationY, double velocity ) {
		double angle = directionToPoint( destinationX, destinationY );
		double dX = Math.cos( angle ) * velocity * deltaTime;
		double dY = Math.sin( angle ) * velocity * deltaTime;
		if( Math.abs( dX ) >= Math.abs( x - destinationX ) && Math.abs( dY ) >= Math.abs( y - destinationY ) ) {
			setCoords( destinationX, destinationY );
		} else {
			setCoords( x + dX, y + dY );
		}
	}



	/**
	 * Places the shape between two another shapes.
	 * K parameter is in 0...1 interval.
	 * <ul>
	 * <li> 0 shifts shape to the center of first given shape.
	 * <li> 1 shifts shape to the center of the second given shape.
	 * <li> 0.5 shifts shape to the middle between given shapes centers.
	 * </ul>
	 */
	public void placeBetween( Shape shape1, Shape shape2, double k ) {
		setCoords( shape1.x + ( shape2.x - shape1.x ) * k, shape1.y + ( shape2.y - shape1.y ) * k );
	}



	/**
	 * Allowing moving the shape around with given velocity with WSAD keys.
	 * @see #moveUsingArrows, #moveUsingKeys, #move
	 */
	public void moveUsingWSAD( double velocity ) {
		moveUsingKeys( key_W, key_S, key_A, key_D, velocity );
	}



	/**
	 * Allowing moving the shape around with given velocity with Arrow keys.
	 * @see #moveUsingWSAD, #moveUsingKeys, #move
	 */
	public void moveUsingArrows( double velocity ) {
		moveUsingKeys( key_Up, key_Down, key_Left, key_Right, velocity );
	}



	/**
	 * Allowing moving the shape around with with given keys and velocity.
	 * @see #moveUsingArrows, #moveUsingWSAD, #move
	 */
	public void moveUsingKeys( int kUp, int kDown, int kLeft, int kRight, double velocity ) {
		double dX = keyDown( kRight ) - keyDown( kLeft );
		double dY = keyDown( kDown ) - keyDown( kUp );

		double sDX, double sDY;
		Camera.current.sizeScreenToField( dX, dY, sDX, sDY );

		if( ! sDX && ! sDY ) return;

		double k = velocity / distance( sDX, sDY ) * deltaTime;
		setCoords( x + sDX * k, y + sDY * k );
	}



	/**
	 * Applies parallax effect for shape depending on current camera size and position relative to given shape.
	 */
	public void parallax( Shape shape ) {
		double dX = shape.width - Camera.current.width;
		double dY = shape.height - Camera.current.height;
		setCoords( shape.leftX() + 0.5 * width + ( Camera.current.leftX() - shape.leftX() ) * ( shape.width - width ) / dX,..;
			shape.topY() + 0.5 * height + ( Camera.current.topY() - shape.topY() ) * ( shape.height - height ) / dY );
	}

	// ==================== Limiting ====================

	/**
	 * Limits shape with given rectangular shape.
	 * If the shape is outside given shape, it will be moved inside it. If the shape is larger than given shape, it will be moved to the center of given shape.
	 * 
	 * @see #limitHorizontallyWith, #limitVerticallyWith, #limitLeftWith, #limitRightWith, #limitTopWith, #limitBottomWith
	 */
	public void limitWith( Shape rectangle, int alterVelocity = false ) {
		limitHorizontallyWith( rectangle, alterVelocity );
		limitVerticallyWith( rectangle, alterVelocity );
	}



	/**
	 * Limits left side of the shape with left side of given rectangular shape.
	 * If the left side X coordinate of shape is less than left side X coordinate of given shape, left side of the shape will be equated to left side of given shape.
	 * 
	 * @see #limitWith, #limitHorizontallyWith, #limitVerticallyWith, #limitRightWith, #limitTopWith, #limitBottomWith
	 */
	public void limitLeftWith( Shape rectangle, SpriteCollisionHandler handler = null ) {
		if( leftX() < rectangle.leftX() ) setX( rectangle.leftX() + 0.5 * width );
	}



	/**
	 * Limits top of the shape with top of given rectangular shape.
	 * If the top Y coordinate of shape is less than top Y coordinate of given shape, top of the shape will be equated to the top of given shape.
	 * 
	 * @see #limitWith, #limitHorizontallyWith, #limitVerticallyWith, #limitLeftWith, #limitRightWith, #limitBottomWith
	 */
	public void limitTopWith( Shape rectangle, SpriteCollisionHandler handler = null ) {
		if( topY() < rectangle.topY() ) setY( rectangle.topY() + 0.5 * height );
	}



	/**
	 * Limits right side of the shape with right side of given rectangular shape.
	 * If the right side X coordinate of shape is more than right side X coordinate of given shape, right side of the shape will be equated to right side of given shape.
	 * 
	 * @see #limitWith, #limitHorizontallyWith, #limitVerticallyWith, #limitLeftWith, #limitTopWith, #limitBottomWith
	 */
	public void limitRightWith( Shape rectangle, SpriteCollisionHandler handler = null ) {
		if( rightX() > rectangle.rightX() ) setX( rectangle.rightX() - 0.5 * width );
	}



	/**
	 * Limits bottom of the shape with bottom of given rectangular shape.
	 * If the bottom Y coordinate of shape is more than bottom Y coordinate of given shape, bottom of the shape will be equated to the bottom of given shape.
	 * 
	 * @see #limitWith, #limitHorizontallyWith, #limitVerticallyWith, #limitLeftWith, #limitRightWith, #limitTopWith
	 */
	public void limitBottomWith( Shape rectangle, SpriteCollisionHandler handler = null ) {
		if( bottomY() > rectangle.bottomY() ) setY( rectangle.bottomY() - 0.5 * height );
	}



	/**
	 * Keeps shape within limits of given shape horizontally.
	 * @see #limitWith, #limitVerticallyWith, #limitLeftWith, #limitRightWith, #limitTopWith, #limitBottomWith
	 */
	public void limitHorizontallyWith( Shape rectangle, int alterVelocity = false ) {
		double x1 = Math.min( rectangle.x, rectangle.leftX() + 0.5 * width );
		double x2 = Math.max( rectangle.x, rectangle.rightX() - 0.5 * width );
		setX( limitDouble( x, x1, x2 ) );
	}



	/**
	 * Keeps shape within limits of given shape vertically.
	 * @see #limitWith, #limitHorizontallyWith, #limitLeftWith, #limitRightWith, #limitTopWith, #limitBottomWith
	 */
	public void limitVerticallyWith( Shape rectangle, int alterVelocity = false ) {
		double y1 = Math.min( rectangle.y, rectangle.topY() + 0.5 * height );
		double y2 = Math.max( rectangle.y, rectangle.bottomY() - 0.5 * height );
		setY( limitDouble( y, y1, y2 ) );
	}

	// ==================== Angle ====================

	/**
	 * Direction to the point.
	 * @return Angle between vector from the center of the shape to the point with given coordinates and X axis.
	 * @see #directionTo, #distanceToPoint example
	 */
	public double directionToPoint( double pointX, double pointY ) {
		return Math.atan2( pointY - y, pointX - x );
	}



	/**
	 * Direction to shape.
	 * @return Angle between vector from the center of this shape to center of given shape and X axis.
	 * @see #directionToPoint, #distanceToPoint example
	 */
	public double directionTo( Shape shape ) {
		return Math.atan2( shape.y - y, shape.x - x );
	}

	// ==================== Size ====================

	/**
	 * Sets the width of the shape.
	 * It's better to use this method instead of equating Width field to new value.
	 * 
	 * @see #width, #getDiameter, #setDiameter, #setHeight, #setSize, #alterSize
	 */
	public void setWidth( double newWidth )	 {
		setSize( newWidth, height );
	}



	/**
	 * Sets the height of the shape.
	 * It's better to use this method instead of equating Height field to new value.
	 * 
	 * @see #height, #setWidth, #setSize, #alterSize
	 */
	public void setHeight( double newHeight )	 {
		setSize( width, newHeight );
	}



	/**
	 * Sets the size of the shape.
	 * It's better to use this method instead of equating Width and Height fields to new values.
	 * 
	 * @see #width, #height, #setWidth, #setHeight, #setSizeAs, #alterSize
	 */
	public void setSize( double newWidth, double newHeight ) {
		width = newWidth;
		height = newHeight;
		update();
	}



	/**
	 * Sets the size of the shape as of given shape.
	 * @see #width, #height, #setWidth, #setHeight, #setSize, #alterSize, #directAs example
	 */
	public void setSizeAs( Shape shape ) {
		setSize( shape.width, shape.height );
	}



	/**
	 * Alters the size of the shape.
	 * It's better to use this method instead of equating Width and Height fields to new values.
	 * 
	 * @see #width, #height, #setWidth, #setHeight, #setSize, #setSizeAs, #stretch example
	 */
	public void alterSize( double dWidth, double dHeight ) {
		width *= dWidth;
		height *= dHeight;
		update();
	}



	/**
	 * Returns diameter of circular shape.
	 * @return Width field of the shape.
	 * @see #setDiameter
	 */
	public double getDiameter() {
		return width;
	}



	/**
	 * Sets the diameter of the shape.
	 * @see #getDiameter
	 */
	public void setDiameter( double newDiameter ) {
		setSize( newDiameter, newDiameter );
	}



	/**
	 * Alters both sizes of the shape (pretending they are equal).
	 * It's better to use this method instead of equating Width and Height fields to new values.
	 * 
	 * @see #clone example
	 */
	public void alterDiameter( double d ) {
		width *= d;
		height *= d;
		update();
	}



	/**
	 * Corrects height to display shape image with no distortion.
	 * After this operation ratio of width to height will be the same as ratio of image width to image height.
	 * 
	 * @see #height, #setHeight, #visualizer
	 */
	public void correctHeight() {
		Image image = visualizer.image;
		setSize( width, width * imageHeight( image.bMaxImage ) / imageWidth( image.bMaxImage ) );
	}



	/**
	 * Returns shape facing.
	 * @return Shape facing
	 * 
	 * <ul>
	 * <li> Returns -1.0 if shape is facing left (LeftFacing constant) 
	 * <li> Returns +1.0 if shape is facing right (RightFacing constant).
	 * </ul>
	 * Equal to the sign of visualizer XScale field.
	 * 
	 * @see #setFacing, #xScale
	 */
	public double getFacing() {
		return visualizer.getFacing();
	}



	public final double leftFacing = -1.double 0;
	public final double rightFacing = 1.double 0;

	/**
	 * Sets the facing of a shape.
	 * Use LeftFacing and RightFacing constants.
	 * @see #getFacing, #xScale
	 */
	public void setFacing( double newFacing ) {
		visualizer.setFacing( newFacing );
	}

	// ==================== Behavior models ===================

	/**
	 * Attaches behavior model to the shape.
	 * Model will be initialized and activated if necessary.
	 * 
	 * @see #lTBehaviorModel, #activate
	 */
	public void attachModel( BehaviorModel model, int activated = true ) {
		model.init( this );
		model.link = behaviorModels.addLast( model );
		if( activated ) {
			model.activate( this );
			model.active = true;
		}
	}



	/**
	 * Attaches list of behavior model to the shape.
	 */
	public void attachModels( LinkedList models, int activated = true ) {
		for( BehaviorModel model: models ) {
			attachModel( model, activated );
		}
	}


	/**
	 * Finds behavior model by its class name.
	 * @return First behavior model with the class of given name.
	 * @see #lTBehaviorModel
	 */
	public BehaviorModel findModel( String typeName ) {
		tTypeId typeID = getTypeID( typeName );
		for( BehaviorModel model: behaviorModels ) {
			if( tTypeId.forObject( model ) == typeID ) return model;
		}
	}



	/**
	 * Activates all behavior models of the shape.
	 * Executes Activate() method of all deactivated models and set their Active field to True.
	 * 
	 * @see #deactivateAllModels, #lTBehaviorModel, #activate
	 */
	public void activateAllModels() {
		for( BehaviorModel model: behaviorModels ) {
			if( ! model.active ) {
				model.activate( this );
				model.active = true;
			}
		}
	}



	/**
	 * Deactivates all behavior models of the shape.
	 * Executes Deactivate() method of all activated models and set their Active field to False.
	 * 
	 * @see #activateAllModels, #lTBehaviorModel, #deactivate
	 */
	public void deactivateAllModels() {
		for( BehaviorModel model: behaviorModels ) {
			if( model.active ) {
				model.deactivate( this );
				model.active = false;
			}
		}
	}



	/**
	 * Activates shape behavior models of class with given name.
	 * Executes Activate() method of all inactive models of class with given name and set their Active field to True.
	 * 
	 * @see #deactivateModel, #toggleModel, #lTBehaviorModel, #activate
	 */
	public void activateModel( String typeName ) {
		tTypeId typeID = getTypeID( typeName );
		for( BehaviorModel model: behaviorModels ) {
			if( tTypeId.forObject( model ) == typeID && ! model.active ) {
				model.activate( this );
				model.active = true;
			}
		}
	}



	/**
	 * Deactivates shape behavior models of class with given name.
	 * Executes Deactivate() method of all active models of class with given name and set their Active field to False.
	 * 
	 * @see #activateModel, #toggleModel, #lTBehaviorModel, #deactivate
	 */
	public void deactivateModel( String typeName ) {
		tTypeId typeID = getTypeID( typeName );
		for( BehaviorModel model: behaviorModels ) {
			if( tTypeId.forObject( model ) == typeID && model.active ) {
				model.deactivate( this );
				model.active = false;
			}
		}
	}



	/**
	 * Toggles activity of shape behavior models of class with given name.
	 * Executes Activate() method of all inactive and Deactivate() method of all active models of class with given name and toggles their Active field.
	 * 
	 * @see #activateModel, #deactivateModel, #lTBehaviorModel, #activate, #deactivate
	 */
	public void toggleModel( String typeName ) {
		tTypeId typeID = getTypeID( typeName );
		for( BehaviorModel model: behaviorModels ) {
			if( tTypeId.forObject( model ) == typeID ) {
				if( model.active ) {
					model.deactivate( this );
					model.active = false;
				} else {
					model.activate( this );
					model.active = true;
				}
			}
		}
	}



	/**
	 * Removes all shape behavior models of class with given name.
	 * Active models will be deactivated before removal.
	 * 
	 * @see #lTBehaviorModel, #deactivate
	 */
	public void removeModel( String typeName ) {
		tTypeId typeID = getTypeID( typeName );
		for( BehaviorModel model: behaviorModels ) {
			if( tTypeId.forObject( model ) == typeID ) {
				model.remove( this );
			}
		}
	}



	/**
	 * Shows all behavior models attached to shape with their status.
	 */
	public int showModels( int y = 0, String shift = "" ) {
		if( behaviorModels.isEmpty() ) return y;
		drawText( shift + getTitle() + " ", 0, y );
	    y += 16;
	    for( BehaviorModel model: behaviorModels ) {
			String activeString;
			if( model.active ) activeString = "active"; else activeString.equals( inactive );
	    	drawText( shift + tTypeID.forObject( model ).name() + " " + activeString + ", " + model.info( this ), 8, y );
			y += 16;
	    }
		return y;
	}

	// ==================== Windowed Visualizer ====================

	/**
	 * Limits sprite displaying by window with given parameters.
	 * These parameters forms a rectangle on game field which will be viewport for displaying the sprite.
	 * All sprite parts which are outside this rectangle will not be displayed.
	 * 
	 * @see #limitByWindowShape, #removeWindowLimit
	 */
	public void limitByWindow( double x, double y, double width, double height ) {
		WindowedVisualizer newVisualizer = new WindowedVisualizer();
		newVisualizer.viewport = new Shape();
		newVisualizer.viewport.x = x;
		newVisualizer.viewport.y = y;
		newVisualizer.viewport.width = width;
		newVisualizer.viewport.height = height;
		newVisualizer.visualizer = visualizer;
		visualizer = newVisualizer;
	}



	/**
	 * Limits sprite displaying by given rectangular shape.
	 * All sprite parts which are outside this rectangle will not be displayed.
	 * 
	 * @see #limitByWindow, #removeWindowLimit
	 */
	public void limitByWindowShape( Shape shape ) {
		limitByWindow( shape.x, shape.y, shape.width, shape.height );
	}



	/**
	 * Removes window limit.
	 * After executing this method the sprite will be displayed as usual.
	 * 
	 * @see #limitByWindow, #limitByWindowShape
	 */
	public void removeWindowLimit() {
		visualizer = WindowedVisualizer( visualizer ).visualizer;
	}

	// ==================== Parameters ===================	

	/**
	 * Retrieves value of object's parameter with given name.
	 * @return Value of object's parameter with given name.
	 * @see #getTitle, #getName, #lTBehaviorModel example.
	 */
	public String getParameter( String name ) {
		if( ! parameters ) return "";
		for( Parameter parameter: parameters ) {
			if( parameter.name == name ) return parameter.value;
		}
	}



	public String getTitle() {
		return titleGenerator.getTitle( this );
	}



	public String getClassTitle() {
	}



	/**
	 * Retrieves name of object.
	 * @return Value of object's parameter "name".
	 * @see #getParameter, #getTitle
	 */
	public String getName() {
		return getParameter( "name" );
	}



	public int parameterExists( String name ) {
		if( parameters ) {
			for( Parameter parameter: parameters ) {
				if( parameter.name == name ) return true;
			}
		}
		return false;
	}



	/**
	 * Sets shape parameter  with given name and value.
	 * Recommended to use it only if you build your own world via code.
	 * 
	 * @see #getParameter
	 */
	public void setParameter( String name, String value ) {
		if( parameters ) {
			for( Parameter parameter: parameters ) {
				if( parameter.name == name ) {
					parameter.value = value;
					return;
				}
			}
		}
		addParameter( name, value );
	}



	/**
	 * Adds parameter with given name and value to the shape.
	 * Recommended to use it only if you build your own world via code.
	 * 
	 * @see #getParameter
	 */
	public void addParameter( String name, String value ) {
		Parameter parameter = new Parameter();
		parameter.name = name;
		parameter.value = value;
		if( ! parameters ) parameters == new LinkedList();
		parameters.addLast( parameter );
	}



	/**
	 * Removes parameter with given name from the shape.
	 * Recommended to use it only if you build your own world via code.
	 * 
	 * @see #getParameter
	 */
	public void removeParameter( String name ) {
		if( ! parameters ) return;
		tLink link = parameters.firstLink();
		while( link ) {
			if( Parameter( link.value() ).name == name ) link.remove();
			link = link.nextLink() ;
		}
		if( parameters.isEmpty() ) parameters == null;
	}

	// ==================== Search ===================

	public Shape load() {
		return loadShape();
	}



	public Shape loadShape() {
		String typeName = getParameter( "class" );
		Shape newShape;
		if( typeName ) {
			newShape = Shape( getTypeID( typeName ).newObject() );
		} else {
			newShape = Shape( tTypeId.forObject( this ).newObject() );
		}
		copyTo( newShape );
		return newShape;
	}



	/**
	 * Finds shape with given name.
	 * @return First found shape with given name.
	 * IgnoreError parameter should be set to True if you aren't sure is the corresponding shape inside this layer.
	 * 
	 * @see #parallax example
	 */
	public Shape findShape( String name, int ignoreError = false ) {
		return findShapeWithParameterID( "name", name, null, ignoreError );
	}



	/**
	 * Finds shape of class with given name.
	 * @return First found shape of class of class with given name.
	 * IgnoreError parameter should be set to True if you aren't sure is the corresponding shape inside this layer.
	 * You can specify optional Name parameter to check only shapes with this name.
	 * 
	 * @see #parallax example
	 */
	public Shape findShapeWithType( String shapeType, String name = "", int ignoreError = false ) {
		if( name ) {
			return findShapeWithParameterID( "name", name, getTypeID( shapeType ), ignoreError );
		} else {
			return findShapeWithParameterID( "", "", getTypeID( shapeType ), ignoreError );
		}
	}



	/**
	 * Finds shape of class with given name with parameter with given name and value.
	 * @return First found layer shape of class with given name and parameter with given name and value.
	 * IgnoreError parameter should be set to True if you aren't sure is the corresponding shape inside this layer.
	 */
	public Shape findShapeWithParameter( String parameterName, String parameterValue, String shapeType = "", int ignoreError = false ) {
		return findShapeWithParameterID( parameterName, parameterValue, getTypeID( shapeType ), ignoreError );
	}



	public Shape findShapeWithParameterID( String parameterName, String parameterValue, tTypeID shapeTypeID, int ignoreError = false ) {
		if( tTypeId.forObject( this ) == shapeTypeID || ! shapeTypeID ) {
			if( getParameter( parameterName ) == parameterValue || ! parameterName ) return this;
		}

		if( ! ignoreError ) {
			String typeName = "";
			if( shapeTypeID ) typeName.equals(  and type \" ) + shapeTypeID.name() + "\"";
			error( "Shape with parameter " + parameterName + " = " + parameterValue + typeName + " not found." );
		}
		return null;
	}



	public Shape findShapeWithParameterIDInChildShapes( String parameterName, String parameterValue, tTypeID shapeTypeID ) {
		return null;
	}



	/**
	 * Inserts the shape before given.
	 * Included layers and sprite maps will be also checked for given shape.
	 */
	public int insertBeforeShape( Shape shape = null, LinkedList shapesList = null, Shape beforeShape ) {
		return false;
	}



	/**
	 * Removes the shape from layer.
	 * Included layers and sprite maps will be also processed.
	 */
	public void remove( Shape shape ) {
	}



	/**
	 * Removes all shapes of class with given name from layer.
	 * Included layers will be also processed.
	 */
	public void removeAllOfType( String typeName ) {
		removeAllOfTypeID( getTypeID( typeName ) );
	}



	public void removeAllOfTypeID( tTypeID typeID ) {
	}

	// ==================== Management ===================

	/**
	 * Initialization method of the shape.
	 * Fill it with shape initialization commands. This method will be executed after loading the layer which have this shape inside.
	 */
	public void init() {
	}



	/**
	 * Acting method of the shape.
	 * Fill it with the shape acting commands. By default this method applies all behavior models of the shape to the shape, so if
	 * you want to have this action inside your own Act() method, use Super.Act() command.
	 * @see #lTBehaviorModel, #applyTo, #watch
	 */
	public void act() {
		if( active ) {
			BehaviorModel lastModel = new BehaviorModel();
			tLink link = behaviorModels.addLast( lastModel );
			for( BehaviorModel model: behaviorModels ) {
				if( model == lastModel ) exit;
				if( model.active ) {
					model.applyTo( this );
				} else {
					model.watch( this );
				}
			}
			link.remove();

			if Sprite( this );
				spriteActed = true;
				spritesActed += 1;
			}
		}
	}



	/**
	 * Method for updating shape.
	 * It will be called after changing coordinates or size. You can add your shape updating commands here, but don't forget to add Super.Update() command as well.
	 */
	public void update() {
	}



	/**
	 * Method for destruction of the shape.
	 * Fill it with commands for removing shape from layers, lists, maps, etc.
	 */
	public void destroy() {
	}



	public void hide() {
		active = false;
		visible = false;
	}



	public int physics() {
	}

	// ==================== Cloning ===================

	/**
	 * Clones the shape.
	 * @return Clone of the shape.
	 */
	public Shape clone() {
		Shape newShape = new Shape();
		copyShapeTo( newShape );
		return newShape;
	}



	public void copyShapeTo( Shape shape ) {
		shape.parameters = parameters;
		if( visualizer ) shape.visualizer == visualizer.clone();
		shape.x = x;
		shape.y = y;
		shape.width = width;
		shape.height = height;
		shape.visible = visible;
		shape.active = active;
	}



	public void copyTo( Shape shape ) {
		copyShapeTo( shape );
	}

	// ==================== Saving / loading ====================

	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		xMLObject.manageListField( "parameters", parameters );
		xMLObject.manageDoubleAttribute( "x", x );
		xMLObject.manageDoubleAttribute( "y", y );
		xMLObject.manageDoubleAttribute( "width", width, 1.0 );
		xMLObject.manageDoubleAttribute( "height", height, 1.0 );
		xMLObject.manageIntAttribute( "visible", visible, 1 );
		xMLObject.manageIntAttribute( "active", active, 1 );
		visualizer = Visualizer( xMLObject.manageObjectField( "visualizer", visualizer ) );
	}
}





public class Parameter extends DWLabObject {
	public String name;
	public String value;



	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );
		xMLObject.manageStringAttribute( "name", name );
		xMLObject.manageStringAttribute( "value", value );
	}
}





public TitleGenerator titleGenerator = new TitleGenerator();

public class TitleGenerator {
	public String getTitle( Shape shape ) {
		String title = shape.getParameter( "name" );
		if( title ) return title;
		title = shape.getParameter( "class" );
		if( title ) return title;
		return shape.getClassTitle();
	}
}
