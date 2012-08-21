/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.gui;

import dwlab.base.Project;
import dwlab.base.Sys;
import dwlab.layers.Layer;
import dwlab.layers.World;
import dwlab.shapes.Shape;
import dwlab.sprites.Camera;
import java.util.Iterator;
import java.util.LinkedList;

/**
 * Class for GUI project and subprojects.
 */
public class GUIProject extends Project {
	public static Window window;
	public static TextField activeTextField;

	/**
	* Camera for displaying windows.
	*/
	public static Camera camera = new Camera();
	
	/**
	 * List of windows.
	 */
	public LinkedList<Window> windows = new LinkedList<Window>() ;

	/**
	 * Flag for locking project controls.
	 */
	public boolean locked;

	// ==================== Loading layers and windows ===================	

	/**
	 * Window loading function.
	 * Window should be loaded from Lab world file, as layer of the root and has unique class or name (among other layers of root).
	 * Modal parameter (can be set in editor) set to True forces all existing windows to be inactive while this window is not closed.
	 */
	public Window loadWindow( World world, Class windowClass, String windowName, boolean add ) {
		activeTextField = null;
		if( windowClass != null ) {
			window = (Window) loadLayer( (Layer) world.findShape( windowClass ) );
		} else {
			window = (Window) loadLayer( (Layer) world.findShape( windowName ) );
		}

		Shape screen = window.bounds;
		if( screen != null ) {
			if( windows.isEmpty() ) camera.setSize( screen.getWidth(), screen.getHeight() );

			double dY = 0.5 * ( camera.getHeight() - screen.getHeight() * camera.getWidth() / screen.getWidth() );
			String verticalAlign = window.getParameter( "vertical" );
			if( verticalAlign.equals( "top" ) ) {
				dY = -dY;
			} else if ( !verticalAlign.equals( "bottom" ) ) {
				dY = 0.0;
			}
			
			double k = camera.getWidth() / screen.getWidth();
			for( Shape shape: window.children ) {
				shape.setCoords( camera.getX() + ( shape.getX() - screen.getX() ) * k, camera.getY() + ( shape.getY() - screen.getY() ) * k + dY );
				shape.setSize( shape.getWidth() * k, shape.getHeight() * k );
			}
			screen.jumpTo( camera );
			screen.alterCoords( 0.0, dY );
			screen.setSize( camera.getWidth(), screen.getHeight() * camera.getWidth() / screen.getWidth() );
		}

		window.modal = window.getParameter( "modal" ).equals( "true" );
		window.world = world;
		window.project = this;
		window.init();
		if( window.modal ) for( Window win: windows ) win.active = false;
		if( add ) windows.addLast( window );
		Sys.flushKeys();
		return window;
	}


	@Override
	public void reloadWindows() {
		LinkedList<Window> newWindows = new LinkedList<Window>();
		for ( Window win : windows ) {
			newWindows.add( loadWindow( win.world, win.getClass(), window.getName(), false ) );
		}
		windows.clear();
		windows.addAll( newWindows );
	}



	/**
	 * Function which finds a window in opened windows by given name or class.
	 * @return Found window.
	 */
	public Window findWindow( String windowName ) {
		for( Window win: windows ) {
			if( win.getName().equals( windowName ) ) return win;
		}
		error( "Window with name \"" + windowName + "\" is not found." );
		return null;
	}


	/**
	 * Function which finds a window in opened windows by given name or class.
	 * @return Found window.
	 */
	public Window findWindow( Class windowClass ) {
		for( Window win: windows ) {
			if( windowClass == window.getClass() ) return window;
		}
		error( "Window with class \"" + windowClass + "\" is not found." );
		return null;
	}
		
		
	/**
	 * Closes given window
	 * Method removes the window from project's windows list.
	 */
	public void closeWindow( Window window ) {
		windows.remove( window );
		if( window.modal ) {
			for ( Iterator<Window> iterator = windows.descendingIterator(); iterator.hasNext(); ) {
				Window win = iterator.next();
				win.active = true;
				if( win.modal ) return;
			}
		}
		window.onClose();
		Sys.flushKeys();
	}
	
	public void closeWindow() {
		closeWindow( windows.getLast() );
	}



	@Override
	public void windowsLogic() {
		Camera oldCamera = Camera.current;
		Camera.current = camera;
		cursor.setMouseCoords();

		for( Window win: windows ) if( win.active ) win.act();

		Camera.current = oldCamera;
	}



	@Override
	public void windowsRender() {
		Camera oldCamera = Camera.current;
		Camera.current = camera;
		Camera.current.setCameraViewport();
		
		cursor.setMouseCoords();
		for( Window win: windows ) {
			if( win.visible ) win.draw();
		}

		Camera.current = oldCamera;
		cursor.setMouseCoords();
	}
}
