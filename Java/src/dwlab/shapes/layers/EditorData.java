/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.shapes.layers;

import dwlab.base.Obj;
import dwlab.shapes.maps.TileSet;
import dwlab.visualizers.Color;
import dwlab.base.Image;
import dwlab.base.XMLObject;
import java.util.LinkedList;

public class EditorData extends Obj {
	public static EditorData current;

	public LinkedList<Image> images = new LinkedList<Image>();
	public LinkedList<TileSet> tilesets = new LinkedList<TileSet>();

	public int incbinValue;
	public Color backgroundColor = new Color( "FFFFFF" );
	public double gridCellWidth = 1d;
	public double gridCellHeight = 1d;
	public int gridCellXDiv = 2;
	public int gridCellYDiv = 2;
	
	public enum GridPositionSnappingMode {
		EDGES,
		CENTER,
		FIXED
	}
	
	public GridPositionSnappingMode gridPositionSnappingMode = GridPositionSnappingMode.EDGES;
	
	public enum GridResizingSnappingMode {
		EDGES,
		SIZE,
		FIXED
	}
	
	public GridResizingSnappingMode gridResizingSnappingMode = GridResizingSnappingMode.EDGES;
	
	public Color gridColor = new Color( "7FFF00FF" );
	public int collisionGridCellXDiv = 16;
	public int collisionGridCellYDiv = 16;

	@Override
	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		xMLObject.manageIntAttribute( "incbin", incbinValue );
		xMLObject.manageListField( "images", images );
		xMLObject.manageListField( "tilesets", tilesets );

		backgroundColor = xMLObject.manageObjectField( "background", backgroundColor );
		gridCellWidth = xMLObject.manageDoubleAttribute( "cell_width", gridCellWidth, 1d );
		gridCellHeight = xMLObject.manageDoubleAttribute( "cell_height", gridCellHeight, 1d );
		gridCellXDiv = xMLObject.manageIntAttribute( "x_div", gridCellXDiv );
		gridCellYDiv = xMLObject.manageIntAttribute( "y_div", gridCellYDiv );
		gridPositionSnappingMode = xMLObject.manageEnumAttribute( "position_snap", gridPositionSnappingMode );
		gridResizingSnappingMode = xMLObject.manageEnumAttribute( "resize_snap", gridResizingSnappingMode );
		gridColor = xMLObject.manageObjectField( "grid_color", gridColor );
		collisionGridCellXDiv = xMLObject.manageIntAttribute( "coll_x_div", collisionGridCellXDiv );
		collisionGridCellYDiv =xMLObject.manageIntAttribute( "coll_y_div", collisionGridCellYDiv );
	}
}
