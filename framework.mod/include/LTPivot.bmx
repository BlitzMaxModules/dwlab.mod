' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Type LTPivot Extends LTModel
	Field X:Float, Y:Float
	
	
	
	Method Draw()
		Visual.DrawUsingPivot( Self )
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
		Vis.DrawUsingPivot( Self )
	End Method
	
	' ==================== Collidess ===================
	
	Method CollidesWith:Int( Model:LTModel )
		Return Model.CollidesWithPivot( Self )
	End Method

	
	
	Method CollidesWithPivot:Int( Piv:LTPivot )
		If L_PivotWithPivot( Self, Piv ) Then Return True
	End Method

	
	
	Method CollidesWithCircle:Int( Circ:LTCircle )
		If L_PivotWithCircle( Self, Circ ) Then Return True
	End Method
	
	
	
	Method CollidesWithRectangle:Int( Rectangle:LTRectangle )
		If L_PivotWithRectangle( Self, Rectangle ) Then Return True
	End Method
	
	' ==================== Other ====================
	
	Method SetMouseCoords()
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), X, Y )
	End Method



	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageFloatAttribute( "x", X )
		XMLObject.ManageFloatAttribute( "y", Y )
	End Method
End Type