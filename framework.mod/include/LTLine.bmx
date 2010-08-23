' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Type LTLine Extends LTModel
	Field Pivot:LTPivot[] = New LTPivot[ 2 ]
	
	
	
	Method Draw()
		Visual.DrawUsingLine( Self )
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
		Vis.DrawUsingLine( Self )
	End Method



	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		Pivot[ 0 ] = LTPivot( XMLObject.ManageObjectField( "piv0", Pivot[ 0 ] ) )
		Pivot[ 1 ] = LTPivot( XMLObject.ManageObjectField( "piv1", Pivot[ 1 ] ) )
	End Method
End Type