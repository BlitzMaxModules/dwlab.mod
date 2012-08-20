package dwlab.profiles;
import java.util.LinkedList;
import dwlab.base.XMLObject;
import java.lang.Math;
import dwlab.base.Project;
import dwlab.base.Obj;
import dwlab.sprites.Camera;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

/**
 * Current profile.
 */
public Profile currentProfile;

public tGadget projectWindow, tGadget projectCanvas;
public int xResolution, int yResolution;
public int viewportCenterX, int viewportCenterY;

public LinkedList profiles = new LinkedList();
public LinkedList languages = new LinkedList();
public LinkedList audioDrivers = new LinkedList();

/**
 * Head class for profiles.
 */
public class Profile extends Obj {
	/**
	 * Name of the profile.
	 */
	public String name;

	/**
	 * Quantity of points earned by the player.
	 */
	public int score;

	/**
	 * Name of MaxGUI language.
	 */
	public String language;

	/**
	 * Name of the audio driver.
	 */
	public String audioDriver;

	/**
	 * Name of the video driver.
	 */
	public String videoDriver;

	/**
	 * Full screen flag (false means windowed mode).
	 */
	public int fullScreen;

	/**
	 * Width of screen resolution.
	 */
	public int screenWidth;

	/**
	 * Height of screen resolution.
	 */
	public int screenHeight;

	/**
	 * Screen color depth.
	 */
	public int colorDepth;

	/**
	 * Display refreshing frequency.
	 */
	public int frequency;

	/**
	 * List of changeable keys (button actions).
	 */
	public LinkedList keySet = new LinkedList();

	/**
	 * Sound flag.
	 * True means sound is on, False means off.
	 */
	public int soundOn = true;

	/**
	 * Sound volume ( 0.0 - 1.0 ).
	 */
	public double soundVolume = 1.0;

	/**
	 * Music flag.
	 * True means sound is on, False means off.
	 */
	public int musicOn = true;

	/**
	 * Music volume ( 0.0 - 1.0 ).
	 */
	public double musicVolume = 1.0;

	public int minGrainSize = 8;
	public int grainXQuantity = 64;
	public int minGrainYQuantity = 36;
	public int maxGrainYQuantity = 48;



	/**
	 * Profile system initialization function.
	 * Fills lists of available graphic modes, graphic and audio drivers.
	 */
	public static void initSystem() {
		for( tGraphicsMode mode: graphicsModes() ) {
			if( mode.width >= 640 && mode.width > mode.height ) {
				ScreenResolution.add( mode.width, mode.height, mode.depth, mode.hertz );
				//DebugLog Mode.Width + ", " + Mode.Height + ", " + Mode.Depth + ", " + Mode.Hertz
			}
		}

		for( tTypeId driverTypeID: tTypeID.forName( "TMax2DDriver" ).derivedTypes() ) {
			tMax2dDriver driver = null;
			String driverName = "";
			switch( driverTypeID.name() ) {
				case "TD3D7Max2DDriver", "TD3D9Max2DDriver":
					driver = tMax2dDriver( driverTypeID.newObject() );
			}
			Obj driverObject = driverTypeID.newObject();
			for( tMethod theMethod: driverTypeID.enumMethods() ) {
				String name = theMethod.name().toLowerCase();
				if( name = "create" ) driver == tMax2dDriver( theMethod.invoke( driverObject, null ) );
				if( name = "tostring" ) driverName == String( theMethod.invoke( driverObject, null ) );
			}
			if( driver ) {
				VideoDriver videoDriver = new VideoDriver();
				videoDriver.driver = driver;
				videoDriver.name = driverName;
				videoDrivers.addLast( videoDriver );
			}
		}

		for( String driver: audioDrivers() ) {
			audioDrivers.addLast( driver );
		}
	}



