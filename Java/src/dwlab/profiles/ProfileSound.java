package dwlab.profiles;
import java.util.HashMap;
import java.util.LinkedList;


// Mouse-oriented game menu - Digital Wizard's Lab framework template
// Copyright (C) 2011, Matt Merkulov

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php\r\n */


public HashMap soundChannels = new HashMap();
public HashMap musicChannels = new HashMap();
public LinkedList channelsList = new LinkedList();

/**
 * Sound playing function.
 * @return Channel allocated for playing sound.
 * Use it instead of standard to make profile sound volume affect playing sound. Function also regisers the channel of a sound.
 * Temporary flag defines if channel of sound should be unregistered after stopping or pausing.
 * If you set Temporary flag to false, you should unregister sound after use manually by calling L_UnregisterSound function.
 */
public static tChannel playSound( tSound sound, int temporary = true, double volume = 1.0, double rate = 1.0, double pan = 0.0, double depth = 0.0 ) {
	tChannel channel = playSoundAndSetParameters( sound, rate, pan, depth );
	setSoundVolume( channel, volume );
	resumeChannel( channel );
	if( temporary ) channelsList.addLast( channel );
}



/**
 * Music playing function.
 * @return Channel allocated for playing music.
 * Use it instead of standard sound playing functions to make profile music volume affect playing music. Function also regisers the channel of a music.
 */
public static tChannel playMusic( tSound sound, int temporary = true, double volume = 1.0, double rate = 1.0, double pan = 0.0, double depth = 0.0 ) {
	tChannel channel = playSoundAndSetParameters( sound, rate, pan, depth );
	setMusicVolume( channel, volume );
	resumeChannel( channel );
	if( temporary ) channelsList.addLast( channel );
}



public static tChannel playSoundAndSetParameters( tSound sound, double rate = 1.0, double pan = 0.0, double depth = 0.0 ) {
	tChannel channel = cueSound( sound );
	if( rate != 1.0 ) channel.setRate( rate );
	if( pan != 0.0 ) channel.setPan( pan );
	if( depth != 0.0 ) channel.setDepth( depth );
	return channel;
}



/**
 * Sound channel volume setting function.
 * This function also registers the channel for setting sound master volume.
 */
public static void setSoundVolume( tChannel channel, double volume ) {
	channel.setVolume( volume * currentProfile.soundVolume * currentProfile.soundOn );
	soundChannels.put( channel, String( volume ) );
}



/**
 * Music channel volume setting function.
 * This function also registers the channel for setting music master volume.
 */
public static void setMusicVolume( tChannel channel, double volume ) {
	channel.setVolume( volume * currentProfile.musicVolume * currentProfile.musicOn );
	musicChannels.put( channel, String( volume ) );
}



/**
 * Sound refreshing function.
 * This function sets the volume to all sounds. Call it when sound and music settings of current profile are changed.
 */
public static void refreshSounds() {
	for( tKeyValue keyValue: soundChannels ) {
		setSoundVolume( tChannel( keyValue.key() ), String( keyValue.value() ).toDouble() );
	}

	for( tKeyValue keyValue: musicChannels ) {
		setMusicVolume( tChannel( keyValue.key() ), String( keyValue.value() ).toDouble() );
	}
}


/**
 * Cleaning function which unregisters sounds which stopped playing.
 * This function should be called periodically during the program execution (probably in project's Logic() method).
 */
public static void clearSoundMaps() {
	for( tChannel channel: channelsList ) {
		if( ! channel.playing() ) unregisterChannel( channel );
	}
}



/**
 * Cleaning function which unregisters given channel.
 */
public static void unregisterChannel( tChannel channel ) {
	soundChannels.remove( channel );
	musicChannels.remove( channel );
}
