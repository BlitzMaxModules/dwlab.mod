'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTWaitingModel Extends LTTemporaryModel
	Function Create:LTWaitingModel( Time:Double, NextModel:LTBehaviorModel )
		Local Model:LTWaitingModel = New LTWaitingModel
		Model.Period = Time
		Model.NextModel = NextModel
		Return Model
	End Function
End Type