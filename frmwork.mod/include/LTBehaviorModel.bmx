'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTTemporaryModel.bmx"
Include "CommandModels.bmx"
Include "LTModelStack.bmx"
Include "LTAnimationModel.bmx"
Include "LTConditionalModel.bmx"
Include "Joints.bmx"

Rem
bbdoc: Behavior model is the object which can be attached to the shape and affect its state.
End Rem
Type LTBehaviorModel Extends LTObject
	Field Active:Int
	Field Link:TLink
	
	
	
	Rem
	bbdoc: Initialization method.
	about: It will be executed when model will be attached to shape.
	Fill it with model initialization commands. 
	End Rem
	Method Init( Shape:LTShape )
	End Method
	
	
	
	Rem
	bbdoc: Activation method.
	about: It will be executed when model will be activated (and when attached too if you didn't set activation flag to False).
	
	See also: #Deactivate, #ActivateAllModels, #DeactivateAllModels, #ActivateModel, #DeactivateModel
	End Rem
	Method Activate( Shape:LTShape )
	End Method
	
	
	
	Rem
	bbdoc: Deactivation method.
	about: It will be executed when model will be activated (and when removed too if it was active).
	
	See also: #Activate, #ActivateAllModels, #DeactivateAllModels, #ActivateModel, #DeactivateModel
	End Rem
	Method Deactivate( Shape:LTShape )
	End Method
	
	
	
	Rem
	bbdoc: Watching method.
	about: This method will be executed by shape default Act() method if the model will be inactive.
	Fill it with commands which will check certain conditions and activate model.
	
	See also: #ApplyTo, #Act
	End Rem
	Method Watch( Shape:LTShape )
	End Method
	
	
	
	Rem
	bbdoc: Model applying method.
	about: This method will be executed by shape default Act() method if the model will be active.
	Fill it with commands which are affect shape in the way of corresponding behavior.
	
	See also: #Watch, #Act
	End Rem
	Method ApplyTo( Shape:LTShape )
	End Method
	
	
	
	Rem
	bbdoc: Activates behavior model.
	about: For use inside model's methods.
	
	See also: #Activate, #Deactivate, #ActivateAllModels, #DeactivateAllModels, #DeactivateModel
	End Rem
	Method ActivateModel( Shape:LTShape ) Final
		If Not Active Then
			Activate( Shape )
			Active = True
		End If
	End Method
	
	
	
	Rem
	bbdoc: Deactivates behavior model.
	about: For use inside model's methods.
	
	See also: #Activate, #Deactivate, #ActivateAllModels, #DeactivateAllModels, #ActivateModel
	End Rem
	Method DeactivateModel( Shape:LTShape ) Final
		If Active Then
			Deactivate( Shape )
			Active = False
		End If
	End Method
	
	
	
	Rem
	bbdoc: Removes behavior model.
	about: Model will be deactivated before removal.
	
	See also: #Deactivate
	End Rem
	Method Remove( Shape:LTShape ) Final
		If Active Then DeactivateModel( Shape )
		If Link Then Link.Remove()
	End Method
	
	
	
	Rem
	bbdoc: Removes every other behavior model of same type from shape's behavior models.
	about: See also: #Remove
	End Rem
	Method RemoveSame( Shape:LTShape ) Final
		Local TypeID:TTypeId = TTypeId.ForObject( Self )
		For Local Model:LTBehaviorModel = Eachin Shape.BehaviorModels
			If TTypeId.ForObject( Model ) = TypeID And Model <> Self Then Model.Remove( Shape )
		Next
	End Method
	
	
	
	Method Info:String( Shape:LTShape )
	End Method
End Type