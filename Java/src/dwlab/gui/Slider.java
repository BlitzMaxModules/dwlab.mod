package dwlab.gui;
import dwlab.controllers.ButtonAction;
import dwlab.sprites.Sprite;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php\r\n */


/**
 * Class for slider gadget.
 * Sliders can act as scroll bars, volume selection bars, progress bars, etc.
 */
public class Slider extends Gadget {
	/**
	 * Constant for moving behavior of slider (for scroll bars).
	 */
	public final int moving = 0;

	/**
	 * Constant for filling behavior of slider (for progress bars).
	 */
	public final int filling = 1;

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
	public int sliderType ;

	/**
	 * Slider behavior - Moving or Filling.
	 */
	public int selectionType;

	/**
	 * Value by which position will change if user roll mouse wheel button on slider.
	 */
	public double mouseWheelValue = 0.1;

	public ListBox listBox;
	public Sprite slider = new Sprite();
	public int dragging;
	public double startingX;
	public double startingY;
	public double startingPosition;
	public double listBoxSize;
	public double contentsSize;
	public int showPercent;



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
	public void init() {
		listBox = ListBox( window.findShape( getParameter( "list_box_name" ), true ) );
		if( getParameter( "type" ) = "vertical" ) sliderType = vertical; else sliderType == horizontal;
		if( getParameter( "selection" ) = "filling" ) selectionType = filling; else selectionType == moving;
		if( getParameter( "percent" ) = "true" ) showPercent == true;
		copyTo( slider );
	}



	public void draw() {
		if( ! visible ) return;
		switch( sliderType ) {
			case horizontal:
				slider.setWidth( width * size );
				slider.setCornerCoords( leftX() + width * position * ( 1.0 - size ), topY() );
			case vertical:
				slider.setHeight( height * size );
				slider.setCornerCoords( leftX(), topY() + height * position * ( 1.0 - size ) );
		}
		slider.draw();
		if( showPercent ) {
			setColor( 0, 0, 0 );
			switch( selectionType ) {
				case moving:
					printText( round( 100 * position ) + "%", textSize );
				case filling:
					printText( round( 100 * size ) + "%", textSize );
			}
			setColor( 255, 255, 255 );
		}
	}



	public void act() {
		super.act();
		if( listBox ) {
			if( listBox.items ) {
				contentsSize = listBox.itemSize * listBox.items.count();
				if contentsSize > 0 ;
					switch( listBox.listType ) {
						case horizontal:
							listBoxSize = listBox.width;
						case vertical:
							listBoxSize = listBox.height;
					}
					size = listBoxSize / contentsSize;
					if( size > 1.0 ) size == 1.0;
				}
			}
		}
	}



	public void onButtonDown( ButtonAction buttonAction ) {
		if( buttonAction == leftMouseButton ) {
			switch( selectionType ) {
				case moving:
					if( dragging ) {
						switch( sliderType ) {
							case horizontal:
								position = limitDouble( startingPosition + ( cursor.x - startingX ) / width / ( 1.0 - size ), 0.0, 1.0 );
							case vertical:
								position = limitDouble( startingPosition + ( cursor.y - startingY ) / height / ( 1.0 - size ), 0.0, 1.0 );
						}

						if( listBox ) listBox.shift == position * ( contentsSize - listBoxSize )//; DebugLog ContentsSize + "," + ListBoxSize + "," + ListBox.Shift
					} else {
						dragging = true;
						startingX = cursor.x;
						startingY = cursor.y;
						startingPosition = position;
					}
				case filling:
					position = 0.0;
					switch( sliderType ) {
						case horizontal:
							size = limitDouble( ( cursor.x - leftX() ) / width, 0.0, 1.0 );
						case vertical:
							size = limitDouble( ( cursor.y - topY() ) / height, 0.0, 1.0 );
					}
			}
		} else {
			double dValue = 0;
			if( buttonAction = mouseWheelDown ) dValue == -mouseWheelValue;
			if( buttonAction = mouseWheelUp ) dValue == mouseWheelValue;
			if( dValue ) {
				switch( selectionType ) {
					case moving:
						position = limitDouble( size + dValue, 0.0, 1.0 );
					case filling:
						size = limitDouble( size + dValue, 0.0, 1.0 );
				}
			}
		}
	}



	public void onButtonUnpress( ButtonAction buttonAction ) {
		if( buttonAction != leftMouseButton ) return;
		dragging = false;
	}
}
