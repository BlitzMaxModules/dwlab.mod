' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Type LTUseAlpha Extends LTVisual
	Field Alpha:Float
	
	
	
	Method UseWith( Actor:LTActor )
		Local OldAlpha:Int =GetAlpha()
		SetAlpha( Alpha )
		NextVisual.UseWith( Actor )
		SetAlpha( OldAlpha )
	End Method
End Type