'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_DefaultJointList:TList = New TList
Global L_JointList:TList = L_DefaultJointList

Function L_SetJointList( List:TList = Null )
	If List = Null Then
		L_JointList = L_DefaultJointList
	Else
		L_JointList = List
	End If
End Function





Function L_OperateJoints( List:TList )
	For Local Joint:LTJoint = Eachin List
		Joint.Operate()
	Next
End Function





Type LTJoint Extends LTObject
	Method Operate()
	End Method
End Type