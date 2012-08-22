/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.base;

import dwlab.controllers.ButtonAction;
import dwlab.controllers.Pushable;
import dwlab.layers.Layer;
import dwlab.sprites.Camera;
import dwlab.sprites.Sprite;
import java.util.LinkedList;

/**
 * Class for main project and subprojects.
 */
public class Project extends Obj {
	public static int collisionChecks;
	public static int tilesDisplayed;
	public static int spritesDisplayed;
	public static int spritesActed;
	public static boolean spriteActed;

	public static Project current;
	public static Sprite cursor = new Sprite( Sprite.ShapeType.PIVOT );

	/**
	* Quantity of logic frames per second.
	* @see #logic
	*/
	public static double logicFPS = 75;
	public static double deltaTime;

	public static int maxLogicStepsWithoutRender = 6;
	
	public static LinkedList<ButtonAction> controllers = new LinkedList<ButtonAction>();

	/**
	* Current frames per second quantity.
	* @see #render
	*/
	public static int fPS;

	/**
	* Flipping flag.
	* If set to True then screen clearing will be performed before Render() and buffer switching will be performed after Render().
	*/
	public static boolean flipping = true;

	/**
	 * Current logic frame number.
	 */
	public int pass;

	/**
	 * Current game time in seconds (starts from 0).
	 * @see #perSecond
	 */
	public double time = 0.0;

	/**
	 * Exit flag.
	 * Set it to True to exit project.
	 */
	public boolean exiting;

	public long startingTime;

	// ==================== Loading layers and windows ===================	

	/**
	 * Loads layer from world.
	 */
	public Layer loadLayer( Layer layer ) {
		return (Layer) layer.load();
	}

	// ==================== Management ===================	

	/**
	 * Graphics initialization method.
	 * It will be relaunched after changing graphics driver (via profiles). You should put font loading code there if you have any.
	 * 
	 * @see #init, #initSound, #deInit
	 */
	public void initGraphics() {
	}


	/**
	 * Sound initialization method.
	 * It will be relaunched after changing sound driver (via profiles). You should put sound loading code there if you have any.
	 * 
	 * @see #init, #initGraphics, #deInit
	 */
	public void initSound() {
	}


	/**
	 * Rendering method.
	 * Fill it with objects drawing commands. Will be executed as many times as possible, while keeping logic frame rate.
	 * 
	 * @see #minFPS, #fPS
	 */
	public void render() {
	}


	/**
	 * Logic method. 
	 * Fill it with project mechanics commands. Will be executed "LogicFPS" times per second.
	 * 
	 * @see #logicFPS
	 */
	public void logic() {
	}


	/**
	 * Deinitialization method.
	 * It will be executed before exit from the project.
	 * 
	 * @see #init, #initGraphics, #initSound
	 */
	public void deInit() {
	}


	/**
	 * Executes the project.
	 * You cannot use this method to execute more projects if the project is already running, use Insert() method instead.
	 */
	public void execute() {
		Project oldProject = current;
		current = this;

		Sys.flushControllers();

		exiting = false;
		pass = 1;
		deltaTime = 0;

		init();
		initGraphics();
		initSound();

		time = 0.0;
		startingTime = System.currentTimeMillis();

		double realTime = 0d;
		int fPSCount = 0;
		long fPSTime = 0l;

		for( ButtonAction controller: controllers ) {
			for( Pushable pushable : controller.buttonList ) {
				pushable.reset();
			}
		}

		int logicStepsWithoutRender = 0;

		while( true ) {
			deltaTime = 1.0 / logicFPS;
			time += deltaTime;

			collisionChecks = 0;
			spritesActed = 0;

			processEvents();

			cursor.setMouseCoords();
			logic();

			windowsLogic();

			for( ButtonAction controller: controllers ) {
				for( Pushable pushable : controller.buttonList ) {
					pushable.reset();
				}
			}
			
			if( exiting ) break;

			logicStepsWithoutRender += 1;

			while( true ) {
				realTime = 0.001 * ( System.currentTimeMillis() - startingTime );
				if( realTime >= time && logicStepsWithoutRender <= maxLogicStepsWithoutRender ) break;

				if( flipping && Graphics.initialized() ) Graphics.clearScreen();

				spritesDisplayed = 0;
				tilesDisplayed = 0;

				Camera.current.setCameraViewport();
				cursor.setMouseCoords();
				render();

				windowsRender();

				if( flipping && Graphics.initialized() ) Graphics.switchBuffers();

				logicStepsWithoutRender = 0;
				fPSCount ++;
			}

			if( System.currentTimeMillis() >= 1000 + fPSTime ) {
				fPS = fPSCount;
				fPSCount = 0;
				fPSTime = System.currentTimeMillis();
			}

			pass += 1;
		}

		deInit();
		current = oldProject;
	}

	// ==================== Events ===================		

	public void processEvents() {
		/*while( true ) {
			pollEvent();
			for( ButtonAction controller: controllers ) {
				for( Pushable pushable : controller.buttonList ) {
					pushable.processEvent();
				}
			}
			switch( eventID() ) {
				case event_WindowClose:
					onCloseButton();
				case event_WindowSize:
					onWindowResize();
				case 0:
					exit;
			}
			onEvent();
		}*/
	}


	public void onEvent() {
	}


	public void onCloseButton() {
		exiting = true;
	}


	public void onWindowResize() {
	}

	// ==================== Dummies for GUI project ===================	

	public void windowsLogic() {
	}


	public void windowsRender() {
	}


	public void reloadWindows() {
	}

	// ==================== Other ===================	

	/**
	 * Switches the project execution to given.
	 * Use this command instead of calling another Execute() method.
	 * 
	 * @see #lTButtonAction example
	 */
	public void switchTo( Project project ) {
		long freezingTime = System.currentTimeMillis();
		project.execute();
		deltaTime = 1.0 / logicFPS;
		startingTime += System.currentTimeMillis() - freezingTime;
	}


	//Deprecated
	public double perSecond( double value ) {
		return value * deltaTime;
	}


	/**
	* Draws various debugging information on screen.
	* See also #wedgeOffWithSprite example
	*/
	public static void showDebugInfo() {
		Graphics.drawText( "FPS" + fPS, 0, 0 );
		Graphics.drawText( "Memory" + Runtime.getRuntime().totalMemory() / 1024 + "kb", 0, 16 );

		Graphics.drawText( "Collision  checks" + collisionChecks, 0, 32 );
		Graphics.drawText( "Tiles  displayed" + tilesDisplayed, 0, 48 );
		Graphics.drawText( "Sprites  displayed" + spritesDisplayed, 0, 64 );
		Graphics.drawText( "Sprites  acted" + spritesActed, 0, 80 );
	}
}
