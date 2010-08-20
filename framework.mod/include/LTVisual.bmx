' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Include "LTImage.bmx"
Include "LTUseColor.bmx"
Include "LTUseAlpha.bmx"
Include "LTUseFrame.bmx"

Type LTVisual Extends LTObject
	Field NextVisual:LTVisual
	
	
	
	Method Attach:LTVisual( Visual:LTVisual )
		Visual.NextVisual = Self
		Return Visual
	End Method
	
	
	
	Method UseWith( Actor:LTActor )
	End Method
	
	
	
	Method DrawUsingPivot( Pivot:LTPivot )
	End Method
	
	
	
	Method DrawUsingCircle( Circle:LTCircle )
	End Method
	
	
	
	Method DrawUsingRectangle( Rectangle:LTRectangle )
	End Method
	
	
	
	Method DrawUsingLine( Line:LTLine )
	End Method
End Type