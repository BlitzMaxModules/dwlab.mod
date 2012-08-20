package dwlab.sprites;
import dwlab.base.Graphics;
import dwlab.base.Project;
import dwlab.base.Rectangle;
import dwlab.shapes.Shape;
import dwlab.shapes.Vector;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */


/**
 * Camera for displaying game objects.
 * Camera sprite defines rectangular area on game field which will be projected to the defined viewport rectangle.
 */
public class Camera extends VectorSprite {
	public static Vector servicePivot = new Vector();
	
	/**
	* Global variable for current camera.
	*/
	public static Camera current = new Camera();

	/**
	* Global flag for discrete graphics.
	*/
	public static boolean discreteGraphics = false;
	

	/**
	 * Viewport rectangular shape.
	 * @see #viewportClipping, #setCameraViewport, #resetViewport
	 */
	public Rectangle viewport = new Rectangle();

	public double k = 1.0d;
	public double vDX, vDY;

	public double z, dZ, zK = 1.1d;

	/**
	 * Viewport clipping flag.
	 * Defines will the objects parts outside viewport be clipped. Defaults to True.
	 * 
	 * @see #viewport, #setCameraViewport, #resetViewport
	 */
	public boolean viewportClipping = true;

	/**
	 * Isometric view flag.
	 */
	public boolean isometric;

	/**
	 * Elements of vectors V1 and V2 for Isometric view.
	 */
	public double vX1, vY1,  vX2, vY2, vK, aVK;


	/**
	 * Transforms screen coordinates to game field coordinates.
	 * @see #sizeScreenToField, #distScreenToField, #fieldToScreen, #sizeFieldToScreen, #distFieldToScreen
	 */
	public void screenToField( double screenX, double screenY, Vector pivot ) {
		if( isometric ) {
			pivot.x = ( screenX * vY2 - screenY * vX2 ) / vK - vDX;
			pivot.y = ( screenY * vX1 - screenX * vY1 ) / vK  - vDY;
		} else {
			pivot.x =screenX / k - vDX;
			pivot.y = screenY / k - vDY;
		}
	}
	
	public void screenToField( double screenX, double screenY ) {
		screenToField( screenX, screenY, servicePivot );
	}



	/**
	 * Transforms size of the object on the screen in pixels to size of this object on game field in units.
	 * @see #screenToField, #distScreenToField, #fieldToScreen, #sizeFieldToScreen, #distFieldToScreen
	 */
	public void sizeScreenToField( double screenWidth, double screenHeight, Vector sizes ) {
		if( isometric ) {
			sizes.x = Math.abs( ( Math.abs( screenWidth * vY2 ) - Math.abs( screenHeight * vX2 ) ) / aVK );
			sizes.y = Math.abs( ( Math.abs( screenHeight * vY2 ) - Math.abs( screenWidth * vX2 ) ) / aVK );
		} else {
			sizes.x = screenWidth / k;
			sizes.y = screenHeight / k;
		}
	}



	/**
	 * Transforms distance from the screen to field coordinate system.
	 * @see #screenToField, #sizeScreenToField, #fieldToScreen, #sizeFieldToScreen, #distFieldToScreen
	 */
	public double distScreenToField( double screenDist ) {
		return screenDist / k;
	}



	/**
	 * Transforms game field coordinates to the screen coordinates.
	 * @see #screenToField, #sizeScreenToField, #distScreenToField, #sizeFieldToScreen, #distFieldToScreen
	 */
	public void fieldToScreen( double fieldX, double fieldY, Vector pivot ) {
		if( isometric ) {
			pivot.x = ( ( fieldX + vDX ) * vX1 + ( fieldY + vDY ) * vX2 ) * k;
			pivot.y = ( ( fieldX + vDX ) * vY1 + ( fieldY + vDY ) * vY2 ) * k;
		} else {
			pivot.x = ( fieldX + vDX ) * k;
			pivot.y = ( fieldY + vDY ) * k;
		}

		if( discreteGraphics ) pivot.roundCoords();
	}


