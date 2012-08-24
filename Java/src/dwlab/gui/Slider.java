package dwlab.gui;
import dwlab.base.Project;
import dwlab.base.Service;
import dwlab.controllers.ButtonAction;
import dwlab.shapes.sprites.Sprite;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */


/**
 * Class for slider gadget.
 * Sliders can act as scroll bars, volume selection bars, progress bars, etc.
 */
public class Slider extends Gadget {
	public enum Behavior {
		MOVING,
		FILLING
	}

	/**
	 * Position of the moving part on the slider field ( 0.0 - 1.0 ).
	 */
	public double position;

	/**
	 * Size of the moving part relative to slider field ( 0.0 - 1.0 ).
	 */
	public double size = 1.0;

	/**
	 * Type of the slider - Vertical or Horizontal.
	 */
	public Orientation sliderType ;

	/**
	 * Slider behavior - Moving or Filling.
	 */
	public Behavior behavior;

	/**
	 * Value by which position will change if user roll mouse wheel button on slider.
	 */
	public double mouseWheelValue = 0.1;

	public ListBox listBox;
	public Sprite slider = new Sprite();
	public boolean dragging;
	public double startingX;
	public double startingY;
	public double startingPosition;
	public double listBoxSize;
	public double contentsSize;
	public boolean showPercent;


	@Override
	public String getClassTitle() {
		return "Slider";
	}


	/**
	 * Slider initialization method.
	 * You can set different slider properties using object parameters in editor:
	 * <ul><li>"type" - sets slider type ( "vertical" or "horizontal" )
	 * <li>"selection" - sets slider behavior ( "moving" or "filling" )</ul>
	 * <li>"percent" - sets showing slider position in percents </ul>
	 * And you can attach a list box (which should be inside same window) to scroll its contents with the slider by naming list box and
	 * set "list_box_name" parameter of the slider to list box name.
	 */		
	@Override
	public void init() {
		listBox = (ListBox) Window.current.findShape( getParameter( "list_box_name" ) );
		if( getParameter( "type" ).equals( "vertical" ) ) sliderType = Orientation.VERTICAL; else sliderType = Orientation.HORIZONTAL;
		if( getParameter( "behavior" ).equals(  "filling" ) ) behavior = Behavior.FILLING; else behavior = Behavior.MOVING;
		if( getParameter( "percent" ).equals(  "true" ) ) showPercent = true;
		copyTo( slider );
	}


	@Override
	public void draw() {
		if( ! visible ) return;
		switch( sliderType ) {
			case HORIZONTAL:
				slider.setWidth( width * size );
				slider.setCornerCoords( leftX() + width * position * ( 1.0 - size ), topY() );
			case VERTICAL:
				slider.setHeight( height * size );
				slider.setCornerCoords( leftX(), topY() + height * position * ( 1.0 - size ) );
		}
		slider.draw();
		if( showPercent ) {
			switch( behavior ) {
				case MOVING:
					printText( Math.round( 100 * position ) + "%", textSize );
				case FILLING:
					printText( Math.round( 100 * size ) + "%", textSize );
			}
		}
	}


	@Override
	public void act() {
		super.act();
		if( listBox != null ) {
			if( listBox.items != null ) {
				contentsSize = listBox.itemSize * listBox.items.size();
				if( contentsSize > 0 ) {
					switch( listBox.listType ) {
						case HORIZONTAL:
							listBoxSize = listBox.getWidth();
						case VERTICAL:
							listBoxSize = listBox.getHeight();
					}
					size = listBoxSize / contentsSize;
					if( size > 1.0 ) size = 1.0;
				}
			}
		}
	}


	@Override
	public void onButtonDown( ButtonAction buttonAction ) {
		if( buttonAction == Window.select ) {
			switch( behavior ) {
				case MOVING:
					if( dragging ) {
						switch( sliderType ) {
							case HORIZONTAL:
								position = Service.limit( startingPosition + ( Project.cursor.getX() - startingX ) / width / ( 1.0 - size ), 0.0, 1.0 );
							case VERTICAL:
								position = Service.limit( startingPosition + ( Project.cursor.getY() - startingY ) / height / ( 1.0 - size ), 0.0, 1.0 );
						}

						if( listBox != null ) listBox.shift = position * ( contentsSize - listBoxSize );
					} else {
						dragging = true;
						startingX = Project.cursor.getX();
						startingY = Project.cursor.getY();
						startingPosition = position;
					}
				case FILLING:
					position = 0.0;
					switch( sliderType ) {
						case HORIZONTAL:
							size = Service.limit( ( Project.cursor.getX() - leftX() ) / width, 0.0, 1.0 );
						case VERTICAL:
							size = Service.limit( ( Project.cursor.getY() - topY() ) / height, 0.0, 1.0 );
					}
			}
		} else {
			double dValue = 0;
			if( buttonAction == Window.scaleDown ) dValue = -mouseWheelValue;
			if( buttonAction == Window.scaleUp ) dValue = mouseWheelValue;
			if( dValue != 0 ) {
				switch( behavior ) {
					case MOVING:
						position = Service.limit( size + dValue, 0.0, 1.0 );
					case FILLING:
						size = Service.limit( size + dValue, 0.0, 1.0 );
				}
			}
		}
	}


	@Override
	public void onButtonUnpress( ButtonAction buttonAction ) {
		if( buttonAction != Window.select ) return;
		dragging = false;
	}
}
