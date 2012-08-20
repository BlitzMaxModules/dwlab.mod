package dwlab.layers;
import java.util.LinkedList;
import dwlab.base.XMLObject;
import dwlab.base.Obj;
import dwlab.visualizers.Color;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

public EditorData editorData;

public class EditorData extends Obj {
	public final int edgesSnapping = 0;

	public final int centerSnapping = 1;
	public final int fixedShifting = 2;

	public final int sizeSnapping = 1;
	public final int fixedResizing = 2;

	public LinkedList images = new LinkedList();
	public LinkedList tilesets = new LinkedList();

	public int incbinValue;
	public Color backgroundColor = Color.fromHex( "FFFFFF" );
	public double gridCellWidth = 1.double 0;
	public double gridCellHeight = 1.double 0;
	public int gridCellXDiv = 2;
	public int gridCellYDiv = 2;
	public int gridPositionSnappingMode = edgesSnapping;
	public int gridResizingSnappingMode = edgesSnapping;
	public Color gridColor = Color.fromHex( "FF00FF", 0.5 );
	public int collisionGridCellXDiv = 16;
	public int collisionGridCellYDiv = 16;

	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		xMLObject.manageIntAttribute( "incbin", incbinValue );
		xMLObject.manageListField( "images", images );
		xMLObject.manageListField( "tilesets", tilesets );

		backgroundColor = Color( xMLObject.manageObjectField( "background", backgroundColor ) );
		xMLObject.manageDoubleAttribute( "cell_width", gridCellWidth, 1.double 0 );
		xMLObject.manageDoubleAttribute( "cell_height", gridCellHeight, 1.double 0 );
		xMLObject.manageIntAttribute( "x_div", gridCellXDiv );
		xMLObject.manageIntAttribute( "y_div", gridCellYDiv );
		xMLObject.manageIntAttribute( "position_snap", gridPositionSnappingMode );
		xMLObject.manageIntAttribute( "resize_snap", gridResizingSnappingMode );
		gridColor = Color( xMLObject.manageObjectField( "grid_color", gridColor ) );
		xMLObject.manageIntAttribute( "coll_x_div", collisionGridCellXDiv );
		xMLObject.manageIntAttribute( "coll_y_div", collisionGridCellYDiv );
	}
}