	/**
	 * Transforms size of the object on the field in units to size of this object on screen in pixels.
	 * @see #screenToField, #sizeScreenToField, #distScreenToField, #fieldToScreen, #distFieldToScreen
	 */
	public void sizeFieldToScreen( double fieldWidth, double fieldHeight, Vector sizes ) {
		if( isometric ) {
			sizes.x = ( Math.abs( fieldWidth * vX1 ) + Math.abs( fieldHeight * vX2 ) ) * k;
			sizes.y = ( Math.abs( fieldWidth * vY1 ) + Math.abs( fieldHeight * vY2 ) ) * k;
		} else {
			sizes.x = fieldWidth * k;
			sizes.y = fieldHeight * k;
		}

		if( discreteGraphics ) sizes.roundCoords();
	}


	/**
	 * Transforms field distance to the screen distance.
	 * @see #screenToField, #sizeScreenToField, #distScreenToField, #fieldToScreen, #sizeFieldToScreen
	 */
	public double distFieldToScreen( double screenDist ) {
		return screenDist * k;
	}


	/**
	 * Set viewport cliiping for camera.
	 * If ViewportClipping flag is set to False, then this command does nothing.
	 * 
	 * @see #viewport, #viewportClipping, #resetViewport
	 */
	public void setCameraViewport() {
		if( viewportClipping ) {
			Graphics.setViewport( viewport.x - 0.5 * viewport.width, viewport.y - 0.5 * viewport.height, viewport.width, viewport.height );
		} else {
			Graphics.resetViewport();
		}
	}


	public void setZoom( double newK ) {
		k = newK;
		setSize( viewport.width / k, viewport.height / k );
	}



	//Deprecated
	public void setMagnification( double newK ) {
		setZoom( newK );
	}



	/**
	 * Smoothly shifts camera to the given point.
	 * @see #lTCamera example
	 */
	public void shiftCameraToPoint( double newX, double newY, double acceleration ) {
		applyAcceleration( x, newX, dX, acceleration );
		applyAcceleration( y, newY, dY, acceleration );
		moveForward();
	}




	/**
	 * Smoothly shifts camera to the given shape center.
	 */
	public void shiftCameraToShape( Shape shape, double acceleration ) {
		shiftCameraToPoint( shape.getX(), shape.getY(), acceleration );
	}



	public double applyAcceleration( double x, double newX, double dX, double acceleration ) {
		double a = Project.deltaTime * acceleration * Math.signum( newX - x );
		if( ( newX - x ) * dX < 0 ) {
			dX += a;
		} else if( dX * dX / 2.0 / acceleration < Math.abs( newX - x ) ) {
			dX += a;
		} else {
			dX -= a;
		}
		return dX;
	}



	/**
	 * Smoothly alterts camera zoom to the given one.
	 * @see #lTCamera example
	 */
	public void alterCameraZoom( double newZ, double oldK, double acceleration ) {
		applyAcceleration( z, newZ, dZ, acceleration );
		//If Abs( NewZ - Z ) > Abs( DZ ) Then DZ = NewZ - Z
		z += deltaTime * dZ;
		setZoom( oldK * zK ^ z );
	}



	//Deprecated
	public void alterCameraMagnification( double newZ, double oldK, double acceleration ) {
		alterCameraZoom( newZ, oldK, acceleration );
	}



	public void update() {
		if( isometric ) {
			double dWidth = Math.abs( vX1 ) + Math.abs( vX2 );
			double dHeight = Math.abs( vY1 ) + Math.abs( vY2 );
			k = Math.min( viewport.width / dWidth / width, viewport.height / dHeight / height );
			vK = ( vX1 * vY2 - vY1 * vX2 ) * k;
			aVK = ( Math.abs( vX1 * vY2 ) - Math.abs( vY1 * vX2 ) ) * k;
			vDX = ( viewport.x * vY2 - viewport.y * vX2 ) / vK - x;
			vDY = ( viewport.y * vX1 - viewport.x * vY1 ) / vK - y;
		} else {
			k = viewport.width / width;
			height = viewport.height / k;
			vDX = viewport.x / k - x;
			vDY = viewport.y/ k - y;
		}
	}



