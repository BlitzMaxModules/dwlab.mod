' Copyright (c) 2012 Michaël Lievens
' 
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.
' 
SuperStrict

Rem
bbdoc: Box2D
End Rem
Module dwlab.box2d

ModuleInfo "Version: 1.00"
ModuleInfo "License: MIT"
ModuleInfo "Copyright: Box2D (c) 2006-2012 Erin Catto http://box2d.org/"
ModuleInfo "Copyright: BlitzMax port - 2012 Michaël Lievens"

ModuleInfo "History: Updated to revision 249 - http://box2d.googlecode.com/svn/trunk/"
ModuleInfo "History: 1.00 Initial Release"

Import brl.system
Import "common.bmx"


Function SignedShortToInt:Int(signedShort:Short)
  Return (signedShort Shl 16) Sar 16
End Function

Function b2Cross:Float(a:b2Vec2, b:b2Vec2)
  return a.X() * b.Y() - a.Y() * b.X()
End Function

Function b2CrossVectorScalar:b2Vec2(vector:b2Vec2, scalar:Float)
  return Vec2(scalar * vector.Y(), -scalar * vector.X())
End Function

Function b2CrossScalarVector:b2Vec2(scalar:Float, vector:b2Vec2)
  return Vec2(-scalar * vector.Y(), scalar * vector.X())
End Function

' ***********************************************************************************************************
' Type: b2AABB
' ***********************************************************************************************************

