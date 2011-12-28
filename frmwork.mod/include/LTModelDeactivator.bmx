'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTModelDeactivator Extends LTBehaviorModel
	Field Model:LTBehaviorModel
	Field Permanent:Int

	
	
	Function Create:LTModelDeactivator( Model:LTBehaviorModel, Permanent:Int = False )
		Local Deactivator:LTModelDeactivator = New LTModelDeactivator
		Deactivator.Model = Model
		Deactivator.Permanent = Permanent
		Return Deactivator
	End Function
	
	
	
	Method ApplyTo( Shape:LTShape )
		Model.DeactivateModel( Shape )
		If Not Permanent Then Remove( Shape )
	End Method
	
	
	
	Method Info:String( Shape:LTShape )
		If Model Then Return "deactivate " + TTypeID.ForObject( Model ).Name()
	End Method
End Type