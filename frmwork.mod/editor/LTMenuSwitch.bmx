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

Type LTMenuSwitch Extends LTObject
	Field MenuItem:TGadget
	Field MenuNumber:Int
	
	
	
	Function Create( Text:String, MenuNumber:Int, Menu:TGadget )
		Local Switch:LTMenuSwitch = New LTMenuSwitch
		Switch.MenuItem = CreateMenu( Text, MenuNumber, Menu )
		Switch.MenuNumber = MenuNumber
		L_MenuSwicthes.AddLast( Switch )
	End Function
	
	
	
	Function Find:LTMenuSwitch( MenuNumber:Int )
		For Local Switch:LTMenuSwitch = Eachin L_MenuSwicthes
			If Switch.MenuNumber = MenuNumber Then Return Switch
		Next
	End Function
	
	
	
	Function ReadSwitches( File:TStream )
		For Local Switch:LTMenuSwitch = Eachin L_MenuSwicthes
			Local Dummy:Int
			Switch.Set( ReadLine( File ) = "1", Dummy )
		Next
	End Function
	
	
	
	Function SaveSwicthes( File:TStream )
		For Local Switch:LTMenuSwitch = Eachin L_MenuSwicthes
			WriteLine( File, Switch.State() )
		Next
	End Function
	
	
	
	Method Set( ToState:Int, Variable:Int Var )
		Variable = ToState
		If ToState Then
			CheckMenu( MenuItem )
			SelectGadgetItem( Editor.Toolbar, MenuNumber )
		Else
			UncheckMenu( MenuItem )
			DeselectGadgetItem( Editor.Toolbar, MenuNumber )
		End If		
	End Method
	
	
	
	Method Toggle( Variable:Int Var )
		Set( 1 - State(), Variable )
	End Method
	
	
	
	Method State:Int()
		Return MenuChecked( MenuItem )
	End Method
End Type
