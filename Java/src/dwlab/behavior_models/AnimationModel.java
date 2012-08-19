package dwlab.behavior_models;
import dwlab.shapes.Shape;
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

/**
 * This model plays animation of the sprite.
 * You can specify parameters from LTSprite's Animate() method and add models which will be executed after animation will end to the
 * NextModels parameter. Though if animation is looped it will be played forever.

 * @see #lTModelStack, #lTBehaviorModel example.
 */
public class AnimationModel extends ChainedModel {
	public double startingTime;
	public int looped;
	public double speed;
	public int framesQuantity;
	public int frameStart;
	public int pingPong;



	public static AnimationModel create( int looped = true, double speed, int framesQuantity = 0, int frameStart = 0, int pingPong = false ) {
		AnimationModel model = new AnimationModel();
		model.speed = speed;
		model.looped = looped;
		model.framesQuantity = framesQuantity;
		model.frameStart = frameStart;
		model.pingPong = pingPong;
		return model;
	}



	public void activate( Shape shape ) {
		startingTime = currentProject.time;
	}



	public void applyTo( Shape shape ) {
		if( ! looped ) {
			if( currentProject.time > startingTime + speed * ( framesQuantity + ( framesQuantity - 2 ) * pingPong ) ) {
				deactivateModel( shape );
				return;
			}
		}
		Sprite( shape ).animate( speed, framesQuantity, frameStart, startingTime, pingPong );
	}



	public String info( Shape shape ) {
		return Sprite( shape ).frame;
	}
}
