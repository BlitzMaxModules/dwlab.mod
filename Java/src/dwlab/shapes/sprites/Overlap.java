/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.shapes.sprites;

import dwlab.shapes.sprites.Sprite.ShapeType;

public class Overlap {
	public static Sprite servicePivot1 = new Sprite();
	public static Sprite servicePivot2 = new Sprite();
	public static Sprite servicePivot3 = new Sprite();
	public static Sprite servicePivot4 = new Sprite();
	public static Sprite serviceOval1 = new Sprite( ShapeType.OVAL );



	public static boolean circleAndPivot( Sprite circle, Sprite pivot ) {
		if( 4d * circle.distance2to( pivot ) <= circle.getWidth() * circle.getWidth() ) return true; else return false;
	}



	public static boolean circleAndOval( Sprite circle, Sprite oval ) {
		if( oval.getWidth() == oval.getHeight() ) return circleAndCircle( circle, oval );

		if( oval.getWidth() > oval.getHeight() ) {
			double dWidth = oval.getWidth() - oval.getHeight();
			serviceOval1.setCoords( oval.getX() - dWidth, oval.getY() );
			serviceOval1.setDiameter( oval.getHeight() );
			if( ! circleAndCircle( circle, serviceOval1 ) ) return false;
			serviceOval1.setX( oval.getX() + dWidth );
		} else {
			double dHeight = oval.getHeight() - oval.getWidth();
			serviceOval1.setCoords( oval.getX(), oval.getY() - dHeight );
			serviceOval1.setDiameter( oval.getWidth() );
			if( ! circleAndCircle( circle, serviceOval1 ) ) return false;
			serviceOval1.setY( oval.getY() + dHeight );
		}
		return circleAndCircle( circle, serviceOval1 );
	}



	public static boolean circleAndCircle( Sprite circle1, Sprite circle2 ) {
		double diameters = circle1.getWidth() + circle2.getWidth();
		if( 4.0 * circle1.distance2to( circle2 ) <= diameters * diameters ) return true; else return false;
	}



	public static boolean circleAndRectangle( Sprite circle, Sprite rectangle ) {
		if( rectangleAndRectangle( circle, rectangle ) ) {
			rectangle.getPivots( servicePivot1, servicePivot2, servicePivot3, servicePivot4 );
			if( !circleAndPivot( circle, servicePivot1 ) ) return false;
			if( !circleAndPivot( circle, servicePivot2 ) ) return false;
			if( !circleAndPivot( circle, servicePivot3 ) ) return false;
			if( !circleAndPivot( circle, servicePivot4 ) ) return false;
			return true;
		}
		return false;
	}



	public static boolean circleAndTriangle( Sprite circle, Sprite triangle ) {
		triangle.getRightAngleVertex( servicePivot1 );
		if( !circleAndPivot( circle, servicePivot1 ) ) return false;
		triangle.getOtherVertices( servicePivot1, servicePivot2 );
		if( !circleAndPivot( circle, servicePivot1 ) ) return false;
		if( !circleAndPivot( circle, servicePivot2 ) ) return false;
		return true;
	}



	public static boolean rectangleAndPivot( Sprite rectangle, Sprite pivot ) {
		if( ( rectangle.getX() - 0.5d * rectangle.getWidth() <= pivot.getX() ) && ( rectangle.getY() - 0.5d * rectangle.getHeight() <= pivot.getY() )
				&& ( rectangle.getX() + 0.5d * rectangle.getWidth() >= pivot.getX() ) && ( rectangle.getY() + 0.5d * rectangle.getHeight() >= pivot.getY() ) ) return true; else return false;
	}



	public static boolean rectangleAndRectangle( Sprite rectangle1, Sprite rectangle2 ) {
		if( ( rectangle1.getX() - 0.5d * rectangle1.getWidth() <= rectangle2.getX() - 0.5d * rectangle2.getWidth() )
				&& ( rectangle1.getY() - 0.5d * rectangle1.getHeight() <= rectangle2.getY() - 0.5d * rectangle2.getHeight() )
				&& ( rectangle1.getX() + 0.5d * rectangle1.getWidth() >= rectangle2.getX() + 0.5d * rectangle2.getWidth() )
				&& ( rectangle1.getY() + 0.5d * rectangle1.getHeight() >= rectangle2.getY() + 0.5d * rectangle2.getHeight() ) ) return true; else return false;
	}
}