	/**
	 * Applies color with given intensity to the whole viewport.
	 * Red color for example will make picture more "reddish".
	 * If you use intensity 0.0, it will give no effect and intensity 1.0 will make whole viewport solid red.
	 * 
	 * @see #lighten, #darken
	 */
	public void applyColor( double intensity, double red, double green, double blue ) {
		setAlpha( intensity );
		setColor( 255.0 * red, 255.0 * green, 255.0 * blue );
		drawRect( viewport.x - 0.5 * viewport.width, viewport.y - 0.5 * viewport.height, viewport.width, viewport.height );
		Visualizer.resetColor();
	}



	/**
	 * Lightens current camera viewport.
	 * 0.0 intensity will give no effect, 1.0 intensity will turn viewport to solid white.
	 * 
	 * @see #applyColor, #darken
	 */
	public void lighten( double intensity ) {
		applyColor( intensity, 1.0, 1.0, 1.0 );
	}



	/**
	 * Darkens current camera viewport.
	 * 0.0 intensity will give no effect, 1.0 intensity will turn viewport to solid black.
	 * 
	 * @see #applyColor, #lighten
	 */
	public void darken( double intensity ) {
		applyColor( intensity, 0.0, 0.0, 0.0 );
	}

	// ==================== Cloning ===================	

	public Shape clone() {
		Camera newCamera = new Camera();
		copyCameraTo( newCamera );
		return newCamera;
	}



	public void copyCameraTo( Camera camera ) {
		copySpriteTo( camera );

		camera.viewport = viewport.clone();
		camera.viewportClipping = viewportClipping;
		camera.isometric = isometric;
		camera.vX1 = vX1;
		camera.vY1 = vY1;
		camera.vX2 = vX2;
		camera.vY2 = vY2;
		camera.update();
	}



	public void copyTo( Shape shape ) {
		Camera camera = Camera( shape );

		if( ! camera ) error( "Trying to copy camera \"" + shape.getTitle() + "\" data to non-camera" );

		copyCameraTo( camera );
	}

	// ==================== Other ====================

	/**
	 * Creates new camera object using given screen resolution and unit size in pixels.
	 * @return New camera object.
	 */
	public static Camera create( double width = 800.0, double height = 600.0, double unitSize = 25.0 ) {
		Camera camera = new Camera();
		camera.viewport.setCoords( 0.5 * width, 0.5 * height );
		camera.viewport.setSize( width, height );
		camera.setSize( width / unitSize, height / unitSize );
		return camera;
	}



	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		viewport = Shape( xMLObject.manageObjectField( "viewport", viewport ) );
		xMLObject.manageIntAttribute( "viewport-clipping", viewportClipping );
		xMLObject.manageIntAttribute( "isometric", isometric );
		xMLObject.manageDoubleAttribute( "x1", vX1 );
		xMLObject.manageDoubleAttribute( "y1", vY1 );
		xMLObject.manageDoubleAttribute( "x2", vX2 );
		xMLObject.manageDoubleAttribute( "y2", vY2 );

		if( DWLabSystem.xMLMode == XMLMode.GET ) update();
	}
}



/**
 * Sets graphics mode.
 * Provide width and height of screen in pixels and unit size in pixels for camera.

 * @see #parallax example
 */
public static void initGraphics( int width = 800, int height = 600, double unitSize = 25.0, int colorDepth = 0, int frequency = 60 ) {
	graphics( width, height, colorDepth, frequency );
	autoImageFlags( fILTEREDIMAGE | dYNAMICIMAGE | mIPMAPPEDIMAGE );
	setBlend( alphaBlend );

	Camera.current.viewport.setSize( width, height );
	Camera.current.viewport.setCoords( 0.5 * width, 0.5 * height );
	Camera.current.setSize( width / unitSize, height / unitSize );
}



