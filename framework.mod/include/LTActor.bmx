' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Include "LTModel.bmx"
Include "LTShape.bmx"
Include "LTBehavior.bmx"
Include "LTVisual.bmx"

Type LTActor Extends LTObject
	Field Model:LTModel
	Field Shape:LTShape
	Field Visual:LTVisual
	Field Behavior:LTBehavior
	
	
	
	Method Draw()
		Visual.UseWith( Self )
	End Method
End Type





Type LTGroup Extends LTObject
End Type