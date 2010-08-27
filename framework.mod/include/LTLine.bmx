'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTLine Extends LTShape
	Field Pivot:LTPivot[] = New LTPivot[ 2 ]
	
	Method Create:LTLine( Pivot1:LTPivot, Pivot2:LTPivot )
		Local Line:LTLine = New LTLine
		Line.Pivot[ 0 ] = Pivot1
		Line.Pivot[ 1 ] = Pivot2
		Return Line
	End Method
	
	' ==================== Drawing ===================	
	
	Method Draw()
		Visual.DrawUsingLine( Self )
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
		Vis.DrawUsingLine( Self )
	End Method
	
	' ==================== Collisions ===================
	
	Method Collides:Int( Shape:LTShape )
		Return Shape.CollidesWithLine( Self )
	End Method
	
	
	
	Method CollidesWithCircle:Int( Circle:LTCircle )
		Return L_CircleWithLine( Circle, Self )
	End Method

	' ==================== Other ====================

	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		Pivot[ 0 ] = LTPivot( XMLObject.ManageObjectField( "piv0", Pivot[ 0 ] ) )
		Pivot[ 1 ] = LTPivot( XMLObject.ManageObjectField( "piv1", Pivot[ 1 ] ) )
	End Method
End Type