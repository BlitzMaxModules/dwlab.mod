'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

Global Editor:LTEditor = New LTEditor
Editor.Execute()

Type LTEditor Extends LTProject
	Field Window:TGadget
	Field Canvas:TGadget
	Field ResourcesTree:TGadget
	Field Icons:TIconStrip
	Field Toolbar:TGadget
	Field NodeMenu:TGadget
	Field SelectingListWindow:TGadget
	Field SelectingList:TGadget
	
	
	
	Const NewShape:Int = 1
	Const NewVisual:Int = 2
	Const NewFolder:Int = 3
	Const DeleteNode:Int = 4
	
	
	
	Method Init()
		Window = CreateWindow( "Digital Wizard's Lab Editor", 10, 10, 800, 600 )
		
		ResourcesTree = CreateTreeView( 0, 0, 250, 523, Window )
		Icons = LoadIconStrip( L_EditorPath + "\icons.png" )
		Canvas = CreateCanvas( 250, 0, 550, 523, Window )
		SetGraphics( CanvasGraphics( Canvas ) )
		
		SetGadgetIconStrip( ResourcesTree, Icons )
		AddTreeViewNode( "Resources", TreeViewRoot( ResourcesTree ), 0 )
		
		Icons = LoadIconStrip( L_EditorPath + "\toolbar.png" )
		Toolbar = CreateToolbar( Icons, 0, 0, 550, 20, Window )
		AddGadgetItem( Toolbar, "", , 0 )
		
		NodeMenu = CreateMenu( "nodemenu", 0, Null )
		CreateMenu( "New shape", NewShape, NodeMenu )
		CreateMenu( "New visual", NewVisual, NodeMenu )
		CreateMenu( "New folder", NewFolder, NodeMenu )
		CreateMenu( "Delete", DeleteNode, NodeMenu )
	End Method
	
	
	
	Method Logic()
		Select WaitEvent()
			Case Event_WindowClose
				End
			Case Event_KeyDown
				If EventData() = Key_Escape Then End
			Case Event_GadgetMenu
				PopupWindowMenu( Window, NodeMenu )
			Case Event_MenuAction
				Select EventData()
					Case NewShape
						'SelectingListWindow = CreateWindow( "Select shape type" )
				End Select
		End Select
	End Method
End Type