	/**
	 * Default profile creation function.
	 * @return New default profile.
	 * Creates profile, sets its parameters to default values and initializes profile.
	 */
	public static Profile createDefault( tTypeID profileTypeID ) {
		Profile profile = Profile( profileTypeID.newObject() );
		profile.name = "{{P_Player}}";
		tTypeId typeID = tTypeId.forObject( getGraphicsDriver() );
		for( VideoDriver driver: videoDrivers ) {
			if( tTypeID.forObject( driver.driver ) = typeID ) profile.videoDriver == driver.name;
		}

		ScreenResolution resolution = ScreenResolution.get();
		profile.screenWidth = resolution.width;
		profile.screenHeight = resolution.height;
		ColorDepth colorDepth = ColorDepth.get( resolution );
		profile.colorDepth = colorDepth.bits;
		profile.frequency = Frequency.get( colorDepth ).hertz;

		if( audioDriverExists( "DirectSound" ) ) profile.audioDriver.equals( DirectSound );
		if( ! profile.audioDriver && audioDrivers() ) profile.audioDriver == audioDrivers()[ 0 ];

		profile.init();
		profile.reset();
		return profile;
	}



	/**
	 * Finds language with given name.
	 * @return Language with given name from languages list.
	 */
	public static tMaxGuiLanguage getLanguage( String name ) {
		for( tMaxGuiLanguage language: languages ) {
			if( language.getName() == name ) return language;
		}
		return tMaxGuiLanguage( languages.getFirst() );
	}



	/**
	 * Applies profile.
	 * You can specify an array of projects which should been initialized after changing drivers or screen resolution.
	 */
	public void apply( Project projects[] = null, int newScreen = true, int newVideoDriver = true, int newAudioDriver = true, int newLanguage = true ) {
		if( newLanguage ) setLocalizationLanguage( getLanguage( language ) );

		if( newVideoDriver ) setGraphicsDriver( VideoDriver.get( videoDriver ).driver );

		if( newScreen || newVideoDriver ) {
			if( fullScreen ) {
				if( projectWindow ) {
					disablePolledInput();
					freeGadget( projectWindow );
					projectWindow = null;
				} else {
					endGraphics();
				}
				changeViewportResolution( screenWidth, screenHeight );
				graphics( screenWidth, screenHeight, colorDepth, frequency );
				viewportCenterX = 0.5 * screenWidth;
				viewportCenterY = 0.5 * screenHeight;
			} else {
				if( projectWindow ) {
					changeViewportResolution( clientWidth( projectWindow ), clientHeight( projectWindow ) );
					setGadgetShape( projectWindow, gadgetX( projectWindow ), gadgetY( projectWindow ), xResolution, yResolution );
				} else {
					endGraphics();
					int maxXResolution = clientWidth( desktop() ) - 8;
					int maxYResolution = clientHeight( desktop() ) - 34;
					if xResolution < minGrainSize * grainXQuantity || yResolution < minGrainSize * minGrainYQuantity || ..;
							xResolution > maxXResolution || yResolution > maxYResolution then;
						changeViewportResolution( maxXResolution, maxYResolution );
					}
					projectWindow = createWindow( appTitle, 0.5 * ( clientWidth( desktop() ) - xResolution - 4 ), ..;
							0.5 * ( clientHeight( desktop() ) - yResolution - 13 ), xResolution, yResolution, null, ..;
							window_TItleBar | window_Resizable | window_ClientCoords );
					projectCanvas = createCanvas( 0, 0, clientWidth( projectWindow ), clientHeight( projectWindow ), projectWindow );
					setGadgetLayout( projectCanvas, edge_Aligned, edge_Aligned, edge_Aligned, edge_Aligned );
				}
				setGraphics( canvasGraphics( projectCanvas ) );
				enablePolledInput( projectCanvas );
				activateGadget( projectCanvas );
				viewportCenterX = 0.5 * xResolution;
				viewportCenterY = 0.5 * yResolution;
			}
			autoImageFlags( fILTEREDIMAGE | dYNAMICIMAGE );
			setBlend( alphaBlend );
		}

