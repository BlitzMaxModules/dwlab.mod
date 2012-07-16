'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global Box2DObjects:TList = New TList

Rem
bbdoc: 
about: 

See also: #LTVectorSprite
End Rem
Type LTBox2DSprite Extends LTVectorSprite
	Field Body:b2Body
	Field ListLink:TLink
	
	
	Method Init()
		UpdateFromAngularModel()
		ListLink = Box2DObjects.AddLast( Self )
		Local Def:b2BodyDef = New b2BodyDef
		Select GetParameter( "type" )
			Case "kinematic"
				Def.SetType( b2_kinematicBody )
			Case "static"
				Def.SetType( b2_staticBody )
			Default
				Def.SetType( b2_dynamicBody )
		End Select
		Def.SetPosition( New b2Vec2.Create( X, Y ) )
		Def.SetLinearVelocity( New b2Vec2.Create( DX, DY ) )
		Def.SetAngle( DisplayingAngle )
		Body = New b2World.CreateBody( Def )
	End Method
	
	
	
	Method SetCoords( NewX:Double, NewY:Double )

	End Method
	
	
	
	Method Update()
		Local Vector:b2Vec2 = Body.GetPosition()
		X = Vector.X()
		Y = Vector.Y()
		Vector = Body.GetLinearVelocity()
		DX = Vector.X()
		DY = Vector.Y()
		UpdateAngularModel()
		DisplayingAngle = Body.GetAngle()
	End Method
	
	
	
	Method Destroy()
		ListLink.Remove()
	End Method
End Type