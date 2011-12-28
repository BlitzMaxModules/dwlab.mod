'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTModelStack Extends LTBehaviorModel
	Field Models:TList = New TList

	
	
	Method ApplyTo( Shape:LTShape )
		For Local Model:LTBehaviorModel = EachIn Models
			If Model.Active Then
				Model.ApplyTo( Shape )
				Exit
			End If
		Next
	End Method
	
	
	
	Method Add( Model:LTBehaviorModel, Activated:Int = True )
		Model.Init( Null )
		Model.Link = Models.AddLast( Model )
		If Activated Then
			Model.Activate( Null )
			Model.Active = True
		End If
	End Method
	
	
	
	Method Info:String( Shape:LTShape )
		Local N:Int = 1
		For Local Model:LTBehaviorModel = EachIn Models
			If Model.Active Then
				Return "" + N + "th of " + Models.Count() + " models is active"
				Exit
			End If
			N :+ 1
		Next
		Return "no active models of " + Models.Count()
	End Method
End Type