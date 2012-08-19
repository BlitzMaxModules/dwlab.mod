package dwlab.base;
import dwlab.layers.Layer;
import dwlab.controllers.Pushable;
import dwlab.sprites.Sprite;

//
// Digital Wizard's Lab - game development framework
// Copyright (C) 2012, Matt Merkulov
//
// All rights reserved. Use of this code is allowed under the
// Artistic License 2.0 terms, as specified in the license.txt
// file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php
//

public int collisionChecks;
public int tilesDisplayed;
public int spritesDisplayed;
public int spritesActed;
public int spriteActed;

public Project currentProject;
public Sprite cursor = Sprite.fromShape( , , , , Sprite.pivot );

/**
 * Quantity of logic frames per second.
 * @see #logic
 */
public double logicFPS = 75;
public double deltaTime;

public double maxLogicStepsWithoutRender = 6;

/**
 * Current frames per second quantity.
 * @see #render
 */
public int fPS;

/**
 * Flipping flag.
 * If set to True then Cls will be performed before Render() and Flip will be performed after Render().
 */
public int flipping = true;

/**
 * Class for main project and subprojects.
 */
public class Project extends DWLabObject {
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
	public int exiting;

	public int startingTime;

	// ==================== Loading layers and windows ===================	

	/**
	 * Loads and initializes layer and all its child objects from previously loaded world.
	 */
	public void loadAndInitLayer( Layer newLayer var, Layer layer ) {
		newLayer = loadLayer( layer );
		newLayer.init();
	}



	/**
	 * Loads layer from world.
	 */
	public Layer loadLayer( Layer layer ) {
		return Layer( layer.load() );
	}

	// ==================== Management ===================	

	/**
	 * Initialization method.
	 * Fill it with project initialization commands.
	 * 
	 * @see #initGraphics, #initSound, #deInit
	 */
	public void init() {
	}



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
		Project oldProject = currentProject;
		currentProject = this;

		flushKeys;
		flushMouse;

		exiting = false;
		pass = 1;
		deltaTime = 0;

		init();
		initGraphics();
		initSound();

		time = 0.0;
		startingTime = milliSecs();

		double realTime = 0;
		int fPSCount;
		int fPSTime;

		for( Pushable controller: controllers ) {
			controller.reset();
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

			for( Pushable controller: controllers ) {
				controller.reset();
			}

			if( exiting ) exit;

			logicStepsWithoutRender += 1;

			while( true ) {
				realTime = 0.001 * ( millisecs() - startingTime );
				if( realTime >= time && logicStepsWithoutRender <= maxLogicStepsWithoutRender ) exit;

				if( flipping && graphicsWidth() ) cls;

				spritesDisplayed = 0;
				tilesDisplayed = 0;

				Camera.current.setCameraViewport();
				cursor.setMouseCoords();
				render();

				windowsRender();

				if( flipping && graphicsWidth() ) flip( false );

				logicStepsWithoutRender = 0;
				fPSCount += 1;
			}

			if( millisecs() >= 1000 + fPSTime ) {
				fPS = fPSCount;
				fPSCount = 0;
				fPSTime = millisecs();
			}

			pollSystem();
			pass += 1;
		}

		deInit();
		currentProject = oldProject;
	}

	// ==================== Events ===================		

	public void processEvents() {
		while( true ) {
			pollEvent();
			for( Pushable controller: controllers ) {
				controller.processEvent();
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
		}
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
		int freezingTime = milliSecs();
		project.execute();
		deltaTime = 1.0 / logicFPS;
		startingTime += milliSecs() - freezingTime;
	}



	//Deprecated
	public double perSecond( double value ) {
		return value * deltaTime;
	}



	public void showDebugInfo() {
		showDebugInfo();
	}
}





/**
 * Converts value second to value per logic frame.
 * @return Value for logic frame using given per second value.
 * For example, can return coordinate increment for speed per second.

 * @see #l_LogicFPS, #setAsTile example
 */
public static double perSecond( double value ) {
	return value * deltaTime;
}




/**
 * Draws various debugging information on screen.
 * See also #wedgeOffWithSprite example
 */
public static void showDebugInfo() {
	drawText( " FPS" + fPS, 0, 0 );
	drawText( " Memory" + int( gCMemAlloced() / 1024 ) + "kb", 0, 16 );

	drawText( "Collision  checks" + collisionChecks, 0, 32 );
	drawText( "Tiles  displayed" + tilesDisplayed, 0, 48 );
	drawText( "Sprites  displayed" + spritesDisplayed, 0, 64 );
	drawText( "Sprites  acted" + spritesActed, 0, 80 );
}
