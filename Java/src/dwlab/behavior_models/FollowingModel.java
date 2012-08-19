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

public class FollowingModel extends ChainedModel {
	public Shape destinationShape;
	public int removeWhenStop;



	public static FollowingModel create( Shape destinationShape, int removeWhenStop ) {
		FollowingModel model = new FollowingModel();
		model.destinationShape = destinationShape;
		model.removeWhenStop = removeWhenStop;
		return model;
	}



	public void applyTo( Shape shape ) {
		Sprite( shape ).moveTowards( destinationShape, Sprite( shape ).velocity );
		if( removeWhenStop then if shape.isAtPositionOf( destinationShape ) ) remove( shape );
	}
}
