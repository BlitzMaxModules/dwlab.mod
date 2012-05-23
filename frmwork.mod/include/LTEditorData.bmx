'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_EditorData:LTEditorData

Type LTEditorData Extends LTObject
	Const EdgesSnapping:Int = 0
	
	Const CenterSnapping:Int = 1
	Const FixedShifting:Int = 2
	
	Const SizeSnapping:Int = 1
	Const FixedResizing:Int = 2

	Field Images:TList = New TList
	Field Tilesets:TList = New TList
	
	Field IncbinValue:Int
	Field BackgroundColor:LTColor = LTColor.FromHex( "FFFFFF" )
	Field GridCellWidth:Double = 1.0
	Field GridCellHeight:Double = 1.0
	Field GridCellXDiv:Int = 2
	Field GridCellYDiv:Int = 2
	Field GridPositionSnappingMode:Int = EdgesSnapping
	Field GridResizingSnappingMode:Int = EdgesSnapping
	Field GridColor:LTColor = LTColor.FromHex( "FF00FF", 0.5 )
	Field CollisionGridCellXDiv:Int = 16
	Field CollisionGridCellYDiv:Int = 16

	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageIntAttribute( "incbin", IncbinValue )
		XMLObject.ManageListField( "images", Images )
		XMLObject.ManageListField( "tilesets", Tilesets )
		
		BackgroundColor = LTColor( XMLObject.ManageObjectField( "background", BackgroundColor ) )
		XMLObject.ManageDoubleAttribute( "cell_width", GridCellWidth )
		XMLObject.ManageDoubleAttribute( "cell_width", GridCellHeight )
		XMLObject.ManageIntAttribute( "x_div", GridCellXDiv )
		XMLObject.ManageIntAttribute( "y_div", GridCellYDiv )
		XMLObject.ManageIntAttribute( "position_snap", GridPositionSnappingMode )
		XMLObject.ManageIntAttribute( "resize_snap", GridResizingSnappingMode )
		GridColor = LTColor( XMLObject.ManageObjectField( "grid_color", GridColor ) )
		XMLObject.ManageIntAttribute( "coll_x_div", CollisionGridCellXDiv )
		XMLObject.ManageIntAttribute( "coll_y_div", CollisionGridCellYDiv )
	End Method
End Type