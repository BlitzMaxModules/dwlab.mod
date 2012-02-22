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
Include "LTAnimationModel.bmx"
Include "LTMovingModel.bmx"
Include "LTFollowingModel.bmx"

Type LTChainedModel Extends LTBehaviorModel
	Field NextModels:TList = New TList
	
	
	
	Method Deactivate( Shape:LTShape )
		Shape.AttachModels( NextModels )
	End Method
End Type