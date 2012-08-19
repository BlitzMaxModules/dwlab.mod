package dwlab.behavior_models;

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
 * This model is for waiting given period of time.
 * You can add behavior models which will be executed after this period of tme. Waiting model itself will be removed from the shape.

 * @see #randomWaitingModel, #lTBehaviorModel example.
 */
public class FixedWaitingModel extends TemporaryModel {
	public static FixedWaitingModel create( double time ) {
		FixedWaitingModel model = new FixedWaitingModel();
		model.period = time;
		return model;
	}
}