Rem
bbdoc: An axis aligned bounding box.
End Rem
Type b2AABB

  Field b2ObjectPtr:Byte Ptr 

  Rem
  bbdoc: Creates a new AABB
  End Rem
  Function CreateAABB:b2AABB(lowerBound:b2Vec2 = Null, upperBound:b2Vec2 = Null)
    Return New b2AABB.Create(lowerBound, upperBound)
  End Function
  
  Rem
  bbdoc: Creates a new AABB
  End Rem
  Method Create:b2AABB(lowerBound:b2Vec2 = Null, upperBound:b2Vec2 = Null)
    If lowerBound Then
      If upperBound Then
        b2ObjectPtr = bmx_b2aabb_create(lowerBound.b2ObjectPtr, upperBound.b2ObjectPtr)
      Else
        b2ObjectPtr = bmx_b2aabb_create(lowerBound.b2ObjectPtr, Null)
      End If
    Else
      If upperBound Then
        b2ObjectPtr = bmx_b2aabb_create(Null, upperBound.b2ObjectPtr)
      Else
        b2ObjectPtr = bmx_b2aabb_create(Null, Null)
      End If
    End If
    Return Self
  End Method

  Method Delete()
    If b2ObjectPtr Then
      bmx_b2aabb_delete(b2ObjectPtr)
      b2ObjectPtr = Null
    End If
  End Method
  
  Rem
  bbdoc: Returns the @lowerBound and @upperBound b2Vec2.
  End Rem
  Method Get(lowerBound:b2Vec2 Var, upperBound:b2Vec2 Var)
    bmx_b2aabb_get(b2ObjectPtr, lowerBound.b2ObjectPtr, upperBound.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Sets the lower and the upper bound vertex.
  End Rem
  Method Set(lowerBound:b2Vec2, upperBound:b2Vec2)
    bmx_b2aabb_set(b2ObjectPtr, lowerBound.b2ObjectPtr, upperBound.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Returns the @lowerBound b2Vec2.
  End Rem
  Method GetLowerBound:b2Vec2()
    Return b2Vec2._create(bmx_b2aabb_getlowerbound(b2ObjectPtr))
  End Method
        
  Rem
  bbdoc: Sets the lower bound vertex.
  End Rem
  Method SetLowerBound(lowerBound:b2Vec2)
    bmx_b2aabb_setlowerbound(b2ObjectPtr, lowerBound.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Returns the @upperBound b2Vec2.
  End Rem
  Method GetUpperBound:b2Vec2()
    Return b2Vec2._create(bmx_b2aabb_getupperbound(b2ObjectPtr))
  End Method
  
  Rem
  bbdoc: Sets the upper bound vertex.
  End Rem
  Method SetUpperBound(upperBound:b2Vec2)
    bmx_b2aabb_setupperbound(b2ObjectPtr, upperBound.b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Verify that the bounds are sorted. 
  End Rem
  Method IsValid:Int()
    Return bmx_b2aabb_isvalid(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Get the center of the AABB.
  End Rem
  Method GetCenter:b2Vec2()
    Return b2Vec2._create(bmx_b2aabb_getcenter(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Get the extents of the AABB (half-widths).
  End Rem
  Method GetExtents:b2Vec2()
    Return b2Vec2._create(bmx_b2aabb_getextents(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Get the perimeter length.
  End Rem
  Method GetPerimeter:Float()
    Return bmx_b2aabb_getperimeter(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Combine an AABB into this one.
  End Rem
  Method Combine(AABB:b2AABB)
    bmx_b2aabb_combine(b2ObjectPtr, AABB.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Combine two AABBs into this one.
  End Rem
  Method Combine2(AABB1:b2AABB, AABB2:b2AABB)
    bmx_b2aabb_combine2(b2ObjectPtr, AABB1.b2ObjectPtr, AABB2.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Does this AABB contain the provided @AABB. 
  End Rem
  Method Contains:Int(AABB:b2AABB)
    Return bmx_b2aabb_contains(b2ObjectPtr, AABB.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Ray Casting.
  End Rem
  Method RayCast:Int(rayCastOutput:b2RayCastOutput, rayCastInput:b2RayCastInput)
    Return bmx_b2aabb_raycast(b2ObjectPtr, rayCastOutput.b2ObjectPtr, rayCastInput.b2ObjectPtr)
  End Method
  
End Type



' ***********************************************************************************************************
' Type: b2Fixture
' ***********************************************************************************************************


Rem
bbdoc: A fixture is used to attach a shape to a body for collision detection.
about: A fixture inherits its transform from its parent.
Fixtures hold additional non-geometric data such as friction, collision filters, etc.
Fixtures are created via b2Body::CreateFixture.
<p>
Warning: You cannot reuse fixture.
</p>
End Rem
Type b2Fixture

  Field b2ObjectPtr:Byte Ptr
  Field userData:Object

  Function _create:b2Fixture(b2ObjectPtr:Byte Ptr)
    If b2ObjectPtr Then
      Local fixture:b2Fixture = b2Fixture(bmx_b2fixture_getmaxfixture(b2ObjectPtr))
      If Not fixture Then
        fixture = New b2Fixture
        fixture.b2ObjectPtr = b2ObjectPtr
      Else
        If Not fixture.b2ObjectPtr Then
          fixture.b2ObjectPtr = b2ObjectPtr
        EndIf
      End If
      Return fixture
    End If
  End Function

  Rem
  bbdoc: Get the type of the child shape. You can use this to down cast to the concrete shape.
  return: The shape type.<br>
  <ul>
  <li><b>e_circle</b> : Type - Circle.</li>
  <li><b>e_edge</b> : Type - Edge.</li>
  <li><b>e_polygon</b> : Type - Polygon.</li>
  <li><b>e_chain</b> : Type - Chain.</li>
  <li><b>e_typeCount</b> : Type - Reserved.</li>
  </ul>
  End rem
  Method GetType:Int()
    Return bmx_b2fixture_gettype(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Get the parent body of this fixture. This is NULL if the fixture is not attached.
  End rem
  Method GetBody:b2Body()
    Return b2Body._create(bmx_b2fixture_getbody(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Is this fixture a sensor (non-solid)?
  returns: True if the shape is a sensor.
  End Rem
  Method IsSensor:Int()
    Return bmx_b2fixture_issensor(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Test a point for containment in this fixture.
  about: @point: a point in world coordinates.
  returns: True if the point is inside the fixture.
  End Rem
  Method TestPoint:Int(point:b2Vec2)
    Return bmx_b2fixture_testpoint(b2ObjectPtr, point.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Get the user data that was assigned in the fixture.
  End Rem
  Method GetUserData:Object()
    Return userData
  End Method
  
  Rem
  bbdoc: Sets the user data.
  End Rem
  Method SetUserData(data:Object)
    userData = data
  End Method
  
End Type

' ***********************************************************************************************************
' Type: b2DestructionListener
' ***********************************************************************************************************

Rem
bbdoc: Joints and shapes are destroyed when their associated body is destroyed. 
about: Implement this listener so that you may nullify references to these joints and shapes. 
End Rem
Type b2DestructionListener

  Field b2ObjectPtr:Byte Ptr

  Method New()
    b2ObjectPtr = bmx_b2destructionlistener_create(Self)
  End Method

  Rem
  bbdoc: Called when any joint is about to be destroyed due to the destruction of one of its attached bodies. 
  End Rem
  Method SayGoodbyeJoint(joint:b2Joint)
  End Method

  Function _SayGoodbyeJoint(listener:b2DestructionListener, joint:Byte Ptr)
    listener.SayGoodbyeJoint(b2Joint._create(joint))
  End Function
  
  Rem
  bbdoc: Called when any fixture is about to be destroyed due to the destruction of its parent body.
  End Rem
  Method SayGoodbyeShape(fixture:b2Fixture)
  End Method
  
  Function _SayGoodbyeFixture(listener:b2DestructionListener, fixture:Byte Ptr)
    listener.SayGoodbyeShape(b2Fixture._create(fixture))
  End Function

  Method Delete()
    If b2ObjectPtr Then
      bmx_b2destructionlistener_delete(b2ObjectPtr)
      b2ObjectPtr = Null
    End If
  End Method

End Type

' ***********************************************************************************************************
' Type: b2QueryCallback
' ***********************************************************************************************************

Rem
bbdoc: Implement and register this type with a b2World to provide Callback class for AABB queries. 
about: See b2World::Query
End Rem
Type b2QueryCallback

  Field b2ObjectPtr:Byte Ptr

  Method New()
    b2ObjectPtr = bmx_b2querycallback_create(Self)
  End Method

  Rem
  bbdoc: Called for each fixture found in the query AABB.
  returns: false to terminate the query.
  End Rem
  Method ReportFixture:Int(fixture:b2Fixture)
    return bmx_b2querycallback_reportfixture(b2ObjectPtr, fixture.b2ObjectPtr)
  End Method

  Method _ReportFixture:Int(QueryCallback:b2QueryCallback, fixture:b2Fixture)
    return QueryCallback.ReportFixture(b2Fixture._create(fixture))
  End Method

End Type

' ***********************************************************************************************************
' Type: b2Draw
' ***********************************************************************************************************

Rem
bbdoc: Implement and register this type with a b2World to provide debug drawing of physics entities in your game. 
End Rem
Type b2Draw

  Field b2ObjectPtr:Byte Ptr

  Const e_shapeBit:Int = $0001        ' draw shapes
  Const e_jointBit:Int = $0002        ' draw joint connections
  Const e_aabbBit:Int = $0004       ' draw axis aligned bounding boxes
  Const e_pairBit:Int = $0008         ' draw broad-phase pairs
  Const e_centerOfMassBit:Int = $0010 ' draw center of mass frame
    
  Method New()
    b2ObjectPtr = bmx_b2draw_create(Self)
  End Method
  
  Rem
  bbdoc: Set the drawing flags.
  End Rem
  Method SetFlags(flags:Int)
    bmx_b2draw_setflags(b2ObjectPtr, flags)
  End Method
  
  Rem
  bbdoc: Get the drawing flags.
  End Rem
  Method GetFlags:Int()
    Return bmx_b2draw_getflags(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Append flags to the current flags.
  End Rem
  Method AppendFlags(flags:Int)
    bmx_b2draw_appendflags(b2ObjectPtr, flags)
  End Method
  
  Rem
  bbdoc: Clear flags from the current flags.
  End Rem
  Method ClearFlags(flags:Int)
    bmx_b2draw_clearflags(b2ObjectPtr, flags)
  End Method

  Rem
  bbdoc: Draw a closed polygon provided in CCW order. 
  End Rem
  Method DrawPolygon(vertices:b2Vec2[], color:b2Color) Abstract


  Function _DrawPolygon(obj:b2Draw, vertices:b2Vec2[], r:Int, g:Int, b:Int)
    obj.DrawPolygon(vertices, b2Color.Set(r, g, b))
  End Function
  
  Rem
  bbdoc: Draw a solid closed polygon provided in CCW order
  End Rem
  Method DrawSolidPolygon(vertices:b2Vec2[], color:b2Color) Abstract

  Function _DrawSolidPolygon(obj:b2Draw, vertices:b2Vec2[], r:Int, g:Int, b:Int)
    obj.DrawSolidPolygon(vertices, b2Color.Set(r, g, b))
  End Function

  Rem
  bbdoc: Draw a circle.
  End Rem
  Method DrawCircle(center:b2Vec2, radius:Float, color:b2Color) Abstract
  
  Rem
  bbdoc: Draw a solid circle.
  End Rem
  Method DrawSolidCircle(center:b2Vec2, radius:Float, axis:b2Vec2, color:b2Color) Abstract
  
  Function _DrawSolidCircle(obj:b2Draw, center:Byte Ptr, radius:Float, axis:Byte Ptr, r:Int, g:Int, b:Int)
    obj.DrawSolidCircle(b2Vec2._create(center), radius, b2Vec2._create(axis), b2Color.Set(r, g, b))
  End Function
  
  Rem
  bbdoc: Draw a line segment.
  End Rem
  Method DrawSegment(p1:b2Vec2, p2:b2Vec2, color:b2Color) Abstract

  Function _DrawSegment(obj:b2Draw, p1:Byte Ptr, p2:Byte Ptr, r:Int, g:Int, b:Int)
    obj.DrawSegment(b2Vec2._create(p1), b2Vec2._create(p2), b2Color.Set(r, g, b))
  End Function
  
  Rem
  bbdoc: Draw a transform. Choose your own length scale. @param xf a transform.
  End Rem
  Method DrawTransform(xf:b2Transform) Abstract

  Function _DrawTransform(obj:b2Draw, xf:b2Transform)
    obj.DrawTransform(xf)
  End Function


End Type

' ***********************************************************************************************************
' Type: b2Color
' ***********************************************************************************************************

Rem
bbdoc: Color for debug drawing.
about: Each value has the range [0,1]. 
End Rem
Type b2Color
  
  Field red:Int, green:Int, blue:Int

  Function Set:b2Color(r:Int, g:Int, b:Int)
    Local this:b2Color = New b2Color
    this.red = r
    this.green = g
    this.blue = b
    Return this
  End Function

End Type

' ***********************************************************************************************************
' Type: b2Rot
' ***********************************************************************************************************

Rem
bbdoc: A transform Rotation
End Rem
Type b2Rot

  Field b2ObjectPtr:Byte Ptr

  Rem
  bbdoc: Instantiates a new b2Rot Object.
  about: Default rotation transformation is set to zero.
  end Rem
  Method New()
    b2ObjectPtr = bmx_b2rot_create()
  End Method

  Function _create:b2Rot(b2ObjectPtr:Byte Ptr)
    If b2ObjectPtr Then
      Local this:b2Rot = New b2Rot
      this.b2ObjectPtr = b2ObjectPtr
      Return this
    End If
  End Function

  Rem
  bbdoc: Creates a new Rotation Transform using Degrees.
  End Rem
  Method Create:b2Rot(angle:float)
    b2ObjectPtr = bmx_b2rot_createrotation(angle)
    Return Self
  End Method
    
  Rem
  bbdoc: Creates a new Rotation Transform using Radian.
  End Rem
  Method CreateRad:b2Rot(angle:float)
    b2ObjectPtr = bmx_b2rot_createrotationrad(angle)
    Return Self
  End Method

  Rem
  bbdoc: Deletes a given b2Rot object
  endrem
  Method Delete()
    If b2ObjectPtr Then
      bmx_b2rot_delete(b2ObjectPtr)
      b2ObjectPtr = Null
    End If
  End Method

  Rem
  bbdoc: Set this to the identity rotation.
  End Rem
  Method SetIdentity()
    bmx_b2rot_setidentity(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Set using an angle in Degrees. 
  End Rem 
  Method Set(angle:Float)
    bmx_b2rot_set(b2ObjectPtr, angle)
  End Method
    
  Rem
  bbdoc: Set using an angle in Radian. 
  End Rem 
  Method SetRad(angle:Float)
    bmx_b2rot_setrad(b2ObjectPtr, angle)
  End Method

  Rem
  bbdoc: Returns the angle in Degrees.
  End Rem
  Method GetAngle:Float()
    Return bmx_b2rot_getangle(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Returns the angle in Radian.
  End Rem
  Method GetAngleRad:Float()
    Return bmx_b2rot_getanglerad(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Returns the x-axis.
  End Rem
  Method GetXAxis:b2Vec2()
    Return b2Vec2._create(bmx_b2rot_getxaxis(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Returns the y-axis. 
  End Rem 
  Method GetYAxis:b2Vec2()
    return b2Vec2._create(bmx_b2rot_getyaxis(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Returns the Sinus value in this b2Rot object.
  End Rem
  Method GetSinus:Float()
    return bmx_b2rot_getsinus(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Sets the Sinus value for this b2Rot object.
  End Rem
  Method SetSinus(sinus:Float)
    bmx_b2rot_setsinus(b2ObjectPtr, sinus)
  End Method
  
  Rem
  bbdoc: Returns the Cosinus value in this b2Rot object.
  End Rem
  Method GetCosinus:Float()
    return bmx_b2rot_getcosinus(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Sets the Cosinus value for this b2Rot object.
  End Rem
  Method SetCosinus(cosinus:Float)
    bmx_b2rot_setcosinus(b2ObjectPtr, cosinus)
  End Method

End Type

' ***********************************************************************************************************
' Type: b2Transform
' ***********************************************************************************************************

Rem
bbdoc: A transform contains translation and rotation.<br>It is used to represent the position and orientation of rigid frames.
End Rem
Type b2Transform

  Field b2ObjectPtr:Byte Ptr

  Rem
  bbdoc: Instantiates a new b2Transform Object.
  about: Position and Rotation transformation are equal to zero.
  end Rem
  Method New()
    b2ObjectPtr = bmx_b2transform_create()
  End Method

  Function _create:b2Transform(b2ObjectPtr:Byte Ptr)
    If b2ObjectPtr Then
      Local this:b2Transform = New b2Transform
      this.b2ObjectPtr = b2ObjectPtr
      Return this
    End If
  End Function

  Rem
  bbdoc: Creates a new Transform using a position vector and a rotation.
  End Rem
  Method Create:b2Transform(position:b2Vec2, rotation:b2Rot)
    b2ObjectPtr = bmx_b2transform_createtransform(position.b2ObjectPtr, rotation.b2ObjectPtr)
    Return Self
  End Method
    
  Rem
  bbdoc: Deletes a given b2Transform object
  endrem
  Method Delete()
    If b2ObjectPtr Then
      bmx_b2transform_delete(b2ObjectPtr)
      b2ObjectPtr = Null
    End If
  End Method

  Rem
  bbdoc: Set this to the identity transform.
  End Rem
  Method SetIdentity()
    bmx_b2transform_setidentity(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Set this based on the position and angle in degrees.
  End Rem 
  Method Set(position:b2Vec2, angle:Float)
    bmx_b2transform_set(b2ObjectPtr, position.b2ObjectPtr, angle)
  End Method
    
  Rem
  bbdoc: Set this based on the position and angle in radian.
  End Rem 
  Method SetRad(position:b2Vec2, angle:Float)
    bmx_b2transform_setrad(b2ObjectPtr, position.b2ObjectPtr, angle)
  End Method

  Rem
  bbdoc: Returns the Position vector.
  End Rem
  Method GetPosition:b2Vec2()
    Return b2Vec2._create(bmx_b2transform_getposition(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Sets the Position vector.
  End Rem 
  Method SetPosition(position:b2Vec2)
    bmx_b2transform_setposition(b2ObjectPtr, position.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Returns the Rotation transform
  End Rem
  Method GetRotation:b2Rot()
    Return b2Rot._create(bmx_b2transform_getrotation(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Sets the Rotation transform
  End Rem 
  Method SetRotation(rotation:b2Rot)
    bmx_b2transform_setrotation(b2ObjectPtr, rotation.b2ObjectPtr)
  End Method

End Type

' ***********************************************************************************************************
' Type: b2Filter
' ***********************************************************************************************************

Rem
bbdoc: This holds contact filtering data.
End Rem
Type b2Filter

  Field b2ObjectPtr:Byte Ptr

  Rem
  bbdoc: Instantiates a new b2Filter Object.
  about: By default: 
  <br> categoryBits = 1 
  <br> maskBits = 65535 
  <br> groupIndex = 0
  end Rem
  Method New()
    b2ObjectPtr = bmx_b2filter_create(Null, Null, Null)
  End Method

  Rem
  bbdoc: Creates a new Filter
  End Rem
  Function CreateFilter:b2Filter(categoryBits:Short = 1, maskBits:Short = 65535, groupIndex:Int = 0)
    Return New b2Filter.Create(categoryBits, maskBits, groupIndex)
  End Function
  
  Function _create:b2Filter(b2ObjectPtr:Byte Ptr)
    If b2ObjectPtr Then
      Local this:b2Filter = New b2Filter
      this.b2ObjectPtr = b2ObjectPtr
      Return this
    End If
  End Function

  Rem
  bbdoc: Creates a new Filter
  End Rem
  Method Create:b2Filter(categoryBits:Short = 1, maskBits:Short = 65535, groupIndex:Int = 0)
    b2ObjectPtr = bmx_b2filter_create(categoryBits, maskBits, groupIndex)
    Return Self
  End Method
    
  Rem
  bbdoc: Deletes a given b2Filter object
  endrem
  Method Delete()
    If b2ObjectPtr Then
      bmx_b2filter_delete(b2ObjectPtr)
      b2ObjectPtr = Null
    End If
  End Method

  Rem
  bbdoc: Returns the collision category bits
  End Rem
  Method GetCategoryBits:Short()
    Return bmx_b2filter_getcategorybits(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Sets the collision category bits 
  about: Normally you would just set one bit.
  End Rem 
  Method SetCategoryBits(categoryBits:Short)
    bmx_b2filter_setcategorybits(b2ObjectPtr, categoryBits)
  End Method
    
  Rem
  bbdoc: Returns the collision mask bits
  about: This states the categories that this shape would accept for collision.
  End Rem
  Method GetMaskBits:Short()
    Return bmx_b2filter_getmaskbits(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Sets the collision mask bits
  about: This states the categories that this shape would accept for collision.
  End Rem 
  Method SetMaskBits(maskBits:Short)
    bmx_b2filter_setmaskbits(b2ObjectPtr, maskBits)
  End Method

  Rem
  bbdoc: Returns the Collision groups
  about: Collision groups allow a certain group of objects to never collide (negative) or always collide (positive).
  <br>Zero means no collision group.
  <br>Non-zero group filtering always wins against the mask bits.
  End Rem
  Method GetGroupIndex:int()
    Return SignedShortToInt(bmx_b2filter_getgroupindex(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Sets the Collision groups
  about: Collision groups allow a certain group of objects to never collide (negative) or always collide (positive).
  <br>Zero means no collision group.
  <br>Non-zero group filtering always wins against the mask bits.
  End Rem 
  Method SetGroupIndex(groupIndex:int)
    bmx_b2filter_setgroupindex(b2ObjectPtr, groupIndex)
  End Method

End Type


' ***********************************************************************************************************
' Type: b2FixtureDef
' ***********************************************************************************************************

Rem
bbdoc: A fixture definition is used to create a fixture. 
about: This Type defines an abstract fixture definition.
You can reuse fixture definitions safely.
End Rem
Type b2FixtureDef

  Field b2ObjectPtr:Byte Ptr
  Field userData:Object

  Method New()
    b2ObjectPtr = bmx_b2fixturedef_create()
  End Method
  
  Rem
  bbdoc: Sets the shape in Fixture definition
  End Rem
  Method SetShape(shape:b2Shape)
    bmx_b2fixturedef_setshape(b2ObjectPtr, shape.b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Returns the shape From Fixture definition
  End Rem
  Method GetShape:b2Shape()
    bmx_b2fixturedef_getshape(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Sets the Fixture's friction coefficient, usually in the range [0,1].
  End Rem
  Method SetFriction(friction:Float)
    bmx_b2fixturedef_setfriction(b2ObjectPtr, friction)
  End Method
  
  Rem
  bbdoc: Gets the Fixture's friction coefficient, usually in the range [0,1].
  End Rem
  Method GetFriction:Float()
    Return bmx_b2fixturedef_getfriction(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Sets the Fixture's restitution (elasticity) usually in the range [0,1]. 
  End Rem
  Method SetRestitution(restitution:Float)
    bmx_b2fixturedef_setrestitution(b2ObjectPtr, restitution)
  End Method
  
  Rem
  bbdoc: Gets the Fixture's restitution (elasticity) usually in the range [0,1]. 
  End Rem
  Method GetRestitution:Float()
    Return bmx_b2fixturedef_getrestitution(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Sets the Fixture's density, usually in kg/m^2. 
  End Rem
  Method SetDensity(density:Float)
    bmx_b2fixturedef_setdensity(b2ObjectPtr, density)
  End Method
  
  Rem
  bbdoc: Gets the Fixture's density, usually in kg/m^2. 
  End Rem
  Method GetDensity:Float()
    Return bmx_b2fixturedef_getdensity(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Sets the contact filtering data.
  End Rem
  Method SetFilter(filter:b2Filter)
    bmx_b2fixturedef_setfilter(b2ObjectPtr, filter.b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Returns the contact filtering data.
  End Rem
  Method GetFilter:b2Filter()
    Return b2Filter._create(bmx_b2fixturedef_getfilter(b2ObjectPtr))
  End Method
  
  Rem
  bbdoc: Returns True if this fixture is a sensor.
  about: A sensor fixture collects contact information but never generates a collision response.
  End Rem
  Method IsSensor:Int()
    Return bmx_b2fixturedef_issensor(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: A sensor fixture collects contact information but never generates a collision response.
  End Rem
  Method SetIsSensor(sensor:Int)
    bmx_b2fixturedef_setissensor(b2ObjectPtr, sensor)
  End Method
  
  Rem
  bbdoc: Sets the user data.
  End Rem
  Method SetUserData(data:Object)
    userData = data
  End Method

  Rem
  bbdoc: Get the user data that was assigned in the fixture definition.
  End Rem
  Method GetUserData:Object()
    Return userData
  End Method
  
End Type


' ***********************************************************************************************************
' Type: b2Joint
' ***********************************************************************************************************


Rem
bbdoc: The base joint class.
about: Joints are used to constraint two bodies together in various fashions. Some joints also feature limits and motors.
End Rem
Type b2Joint

  Field b2ObjectPtr:Byte Ptr
  Field userData:Object
  
  Function _create:b2Joint(b2ObjectPtr:Byte Ptr)
    If b2ObjectPtr Then
      Local joint:b2Joint = b2Joint(bmx_b2joint_getmaxjoint(b2ObjectPtr))
      If Not joint Then
        joint = New b2Joint
        joint.b2ObjectPtr = b2ObjectPtr
      Else
        If Not joint.b2ObjectPtr Then
          joint.b2ObjectPtr = b2ObjectPtr
        EndIf
      End If
      Return joint
    End If
  End Function

  Rem
  bbdoc: Get the type of the concrete joint.
  return: The joint type.<br>
  <ul>
  <li><b>e_unknownJoint</b> : Type - Unknown Joint.</li>
  <li><b>e_revoluteJoint</b> : Type - Revolute Joint.</li>
  <li><b>e_prismaticJoint</b> : Type - Prismatic Joint.</li>
  <li><b>e_distanceJoint</b> : Type - Distance Joint.</li>
  <li><b>e_pulleyJoint</b> : Type - Pulley Joint.</li>
  <li><b>e_mouseJoint</b> : Type - Mouse Joint.</li>
  <li><b>e_gearJoint</b> : Type - Gear Joint.</li>
  <li><b>e_wheelJoint</b> : Type - Wheel Joint.</li>
  <li><b>e_weldJoint</b> : Type - Weld Joint.</li>
  <li><b>e_frictionJoint</b> : Type - Friction Joint.</li>
  <li><b>e_ropeJoint</b> : Type - Rope Joint.</li>
  <li><b>e_motorJoint</b> : Type - Motor Joint.</li>
  </ul>
  End rem
  Method GetType:Int()
    Return bmx_b2joint_gettype(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Get the first body attached to this joint.
  End Rem
  Method GetBodyA:b2Body()
    Return b2Body._create(bmx_b2joint_getbodya(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Get the second body attached to this joint.
  End Rem
  Method GetBodyB:b2Body()
    Return b2Body._create(bmx_b2joint_getbodyb(b2ObjectPtr))
  End Method
  
  Rem
  bbdoc: Get the user data.
  End Rem
  Method GetUserData:Object()
    Return userData
  End Method

  Rem
  bbdoc: Sets the user data.
  End Rem
  Method SetUserData(data:Object)
    userData = data
  End Method

  Rem
  bbdoc: Short-cut function to determine if either body is inactive.
  returns: True if the body is active.
  End Rem
  Method IsActive:Int()
    Return bmx_b2joint_isactive(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Get the anchor point on bodyA in world coordinates.
  about: Abstract implementation
  End rem
  Method GetAnchorA:b2Vec2()
    Return Null
  EndMethod

  Rem
  bbdoc: Get the anchor point on bodyB in world coordinates.
  about: Abstract implementation
  End rem
  Method GetAnchorB:b2Vec2()
    Return Null
  EndMethod

  Rem
  bbdoc: Get the reaction force on bodyB at the joint anchor in Newtons.
  about: Abstract implementation
  End rem
  Method GetReactionForce:b2Vec2(inv_dt:Float)
    Return Null
  EndMethod

  Rem
  bbdoc: Get the reaction torque on bodyB in N*m.
  about: Abstract implementation
  End Rem
  Method GetReactionTorque:Float(inv_dt:Float)
    Return Null
  EndMethod

  Rem
  bbdoc: Shift the origin for any points stored in world coordinates.
  about: Abstract implementation
  End Rem
  Method ShiftOrigin(newOrigin:b2Vec2)
  EndMethod
  
  Rem
  bbdoc: Dump this joint to the log file.
  about: Abstract implementation
  End Rem
  Method Dump()
  EndMethod

End Type

' ***********************************************************************************************************
' Type: b2JointDef
' ***********************************************************************************************************

Rem
bbdoc: Joint definitions are used to construct joints.
End Rem
Type b2JointDef

  Field b2ObjectPtr:Byte Ptr
  Field userData:Object

' Method New()
'   b2ObjectPtr = bmx_b2jointdef_create()
' End Method
  
  Rem
  bbdoc: Get the type of the joint.
  return: The joint type.<br>
  <ul>
  <li><b>e_unknownJoint</b> : Type - Unknown Joint.</li>
  <li><b>e_revoluteJoint</b> : Type - Revolute Joint.</li>
  <li><b>e_prismaticJoint</b> : Type - Prismatic Joint.</li>
  <li><b>e_distanceJoint</b> : Type - Distance Joint.</li>
  <li><b>e_pulleyJoint</b> : Type - Pulley Joint.</li>
  <li><b>e_mouseJoint</b> : Type - Mouse Joint.</li>
  <li><b>e_gearJoint</b> : Type - Gear Joint.</li>
  <li><b>e_wheelJoint</b> : Type - Wheel Joint.</li>
  <li><b>e_weldJoint</b> : Type - Weld Joint.</li>
  <li><b>e_frictionJoint</b> : Type - Friction Joint.</li>
  <li><b>e_ropeJoint</b> : Type - Rope Joint.</li>
  <li><b>e_motorJoint</b> : Type - Motor Joint.</li>
  </ul>
  End rem
  Method GetType:Int()
    Return bmx_b2jointdef_gettype(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Set the type of the joint.
  return: The joint type.<br>
  <ul>
  <li><b>e_unknownJoint</b> : Type - Unknown Joint.</li>
  <li><b>e_revoluteJoint</b> : Type - Revolute Joint.</li>
  <li><b>e_prismaticJoint</b> : Type - Prismatic Joint.</li>
  <li><b>e_distanceJoint</b> : Type - Distance Joint.</li>
  <li><b>e_pulleyJoint</b> : Type - Pulley Joint.</li>
  <li><b>e_mouseJoint</b> : Type - Mouse Joint.</li>
  <li><b>e_gearJoint</b> : Type - Gear Joint.</li>
  <li><b>e_wheelJoint</b> : Type - Wheel Joint.</li>
  <li><b>e_weldJoint</b> : Type - Weld Joint.</li>
  <li><b>e_frictionJoint</b> : Type - Friction Joint.</li>
  <li><b>e_ropeJoint</b> : Type - Rope Joint.</li>
  <li><b>e_motorJoint</b> : Type - Motor Joint.</li>
  </ul>
  End rem
  Method SetType(jointType:Int)
    bmx_b2jointdef_settype(b2ObjectPtr, jointType)
  End Method

  Rem
  bbdoc: Get the user data.
  End Rem
  Method GetUserData:Object()
    Return userData
  End Method

  Rem
  bbdoc: Sets the user data.
  End Rem
  Method SetUserData(data:Object)
    userData = data
  End Method

  Rem
  bbdoc: Get the first body attached to this jointDef.
  End Rem
  Method GetBodyA:b2Body()
    Return b2Body._create(bmx_b2jointdef_getbodya(b2ObjectPtr))
  End Method
  
  Rem
  bbdoc: Set the first body attached to this jointDef.
  End Rem
  Method SetBodyA(body:b2Body)
    bmx_b2jointdef_setbodya(b2ObjectPtr, body.b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Get the second body attached to this jointDef.
  End Rem
  Method GetBodyB:b2Body()
    Return b2Body._create(bmx_b2jointdef_getbodyb(b2ObjectPtr))
  End Method
  
  Rem
  bbdoc: Set the second body attached to this jointDef.
  End Rem
  Method SetBodyB(body:b2Body)
    bmx_b2jointdef_setbodyb(b2ObjectPtr, body.b2ObjectPtr)
  End Method
    
  Rem
  bbdoc: Set this flag to true if the attached bodies should collide.
  End Rem
  Method SetCollideConnected(flag:Int)
    bmx_b2jointdef_setcollideconnected(b2ObjectPtr, flag)
  End Method
  
  Rem
  bbdoc: Returns true if the attached bodies should collide.
  End Rem
  Method GetCollideConnected:int()
    return bmx_b2jointdef_getcollideconnected(b2ObjectPtr)
  End Method

End Type


' ***********************************************************************************************************
' Type: b2MouseJoint
' ***********************************************************************************************************

Rem
bbdoc: A mouse joint is used to make a point on a body track a specified world point.<br>
This a soft constraint with a maximum force.<br>
This allows the constraint to stretch and without applying huge forces.
about: this joint is not documented in the manual because it was developed to be used in the testbed.<br>
If you want to learn how to use the mouse joint, look at the testbed.
End Rem
Type b2MouseJoint extends b2Joint

  Rem
  bbdoc: Get the anchor point on bodyA in world coordinates.
  End rem
  Method GetAnchorA:b2Vec2()
    Return b2Vec2._create(bmx_b2mousejoint_getanchora(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Get the anchor point on bodyB in world coordinates.
  End rem
  Method GetAnchorB:b2Vec2()
    Return b2Vec2._create(bmx_b2mousejoint_getanchorb(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Get the reaction force on bodyB at the joint anchor in Newtons.
  End rem
  Method GetReactionForce:b2Vec2(inv_dt:Float)
    Return b2Vec2._create(bmx_b2mousejoint_getreactionforce(b2ObjectPtr, inv_dt))
  End Method

  Rem
  bbdoc: Get the reaction torque on bodyB in N*m.
  End Rem
  Method GetReactionTorque:Float(inv_dt:Float)
    Return bmx_b2mousejoint_getreactiontorque(b2ObjectPtr, inv_dt)
  End Method

  Rem
  bbdoc: Get the world target point. 
  End rem
  Method GetTarget:b2Vec2()
    Return b2Vec2._create(bmx_b2mousejoint_gettarget(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Use this to update the target point.
  End rem
  Method SetTarget(target:b2Vec2)
    bmx_b2mousejoint_settarget(b2ObjectPtr, target)
  End Method

  Rem
  bbdoc: Get the maximum force in Newtons.
  about: Usually you will express as some multiple of the weight (multiplier * mass * gravity).
  End Rem
  Method GetMaxForce:Float()
    Return bmx_b2mousejoint_getmaxforce(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Set the maximum force in Newtons.
  about: Usually you will express as some multiple of the weight (multiplier * mass * gravity).
  End Rem
  Method SetMaxForce(force:float)
    bmx_b2mousejoint_setmaxforce(b2ObjectPtr, force)
  End Method

  Rem
  bbdoc: Get the frequency in Hertz.
  End Rem
  Method GetFrequency:Float()
    Return bmx_b2mousejoint_getfrequency(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Set the frequency in Hertz.
  End Rem
  Method SetFrequency(frequency:float)
    bmx_b2mousejoint_setfrequency(b2ObjectPtr, frequency)
  End Method

  Rem
  bbdoc: Get the damping ratio.
  returns: 0 = no damping, 1 = critical damping.
  End Rem
  Method GetDampingRatio:Float()
    Return bmx_b2mousejoint_getdampingratio(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Set the damping ratio
  about: 0 = no damping, 1 = critical damping.
  End Rem
  Method SetDampingRatio(damping:float)
    bmx_b2mousejoint_setdampingratio(b2ObjectPtr, damping)
  End Method

  Rem
  bbdoc: Shift the origin for any points stored in world coordinates.
  End rem
  Method ShiftOrigin(newOrigin:b2Vec2)
    bmx_b2mousejoint_shiftorigin(b2ObjectPtr, newOrigin)
  End Method

  Rem
  bbdoc: Dump this joint to the log file.
  End Rem
  Method Dump()
    bmx_b2mousejoint_dump(b2ObjectPtr)
  End Method
  
End Type

' ***********************************************************************************************************
' Type: b2MouseJointDef
' ***********************************************************************************************************

Rem
bbdoc: Mouse joint definition.
about: This requires a world target point, tuning parameters, and the time step.
End Rem
Type b2MouseJointDef extends b2JointDef

' Method New()
'   b2ObjectPtr = bmx_b2mousejointdef_create()
' End Method
  
  Rem
  bbdoc: Get the initial world target point. 
  about: This is assumed to coincide with the body anchor initially.
  End rem
  Method GetTarget:b2Vec2()
    Return b2Vec2._create(bmx_b2mousejointdef_gettarget(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Set the initial world target point. 
  about: This is assumed to coincide with the body anchor initially.
  End rem
  Method SetTarget(target:b2Vec2)
    bmx_b2mousejointdef_settarget(b2ObjectPtr, target)
  End Method

  Rem
  bbdoc: Get the maximum constraint force that can be exerted to move the candidate body.
  about: Usually you will express as some multiple of the weight (multiplier * mass * gravity).
  End Rem
  Method GetMaxForce:Float()
    Return bmx_b2mousejointdef_getmaxforce(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Sets the maximum constraint force that can be exerted to move the candidate body.
  about: Usually you will express as some multiple of the weight (multiplier * mass * gravity).
  End Rem
  Method SetMaxForce(force:float)
    bmx_b2mousejointdef_setmaxforce(b2ObjectPtr, force)
  End Method

  Rem
  bbdoc: Get the response speed.
  End Rem
  Method GetFrequencyHz:Float()
    Return bmx_b2mousejointdef_getfrequencyhz(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Sets the response speed.
  End Rem
  Method SetFrequencyHz(frequency:float)
    bmx_b2mousejointdef_setfrequencyhz(b2ObjectPtr, frequency)
  End Method

  Rem
  bbdoc: Get the damping ratio.
  returns: 0 = no damping, 1 = critical damping.
  End Rem
  Method GetDampingRatio:Float()
    Return bmx_b2mousejointdef_getdampingratio(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Sets the damping ratio
  about: 0 = no damping, 1 = critical damping.
  End Rem
  Method SetDampingRatio(damping:float)
    bmx_b2mousejointdef_setdampingratio(b2ObjectPtr, damping)
  End Method

End Type

' ***********************************************************************************************************
' Type: b2Shape
' ***********************************************************************************************************


Rem
bbdoc: A shape is used for collision detection.
about: You can create a shape however you like.
Shapes used for simulation in b2World are created automatically when a b2Fixture is created.
Shapes may encapsulate a one or more child shapes.
End Rem
Type b2Shape

  Field b2ObjectPtr:Byte Ptr

  Function _create:b2Shape(b2ObjectPtr:Byte Ptr)
    If b2ObjectPtr Then
      Local this:b2Shape = New b2Shape
      this.b2ObjectPtr = b2ObjectPtr
      Return this
    End If
  End Function

  Rem
  bbdoc: Get the radius of this circle. 
  End Rem
  Method GetRadius:Float()
    Return bmx_b2shape_getradius(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Set the radius of this circle. 
  End Rem
  Method SetRadius:Float(radius:Float)
    Return bmx_b2shape_setradius(b2ObjectPtr, radius)
  End Method
  
End Type

' ***********************************************************************************************************
' Type: b2CircleShape
' ***********************************************************************************************************

Rem
bbdoc: A circle shape.
End Rem
Type b2CircleShape Extends b2Shape

  Rem
  bbdoc: Instanciate a new Circle shape.
  end Rem
  Method New()
    b2ObjectPtr = bmx_b2circleshape_create()
  End Method
  
  Rem
  bbdoc: Creates a new Circle shape.
  End Rem
  Method Create:b2CircleShape()
    b2ObjectPtr = bmx_b2circleshape_create()
    Return Self
  End Method

End Type

' ***********************************************************************************************************
' Type: b2PolygonShape
' ***********************************************************************************************************

Rem
bbdoc: A convex polygon Shape.
End Rem
Type b2PolygonShape Extends b2Shape

  Rem
  bbdoc: Instanciate a new Polygon shape.
  end Rem
  Method New()
    b2ObjectPtr = bmx_b2polygonshape_create()
  End Method
  
  Rem
  bbdoc: Creates a new Polygon shape.
  End Rem
  Method Create:b2PolygonShape()
    b2ObjectPtr = bmx_b2polygonshape_create()
    Return Self
  End Method

  Rem
  bbdoc: Build vertices to represent an axis-aligned box centered on the local origin.
  about: Parameters:
  <ul>
  <li><b>hx </b> : the half-width.</li>
  <li><b>hy </b> : the half-height. </li>
  </ul>
  End Rem
  Method SetAsBox(hx:Float, hy:Float)
    bmx_b2polygonshape_setasbox(b2ObjectPtr, hx, hy)
  End Method

  Rem
  bbdoc: Build vertices to represent an oriented box. 
  about: Parameters:
  <ul>
  <li><b>hx </b> : the half-width.</li>
  <li><b>hy </b> : the half-height. </li>
  <li><b>center </b> : the center of the box in local coordinates. </li>
  <li><b>angle </b> : the rotation of the box in local degrees coordinates. </li>
  </ul>
  End Rem
  Method SetAsOrientedBox(hx:Float, hy:Float, center:b2Vec2, angle:Float)
    bmx_b2polygondef_setasorientedbox(b2ObjectPtr, hx, hy, center.b2ObjectPtr, angle)
  End Method

  Rem
  bbdoc: Build vertices to represent an oriented box. 
  about: Parameters:
  <ul>
  <li><b>hx </b> : the half-width.</li>
  <li><b>hy </b> : the half-height. </li>
  <li><b>center </b> : the center of the box in local coordinates. </li>
  <li><b>angle </b> : the rotation of the box in local radian coordinates. </li>
  </ul>
  End Rem
  Method SetAsOrientedBoxRad(hx:Float, hy:Float, center:b2Vec2, angle:Float)
    bmx_b2polygondef_setasorientedboxrad(b2ObjectPtr, hx, hy, center.b2ObjectPtr, angle)
  End Method

End Type


' ***********************************************************************************************************
' Type: b2Body
' ***********************************************************************************************************

Rem
bbdoc: A rigid body. These are created via #b2World.#CreateBody().
End Rem
Type b2Body

  Field b2ObjectPtr:Byte Ptr
  Field userData:Object

  Function _create:b2Body(b2ObjectPtr:Byte Ptr)
    If b2ObjectPtr Then
      Local body:b2Body = b2Body(bmx_b2body_getmaxbody(b2ObjectPtr))
      If Not body Then
        body = New b2Body
        body.b2ObjectPtr = b2ObjectPtr
      End If
      Return body
    End If
  End Function
  
  Rem
  bbdoc: Creates a fixture and attach it to this body.
  about: Use this function if you need to set some fixture parameters, like friction.
  Otherwise you can create the fixture directly from a shape.
  If the density is non-zero, this function automatically updates the mass of the body.
  Contacts are not created until the next time step.
  <p>Warning: This function is locked during callbacks.</p>
  <p>Parameters:
  <ul>
  <li><b>def </b> : the fixture definition.</li>
  </ul>
  </p>
  End Rem
  Method CreateFixture:b2Fixture(def:b2FixtureDef)
    Local fixture:b2Fixture = new b2Fixture
    fixture = b2Fixture._create(bmx_b2body_createfixture(b2ObjectPtr, def.b2ObjectPtr))
    fixture.userData = def.userData ' copy the userData
    Return fixture
  End Method

'   [WRONG]
' Method MaxCreateFixture:b2Fixture(def:b2FixtureDef)
'   Local fixture:b2Fixture = new b2Fixture._create(def)
'   return fixture
' End Method
  
  Rem
  bbdoc: Creates a fixture from a shape and attach it to this body.
  about: This is a convenience function.
  Use b2FixtureDef if you need to set parameters like friction, restitution, user data, or filtering.
  If the density is non-zero, this function automatically updates the mass of the body.
  <p>Warning: This function is locked during callbacks.</p>
  <p>Parameters:
  <ul>
  <li><b>shape </b> : the shape to be cloned.</li>
  <li><b>density </b> : the shape density (set to zero for static bodies).</li>
  </ul>
  </p>
  End Rem
  Method _createFixture:b2Fixture(shape:b2Shape, density:Float)
    Return b2Fixture._create(bmx_b2body__createfixture(b2ObjectPtr, shape.b2ObjectPtr, density))
  End Method

  Rem
  bbdoc: Destroy a fixture.
  about : This removes the fixture from the broad-phase and destroys all contacts associated with this fixture.
  This will automatically adjust the mass of the body if the body is dynamic and the fixture has positive density.
  All fixtures attached to a body are implicitly destroyed when the body is destroyed.
  <p>Warning: This method is locked during callbacks.</p>
  <p>Parameters:
  <ul>
  <li><b>fixture </b> : the fixture to be removed.</li>
  </ul>
  </p>
  End Rem
  Method DestroyFixture(fixture:b2Fixture)
  ' bmx_b2body_destroyfixture(b2ObjectPtr, fixture.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Get the world body origin position. 
  End Rem
  Method GetPosition:b2Vec2()
    Return b2Vec2._create(bmx_b2body_getposition(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Get the angle in degrees.
  returns: The current world rotation angle in degrees.
  End Rem
  Method GetAngle:Float()
    Return bmx_b2body_getangle(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Get the angle in radian.
  returns: The current world rotation angle in radian.
  End Rem
  Method GetAngleRad:Float()
    Return bmx_b2body_getanglerad(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Get the world position of the center of mass.
  End Rem
  Method GetWorldCenter:b2Vec2()
    Return b2Vec2._create(bmx_b2body_getworldcenter(b2ObjectPtr))
  End Method

  Rem
  bbdoc:Get the Local position of the center of mass.
  End Rem
  Method GetLocalCenter:b2Vec2()
    Return b2Vec2._create(bmx_b2body_getlocalcenter(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Set the linear velocity of the center of mass.
  about: Parameters:
  <ul>
  <li><b>v </b> : the New linear velocity of the center of mass.</li>
  </ul>
  End Rem
  Method SetLinearVelocity(v:b2Vec2)
    bmx_b2body_setlinearvelocity(b2ObjectPtr, v.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Get the linear velocity of the center of mass.
  returns: The linear velocity of the center of mass.
  End Rem
  Method GetLinearVelocity:b2Vec2()
    Return b2Vec2._create(bmx_b2body_getlinearvelocity(b2ObjectPtr))
  End Method
  
  Rem
  bbdoc: Set the angular velocity.
  about: Parameters:
  <ul>
  <li><b>omega </b> : the New angular velocity in degrees/Second.</li>
  </ul>
  End Rem
  Method SetAngularVelocity(omega:Float)
    bmx_b2body_setangularvelocity(b2ObjectPtr, omega)
  End Method

  Rem
  bbdoc: Get the angular velocity.
  returns: The angular velocity in degrees/Second.
  End Rem
  Method GetAngularVelocity:Float()
    Return bmx_b2body_getangularvelocity(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Apply a force at a world point.
  about: If the force is not applied at the center of mass, it will generate a torque and affect the angular velocity.
  This wakes up the body.
  <p>Parameters:
  <ul>
  <li><b>force </b> : the world force vector, usually in Newtons (N).</li>
  <li><b>point </b> : the world position of the point of application.</li>
  </ul>
  </p>
  End Rem
  Method ApplyForce(force:b2Vec2, point:b2Vec2)
    bmx_b2body_applyforce(b2ObjectPtr, force.b2ObjectPtr, point.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Apply a torque.
  about: This affects the angular velocity without affecting the linear velocity of the center of mass.
  This wakes up the body.
  <p>Parameters:
  <ul>
  <li><b> torque </b> : about the z-axis (out of the screen), usually in N-m.</li>
  </ul>
  </p>
  End Rem
  Method ApplyTorque(torque:Float)
    bmx_b2body_applytorque(b2ObjectPtr, torque)
  End Method

  Rem
  bbdoc: Apply an impulse at a point. 
  about: This immediately modifies the velocity.
  It also modifies the angular velocity if the point of application is not at the center of mass.
  This wakes up the body.
  <p>Parameters:
  <ul>
  <li><b> impulse </b> : the world impulse vector, usually in N-seconds or kg-m/s.</li>
  <li><b> point </b> : the world position of the point of application.</li>
  </ul>
  </p>
  End Rem
  Method ApplyLinearImpulse(impulse:b2Vec2, point:b2Vec2)
    bmx_b2body_applylinearimpulse(b2ObjectPtr, impulse.b2ObjectPtr, point.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Get the total mass of the body.
  returns: The mass, usually in kilograms (kg).
  End Rem
  Method GetMass:Float()
    Return bmx_b2body_getmass(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Get the central rotational inertia of the body.
  returns: The rotational inertia, usually in kg-m^2.
  End Rem
  Method GetInertia:Float()
    Return bmx_b2body_getinertia(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Get the world coordinates of a point given the local coordinates.
  returns: The same point expressed in world coordinates.
  about: Parameters:
  <ul>
  <li><b>localPoint </b> : a point on the body measured relative the the body's origin.</li>
  </ul>
  End Rem
  Method GetWorldPoint:b2Vec2(localPoint:b2Vec2)
    Return b2Vec2._create(bmx_b2body_getworldpoint(b2ObjectPtr, localPoint.b2ObjectPtr))
  End Method

  Rem
  bbdoc: Get the world coordinates of a vector given the local coordinates.
  returns: The same vector expressed in world coordinates.
  about: Parameters:
  <ul>
  <li><b>localVector </b> : a vector fixed in the body.</li>
  </ul>
  End Rem
  Method GetWorldVector:b2Vec2(localVector:b2Vec2)
    Return b2Vec2._create(bmx_b2body_getworldvector(b2ObjectPtr, localVector.b2ObjectPtr))
  End Method

  Rem
  bbdoc: Gets a local point relative to the body's origin given a world point.
  returns: The corresponding local point relative to the body's origin.
  about: Parameters:
  <ul>
  <li><b>worldPoint </b> : a point in world coordinates.</li>
  </ul>
  End Rem
  Method GetLocalPoint:b2Vec2(worldPoint:b2Vec2)
    Return b2Vec2._create(bmx_b2body_getlocalpoint(b2ObjectPtr, worldPoint.b2ObjectPtr))
  End Method

  Rem
  bbdoc: Gets a local vector given a world vector.
  returns: The corresponding local vector.
  about: Parameters:
  <ul>
  <li><b>worldVector </b> : a vector in world coordinates.</li>
  </ul>
  End Rem
  Method GetLocalVector:b2Vec2(worldVector:b2Vec2)
    Return b2Vec2._create(bmx_b2body_getlocalvector(b2ObjectPtr, worldVector.b2ObjectPtr))
  End Method

  Rem
  bbdoc: Is this body treated like a bullet for continuous collision detection?
  End Rem
  Method IsBullet:Int()
    Return bmx_b2body_isbullet(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Should this body be treated like a bullet for continuous collision detection?
  End Rem
  Method SetBullet(flag:Int)
    bmx_b2body_setbullet(b2ObjectPtr, flag)
  End Method

  Rem
  bbdoc: Is this body sleeping (not simulating).
  End Rem
  Method IsAwake:Int()
    Return bmx_b2body_isawake(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Set the sleep state of the body. A sleeping body has very low CPU cost.
  about: Parameters:
  <ul>
  <li><b>flag </b> : set to true to wake the body, false to put it to sleep.</li>
  </ul>
  End Rem
  Method SetAwake(flag:Int)
    bmx_b2body_setawake(b2ObjectPtr, flag)
  End Method

  Rem
  bbdoc: Get the list of all fixtures attached to this body.
  End Rem
' Method GetFixtureList:b2Fixture()
'   Return b2Fixture._create(bmx_b2body_getfixturelist(b2ObjectPtr))
' End Method

  Rem
  bbdoc: Get the list of all joints attached to this body.
  End Rem
' Method GetJointList:b2JointEdge()
'   Return b2JointEdge._create(bmx_b2body_getjointlist(b2ObjectPtr))
' End Method

  Rem
  bbdoc: Get the next body in the world's body list.
  End Rem
  Method GetNext:b2Body()
    Return _create(bmx_b2body_getnext(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Get the user data pointer that was provided in the body definition.
  End Rem
  Method GetUserData:Object()
    Return userData
  End Method

  Rem
  bbdoc: Sets the user data.
  End Rem
  Method SetUserData(data:Object)
    userData = data
  End Method

  Rem
  bbdoc: Get the parent world of this body.
  End Rem
  Method GetWorld:b2World()
    Return b2World._create(bmx_b2body_getworld(b2ObjectPtr))
  End Method
  
  Rem
  bbdoc: Set the mass properties to override the mass properties of the fixtures.
  about: Note that this changes the center of mass position.
  Note that creating or destroying fixtures can also alter the mass.
  This function has no effect if the body isn't dynamic.
  Parameters:
  <ul>
  <li><b>massData </b> : the mass properties.</li>
  </ul>
  End Rem
' Method SetMassData(massData:b2MassData)
'   bmx_b2body_setmassdata(b2ObjectPtr, massData.b2ObjectPtr)
' End Method

  Rem
  bbdoc: Returns the body type: b2_staticBody, b2_kinematicBody, or b2_dynamicBody.
  about: Note: if a b2_dynamicBody body would have zero mass, the mass is set to one.
  <ul>
  <li><b>b2_staticBody</b> : zero mass, zero velocity, may be manually moved.</li>
  <li><b>b2_kinematicBody</b> : zero mass, non-zero velocity set by user, moved by solver.</li>
  <li><b>b2_dynamicBody</b> : positive mass, non-zero velocity determined by forces, moved by solver.</li>
  </ul>
  End Rem
  Method GetType:Int()
    Return bmx_b2body_gettype(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Set the type of this body: b2_staticBody, b2_kinematicBody, or b2_dynamicBody.
  about: This may alter the mass and velocity.
  Note: if a b2_dynamicBody body would have zero mass, the mass is set to one.
  <ul>
  <li><b>b2_staticBody</b> : zero mass, zero velocity, may be manually moved.</li>
  <li><b>b2_kinematicBody</b> : zero mass, non-zero velocity set by user, moved by solver.</li>
  <li><b>b2_dynamicBody</b> : positive mass, non-zero velocity determined by forces, moved by solver.</li>
  </ul>
  End Rem
  Method SetType(bodyType:Int)
    bmx_b2body_settype(b2ObjectPtr, bodyType)
  End Method
  
End Type


' ***********************************************************************************************************
' Type: b2BodyDef
' ***********************************************************************************************************

Rem
bbdoc: A body definition holds all the data needed to construct a rigid body.
about: You can safely re-use body definitions. Shapes are added to a body after construction.
End Rem
Type b2BodyDef

  Field b2ObjectPtr:Byte Ptr
  Field userData:Object

  Method New()
    b2ObjectPtr = bmx_b2bodydef_create()
  End Method
  
  Method Delete()
    If b2ObjectPtr Then
      bmx_b2bodydef_delete(b2ObjectPtr)
      b2ObjectPtr = Null
    End If
  End Method
  
  Rem
  bbdoc: Use this to store application specific body data.
  End Rem
  Method SetUserData(data:Object)
    userData = data
  End Method
  
  Rem
  bbdoc: Returns the application specific body data, if any.
  End Rem
  Method GetUserData:Object()
    Return userData
  End Method
  
  Rem
  bbdoc: Returns the world position of the body. 
  End Rem
  Method GetPosition:b2Vec2()
    Return b2Vec2._create(bmx_b2bodydef_getposition(b2ObjectPtr))
  End Method
  
  Rem
  bbdoc: The world position of the body. 
  about: Avoid creating bodies at the origin since this can lead to many overlapping shapes.
  End Rem
  Method SetPosition(position:b2Vec2)
    bmx_b2bodydef_setposition(b2ObjectPtr, position.b2ObjectPtr)
  End Method

  Rem
  bbdoc: The world position of the body.
  about: Avoid creating bodies at the origin since this can lead to many overlapping shapes.
  End Rem
  Method SetPositionXY(x:Float, y:Float)
    bmx_b2bodydef_setpositionxy(b2ObjectPtr, x, y)
  End Method
  
  Rem
  bbdoc: Returns the world angle of the body in degrees.
  End Rem
  Method GetAngle:Float()
    Return bmx_b2bodydef_getangle(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: The world angle of the body in degrees.
  End Rem
  Method SetAngle(angle:Float)
    bmx_b2bodydef_setangle(b2ObjectPtr, angle)
  End Method
  
  Rem
  bbdoc: Returns the world angle of the body in radian.
  End Rem
  Method GetAngleRad:Float()
    Return bmx_b2bodydef_getanglerad(b2ObjectPtr)
  End Method

  Rem
  bbdoc: The world angle of the body in radian.
  End Rem
  Method SetAngleRad(angle:Float)
    bmx_b2bodydef_setanglerad(b2ObjectPtr, angle)
  End Method

  Rem
  bbdoc: Returns the linear velocity of the body's origin in world co-ordinates.
  End Rem
  Method GetLinearVelocity:b2Vec2()
    Return b2Vec2._create(bmx_b2bodydef_getlinearvelocity(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Set the linear velocity of the body's origin in world co-ordinates.
  End Rem
  Method SetLinearVelocity(velocity:b2Vec2)
    bmx_b2bodydef_setlinearvelocity(b2ObjectPtr, velocity.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Returns the angular velocity of the body definition.
  End Rem
  Method GetAngularVelocity:Float()
    Return bmx_b2bodydef_getangularvelocity(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Set the Angular Velocity is use to reduce the linear velocity. 
  End Rem
  Method SetAngularVelocity(velocity:Float)
    bmx_b2bodydef_setangularvelocity(b2ObjectPtr, velocity)
  End Method
  
  Rem
  bbdoc: Returns the linear damping of the body definition.
  End Rem
  Method GetLinearDamping:Float()
    Return bmx_b2bodydef_getlineardamping(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Linear damping is use to reduce the linear velocity. 
  about: The damping parameter can be larger than 1.0f but the damping effect 
  becomes sensitive to the time step when the damping parameter is large.
  End Rem
  Method SetLinearDamping(damping:Float)
    bmx_b2bodydef_setlineardamping(b2ObjectPtr, damping)
  End Method
  
  Rem
  bbdoc: Returns the angular damping.
  End Rem
  Method GetAngularDamping:Float()
    Return bmx_b2bodydef_getangulardamping(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Angular damping is use to reduce the angular velocity.
  about: The damping parameter can be larger than 1.0f but the damping effect 
  becomes sensitive to the time step when the damping parameter is large.
  End Rem
  Method SetAngularDamping(damping:Float)
    bmx_b2bodydef_setangulardamping(b2ObjectPtr, damping)
  End Method
  
  Rem
  bbdoc: Returns true if the body is allowed to sleep.
  End Rem
  Method GetAllowSleep:Int()
    Return bmx_b2bodydef_getallowsleep(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Set this flag to false if this body should never fall asleep.
  about: Note that this increases CPU usage.
  End Rem
  Method SetAllowSleep(allow:Int)
    bmx_b2bodydef_setallowsleep(b2ObjectPtr, allow)
  End Method
  
  Rem
  bbdoc: Is this body initially awake or sleeping?
  End Rem
  Method GetAwake:Int()
    Return bmx_b2bodydef_getawake(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Enables/Disables the awake state of the body.
  End Rem
  Method SetAwake(awake:Int)
    bmx_b2bodydef_setawake(b2ObjectPtr, awake)
  End Method

  Rem
  bbdoc: Returns True if rotation is fixed.
  End Rem
  Method GetFixedRotation:Int()
    Return bmx_b2bodydef_getfixedrotation(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Should this body be prevented from rotating? Useful for characters.
  End Rem
  Method SetFixedRotation(fixed:Int)
    bmx_b2bodydef_setfixedrotation(b2ObjectPtr, fixed)
  End Method
  
  Rem
  bbdoc: Returns whether this is a bullet type body.
  End Rem
  Method GetBullet:Int()
    Return bmx_b2bodydef_getbullet(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Is this a fast moving body that should be prevented from tunneling through other moving bodies?
  about: Note that all bodies are prevented from tunneling through kinematic and static bodies. This setting is only considered on dynamic bodies.
  <p>
  Warning: You should use this flag sparingly since it increases processing time.
  </p>
  End Rem
  Method SetBullet(bullet:Int)
    bmx_b2bodydef_setbullet(b2ObjectPtr, bullet)
  End Method  
  
  Rem
  bbdoc: Returns whether this body definition start out active?
  End Rem
  Method GetActive:Int()
    Return bmx_b2bodydef_getactive(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Does this body definition start out active?
  End Rem
  Method SetActive(active:Int)
    bmx_b2bodydef_setactive(b2ObjectPtr, active)
  End Method  

  Rem
  bbdoc: Returns the body type: b2_staticBody, b2_kinematicBody, or b2_dynamicBody.
  about: Note: if a b2_dynamicBody body would have zero mass, the mass is set to one.
  <ul>
  <li><b>b2_staticBody</b> : zero mass, zero velocity, may be manually moved.</li>
  <li><b>b2_kinematicBody</b> : zero mass, non-zero velocity set by user, moved by solver.</li>
  <li><b>b2_dynamicBody</b> : positive mass, non-zero velocity determined by forces, moved by solver.</li>
  </ul>
  End Rem
  Method GetType:Int()
    Return bmx_b2bodydef_gettype(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Set the type of this body:  b2_staticBody, b2_kinematicBody, or b2_dynamicBody.
  about: Note: if a b2_dynamicBody body would have zero mass, the mass is set to one.
  <ul>
  <li><b>b2_staticBody</b> : zero mass, zero velocity, may be manually moved.</li>
  <li><b>b2_kinematicBody</b> : zero mass, non-zero velocity set by user, moved by solver.</li>
  <li><b>b2_dynamicBody</b> : positive mass, non-zero velocity determined by forces, moved by solver.</li>
  </ul>
  End Rem
  Method SetType(bodyType:Int)
    bmx_b2bodydef_settype(b2ObjectPtr, bodyType)
  End Method

  Rem
  bbdoc: Returns the scale the gravity applied to this body.
  End Rem
  Method GetGravityScale:Float()
    Return bmx_b2bodydef_getgravityscale(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Set the scale the gravity applied to this body.
  End Rem
  Method SetGravityScale(gravityScale:Float)
    bmx_b2bodydef_setgravityscale(b2ObjectPtr, gravityScale)
  End Method
    
End Type


' ***********************************************************************************************************
' Type: b2RayCastInput
' ***********************************************************************************************************

Rem
bbdoc: Ray-cast input data.
about: The ray extends from p1 to p1 + maxFraction * (p2 - p1).
endrem
Type b2RayCastInput
  
  Field b2ObjectPtr:Byte Ptr

  Rem
  bbdoc: Returns a new b2RayCastInput from C++ source
  endrem
  Function _create:b2RayCastInput(b2ObjectPtr:Byte Ptr)
    If b2ObjectPtr Then
      Local this:b2RayCastInput = New b2RayCastInput
      this.b2ObjectPtr = b2ObjectPtr
      Return this
    End If
  End Function  
  
  Rem
  bbdoc: Creates a new b2RayCastInput with the given coordinates.
  End Rem
  Method Create:b2RayCastInput(p1:b2Vec2, p2:b2Vec2, maxFraction:Float)
    
    b2ObjectPtr = bmx_b2raycastinput_create(p1.b2ObjectPtr, p2.b2ObjectPtr, maxFraction)
    Return Self
    
  End Method
    
  Rem
  bbdoc: Instantiates a new b2RayCastInput Object.
  about: By default @p1, @p2 and @maxFraction are set to 0.
  endrem
  Method New()
    b2ObjectPtr = bmx_b2raycastinput_create(Vec2(0, 0), Vec2(0, 0), 0)
  End Method
  
  Rem
  bbdoc: Deletes a given b2RayCastInput object
  endrem
  Method Delete()
    If b2ObjectPtr Then
      bmx_b2raycastinput_delete(b2ObjectPtr)
      b2ObjectPtr = Null
    End If
  End Method

  Rem
  bbdoc: Copies @rayCastInput into this object.
  End Rem 
  Method Copy(rayCastInput:b2RayCastInput)
    bmx_b2raycastinput_copy(b2ObjectPtr, rayCastInput.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Returns the @p1, @p2 and @maxFraction.
  End Rem
  Method Get(p1:b2Vec2 Var, p2:b2Vec2 Var, maxFraction:Float Var)
    bmx_b2raycastinput_get(b2ObjectPtr, P1.b2ObjectPtr, P2.b2ObjectPtr, Varptr MaxFraction)
  End Method

  Rem
  bbdoc: Sets the @p1, @p2 and @maxFraction.
  End Rem 
  Method Set(p1:b2Vec2, p2:b2Vec2, maxFraction:Float)
    bmx_b2raycastinput_set(b2ObjectPtr, p1.b2ObjectPtr, p2.b2ObjectPtr, maxFraction)
  End Method

  Rem
  bbdoc: Returns the @p1 b2Vec2.
  about: Synonym for #P1().
  End Rem
  Method GetP1:b2Vec2()
    Return b2Vec2._create(bmx_b2raycastinput_getp1(b2ObjectPtr))
  End Method
    
  Rem
  bbdoc: Returns the @p1 b2Vec2.
  End Rem
  Method P1:b2Vec2()
    Return b2Vec2._create(bmx_b2raycastinput_getp1(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Sets the @p1 b2Vec2.
  End Rem 
  Method SetP1(p1:b2Vec2)
    bmx_b2raycastinput_setp1(b2ObjectPtr, p1.b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Returns the @p2 b2Vec2.
  about: Synonym for #P2().
  End Rem
  Method GetP2:b2Vec2()
    Return b2Vec2._create(bmx_b2raycastinput_getp2(b2ObjectPtr))
  End Method
    
  Rem
  bbdoc: Returns the @p2 b2Vec2.
  End Rem
  Method P2:b2Vec2()
    Return b2Vec2._create(bmx_b2raycastinput_getp2(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Sets the @p2 b2Vec2.
  End Rem 
  Method SetP2(p2:b2Vec2)
    bmx_b2raycastinput_setp2(b2ObjectPtr, p2.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Returns the @maxFraction.
  about: Synonym for #MaxFraction().
  End Rem
  Method GetMaxFraction:Float()
    Return bmx_b2raycastinput_getmaxfraction(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Returns the @maxFraction.
  End Rem
  Method MaxFraction:Float()
    Return bmx_b2raycastinput_getmaxfraction(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Sets the @maxFraction.
  End Rem 
  Method SetMaxFraction(maxFraction:Float)
    bmx_b2raycastinput_setmaxfraction(b2ObjectPtr, maxFraction)
  End Method

EndType

' ***********************************************************************************************************
' Type: b2RayCastOutput
' ***********************************************************************************************************

Rem
bbdoc: Ray-cast output data.
about: The ray hits at @p1 + @fraction * (@p2 - @p1), where @p1 and @p2 come from #b2RayCastInput.
endrem
Type b2RayCastOutput
  
  Field b2ObjectPtr:Byte Ptr

  Rem
  bbdoc: Returns a new b2RayCastOutput from C++ source
  endrem
  Function _create:b2RayCastOutput(b2ObjectPtr:Byte Ptr)
    If b2ObjectPtr Then
      Local this:b2RayCastOutput = New b2RayCastOutput
      this.b2ObjectPtr = b2ObjectPtr
      Return this
    End If
  End Function  
  
  Rem
  bbdoc: Creates a new b2RayCastOutput with the given coordinates.
  End Rem
  Method Create:b2RayCastOutput(normal:b2Vec2, fraction:Float)
    
    b2ObjectPtr = bmx_b2raycastoutput_create(normal.b2ObjectPtr, fraction)
    Return Self
    
  End Method
    
  Rem
  bbdoc: Instantiates a new b2RayCastOutput Object.
  about: By default @normal and @fraction are set to 0.
  endrem
  Method New()
    b2ObjectPtr = bmx_b2raycastoutput_create(Vec2(0, 0), 0)
  End Method
  
  Rem
  bbdoc: Deletes a given b2RayCastOutput object
  endrem
  Method Delete()
    If b2ObjectPtr Then
      bmx_b2raycastoutput_delete(b2ObjectPtr)
      b2ObjectPtr = Null
    End If
  End Method

  Rem
  bbdoc: Copies @rayCastOutput into this object.
  End Rem 
  Method Copy(rayCastOutput:b2RayCastOutput)
    bmx_b2raycastoutput_copy(b2ObjectPtr, rayCastOutput.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Returns the @normal and @fraction.
  End Rem
  Method Get(normal:b2Vec2 Var, fraction:Float Var)
    bmx_b2raycastoutput_get(b2ObjectPtr, normal.b2ObjectPtr, Varptr fraction)
  End Method

  Rem
  bbdoc: Sets the @normal and @fraction.
  End Rem 
  Method Set(normal:b2Vec2, fraction:Float)
    bmx_b2raycastoutput_set(b2ObjectPtr, normal.b2ObjectPtr, fraction)
  End Method

  Rem
  bbdoc: Returns the @normal b2Vec2.
  about: Synonym for #Normal().
  End Rem
  Method GetNormal:b2Vec2()
    Return b2Vec2._create(bmx_b2raycastoutput_getnormal(b2ObjectPtr))
  End Method
    
  Rem
  bbdoc: Returns the @normal b2Vec2.
  End Rem
  Method Normal:b2Vec2()
    Return b2Vec2._create(bmx_b2raycastoutput_getnormal(b2ObjectPtr))
  End Method

  Rem
  bbdoc: Sets the @normal b2Vec2.
  End Rem 
  Method SetNormal(normal:b2Vec2)
    bmx_b2raycastoutput_setnormal(b2ObjectPtr, Normal.b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Returns the @fraction.
  about: Synonym for #Fraction().
  End Rem
  Method GetFraction:Float()
    Return bmx_b2raycastoutput_getfraction(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Returns the @fraction.
  End Rem
  Method Fraction:Float()
    Return bmx_b2raycastoutput_getfraction(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Sets the @fraction.
  End Rem 
  Method SetFraction(fraction:Float)
    bmx_b2raycastoutput_setfraction(b2ObjectPtr, Fraction)
  End Method

EndType


' ***********************************************************************************************************
' Type: b2Vec2
' ***********************************************************************************************************

Rem
bbdoc: Convenience function for creating a b2Vec2 object.
End Rem
Function Vec2:b2Vec2(x:Float, y:Float)
  Return New b2Vec2.Create(x, y)
End Function

Rem
bbdoc: A 2D column vector.
End Rem
Type b2Vec2

  Rem
  bbdoc: A zero vector (0,0)
  End Rem
  Global ZERO:b2Vec2 = New b2Vec2.Create()

  Field b2ObjectPtr:Byte Ptr

  Rem
  bbdoc: Returns a New Array of b2Vec2 object.
  endrem
  Function _newb2Vec2Array:b2Vec2[] (count:Int)
    Return New b2Vec2[count]
  End Function
  
  Rem
  bbdoc: Sets a b2Vec2 at the given @index Array position.
  endrem
  Function _setb2Vec2Array(array:b2Vec2[], index:Int, vec:Byte Ptr)
    array[index] = _create(vec)
  End Function

  Rem
  bbdoc: Returns a b2Vec2 at the given @index Array position.
  endrem
  Function _getb2Vec2Array:Byte Ptr(array:b2Vec2[], index:Int)
    Return array[index].b2ObjectPtr
  End Function

  Rem
  bbdoc: Returns a new b2Vec2 from C++ source
  endrem
  Function _create:b2Vec2(b2ObjectPtr:Byte Ptr)
    If b2ObjectPtr Then
      Local this:b2Vec2 = New b2Vec2
      this.b2ObjectPtr = b2ObjectPtr
      Return this
    End If
  End Function  
  
  Rem
  bbdoc: Creates a new vector with the given coordinates.
  End Rem
  Method Create:b2Vec2(x:Float = 0, y:Float = 0)
    b2ObjectPtr = bmx_b2vec2_create(x, y)
    Return Self
  End Method
  
  Rem
  bbdoc: Creates a new vector From another vector.
  End Rem
  Method CreateFromVec2:b2Vec2(vec:b2Vec2)
    Return _create(bmx_b2vec2_fromvect2(vec.b2ObjectPtr))
  End Method

  Rem
  bbdoc: Creates a new vector with the given coordinates.
  End Rem
  Function CreateVec2:b2Vec2(x:Float = 0, y:Float = 0)
    Return New b2Vec2.Create(x, y)
  End Function
  
  Rem
  bbdoc: Instantiates a new b2Vec2 Object.
  about: By default @x and @y coordinates are set to 0.
  end Rem
  Method New()
    b2ObjectPtr = bmx_b2vec2_create(0.0, 0.0)
  End Method
  
  Rem
  bbdoc: Deletes a given b2Vec2 object
  endrem
  Method Delete()
    If b2ObjectPtr Then
      bmx_b2vec2_delete(b2ObjectPtr)
      b2ObjectPtr = Null
    End If
  End Method
    
  Rem
  bbdoc: Copies @vec into this object.
  End Rem 
  Method Copy(vec:b2Vec2)
    bmx_b2vec2_copy(b2ObjectPtr, vec.b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Returns the @X coordinate.
  about: Synonym for #X().
  End Rem
  Method GetX:Float()
    Return bmx_b2vec2_getx(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Returns the @X coordinate.
  End Rem
  Method X:Float()
    Return bmx_b2vec2_getx(b2ObjectPtr)
  End Method
    
  Rem
  bbdoc: Returns the @Y coordinate.
  about: Synonym for #Y().
  End Rem
  Method GetY:Float()
    Return bmx_b2vec2_gety(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Returns the @Y coordinate.
  End Rem
  Method Y:Float()
    Return bmx_b2vec2_gety(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Set this vector to specified @x and @y coordinates.
  End Rem 
  Method Set(x:Float, y:Float)
    bmx_b2vec2_set(b2ObjectPtr, x, y)
  End Method
  
  Rem
  bbdoc: Sets the @x coordinate.
  End Rem
  Method SetX(x:Float)
    bmx_b2vec2_setx(b2ObjectPtr, x)
  End Method

  Rem
  bbdoc: Sets the @y coordinate.
  End Rem
  Method SetY(y:Float)
    bmx_b2vec2_sety(b2ObjectPtr, y)
  End Method

  Rem
  bbdoc: Set this vector to all zeros.
  End Rem
  Method SetZero()
    bmx_b2vec2_setzero(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Adds @vec to this vector.
  End Rem 
  Method Add:b2Vec2(vec:b2Vec2)
    bmx_b2vec2_add(b2ObjectPtr, vec.b2ObjectPtr)
    Return Self
  End Method

  Rem
  bbdoc: Adds @vec to this vector, returning a new b2Vec2.
  about: This object is not modified.
  End Rem 
  Method AddNew:b2Vec2(vec:b2Vec2)
    Return _create(bmx_b2vec2_addnew(b2ObjectPtr, vec.b2ObjectPtr))
  End Method

  Rem
  bbdoc: Subtracts @vec from this vector.
  End Rem 
  Method Subtract:b2Vec2(vec:b2Vec2)
    bmx_b2vec2_subtract(b2ObjectPtr, vec.b2ObjectPtr)
    Return Self
  End Method

  Rem
  bbdoc: Subtracts @vec from this vector, returning a new b2Vec2.
  about: This object is not modified.
  End Rem 
  Method SubtractNew:b2Vec2(vec:b2Vec2)
    Return _create(bmx_b2vec2_subtractnew(b2ObjectPtr, vec.b2ObjectPtr))
  End Method

  Rem
  bbdoc: Multiply this vector by a scalar @value.
  End Rem 
  Method Multiply:b2Vec2(value:Float)
    bmx_b2vec2_multiply(b2ObjectPtr, value)
    Return Self
  End Method

  Rem
  bbdoc: Multiply this vector by a scalar @value, returning a new b2Vec2.
  about: This object is not modified.
  End Rem 
  Method MultiplyNew:b2Vec2(value:Float)
    Return _create(bmx_b2vec2_multiplynew(b2ObjectPtr, value))
  End Method

  Rem
  bbdoc: Divides the vector by @value.
  End Rem 
  Method Divide:b2Vec2(value:Float)
    bmx_b2vec2_multiply(b2ObjectPtr, 1.0 / value)
    Return Self
  End Method
  
  Rem
  bbdoc: Divides the vector by @value, returning a new b2Vec2.
  about: This object is not modified.
  End Rem 
  Method DivideNew:b2Vec2(value:Float)
    Return _create(bmx_b2vec2_multiplyNew(b2ObjectPtr, 1.0 / value))
  End Method
    
  Rem
  bbdoc: Returns  the @length of this vector (the norm).
  End Rem 
  Method Length:Float()
    Return bmx_b2vec2_length(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Get the length squared.
  returns: The @length @squared
  about: For performance, use this instead of b2Vec2::Length (if possible).
  End Rem
  Method LengthSquared:Float()
    Return bmx_b2vec2_lengthsquared(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Convert this vector into a unit vector.
  returns: The @length. 
  End Rem
  Method Normalize:Float()
    Return bmx_b2vec2_normalize(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Does this vector contain finite coordinates?
  End Rem
  Method IsValid:Int()
    Return bmx_b2vec2_isvalid(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Get the skew vector
  about: Such that dot(skew_vec, other) == cross(vec, other) 
  End Rem 
  Method Skew:b2Vec2()
    Return _create(bmx_b2vec2_skew(b2ObjectPtr))
  End Method
    
EndType


' ***********************************************************************************************************
' Type: b2Vec3
' ***********************************************************************************************************

Rem
bbdoc: Convenience function for creating a b2Vec3 object.
End Rem
Function Vec3:b2Vec3(x:Float, y:Float, z:Float)
  Return New b2Vec3.Create(x, y, z)
End Function

Rem
bbdoc: A 2D column vector with 3 elements.
End Rem
Type b2Vec3

  Rem
  bbdoc: A zero vector (0,0)
  End Rem
  Global ZERO:b2Vec3 = New b2Vec3.Create()

  Field b2ObjectPtr:Byte Ptr

  Rem
  bbdoc: Returns a New Array of b2Vec3 object.
  endrem
  Function _newb2Vec3Array:b2Vec3[] (count:Int)
    Return New b2Vec3[count]
  End Function
  
  Rem
  bbdoc: Sets a b2Vec3 at the given @index Array position.
  endrem
  Function _setb2Vec3Array(array:b2Vec3[], index:Int, vec:Byte Ptr)
    array[index] = _create(vec)
  End Function

  Rem
  bbdoc: Returns a b2Vec3 at the given @index Array position.
  endrem
  Function _getb2Vec3Array:Byte Ptr(array:b2Vec3[], index:Int)
    Return array[index].b2ObjectPtr
  End Function

  Rem
  bbdoc: Returns a new b2Vec3 from C++ source
  endrem
  Function _create:b2Vec3(b2ObjectPtr:Byte Ptr)
    If b2ObjectPtr Then
      Local this:b2Vec3 = New b2Vec3
      this.b2ObjectPtr = b2ObjectPtr
      Return this
    End If
  End Function  
  
  Rem
  bbdoc: Creates a new vector with the given coordinates.
  End Rem
  Method Create:b2Vec3(x:Float = 0, y:Float = 0, z:Float = 0)
    b2ObjectPtr = bmx_b2vec3_create(x, y, z)
    Return Self
  End Method
  
  Rem
  bbdoc: Creates a new vector From another vector.
  End Rem
  Method CreateFromVec3:b2Vec3(vec:b2Vec3)
    Return _create(bmx_b2vec3_fromvect3(vec.b2ObjectPtr))
  End Method

  Rem
  bbdoc: Creates a new vector with the given coordinates.
  End Rem
  Function CreateVec3:b2Vec3(x:Float = 0, y:Float = 0, z:Float = 0)
    Return New b2Vec3.Create(x, y, z)
  End Function
  
  Rem
  bbdoc: Instantiates a new b2Vec3 Object.
  about: By default @x, @y and @z coordinates are set to 0.
  end Rem
  Method New()
    b2ObjectPtr = bmx_b2vec3_create(0, 0, 0)
  End Method
  
  Rem
  bbdoc: Deletes a given b2Vec3 object
  endrem
  Method Delete()
    If b2ObjectPtr Then
      bmx_b2vec3_delete(b2ObjectPtr)
      b2ObjectPtr = Null
    End If
  End Method
    
  Rem
  bbdoc: Copies @vec into this object.
  End Rem 
  Method Copy(vec:b2Vec3)
    bmx_b2vec3_copy(b2ObjectPtr, vec.b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Returns the @x coordinate.
  about: Synonym for #X().
  End Rem
  Method GetX:Float()
    Return bmx_b2vec3_getx(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Returns the @x coordinate.
  End Rem
  Method X:Float()
    Return bmx_b2vec3_getx(b2ObjectPtr)
  End Method
    
  Rem
  bbdoc: Returns the @y coordinate.
  about: Synonym for #Y().
  End Rem
  Method GetY:Float()
    Return bmx_b2vec3_gety(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Returns the @y coordinate.
  End Rem
  Method Y:Float()
    Return bmx_b2vec3_gety(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Returns the @z coordinate.
  about: Synonym for #Z().
  End Rem
  Method GetZ:Float()
    Return bmx_b2vec3_getz(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Returns the @z coordinate.
  End Rem
  Method Z:Float()
    Return bmx_b2vec3_getz(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Sets the @x, @y and @z parts.
  End Rem 
  Method Set(x:Float, y:Float, z:Float)
    bmx_b2vec3_set(b2ObjectPtr, x, y, z)
  End Method
  
  Rem
  bbdoc: Sets the @x part.
  End Rem
  Method SetX(x:Float)
    bmx_b2vec3_setx(b2ObjectPtr, x)
  End Method

  Rem
  bbdoc: Sets the @y part.
  End Rem
  Method SetY(y:Float)
    bmx_b2vec3_sety(b2ObjectPtr, y)
  End Method

  Rem
  bbdoc: Sets the @z part.
  End Rem
  Method SetZ(z:Float)
    bmx_b2vec3_setz(b2ObjectPtr, z)
  End Method

  Rem
  bbdoc: Set this vector to all zeros.
  End Rem
  Method SetZero()
    bmx_b2vec3_setzero(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Adds @vec to this vector.
  End Rem 
  Method Add:b2Vec3(vec:b2Vec3)
    bmx_b2vec3_add(b2ObjectPtr, vec.b2ObjectPtr)
    Return Self
  End Method

  Rem
  bbdoc: Adds @vec to this vector, returning a new b2Vec3.
  about: This object is not modified.
  End Rem 
  Method AddNew:b2Vec3(vec:b2Vec3)
    Return _create(bmx_b2vec3_addnew(b2ObjectPtr, vec.b2ObjectPtr))
  End Method

  Rem
  bbdoc: Subtracts @vec from this vector.
  End Rem 
  Method Subtract:b2Vec3(vec:b2Vec3)
    bmx_b2vec3_subtract(b2ObjectPtr, vec.b2ObjectPtr)
    Return Self
  End Method

  Rem
  bbdoc: Subtracts @vec from this vector, returning a new b2Vec3.
  about: This object is not modified.
  End Rem 
  Method SubtractNew:b2Vec3(vec:b2Vec3)
    Return _create(bmx_b2vec3_subtractnew(b2ObjectPtr, vec.b2ObjectPtr))
  End Method

  Rem
  bbdoc: Multiplies the vector by @value.
  End Rem 
  Method Multiply:b2Vec3(value:Float)
    bmx_b2vec3_multiply(b2ObjectPtr, value)
    Return Self
  End Method

  Rem
  bbdoc: Multiplies the vector by @value, returning a new b2Vec3.
  about: This object is not modified.
  End Rem 
  Method MultiplyNew:b2Vec3(value:Float)
    Return _create(bmx_b2vec3_multiplynew(b2ObjectPtr, value))
  End Method

  Rem
  bbdoc: Divides the vector by @value.
  End Rem 
  Method Divide:b2Vec3(value:Float)
    bmx_b2vec3_multiply(b2ObjectPtr, 1.0 / value)
    Return Self
  End Method
  
  Rem
  bbdoc: Divides the vector by @value, returning a new b2Vec3.
  about: This object is not modified.
  End Rem 
  Method DivideNew:b2Vec3(value:Float)
    Return _create(bmx_b2vec3_multiplyNew(b2ObjectPtr, 1.0 / value))
  End Method
  
EndType


' ***********************************************************************************************************
' Type: b2World
' ***********************************************************************************************************

Rem
bbdoc: The world class manages all physics entities, dynamic simulation, and asynchronous queries. 
about: The world also contains efficient memory management facilities.
End Rem
Type b2World

  Field b2ObjectPtr:Byte Ptr
  
' Field filter:b2ContactFilter
' Field contactListener:b2ContactListener
' Field boundaryListener:b2BoundaryListener
  Field destructionListener:b2DestructionListener
  
  Function _create:b2World(b2ObjectPtr:Byte Ptr)
    If b2ObjectPtr Then
      Local this:b2World = New b2World
      this.b2ObjectPtr = b2ObjectPtr
      Return this
    End If
  End Function

  Rem
  bbdoc: Construct a world object.
  about: @gravity : The world gravity vector.
  End Rem
  Function CreateWorld:b2World(gravity:b2Vec2)
    Return New b2World.Create(gravity)
  End Function
  
  Rem
  bbdoc: Construct a world object.
  about: @gravity : The world gravity vector.
  End Rem
  Method Create:b2World(gravity:b2Vec2)
    b2ObjectPtr = bmx_b2world_create(gravity.b2ObjectPtr)   
    ' setup default destruction listener
    SetDestructionListener(New b2DestructionListener)
    Return Self
  End Method

  Rem
  bbdoc: Destruct the world.
  about: All physics entities are destroyed and all heap memory is released.
  end Rem
  Method Free()
    If b2ObjectPtr Then
      bmx_b2world_free(b2ObjectPtr)
      b2ObjectPtr = Null
    End If
  End Method
  
  Rem
  bbdoc: Destruct the world.
  about: All physics entities are destroyed and all heap memory is released.
  end Rem
  Method Delete()
    Free()
  End Method
  
  Rem
  bbdoc: Register a destruction listener.
  End Rem
  Method SetDestructionListener(listener:b2DestructionListener)
    destructionListener = listener
    bmx_b2world_setdestructionlistener(b2ObjectPtr, listener.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Register a broad-phase boundary listener.
  End Rem
' Method SetBoundaryListener(listener:b2BoundaryListener)
'   boundaryListener = listener
'   bmx_b2world_setboundarylistener(b2ObjectPtr, listener.b2ObjectPtr)
' End Method

  Rem
  bbdoc: Register a contact filter to provide specific control over collision.
  about: Otherwise the default filter is used.
  End Rem
' Method SetFilter(_filter:b2ContactFilter)
'   filter = _filter
'   bmx_b2world_setfilter(b2ObjectPtr, filter.b2ObjectPtr)
' End Method

  Rem
  bbdoc: Register a contact event listener
  End Rem
' Method SetContactListener(listener:b2ContactListener)
'   contactListener = listener
'   bmx_b2world_setcontactlistener(b2ObjectPtr, listener.b2ObjectPtr)
' End Method

  Rem
  bbdoc: Register a routine for debug drawing.
  about: The debug draw functions are called inside the b2World::DoStep method, so make sure your renderer is ready to
  consume draw commands when you call DoStep().
  End Rem
  Method SetDebugDraw(debugDraw:b2Draw)
    bmx_b2world_setDebugDraw(b2ObjectPtr, debugDraw.b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Create a rigid body given a definition. 
  about: No reference to the definition is retained.
  <p>
  Warning: This method is locked during callbacks.
  </p>
  End Rem
  Method CreateBody:b2Body(def:b2BodyDef)
    Local body:b2Body = New b2Body
    body.userData = def.userData ' copy the userData
    body.b2ObjectPtr = bmx_b2world_createbody(b2ObjectPtr, def.b2ObjectPtr, body)
    Return body
  End Method

  Rem
  bbdoc: Destroy a rigid body given a definition.
  about: No reference to the definition is retained.
  <p>Warning: This automatically deletes all associated shapes and joints.</p>
  <p>Warning: This method is locked during callbacks.</p>
  End Rem
  Method DestroyBody(body:b2Body)
    bmx_b2world_destroybody(b2ObjectPtr, body.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Create a joint to constrain bodies together.
  about: No reference to the definition is retained. This may cause the connected bodies to cease
  colliding.
  <p>
  Warning: This method is locked during callbacks.
  </p>
  End Rem
  Method CreateJoint:b2Joint(def:b2JointDef)
    Local joint:b2Joint = b2Joint._create(bmx_b2world_createjoint(b2ObjectPtr, def.b2ObjectPtr))
    joint.userData = def.userData ' copy the userData
    Return joint
  End Method

  Function _createJoint:b2Joint(jointType:Int)
    Local joint:b2Joint
    Select jointType
      Case e_unknownJoint
        joint = New b2Joint
      Case e_revoluteJoint
'       joint = New b2RevoluteJoint
      Case e_prismaticJoint
'       joint = New b2PrismaticJoint
      Case e_distanceJoint
'       joint = New b2DistanceJoint
      Case e_pulleyJoint
'       joint = New b2PulleyJoint
      Case e_mouseJoint
        joint = New b2MouseJoint
      Case e_gearJoint
'       joint = New b2GearJoint
      Case e_wheelJoint
'       joint = New b2WeelJoint
      Case e_weldJoint
'       joint = New b2WeldJoint
      Case e_frictionJoint
'       joint = New b2FrictionJoint
      Case e_ropeJoint
'       joint = New b2RopeJoint
      Case e_motorJoint
'       joint = New b2MotorJoint
      Default
        DebugLog "Warning, joint type '" + jointType + "' is not defined in module."
        joint = New b2Joint
    End Select
    Return joint
  End Function

  Rem
  bbdoc: Destroy a joint.
  about: This may cause the connected bodies to begin colliding.
  <p>
  Warning: This method is locked during callbacks.
  </p>
  End Rem
  Method DestroyJoint(joint:b2Joint)
    bmx_b2world_destroyjoint(b2ObjectPtr, joint.b2ObjectPtr)
  End Method

  Rem
  bbdoc: Add a controller to the world.
  End Rem
' Method CreateController:b2Controller(def:b2ControllerDef)
'   Local controller:b2Controller = b2Controller._create(bmx_b2world_createcontroller(b2ObjectPtr, def.b2ObjectPtr, def._type))
'   controller.userData = def.userData ' copy the userData
'   Return controller
' End Method
' ' 
' Function __createController:b2Controller(controllerType:Int)
'   Local controller:b2Controller
'   Select controllerType
'     Case e_buoyancyController
'       controller = New b2BuoyancyController
'     Case e_constantAccelController
'       controller = New b2ConstantAccelController
'     Case e_tensorDampingController
'       controller = New b2TensorDampingController
'     Case e_gravityController
'       controller = New b2GravityController
'     Case e_constantForceController
'       controller = New b2ConstantForceController
'     Default
'       DebugLog "Warning, controller type '" + controllerType + "' is not defined in module."
'       controller = New b2Controller
'   End Select
'   Return controller
' End Function

  Rem
  bbdoc: Removes a controller from the world.
  End Rem
' Method DestroyController(controller:b2Controller)
'   bmx_b2world_destroycontroller(b2ObjectPtr, controller.b2ObjectPtr)
' End Method

  Rem
  bbdoc: Take a time Step.
  about: This performs collision detection, integration, and constraint solution.
  <p>Parameters: 
  <ul>
  <li><b> timeStep </b> : the amount of time To simulate, this should Not vary. </li>
  <li><b> velocityIterations </b> : for the velocity constraint solver.</li>
  <li><b> positionIterations </b> : for the position constraint solver.</li>
  </ul>
  </p>
  End Rem
  Method DoStep(timeStep:Float, velocityIterations:Int, positionIterations:Int)
    bmx_b2world_dostep(b2ObjectPtr, timeStep, velocityIterations, positionIterations)
  End Method

  Rem
  bbdoc: Get the world body list. 
  returns: The head of the world body list. 
  about: With the returned body, use b2Body::GetNext to get the next body in the world list. A NULL body indicates
  the end of the list. 
  End Rem
' Method GetBodyList:b2Body()
'   Return b2Body._create(bmx_b2world_getbodylist(b2ObjectPtr))
' End Method

  Rem
  bbdoc: Get the world joint list.
  returns: The head of the world joint list. 
  about: With the returned joint, use b2Joint::GetNext to get the next joint in the world list. A NULL joint indicates
  the end of the list.
  End Rem
' Method GetJointList:b2Joint()
'   Return b2Joint._create(bmx_b2world_getjointlist(b2ObjectPtr))
' End Method

  Rem
  bbdoc: Get Sleeping parameter.
  End Rem
  Method GetAllowSleeping:Int()
    return bmx_b2world_getallowsleeping(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Enable/disable Sleeping parameter. 
  End Rem
  Method SetAllowSleeping(flag:Int)
    bmx_b2world_setallowsleeping(b2ObjectPtr, flag)
  End Method

  Rem
  bbdoc: Get Warm Starting parameter.
  End Rem
  Method GetWarmStarting:Int()
    return bmx_b2world_getwarmstarting(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Enable/disable warm starting. For testing. 
  End Rem
  Method SetWarmStarting(flag:Int)
    bmx_b2world_setwarmstarting(b2ObjectPtr, flag)
  End Method

  Rem
  bbdoc: Get continuous physics parameter. 
  End Rem
  Method GetContinuousPhysics:Int()
    return bmx_b2world_getcontinuousphysics(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Enable/disable continuous physics. For testing. 
  End Rem
  Method SetContinuousPhysics(flag:Int)
    bmx_b2world_setcontinuousphysics(b2ObjectPtr, flag)
  End Method

  Rem
  bbdoc: Get the single stepped continuous physics parameter. 
  End Rem
  Method GetSubStepping:Int()
    return bmx_b2world_getsubstepping(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Enable/disable the single stepped continuous physics. For testing.
  End Rem
  Method SetSubStepping(flag:Int)
    bmx_b2world_setsubstepping(b2ObjectPtr, flag)
  End Method

  Rem
  bbdoc: Perform Drawing operation of Debug data structures.
  End Rem
  Method DrawDebugData()
    bmx_b2world_DrawDebugData(b2ObjectPtr)
  End Method

  Rem
  bbdoc:  Get the global gravity vector.
  End Rem
  Method GetGravity:b2Vec2()
    return b2Vec2._create(bmx_b2world_getgravity(b2ObjectPtr))
  End Method
  
  Rem
  bbdoc:  Change the global gravity vector.
  End Rem
  Method SetGravity(gravity:b2Vec2)
    bmx_b2world_setgravity(b2ObjectPtr, gravity.b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Get the number of broad-phase proxies.
  End Rem
  Method GetProxyCount:Int()
    Return bmx_b2world_getproxycount(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Get the number of contacts (each may have 0 or more contact points).
  End Rem
  Method GetContactCount:Int()
    Return bmx_b2world_getcontactcount(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Get the number of bodies.
  End Rem
  Method GetBodyCount:Int()
    Return bmx_b2world_getbodycount(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Get the number joints.
  End Rem
  Method GetJointCount:Int()
    Return bmx_b2world_getjointcount(b2ObjectPtr)
  End Method
  
  Rem
  bbdoc: Get the height of the dynamic tree.
  End Rem
  Method GetTreeHeight:Int()
    Return bmx_b2world_gettreeheight(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Get the balance of the dynamic tree.
  End Rem
  Method GetTreeBalance:Int()
    Return bmx_b2world_gettreebalance(b2ObjectPtr)
  End Method

  Rem
  bbdoc: Query the world for all fixtures that potentially overlap the provided AABB.
  about: @callback: A user implemented callback class.<br>@aabb: The query box.
  End Rem
  Method QueryAABB(callback:b2QueryCallback, aabb:b2AABB)
    bmx_b2world_queryaabb(b2ObjectPtr, callback.b2ObjectPtr, aabb.b2ObjectPtr)
  End Method
  
  Rem
  bbdoc:  Query the world for all shapes that intersect a given segment.
  about: You provide a shape array of an appropriate size. The number of shapes found is returned, and the array
  is filled in order of intersection.
  End Rem
' Method Raycast:Int(segment:b2Segment, shapes:b2Shape[], solidShapes:Int)
'   Return bmx_b2world_raycast(b2ObjectPtr, segment.b2ObjectPtr, shapes, solidShapes)
' End Method
  
  Function _setShape(shapes:b2Shape[], index:Int, shape:Byte Ptr)
    shapes[index] = b2Shape._create(shape)
  End Function
  
End Type
