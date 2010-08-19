' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Include "Collisions.bmx"

Type LTModel Extends LTObject
	Method CollisionWith:Int( Model:LTModel )
	End Method
	
	
	
	Method CollisionWithPivot:Int( Pivot:LTPivot )
	End Method
	
	
	
	Method CollisionWithCircle:Int( Circle:LTCircle )
	End Method
	
	
	
	Method CollisionWithRectangle:Int( Rectangle:LTRectangle )
	End Method
End Type





Type LTPivot Extends LTModel Abstract
	Field X:Float, Y:Float
	
	
	
	Method CollisionWith:Int( Model:LTModel )
		Return Model.CollideWithPivot( Self )
	End Method
	
	
	
	Method CollisionWithPivot:Int( Pivot:LTPivot )
		If X = Pivot.X And Y = Pivot.Y Then
			Return True
		Else
			Return False
		End If
	End Method
	
	
	
	Method CollisionWithCircle:Int( Circle:LTCircle )
		If ( X - Circle.X ) * ( X - Circle.X ) + ( Y - Circle.Y ) * ( Y - Circle.Y ) <= 0.25 * Circle.Diameter * Circle.Diameter Then
			Return True
		Else
			Return False
		End If
	End Method
	
	
	
	Method CollisionWithRectangle:Int( Rectangle:LTRectangle )
		If Abs( X - Rectangle.X ) <= 0.5 * Rectangle.XSize And Abs( Y - Rectangle.Y ) <= 0.5 * Rectangle.YSize Then
			Return True
		Else
			Return False
		End If
	End Method
End Type





Type LTCircle Extends LTPivot Abstract
	Field Diameter:Float

	' ==================== Collisions ===================
	
	Method Collision( Models:LTObject, Reaction:LTModule )
		For Local Model:LTModel = EachIn Models
			If Model <> Self Then Model.CollisionWithCircle( Self, Reaction )
		Next
	End Method

	
	
	Method CollisionWithPivot( Piv:LTPivot, Reaction:LTModule )
		If L_PivotWithCircle( Piv, Self ) Then
			L_ObjVar.Obj = Self
			Reaction.Execute( Piv )
		End If
	End Method

	
	
	Method CollisionWithCircle( Circ:LTCircle, Reaction:LTModule )
		If L_CircleWithCircle( Circ, Self ) Then
			L_ObjVar.Obj = Self
			'debugstop
			Reaction.Execute( Circ )
		End If
	End Method
	
	
	
	Method CollisionWithBox( Box:LTBox, Reaction:LTModule )
		If L_CircleWithBox( Self, Box ) Then
			L_ObjVar.Obj = Self
			Reaction.Execute( Box )
		End If
	End Method
	
	' ==================== Pushing ====================
	
	Method Push( Mdl:LTModel )
		Mdl.PushCircle( Self )
	End Method


	
	Method PushCircle( Circ:LTCircle )
		Local DX:Float = Circ.X - X
		Local DY:Float = Circ.Y - Y
		Local K:Float = 0.5 * ( Circ.Diameter + Diameter ) / Sqr( DX * DX + DY * DY ) - 1.0
		
		Local MassSum:Float = Mass + Circ.Mass
		Local K1:Float, K2:Float
		If MassSum Then
			K1 = K * ( Mass / MassSum )
			K2 = K * ( Circ.Mass / MassSum )
		Else
			K1 = K * 0.5
			K2 = K * 0.5
		End If
		
		'debugstop
		
		Circ.X :+ K1 * DX
		Circ.Y :+ K1 * DY
		X = X - K2 * DX
		Y = Y - K2 * DY
	End Method

	
	
	Method PushBox( Box:LTBox )
		Local DX:Float, DY:Float
		
		If X > Box.X - 0.5 * Box.XSize And X < Box.X + 0.5 * Box.XSize Then
			DY = ( 0.5 * ( Box.YSize + Diameter ) - Abs( Box.Y - Y ) ) * Sgn( Box.Y - Y )
		ElseIf Y > Box.Y - 0.5 * Box.YSize And Y < Box.Y + 0.5 * Box.YSize Then
			DX = ( 0.5 * ( Box.XSize + Diameter ) - Abs( Box.X - X ) ) * Sgn( Box.X - X )
		Else
			Local PX:Float = Box.X + 0.5 * Box.XSize * Sgn( X - Box.X )
			Local PY:Float = Box.Y + 0.5 * Box.YSize * Sgn( Y - Box.Y )
			Local K:Float = 1.0 - 0.5 * Diameter / Sqr( ( X - PX ) * ( X - PX ) + ( Y - PY ) * ( Y - PY ) )
			DX = ( X - PX ) * K
			DY = ( Y - PY ) * K
		End If
		
		Local MassSum:Float = Box.Mass + Mass
		Local K1:Float, K2:Float
		
		If MassSum Then
			K1 = Mass / MassSum
			K2 = Box.Mass / MassSum
		Else
			K1 = 0.5
			K2 = 0.5
		End If
		
		'debugstop
		
		Box.X :+ K1 * DX
		Box.Y :+ K1 * DY
		X = X - K2 * DX
		Y = Y - K2 * DY
	End Method
End Type





Type LTRectangle Extends LTPivot Abstract
	Field XSize:Float
	Field YSize:Float

	' ==================== Collisions ===================
	
	Method Collision( Models:LTObject, Reaction:LTModule )
		For Local Model:LTModel = EachIn Models
			If Model <> Self Then Model.CollisionWithRectangle( Self, Reaction )
		Next
	End Method

	
	
	Method CollisionWithPivot( Piv:LTPivot, Reaction:LTModule )
		If L_PivotWithRectangle( Piv, Self ) Then
			L_ObjVar.Obj = Self
			Reaction.Execute( Piv )
		End If
	End Method

	
	
	Method CollisionWithCircle( Circ:LTCircle, Reaction:LTModule )
		If L_CircleWithRectangle( Circ, Self ) Then
			L_ObjVar.Obj = Self
			Reaction.Execute( CIrc )
		End If
	End Method
	
	
	
	Method CollisionWithRectangle( Rectangle:LTRectangle, Reaction:LTModule )
		If L_RectangleWithRectangle( Rectangle, Self ) Then
			L_ObjVar.Obj = Self
			Reaction.Execute( Rectangle )
		End If
	End Method
	
	' ==================== Pushing ====================
	
	Method Push( Mdl:LTModel )
		Mdl.PushRectangle( Self )
	End Method


	
	Method PushCircle( Circ:LTCircle )
		Circ.PushRectangle( Self )
	End Method

	
	
	Method PushRectangle( Rectangle:LTRectangle )
		Local DX:Float = 0.5 * ( Rectangle.XSize + XSize ) - Abs( Rectangle.X - X )
		Local DY:Float = 0.5 * ( Rectangle.YSize + YSize ) - Abs( Rectangle.Y - Y )
		
		Local MassSum:Float = Mass + Rectangle.Mass
		Local K1:Float = 0.5
		Local K2:Float = 0.5		
		If MassSum Then
			K1 = Mass / MassSum
			K2 = Rectangle.Mass / MassSum
		End If
		
		'debugstop
		If DX < DY Then
			Rectangle.X :+ K1 * DX * Sgn( Rectangle.X - X )
			X :- K2 * DX * Sgn( Rectangle.X - X )
		Else
			Rectangle.Y :+ K1 * DY * Sgn( Rectangle.Y - Y )
			Y :- K2 * DY * Sgn( Rectangle.Y - Y )
		End If
	End Method
End Type