/**
 * VK = ( VX1 * VY2 - VY1 * VX2 ) * K

 * ScreenX = ( ( FieldX + DX ) * VX1 + ( FieldY + DY ) * VX2 ) * K
 * ScreenX / K = ( FieldX + DX ) * VX1 + ( FieldY + DY ) * VX2
 * ScreenX / K - ( FieldX + DX ) * VX1 = ( FieldY + DY ) * VX2
 * ( ScreenX / K - ( FieldX + DX ) * VX1 ) / VX2 = FieldY + DY
 * ( ScreenX / K - ( FieldX + DX ) * VX1 ) / VX2 - DY = FieldY

 * ScreenY = ( ( FieldX + DX ) * VY1 + ( FieldY + DY ) * VY2 ) * K
 * ScreenY = ( ( FieldX + DX ) * VY1 + ( ( ScreenX / K - ( FieldX + DX ) * VX1 ) / VX2 - DY + DY ) * VY2 ) * K
 * ScreenY / K = ( FieldX + DX ) * VY1 + ( ( ScreenX / K - ( FieldX + DX ) * VX1 ) / VX2 - DY + DY ) * VY2
 * ScreenY / K = FieldX * VY1 + DX * VY1 + ScreenX / K / VX2 * VY2 - FieldX * VX1 / VX2 * VY2 - DX * VX1 / VX2 * VY2
 * ScreenY / K - DX * VY1 - ScreenX / K / VX2 * VY2 + DX * VX1 / VX2 * VY2 = FieldX * VY1 - FieldX * VX1 / VX2 * VY2
 * ( ScreenY - ScreenX / VX2 * VY2 ) / K + DX * ( VX1 / VX2 * VY2 - VY1 ) = FieldX * ( VY1 - VX1 / VX2 * VY2 )
 * ( ScreenY - ScreenX / VX2 * VY2 ) / ( VY1 - VX1 / VX2 * VY2 ) / K - DX = FieldX
 * ( ScreenY * VX2 - ScreenX * VY2 ) / ( VY1 * VX2 - VX1 * VY2 ) / K - DX = FieldX
 * ( ScreenX * VY2 - ScreenY * VX2 ) / VK - DX = FieldX


 * ScreenY = ( ( FieldX + DX ) * VY1 + ( FieldY + DY ) * VY2 ) * K
 * ScreenY / K = ( FieldX + DX ) * VY1 + ( FieldY + DY ) * VY2
 * ScreenY / K - ( FieldY + DY ) * VY2 = ( FieldX + DX ) * VY1
 * ( ScreenY / K - ( FieldY + DY ) * VY2 ) / VY1 = FieldX + DX
 * ( ScreenY / K - ( FieldY + DY ) * VY2 ) / VY1 - DX = FieldX

 * ScreenX = ( ( FieldX + DX ) * VX1 + ( FieldY + DY ) * VX2 ) * K
 * ScreenX = ( ( ( ScreenY / K - ( FieldY + DY ) * VY2 ) / VY1 - DX + DX ) * VX1 + ( FieldY + DY ) * VX2 ) * K
 * ScreenX / K = ( ( ScreenY / K - ( FieldY + DY ) * VY2 ) / VY1 ) * VX1 + ( FieldY + DY ) * VX2
 * ScreenX / K = ScreenY / K / VY1 * VX1 - FieldY * VY2 / VY1 * VX1 - DY * VY2 / VY1 * VX1 + FieldY * VX2 + DY * VX2
 * ScreenX / K - ScreenY / K / VY1 * VX1 + DY * VY2 / VY1 * VX1 - DY * VX2 = FieldY * VX2 - FieldY * VY2 / VY1 * VX1
 * ( ScreenX - ScreenY / VY1 * VX1 ) / K + DY * ( VY2 / VY1 * VX1 - VX2 ) = FieldY * ( VX2 - VY2 / VY1 * VX1 )
 * ( ScreenX - ScreenY / VY1 * VX1 ) / ( VX2 - VY2 / VY1 * VX1 ) / K  - DY = FieldY
 * ( ScreenX * VY1 - ScreenY * VX1 ) / ( VX2 * VY1 - VY2 * VX1 ) / K  - DY = FieldY
 * ( ScreenY * VX1 - ScreenX * VY1 ) / VK  - DY = FieldY
 */
