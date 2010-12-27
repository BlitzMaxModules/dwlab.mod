'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

SeedRnd( Millisecs() )

Const L_Version:String = "0.11"

Include "include/LTObject.bmx"
Include "include/LTProject.bmx"
Include "include/LTWorld.bmx"
Include "include/LTMap.bmx"
Include "include/LTActiveObject.bmx"
Include "include/LTVisualizer.bmx"
Include "include/LTText.bmx"
Include "include/LTSound.bmx"
Include "include/LTPath.bmx"
Include "include/LTDrag.bmx"
Include "include/LTAction.bmx"
Include "include/LTXML.bmx"
Include "include/Service.bmx"





Function L_Assert( Condition:Int, Text:String )
	If Not Condition Then
		Notify( Text, True )
		DebugStop
		End
	End If
End Function