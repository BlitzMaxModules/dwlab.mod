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

Import BRL.Blitz

Import "*.h"

Import "glue.cpp"

Import "Box2D/Collision/b2BroadPhase.cpp"
Import "Box2D/Collision/b2CollideCircle.cpp"
Import "Box2D/Collision/b2CollideEdge.cpp"
Import "Box2D/Collision/b2CollidePolygon.cpp"
Import "Box2D/Collision/b2Collision.cpp"
Import "Box2D/Collision/b2Distance.cpp"
Import "Box2D/Collision/b2DynamicTree.cpp"
Import "Box2D/Collision/b2TimeOfImpact.cpp"

Import "Box2D/Collision/Shapes/b2ChainShape.cpp"
Import "Box2D/Collision/Shapes/b2CircleShape.cpp"
Import "Box2D/Collision/Shapes/b2EdgeShape.cpp"
Import "Box2D/Collision/Shapes/b2PolygonShape.cpp"

Import "Box2D/Common/b2BlockAllocator.cpp"
Import "Box2D/Common/b2Draw.cpp"
Import "Box2D/Common/b2Math.cpp"
Import "Box2D/Common/b2Settings.cpp"
Import "Box2D/Common/b2StackAllocator.cpp"
Import "Box2D/Common/b2Timer.cpp"

Import "Box2D/Dynamics/b2Body.cpp"
Import "Box2D/Dynamics/b2ContactManager.cpp"
Import "Box2D/Dynamics/b2Fixture.cpp"
Import "Box2D/Dynamics/b2Island.cpp"
Import "Box2D/Dynamics/b2World.cpp"
Import "Box2D/Dynamics/b2WorldCallbacks.cpp"

Import "Box2D/Dynamics/Contacts/b2ChainAndCircleContact.cpp"
Import "Box2D/Dynamics/Contacts/b2ChainAndPolygonContact.cpp"
Import "Box2D/Dynamics/Contacts/b2CircleContact.cpp"
Import "Box2D/Dynamics/Contacts/b2Contact.cpp"
Import "Box2D/Dynamics/Contacts/b2ContactSolver.cpp"
Import "Box2D/Dynamics/Contacts/b2EdgeAndCircleContact.cpp"
Import "Box2D/Dynamics/Contacts/b2EdgeAndPolygonContact.cpp"
Import "Box2D/Dynamics/Contacts/b2PolygonAndCircleContact.cpp"
Import "Box2D/Dynamics/Contacts/b2PolygonContact.cpp"

Import "Box2D/Dynamics/Joints/b2DistanceJoint.cpp"
Import "Box2D/Dynamics/Joints/b2FrictionJoint.cpp"
Import "Box2D/Dynamics/Joints/b2GearJoint.cpp"
Import "Box2D/Dynamics/Joints/b2Joint.cpp"
Import "Box2D/Dynamics/Joints/b2MotorJoint.cpp"
Import "Box2D/Dynamics/Joints/b2MouseJoint.cpp"
Import "Box2D/Dynamics/Joints/b2PrismaticJoint.cpp"
Import "Box2D/Dynamics/Joints/b2PulleyJoint.cpp"
Import "Box2D/Dynamics/Joints/b2RevoluteJoint.cpp"
Import "Box2D/Dynamics/Joints/b2RopeJoint.cpp"
Import "Box2D/Dynamics/Joints/b2WeldJoint.cpp"
Import "Box2D/Dynamics/Joints/b2WheelJoint.cpp"

Import "Box2D/Rope/b2Rope.cpp"

'Only when b2DebugDraw is available (or whatever...)
'Import "Box2D/Dynamics/Controllers/b2BuoyancyController.cpp"
'Import "Box2D/Dynamics/Controllers/b2ConstantAccelController.cpp"
'Import "Box2D/Dynamics/Controllers/b2ConstantForceController.cpp"
'Import "Box2D/Dynamics/Controllers/b2Controller.cpp"
'Import "Box2D/Dynamics/Controllers/b2GravityController.cpp"
'Import "Box2D/Dynamics/Controllers/b2TensorDampingController.cpp"
