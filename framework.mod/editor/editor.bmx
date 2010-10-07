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
	Field Window:TWindow
	
	Field NewMenuItem:TGadget
	Field OpenMenuItem:TGadget
	Field SaveMenuItem:TGadget
	Field SaveAsMenuItem:TGadget
	Field ImportTileMap:TGadget
	Field ImportTiles:TGadget
	Field ExitMenuItem:TGadget
	
	Field ExitMenuItem:TGadget
	
	Field TileMap:LTTileMap
	Field Objects:LTList
	
	
	
	Method Init()
		TileMap = LTTileMap.Create( 16, 16, 16, 16, 16 )
		Objects = New LTList
		
		Window  = CreateWindow( "", 0, 0, 100, 100 )
		MaximizeWindow( Window )
		
		Local FileMenu:TGadget = CreateMenu( "File", 0, WindowMenu( Window ) )
		Local EditMenu:TGadget = CreateMenu( "Edit", 0, WindowMenu( Window ) )
		
	End Method
	
	
	
	Method Logic()
	End Method
End Type