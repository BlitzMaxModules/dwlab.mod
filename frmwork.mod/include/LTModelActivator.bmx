'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: This model activates another model.
about: If you will set Permanent parameter to True, activator will not be instantly removed after doing its job.
End Rem
Type LTModelActivator Extends LTBehaviorModel
	Field Model:LTBehaviorModel
	Field Permanent:Int

	
	
	Function Create:LTModelActivator( Model:LTBehaviorModel, Permanent:Int = False )
		Local Activator:LTModelActivator = New LTModelActivator
		Activator.Model = Model
		Activator.Permanent = Permanent
		Return Activator
	End Function
	
	
	
	Method ApplyTo( Shape:LTShape )
		Model.ActivateModel( Shape )
		If Not Permanent Then Remove( Shape )
	End Method
	
	
	
	Method Info:String( Shape:LTShape )
		If Model Then Return "activate " + TTypeID.ForObject( Model ).Name()
	End Method
End Type