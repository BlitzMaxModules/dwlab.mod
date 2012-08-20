/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.behavior_models;

import dwlab.base.Project;
import dwlab.shapes.Shape;
import dwlab.sprites.Sprite;

/**
 * This model plays animation of the sprite.
 * You can specify parameters from LTSprite's Animate() method and add models which will be executed after animation will end to the
 * NextModels parameter. Though if animation is looped it will be played forever.

 * @see #lTModelStack, #lTBehaviorModel example.
 */
public class AnimationModel extends ChainedModel {
	public double startingTime;
	public boolean looped;
	public double speed;
	public int framesQuantity;
	public int frameStart;
	public boolean pingPong;


	public AnimationModel( boolean looped, double speed, int framesQuantity, int frameStart, boolean pingPong ) {
		this.speed = speed;
		this.looped = looped;
		this.framesQuantity = framesQuantity;
		this.frameStart = frameStart;
		this.pingPong = pingPong;
	}


	@Override
	public void activate( Shape shape ) {
		startingTime = Project.current.time;
	}


	@Override
	public void applyTo( Shape shape ) {
		if( ! looped ) {
			if( Project.current.time > startingTime + speed * ( framesQuantity + ( pingPong ? 0 : framesQuantity - 2 ) ) ) {
				deactivateModel( shape );
				return;
			}
		}
		( (Sprite) shape ).animate( speed, framesQuantity, frameStart, startingTime, pingPong );
	}


	@Override
	public String info( Shape shape ) {
		return String.valueOf( ( (Sprite) shape ).frame );
	}
}
