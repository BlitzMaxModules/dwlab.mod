'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTFixedJoint.bmx"
Include "LTRevoluteJoint.bmx"

Global L_JointList:TList = New TList
Global L_JointLinksList:TList

Function L_AddJoint( Joint:LTJoint )
	If L_JointLinksList Then
		L_JointLinksList.AddLast( L_JointList.AddLast( Joint ) )
	Else
		L_JointList.AddLast( Joint )
	End If
End Function





Function L_SetJointLinksList( List:TList )
	L_JointLinksList = List
End Function





Function L_DeleteJoints( Links:TList )
	For Local Link:TLink = Eachin Links
		Link.Remove()
	Next
End Function





Type LTJoint Extends LTObject
	Method Operate()
	End Method
End Type