		if( newAudioDriver ) {
			for( tChannel channel: channelsList ) {
				channel.stop();
			}
			setAudioDriver( audioDriver );
			soundChannels.clear();
			musicChannels.clear();
			channelsList.clear();
		}

		if( projects ) {
			for( Project project: projects ) {
				if( newVideoDriver || newScreen ) project.initGraphics();
				if( newScreen || newLanguage ) project.reloadWindows();
				if( newAudioDriver ) project.initSound();
			}
		}
	}



	public void changeViewportResolution( int width, int height ) {
		int grain = Math.floor( width / 64.0 );
		if( height < minGrainYQuantity * grain ) {
			grain = Math.floor( 1.0 * height / minGrainYQuantity );
			yResolution = grain * minGrainYQuantity;
		} else if( height > maxGrainYQuantity * grain then ) {
			grain = Math.floor( 1.0 * height / maxGrainYQuantity );
			yResolution = grain * maxGrainYQuantity;
		} else {
			yResolution = height;
		}
		if( grain < minGrainSize ) {
			xResolution = minGrainSize * grainXQuantity;
			yResolution = minGrainSize * minGrainYQuantity;
		} else {
			xResolution = grain * grainXQuantity;
		}
	}



	/**
	 * Initializes given camera according to profile's resolution.
	 * Fixes camera height and sets viewport to corresponding shape according screen grain.
	 */
	public void initCamera( Camera camera ) {
		camera.setSize( camera.width, camera.width / xResolution * yResolution );
		camera.viewport.setCoords( viewportCenterX, viewportCenterY );
		camera.viewport.setSize( xResolution, yResolution );
		camera.update();
	}



	/**
	 * Clones the profile
	 * @return Profile which is exact copy of given.
	 */
	public Profile clone() {
		Profile profile = new this();
		profile.name = name;
		profile.language = language;
		profile.audioDriver = audioDriver;
		profile.videoDriver = videoDriver;
		profile.fullScreen = fullScreen;
		profile.screenWidth = screenWidth;
		profile.screenHeight = screenHeight;
		profile.colorDepth = colorDepth;
		profile.frequency = frequency;
		return profile;
	}



	/**
	 * Profile initialization method.
	 * Fill it with code which should be executed at profile's creation.
	 */
	public void init() {
	}



	/**
	 * Profile resetting method.
	 * Fill it with code which should be executed at profile's creation and after game over.
	 */
	public void reset() {
	}



	/**
	 * Profile loading method.
	 * Will be executed at start and after switching to this profile.
	 * Fill it with code which transfers data from the profile to the game objects.
	 */
	public void load() {
	}



	/**
	 * Profile saving method.
	 * Will be executed before switching profiles and before exit.
	 * Fill it with code which transfers data from the game objects to the profile.
	 */
	public void save() {
	}



	public void setAsCurrent()		 {
	}



	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		xMLObject.manageStringAttribute( "name", name );
		xMLObject.manageStringAttribute( "language", language );
		xMLObject.manageStringAttribute( "audio", audioDriver );
		xMLObject.manageStringAttribute( "video", videoDriver );
		xMLObject.manageIntAttribute( "fullscreen", fullScreen );
		xMLObject.manageIntAttribute( "width", screenWidth );
		xMLObject.manageIntAttribute( "height", screenHeight );
		xMLObject.manageIntAttribute( "depth", colorDepth );
		xMLObject.manageIntAttribute( "frequency", frequency );
		xMLObject.manageChildList( keySet );
		xMLObject.manageIntAttribute( "sound_on", soundOn, 1 );
		xMLObject.manageDoubleAttribute( "sound_volume", soundVolume, 1.0 );
		xMLObject.manageIntAttribute( "music_on", musicOn, 1 );
		xMLObject.manageDoubleAttribute( "music_volume", musicVolume, 1.0 );
		xMLObject.manageIntAttribute( "x_resolution", xResolution );
		xMLObject.manageIntAttribute( "y_resolution", yResolution );
	}
}
