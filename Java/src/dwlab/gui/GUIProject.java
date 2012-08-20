package dwlab.gui;
import java.util.LinkedList;
import dwlab.layers.Layer;
import dwlab.base.Project;
import dwlab.shapes.Shape;
import dwlab.sprites.Camera;
import dwlab.layers.World;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php


public Window window;
public TextField activeTextField;

/**
 * Camera for displaying windows.
 */
public Camera gUICamera = Camera.create();

/**
 * Class for GUI project and subprojects.
 */
public class GUIProject extends Project {
	/**
	 * List of windows.
	 */
	public LinkedList windows = new LinkedList() ;

	/**
	 * Flag for locking project controls.
	 */
	public int locked;

	// ==================== Loading layers and windows ===================	

	/**
	 * Window loading function.
	 * Window should be loaded from Lab world file, as layer of the root and has unique class or name (among other layers of root).
	 * Modal parameter (can be set in editor) set to True forces all existing windows to be inactive while this window is not closed.
	 */
	public Window loadWindow( World world, String class = "", String name = "", int add = true ) {
		activeTextField = null;
		if( class ) {
			window = Window( loadLayer( Layer( world.findShapeWithParameter( "class", class ) ) ) );
		} else {
			window = Window( loadLayer( Layer( world.findShape( name ) ) ) );
		}

		Shape screen = window.bounds;
		if( screen ) {
			if( windows.isEmpty() ) gUICamera.setSize( screen.width, screen.height );

			double dY = 0.5 * ( gUICamera.height - screen.height * gUICamera.width / screen.width );
			switch( window.getParameter( "vertical" ) ) {
				case "top":
					dY = -dY;
				case "bottom":
				default:
					dY = 0.0;
			}
			double k = gUICamera.width / screen.width;
			for( Shape shape: window.children	 ) {
				shape.setCoords( gUICamera.x + ( shape.x - screen.x ) * k, gUICamera.y + ( shape.y - screen.y ) * k + dY );
				shape.setSize( shape.width * k, shape.height * k );
			}
			screen.jumpTo( gUICamera );
			screen.alterCoords( 0.0, dY );
			screen.setSize( gUICamera.width, screen.height * gUICamera.width / screen.width );
		}

		window.modal = ( window.getParameter( "modal" ) = "true" );
		window.world = world;
		window.project = this;
		window.init();
		if( window.modal ) {
			for( Window window: windows ) {
				window.active = false;
			}
		}
		if( add ) windows.addLast( window );
		flushKeys;
		return window;
	}



	public void reloadWindows() {
		tLink link = windows.firstLink();
		while( link ) {
			Window window = Window( link.value() );
			link._value = loadWindow( window.world, tTypeID.forObject( window ).name(), window.getName(), false );
			link = link.nextLink();
		}
	}



	/**
	 * Function which finds a window in opened windows by given name or class.
	 * @return Found window.
	 */
	public Window findWindow( String class = "", String name = "" ) {
		tTypeId typeID = getTypeID( class );
		for( Window window: windows ) {
			if( name then if window.getName() == name ) return window;
			if( class then if tTypeID.forObject( window ) == typeID ) return window;
		}
		error( "Window with name \"" + name + "\" and class \"" + class + "\" is not found." );
	}



	/**
	 * Closes given window
	 * Method removes the window from project's windows list.
	 */
	public void closeWindow( Window window = null ) {
		if( window = null ) window == Window( windows.getLast() );
		windows.remove( window );
		if( window.modal ) {
			tLink link = windows.lastLink();
			while( link != null ) {
				Window window2 = Window( link.value() );
				window2.active = true;
				if( window2.modal ) return;
				link = link.prevLink();
			}
		}
		window.deInit();
		flushKeys;
	}



	public void windowsLogic() {
		Camera oldCamera = Camera.current;
		Camera.current = gUICamera;
		cursor.setMouseCoords();

		for( Window window: windows ) {
			if( window.active ) window.act();
		}

		Camera.current = oldCamera;
	}



	public void windowsRender() {
		Camera oldCamera = Camera.current;
		Camera.current = gUICamera;
		Camera.current.setCameraViewport();
		cursor.setMouseCoords();
		for( Window window: windows ) {
			if( window.visible ) window.draw();
		}

		Camera.current = oldCamera;
		cursor.setMouseCoords();
	}
}
