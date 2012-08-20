package dwlab.gui;
import java.util.LinkedList;
import java.lang.Math;
import dwlab.controllers.ButtonAction;
import dwlab.sprites.Sprite;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php\r\n */


/**
 * Class for list box gadget.
 */
public class ListBox extends Gadget {
	/**
	 * List type.
	 * Can be Vertical or Horizontal.
	 */
	public int listType = vertical;

	/**
	 * List which contains list box items.
	 */
	public LinkedList items;

	/**
	 * List item size.
	 * Height for vertical lists, width for horizontal lists in units.
	 */
	public double itemSize = 1.0;
	public double shift;


	public String getClassTitle() {
		return "List box";
	}



	public void init() {
		super.init();
		if( parameterExists( "item_size" ) ) itemSize == getParameter( "item_size" ).toDouble();
	}



	public void draw() {
		if( ! visible ) return;
		super.draw();

		if( ! items ) return;
		int num = 0;
		setAsViewport();
		for( Object item: items ) {
			drawItem( item, num, getItemSprite( num ) );
			num += 1;
		}
		Camera.current.setCameraViewport();
	}



	public Sprite getItemSprite( int num ) {
		Sprite sprite = new Sprite();
		if( listType == vertical ) {
			sprite.setSize( width, itemSize );
			sprite.setCornerCoords( leftX(), topY() + num * itemSize - shift );
		} else {
			sprite.setSize( itemSize, height );
			sprite.setCornerCoords( leftX() + num * itemSize - shift, topY() );
		}
		return sprite;
	}



	/**
	 * Method for drawing list box item.
	 * Fill this method with code which displays given item. You also can use its number in list and shape which it occupies in list box.
	 */
	public void drawItem( Object item, int num, Sprite sprite ) {
	}



	public void onButtonPress( ButtonAction buttonAction ) {
		if( ! items ) return;
		if( itemSize <= 0 ) return;
		int num;
		if( listType == vertical ) {
			num = Math.floor( ( cursor.y - topY() + shift ) / itemSize );
		} else {
			num = Math.floor( ( cursor.x - leftX() + shift ) / itemSize );
		}
		if( num >= 0 && num < items.count() ) onButtonPressOnItem( buttonAction, items.get( num ), num );
	}



	/**
	 * Pressing button on list box item.
	 * Fill this method with code of reaction to user's button press on item (selection via click for example).
	 */
	public void onButtonPressOnItem( ButtonAction buttonAction, Object item, int num ) {
	}
}
