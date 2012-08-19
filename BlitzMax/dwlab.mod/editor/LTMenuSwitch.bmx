'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_MenuSwicthes:TList = New TList

Rem
bbdoc: Class for switchable menu items connected with corresponding toolbar buttons.
EndRem
Type LTMenuSwitch
	Field Toolbar:TGadget
	Field MenuItem:TGadget
	Field MenuNumber:Int
	Field Store:Int
	
	
	
	Rem
	bbdoc: Creates new menu switch.
	returns: Menu switch
	about: You should provide menu text, toolbar gadget, menu number (which should also be a toolbar button number) and menu gadget.
	EndRem
	Function Create( Text:String, Toolbar:TGadget, MenuNumber:Int, Menu:TGadget, Store:Int = True )
		Local Switch:LTMenuSwitch = New LTMenuSwitch
		Switch.Toolbar = Toolbar
		Switch.MenuItem = CreateMenu( Text, MenuNumber, Menu )
		Switch.MenuNumber = MenuNumber
		Switch.Store = Store
		L_MenuSwicthes.AddLast( Switch )
	End Function
	
	
	
	Rem
	bbdoc: Searches for menu switch with given number.
	returns: Found menu switch
	EndRem
	Function Find:LTMenuSwitch( MenuNumber:Int )
		For Local Switch:LTMenuSwitch = EachIn L_MenuSwicthes
			If Switch.MenuNumber = MenuNumber Then Return Switch
		Next
	End Function
	
	
	
	Rem
	bbdoc: Reads menu switches states from specified file
	about: States will be stored as list of 0s and 1s.
	EndRem
	Function ReadSwitches( File:TStream )
		For Local Switch:LTMenuSwitch = EachIn L_MenuSwicthes
			If Switch.Store Then Switch.Set( ReadLine( File ) = "1" )
		Next
	End Function
	
	
	
	Rem
	bbdoc: Saves menu switches states to specified file.
	about: States will be stored as list of 0s and 1s.
	EndRem
	Function SaveSwicthes( File:TStream )
		For Local Switch:LTMenuSwitch = EachIn L_MenuSwicthes
			If Switch.Store Then WriteLine( File, Switch.State() )
		Next
	End Function
	
	
	
	Rem
	bbdoc: Sets the state of menu switch to given.
	about: You should also provide variable which should store switch state.
	EndRem
	Method Set( ToState:Int )
		If ToState Then
			CheckMenu( MenuItem )
			If Toolbar Then SelectGadgetItem( Toolbar, MenuNumber )
		Else
			UncheckMenu( MenuItem )
			If Toolbar Then DeselectGadgetItem( Toolbar, MenuNumber )
		End If		
	End Method
	
	
	
	Rem
	bbdoc: Toggles state of menu switch.
	EndRem
	Method Toggle:Int()
		Set( 1 - State() )
		Return State()
	End Method
	
	
	
	Rem
	bbdoc: Returns state of menu switch.
	returns: State of menu switch.
	EndRem
	Method State:Int()
		Return MenuChecked( MenuItem )
	End Method
End Type
