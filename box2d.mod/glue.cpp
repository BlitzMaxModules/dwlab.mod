/*
  Copyright (c) 2012 - Michaël Lievens
 
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  
  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
*/

#include <blitz.h>
#include "Box2D.h"


class MaxDestructionListener;
class MaxQueryCallback;
class MaxDraw;

enum b2ControllerType
{
	e_buoyancyController,
	e_constantAccelController,
	e_tensorDampingController,
	e_gravityController,
	e_constantForceController
};


extern "C" {

	b2Vec2 * bmx_b2vec2_create(float32 x, float32 y);
	b2Vec2 * bmx_b2vec2_fromvect2(b2Vec2 * vec);
	void bmx_b2vec2_delete(b2Vec2 * vec);
	void bmx_b2vec2_copy(b2Vec2 * vec, b2Vec2 * other);
	float32 bmx_b2vec2_getx(b2Vec2 * vec);
	float32 bmx_b2vec2_gety(b2Vec2 * vec);
	void bmx_b2vec2_set(b2Vec2 * vec, float32 x, float32 y);
	void bmx_b2vec2_setx(b2Vec2 * vec, float32 x);
	void bmx_b2vec2_sety(b2Vec2 * vec, float32 y);
	void bmx_b2vec2_setzero(b2Vec2 * vec);
	void bmx_b2vec2_add(b2Vec2 * vec, b2Vec2 * other);
	b2Vec2 * bmx_b2vec2_addnew(b2Vec2 * vec, b2Vec2 * other);
	void bmx_b2vec2_subtract(b2Vec2 * vec, b2Vec2 * other);
	b2Vec2 * bmx_b2vec2_subtractnew(b2Vec2 * vec, b2Vec2 * other);
	void bmx_b2vec2_multiply(b2Vec2 * vec, float32 value);
	b2Vec2 * bmx_b2vec2_multiplynew(b2Vec2 * vec, float32 value);
	float32 bmx_b2vec2_length(b2Vec2 * vec);
	float32 bmx_b2vec2_lengthsquared(b2Vec2 * vec);
	float32 bmx_b2vec2_normalize(b2Vec2 * vec);
	int bmx_b2vec2_isvalid(b2Vec2 * vec);
	b2Vec2 * bmx_b2vec2_skew(b2Vec2 * vec);
	
	BBArray * _arm_box2d_b2Vec2__newb2Vec2Array(int count);
	void _arm_box2d_b2Vec2__setb2Vec2Array(BBArray * array, int index, b2Vec2 * vec);
	b2Vec2 * _arm_box2d_b2Vec2__getb2Vec2Array(BBArray * array, int index);
	BBArray * bmx_b2vec2_getvertexarray(const b2Vec2* vertices, int32 vertexCount);

	void _arm_box2d_b2Draw__DrawPolygon(BBObject * maxHandle, BBArray * array, int r, int g, int b);
	void _arm_box2d_b2Draw__DrawSolidPolygon(BBObject * maxHandle, BBArray * array, int r, int g, int b);
	void _arm_box2d_b2Draw__DrawSegment(BBObject * maxHandle, b2Vec2 * p1, b2Vec2 * p2, int r, int g, int b);
	void _arm_box2d_b2Draw__DrawSolidCircle(BBObject * maxHandle, b2Vec2 * center, float32 radius, b2Vec2 * axis, int r, int g, int b);
	void _arm_box2d_b2Draw__DrawTransform(BBObject * maxHandle, b2Transform * xf);

	BBObject * _arm_box2d_b2World__createJoint(b2JointType type);
//  [WRONG]
//	BBObject * _arm_box2d_b2Body_MaxCreateFixture(b2FixtureDef def);

	
	b2Vec3 * bmx_b2vec3_create(float32 x, float32 y, float32 z);
	b2Vec3 * bmx_b2vec3_fromvect3(b2Vec3 * vec);
	void bmx_b2vec3_delete(b2Vec3 * vec);
	void bmx_b2vec3_copy(b2Vec3 * vec, b2Vec3 * other);
	float32 bmx_b2vec3_getx(b2Vec3 * vec);
	float32 bmx_b2vec3_gety(b2Vec3 * vec);
	float32 bmx_b2vec3_getz(b2Vec3 * vec);
	void bmx_b2vec3_set(b2Vec3 * vec, float32 x, float32 y, float32 z);
	void bmx_b2vec3_setx(b2Vec3 * vec, float32 x);
	void bmx_b2vec3_sety(b2Vec3 * vec, float32 y);
	void bmx_b2vec3_setz(b2Vec3 * vec, float32 z);
	void bmx_b2vec3_setzero(b2Vec3 * vec);
	void bmx_b2vec3_add(b2Vec3 * vec, b2Vec3 * other);
	b2Vec3 * bmx_b2vec3_addnew(b2Vec3 * vec, b2Vec3 * other);
	void bmx_b2vec3_subtract(b2Vec3 * vec, b2Vec3 * other);
	b2Vec3 * bmx_b2vec3_subtractnew(b2Vec3 * vec, b2Vec3 * other);
	void bmx_b2vec3_multiply(b2Vec3 * vec, float32 value);
	b2Vec3 * bmx_b2vec3_multiplynew(b2Vec3 * vec, float32 value);
	
	BBArray * _arm_box2d_b2Vec3__newb2Vec3Array(int count);
	void _arm_box2d_b2Vec3__setb2Vec3Array(BBArray * array, int index, b2Vec3 * vec);
	b2Vec3 * _arm_box2d_b2Vec3__getb2Vec3Array(BBArray * array, int index);
	BBArray * bmx_b2vec3_getvertexarray(const b2Vec3* vertices, int32 vertexCount);

	

	b2Rot * bmx_b2rot_create();
	b2Rot * bmx_b2rot_createrotation(float32 angle);
	b2Rot * bmx_b2rot_createrotationrad(float32 angle);
	void bmx_b2rot_delete(b2Rot * rot);
	void bmx_b2rot_setidentity(b2Rot * rot);
	void bmx_b2rot_set(b2Rot * rot, float32 angle);
	void bmx_b2rot_setrad(b2Rot * rot, float32 angle);
	float32 bmx_b2rot_getangle(b2Rot * rot);
	float32 bmx_b2rot_getanglerad(b2Rot * rot);
	b2Vec2 * bmx_b2rot_getxaxis(b2Rot * rot);
	b2Vec2 * bmx_b2rot_getyaxis(b2Rot * rot);
	float32 bmx_b2rot_getsinus(b2Rot * rot);
	void bmx_b2rot_setsinus(b2Rot * rot, float32 sinus);
	float32 bmx_b2rot_getcosinus(b2Rot * rot);
	void bmx_b2rot_setcosinus(b2Rot * rot, float32 cosinus);
	
	
	
	b2Transform * bmx_b2transform_create();
	b2Transform * bmx_b2transform_createtransform(b2Vec2 * position, b2Rot * rotation);
	void bmx_b2transform_delete(b2Transform * trans);
	void bmx_b2transform_setidentity(b2Transform * trans);
	void bmx_b2transform_set(b2Transform * trans, b2Vec2 * position, float32 angle);
	void bmx_b2transform_setrad(b2Transform * trans, b2Vec2 * position, float32 angle);
	b2Vec2 * bmx_b2transform_getposition(b2Transform * trans);
	void bmx_b2transform_setposition(b2Transform * trans, b2Vec2 * position);
	b2Rot * bmx_b2transform_getrotation(b2Transform * trans);
	void bmx_b2transform_setrotation(b2Transform * trans, b2Rot * rotation);
	
	

	b2RayCastInput * bmx_b2raycastinput_create(b2Vec2 * p1, b2Vec2 * p2,  float32 maxFraction);
	void bmx_b2raycastinput_delete(b2RayCastInput * rayCastInput);
	void bmx_b2raycastinput_copy(b2RayCastInput * rayCastInput, b2RayCastInput * other);
	void bmx_b2raycastinput_get(b2RayCastInput * rayCastInput, b2Vec2 * p1, b2Vec2 * p2, float32 * maxFraction);
	void bmx_b2raycastinput_set(b2RayCastInput * rayCastInput, b2Vec2 * p1, b2Vec2 * p2, float32 maxFraction);
	b2Vec2 * bmx_b2raycastinput_getp1(b2RayCastInput * rayCastInput);
	void bmx_b2raycastinput_setp1(b2RayCastInput * rayCastInput, b2Vec2 * p1);
	b2Vec2 * bmx_b2raycastinput_getp2(b2RayCastInput * rayCastInput);
	void bmx_b2raycastinput_setp2(b2RayCastInput * rayCastInput, b2Vec2 * p2);
	float32 bmx_b2raycastinput_getmaxfraction(b2RayCastInput * rayCastInput);
	void bmx_b2raycastinput_setmaxfraction(b2RayCastInput * rayCastInput, float32 maxFraction);
	

	b2RayCastOutput * bmx_b2raycastoutput_create(b2Vec2 * normal,  float32 fraction);
	void bmx_b2raycastoutput_delete(b2RayCastOutput * rayCastOutput);
	void bmx_b2raycastoutput_copy(b2RayCastOutput * rayCastOutput, b2RayCastOutput * other);
	void bmx_b2raycastoutput_get(b2RayCastOutput * rayCastOutput, b2Vec2 * normal, float32 * fraction);
	void bmx_b2raycastoutput_set(b2RayCastOutput * rayCastOutput, b2Vec2 * normal, float32 fraction);
	b2Vec2 * bmx_b2raycastoutput_getnormal(b2RayCastOutput * rayCastOutput);
	void bmx_b2raycastoutput_setnormal(b2RayCastOutput * rayCastOutput, b2Vec2 * normal);
	float32 bmx_b2raycastoutput_getfraction(b2RayCastOutput * rayCastOutput);
	void bmx_b2raycastoutput_setfraction(b2RayCastOutput * rayCastOutput, float32 fraction);
	

	b2AABB * bmx_b2aabb_create(b2Vec2 * lowerBound, b2Vec2 * upperBound);
	void bmx_b2aabb_delete(b2AABB * aabb);
	void bmx_b2aabb_get(b2AABB * aabb, b2Vec2 * lowerBound, b2Vec2 * upperBound);
	void bmx_b2aabb_set(b2AABB * aabb, b2Vec2 * lowerBound, b2Vec2 * upperBound);
	b2Vec2 * bmx_b2aabb_getlowerbound(b2AABB * aabb);
	void bmx_b2aabb_setlowerbound(b2AABB * aabb, b2Vec2 * lowerBound);
	b2Vec2 * bmx_b2aabb_getupperbound(b2AABB * aabb);
	void bmx_b2aabb_setupperbound(b2AABB * aabb, b2Vec2 * upperBound);
	int bmx_b2aabb_isvalid(b2AABB * aabb);
	b2Vec2 * bmx_b2aabb_getcenter(b2AABB * aabb);
	b2Vec2 * bmx_b2aabb_getextents(b2AABB * aabb);
	float32 bmx_b2aabb_getperimeter(b2AABB * aabb);
	void bmx_b2aabb_combine(b2AABB * aabb, b2AABB * other);
	void bmx_b2aabb_combine2(b2AABB * aabb, b2AABB * other1, b2AABB * other2);
	int bmx_b2aabb_raycast(b2AABB * aabb, b2RayCastOutput * rayCastOutput, b2RayCastInput * rayCastInput);
	int bmx_b2aabb_contains(b2AABB * aabb, b2AABB * other);


		
	BBObject * bmx_b2fixture_getmaxfixture(b2Fixture * fixture);
	int bmx_b2fixture_gettype(b2Fixture * fixture);
	b2Body * bmx_b2fixture_getbody(b2Fixture * fixture);
	int bmx_b2fixture_issensor(b2Fixture * fixture);
	int bmx_b2fixture_testpoint(b2Fixture * fixture, b2Vec2 * point);

	
		
	b2Filter * bmx_b2filter_create(uint16 categoryBits, uint16 maskBits, int16 	groupIndex);
	void bmx_b2filter_delete(b2Filter * filter);
	uint16 bmx_b2filter_getcategorybits(b2Filter * filter);
	void bmx_b2filter_setcategorybits(b2Filter * filter, uint16 categoryBits);
	uint16 bmx_b2filter_getmaskbits(b2Filter * filter);
	void bmx_b2filter_setmaskbits(b2Filter * filter, uint16 maskBits);
	int16 bmx_b2filter_getgroupindex(b2Filter * filter);
	void bmx_b2filter_setgroupindex(b2Filter * filter, int16 groupIndex);
	
	b2FixtureDef * bmx_b2fixturedef_create();
	const b2Shape * bmx_b2fixturedef_getshape(b2FixtureDef * def);
	void bmx_b2fixturedef_setshape(b2FixtureDef * def, b2Shape * shape);
	float32 bmx_b2fixturedef_getfriction(b2FixtureDef * def);
	void bmx_b2fixturedef_setfriction(b2FixtureDef * def, float32 friction);
	float32 bmx_b2fixturedef_getrestitution(b2FixtureDef * def);
	void bmx_b2fixturedef_setrestitution(b2FixtureDef * def, float32 restitution);
	float32 bmx_b2fixturedef_getdensity(b2FixtureDef * def);
	void bmx_b2fixturedef_setdensity(b2FixtureDef * def, float32 density);
	int bmx_b2fixturedef_issensor(b2FixtureDef * def);
	void bmx_b2fixturedef_setissensor(b2FixtureDef * def, int sensor);
	void bmx_b2fixturedef_setfilter(b2FixtureDef * def, b2Filter * filter);
	b2Filter* bmx_b2fixturedef_getfilter(b2FixtureDef * def);
	
	
	
	b2CircleShape * bmx_b2circleshape_create();

	

	b2PolygonShape * bmx_b2polygonshape_create();
	void bmx_b2polygonshape_setasbox(b2PolygonShape * shape, float32 hx, float32 hy);
	void bmx_b2polygondef_setasorientedbox(b2PolygonShape * shape, float32 hx, float32 hy, b2Vec2 * center, float32 angle);
	void bmx_b2polygondef_setasorientedboxrad(b2PolygonShape * shape, float32 hx, float32 hy, b2Vec2 * center, float32 angle);
	

	
	BBObject * bmx_b2body_getmaxbody(b2Body * body);
	b2Fixture * bmx_b2body_createfixture(b2Body * body, b2FixtureDef * def);
	b2Fixture * bmx_b2body__createfixture(b2Body * body, b2Shape * shape, float32 density);
	void bmx_b2body_destroyfixture(b2Body * body, b2Fixture * fixture);
	b2Vec2 * bmx_b2body_getposition(b2Body * body);
	float32 bmx_b2body_getangle(b2Body * body);
	float32 bmx_b2body_getanglerad(b2Body * body);
	b2Body * bmx_b2body_getnext(b2Body * body);
	b2Fixture * bmx_b2body_getfixturelist(b2Body * body);
	int bmx_b2body_isawake(b2Body * body);
	void bmx_b2body_setawake(b2Body * body, int flag);
	int bmx_b2body_isbullet(b2Body * body);
	void bmx_b2body_setbullet(b2Body * body, int flag);
	b2Vec2 * bmx_b2body_getworldcenter(b2Body * body);
	b2Vec2 * bmx_b2body_getlocalcenter(b2Body * body);
	void bmx_b2body_setlinearvelocity(b2Body * body, b2Vec2 * v);
	b2Vec2 * bmx_b2body_getlinearvelocity(b2Body * body);
	void bmx_b2body_setangularvelocity(b2Body * body, float32 omega);
	float32 bmx_b2body_getangularvelocity(b2Body * body);
	void bmx_b2body_applyforce(b2Body * body, b2Vec2 * force, b2Vec2 * point);
	void bmx_b2body_applytorque(b2Body * body, float32 torque);
	void bmx_b2body_applylinearimpulse(b2Body * body, b2Vec2 * impulse, b2Vec2 * point);
	float32 bmx_b2body_getmass(b2Body * body);
	float32 bmx_b2body_getinertia(b2Body * body);
	b2Vec2 * bmx_b2body_getworldpoint(b2Body * body, b2Vec2 * localPoint);
	b2Vec2 * bmx_b2body_getworldvector(b2Body * body, b2Vec2 * localVector);
	b2Vec2 * bmx_b2body_getlocalpoint(b2Body * body, b2Vec2 * worldPoint);
	b2Vec2 * bmx_b2body_getlocalvector(b2Body * body, b2Vec2 * worldVector);
	b2JointEdge * bmx_b2body_getjointlist(b2Body * body);
	b2World * bmx_b2body_getworld(b2Body * body);
	void bmx_b2body_setmassdata(b2Body * body, b2MassData * massData);
	int bmx_b2body_gettype(b2Body * def);
	void bmx_b2body_settype(b2Body * def, int type);


	b2BodyDef * bmx_b2bodydef_create();
	void bmx_b2bodydef_delete(b2BodyDef * def);
	b2Vec2 * bmx_b2bodydef_getposition(b2BodyDef * def);
	void bmx_b2bodydef_setposition(b2BodyDef * def, b2Vec2 * position);
	void bmx_b2bodydef_setpositionxy(b2BodyDef * def, float32 x, float32 y);
	float32 bmx_b2bodydef_getangle(b2BodyDef * def);
	void bmx_b2bodydef_setangle(b2BodyDef * def, float32 angle);
	float32 bmx_b2bodydef_getanglerad(b2BodyDef * def);
	void bmx_b2bodydef_setanglerad(b2BodyDef * def, float32 angle);
	b2Vec2 * bmx_b2bodydef_getlinearvelocity(b2BodyDef * def);
	void bmx_b2bodydef_setlinearvelocity(b2BodyDef * def, b2Vec2 * velocity);
	float32 bmx_b2bodydef_getangularvelocity(b2BodyDef * def);
	void bmx_b2bodydef_setangularvelocity(b2BodyDef * def, float32 velocity);
	float32 bmx_b2bodydef_getlineardamping(b2BodyDef * def);
	void bmx_b2bodydef_setlineardamping(b2BodyDef * def, float32 damping);
	float32 bmx_b2bodydef_getangulardamping(b2BodyDef * def);
	void bmx_b2bodydef_setangulardamping(b2BodyDef * def, float32 damping);
	int bmx_b2bodydef_getallowsleep(b2BodyDef * def);
	void bmx_b2bodydef_setallowsleep(b2BodyDef * def, int allow);
	int bmx_b2bodydef_getawake(b2BodyDef * def);
	void bmx_b2bodydef_setawake(b2BodyDef * def, int sleeping);
	int bmx_b2bodydef_getfixedrotation(b2BodyDef * def);
	void bmx_b2bodydef_setfixedrotation(b2BodyDef * def, int fixed);
	int bmx_b2bodydef_getbullet(b2BodyDef * def);
	void bmx_b2bodydef_setbullet(b2BodyDef * def, int bullet);
	int bmx_b2bodydef_getactive(b2BodyDef * def);
	void bmx_b2bodydef_setactive(b2BodyDef * def, int active);
	int bmx_b2bodydef_gettype(b2BodyDef * def);
	void bmx_b2bodydef_settype(b2BodyDef * def, int type);
	float32 bmx_b2bodydef_getgravityscale(b2BodyDef * def);
	void bmx_b2bodydef_setgravityscale(b2BodyDef * def, float32 gravityScale);
	


	void _arm_box2d_b2DestructionListener__SayGoodbyeJoint(BBObject * maxHandle, b2Joint * joint);
	void _arm_box2d_b2DestructionListener__SayGoodbyeFixture(BBObject * maxHandle, b2Fixture * fixture);

	MaxDestructionListener * bmx_b2destructionlistener_create(BBObject * handle);
	void bmx_b2destructionlistener_delete(MaxDestructionListener * listener);

	
	MaxQueryCallback * bmx_b2querycallback_create(BBObject * handle);
	bool bmx_b2querycallback_reportfixture(MaxQueryCallback * callback, b2Fixture *fixture);
	bool _arm_box2d_b2QueryCallback__ReportFixture(BBObject * maxHandle, b2Fixture * fixture);
			
	MaxDraw * bmx_b2draw_create(BBObject * handle);
	void bmx_b2draw_setflags(MaxDraw * dbg, uint32 flags);
	uint32 bmx_b2draw_getflags(MaxDraw * dbg);
	void bmx_b2draw_appendflags(MaxDraw * dbg, uint32 flags);
	void bmx_b2draw_clearflags(MaxDraw * dbg, uint32 flags);

	
	
	BBObject * bmx_b2joint_getmaxjoint(b2Joint * joint);
	int bmx_b2joint_gettype(b2Joint * joint);
	b2Body * bmx_b2joint_getbodya(b2Joint * joint);
	b2Body * bmx_b2joint_getbodyb(b2Joint * joint);
	int bmx_b2joint_isactive(b2Joint * joint);
	
	b2Vec2 * bmx_b2mousejoint_getanchora(b2MouseJoint * mouseJoint);
	b2Vec2 * bmx_b2mousejoint_getanchorb(b2MouseJoint * mouseJoint);
	b2Vec2 * bmx_b2mousejoint_getreactionforce(b2MouseJoint * mouseJoint, float32 inv_dt);
	float32 bmx_b2mousejoint_getreactiontorque(b2MouseJoint * mouseJoint, float32 inv_dt);
	b2Vec2 * bmx_b2mousejoint_gettarget(b2MouseJoint * mouseJoint);
	void bmx_b2mousejoint_settarget(b2MouseJoint * mouseJoint, b2Vec2 * target);
	float32 bmx_b2mousejoint_getmaxforce(b2MouseJoint * mouseJoint);
	void bmx_b2mousejoint_setmaxforce(b2MouseJoint * mouseJoint, float32 force);
	float32 bmx_b2mousejoint_getfrequency(b2MouseJoint * mouseJoint);
	void bmx_b2mousejoint_setfrequency(b2MouseJoint * mouseJoint, float32 frequency);
	float32 bmx_b2mousejoint_getdampingratio(b2MouseJoint * mouseJoint);
	void bmx_b2mousejoint_setdampingratio(b2MouseJoint * mouseJoint, float32 damping);
	void bmx_b2mousejoint_shiftorigin(b2MouseJoint * mouseJoint, b2Vec2 * newOrigin);
	void bmx_b2mousejoint_dump(b2MouseJoint * mouseJoint);
	
	
//	b2JointDef * bmx_b2jointdef_create();
	int bmx_b2jointdef_gettype(b2JointDef * jointDef);
	void bmx_b2jointdef_settype(b2JointDef * jointDef, int jointType);
	b2Body * bmx_b2jointdef_getbodya(b2JointDef * jointDef);
	void bmx_b2jointdef_setbodya(b2JointDef * jointDef, b2Body * bodyA);
	b2Body * bmx_b2jointdef_getbodyb(b2JointDef * jointDef);
	void bmx_b2jointdef_setbodyb(b2JointDef * jointDef, b2Body * bodyB);
	void bmx_b2jointdef_setcollideconnected(b2JointDef * jointDef, int flag);
	int bmx_b2jointdef_getcollideconnected(b2JointDef * jointDef);

//	b2MouseJointDef * bmx_b2mousejointdef_create();
	b2Vec2 * bmx_b2mousejointdef_gettarget(b2MouseJointDef * mouseJointDef);
	void bmx_b2mousejointdef_settarget(b2MouseJointDef * mouseJointDef, b2Vec2 * target);
	float32 bmx_b2mousejointdef_getmaxforce(b2MouseJointDef * mouseJointDef);
	void bmx_b2mousejointdef_setmaxforce(b2MouseJointDef * mouseJointDef, float32 force);
	float32 bmx_b2mousejointdef_getfrequencyhz(b2MouseJointDef * mouseJointDef);
	void bmx_b2mousejointdef_setfrequencyhz(b2MouseJointDef * mouseJointDef, float32 frequency);
	float32 bmx_b2mousejointdef_getdampingratio(b2MouseJointDef * mouseJointDef);
	void bmx_b2mousejointdef_setdampingratio(b2MouseJointDef * mouseJointDef, float32 damping);
	
	
	
	float32 bmx_b2shape_getradius(b2Shape * shape);
	void bmx_b2shape_setradius(b2Shape * shape, float32 radius);
	

		
	b2World * bmx_b2world_create(b2Vec2 * gravity);
	void bmx_b2world_dostep(b2World * world, float32 timeStep, int velocityIterations, int positionIterations);
	b2Body * bmx_b2world_createbody(b2World * world, b2BodyDef * def, BBObject * body);
	void bmx_b2world_destroybody(b2World * world, b2Body * body);
	int bmx_b2world_getallowsleeping(b2World * world);
	void bmx_b2world_setallowsleeping(b2World * world, int flag);
	int bmx_b2world_getwarmstarting(b2World * world);
	void bmx_b2world_setwarmstarting(b2World * world, int flag);
	int bmx_b2world_getcontinuousphysics(b2World * world);
	void bmx_b2world_setcontinuousphysics(b2World * world, int flag);
	int bmx_b2world_getsubstepping(b2World * world);
	void bmx_b2world_setsubstepping(b2World * world, int flag);
	void bmx_b2world_DrawDebugData(b2World * world);
	void bmx_b2world_setdebugDraw(b2World * world, b2Draw * debugDraw);
	
	b2Joint * bmx_b2world_createjoint(b2World * world, b2JointDef * def);
	void bmx_b2world_destroyjoint(b2World * world, b2Joint * joint);
//	b2Body * bmx_b2world_getbodylist(b2World * world);
//	b2Joint * bmx_b2world_getjointlist(b2World * world);
//	void bmx_b2world_setfilter(b2World * world, b2ContactFilter * filter);
//	void bmx_b2world_setcontactlistener(b2World * world, b2ContactListener * listener);
//	void bmx_b2world_setboundarylistener(b2World * world, b2BoundaryListener * listener);
	b2Vec2 * bmx_b2world_getgravity(b2World * world);
	void bmx_b2world_setgravity(b2World * world, b2Vec2 * gravity);
	int32 bmx_b2world_getproxycount(b2World * world);
	int32 bmx_b2world_getcontactcount(b2World * world);
	int32 bmx_b2world_getbodycount(b2World * world);
	int32 bmx_b2world_getjointcount(b2World * world);
	int32 bmx_b2world_gettreeheight(b2World * world);
	int32 bmx_b2world_gettreebalance(b2World * world);
	void bmx_b2world_queryaabb(b2World * world, b2QueryCallback * callback, b2AABB * aabb);
	void bmx_b2world_free(b2World * world);
	void bmx_b2world_setdestructionlistener(b2World * world, b2DestructionListener * listener);
//	int32 bmx_b2world_raycast(b2World * world, b2Segment * segment, BBArray * shapes, int solidShapes);
//	b2Controller * bmx_b2world_createcontroller(b2World * world, b2ControllerDef * def, b2ControllerType type);
//	void bmx_b2world_destroycontroller(b2World * world, b2Controller * controller);

}


//***********************************************************************************************************
// Class : b2vec2
//***********************************************************************************************************


b2Vec2 * bmx_b2vec2_new(b2Vec2 v) {
	b2Vec2 *vec = new b2Vec2(v.x, v.y);
	return vec;
}

b2Vec2 * bmx_b2vec2_fromvect2(b2Vec2 * vec) {
	return bmx_b2vec2_new(*vec);
}

b2Vec2 * bmx_b2vec2_create(float32 x, float32 y) {
	return new b2Vec2(x, y);
}

void bmx_b2vec2_delete(b2Vec2 * vec) {
	delete vec;
}

void bmx_b2vec2_copy(b2Vec2 * vec, b2Vec2 * other) {
	*vec = *other;
}

float32 bmx_b2vec2_getx(b2Vec2 * vec) {
	return vec->x;
}

float32 bmx_b2vec2_gety(b2Vec2 * vec) {
	return vec->y;
}

void bmx_b2vec2_set(b2Vec2 * vec, float32 x, float32 y) {
	vec->Set(x, y);
}

void bmx_b2vec2_setx(b2Vec2 * vec, float32 x) {
	vec->Set(x, vec->y);
}

void bmx_b2vec2_sety(b2Vec2 * vec, float32 y) {
	vec->Set(vec->x, y);
}

void bmx_b2vec2_setzero(b2Vec2 * vec) {
	vec->SetZero();
}

void bmx_b2vec2_add(b2Vec2 * vec, b2Vec2 * other) {
	*vec += *other;
}

b2Vec2 * bmx_b2vec2_addnew(b2Vec2 * vec, b2Vec2 * other) {
	return bmx_b2vec2_new(*vec + *other);
}

void bmx_b2vec2_subtract(b2Vec2 * vec, b2Vec2 * other) {
	*vec -= *other;
}

b2Vec2 * bmx_b2vec2_subtractnew(b2Vec2 * vec, b2Vec2 * other) {
	return bmx_b2vec2_new(*vec - *other);
}

void bmx_b2vec2_multiply(b2Vec2 * vec, float32 value) {
	*vec *= value;
}

b2Vec2 * bmx_b2vec2_multiplynew(b2Vec2 * vec, float32 value) {
	b2Vec2 *v = vec;
	*v *= value;
	return v;
}

float32 bmx_b2vec2_length(b2Vec2 * vec) {
	return vec->Length();
}

float32 bmx_b2vec2_lengthsquared(b2Vec2 * vec) {
	return vec->LengthSquared();
}

float32 bmx_b2vec2_normalize(b2Vec2 * vec) {
	return vec->Normalize();
}

int bmx_b2vec2_isvalid(b2Vec2 * vec) {
	return vec->IsValid();
}

b2Vec2 * bmx_b2vec2_skew(b2Vec2 * vec) {
	return bmx_b2vec2_new(vec->Skew());
}

BBArray * bmx_b2vec2_getvertexarray(const b2Vec2* vertices, int32 vertexCount) {
	BBArray * array = _arm_box2d_b2Vec2__newb2Vec2Array(vertexCount);
	for (int i = 0; i < vertexCount; i++) {
		_arm_box2d_b2Vec2__setb2Vec2Array(array, i, bmx_b2vec2_new(vertices[i]));
	}
	
	return array;
}


//***********************************************************************************************************
// Class : b2vec3
//***********************************************************************************************************


b2Vec3 * bmx_b2vec3_new(b2Vec3 v) {
	b2Vec3 *vec = new b2Vec3(v.x, v.y, v.z);
	return vec;
}

b2Vec3 * bmx_b2vec3_fromvect3(b2Vec3 * vec) {
	return bmx_b2vec3_new(*vec);
}

b2Vec3 * bmx_b2vec3_create(float32 x, float32 y, float32 z) {
	return new b2Vec3(x, y, z);
}

void bmx_b2vec3_delete(b2Vec3 * vec) {
	delete vec;
}

void bmx_b2vec3_copy(b2Vec3 * vec, b2Vec3 * other) {
	*vec = *other;
}

float32 bmx_b2vec3_getx(b2Vec3 * vec) {
	return vec->x;
}

float32 bmx_b2vec3_gety(b2Vec3 * vec) {
	return vec->y;
}

float32 bmx_b2vec3_getz(b2Vec3 * vec) {
	return vec->z;
}

void bmx_b2vec3_set(b2Vec3 * vec, float32 x, float32 y, float32 z) {
	vec->Set(x, y, z);
}

void bmx_b2vec3_setx(b2Vec3 * vec, float32 x) {
	vec->Set(x, vec->y, vec->z);
}

void bmx_b2vec3_sety(b2Vec3 * vec, float32 y) {
	vec->Set(vec->x, y, vec->z);
}

void bmx_b2vec3_setz(b2Vec3 * vec, float32 z) {
	vec->Set(vec->x, vec->y, z);
}

void bmx_b2vec3_setzero(b2Vec3 * vec) {
	vec->SetZero();
}

void bmx_b2vec3_add(b2Vec3 * vec, b2Vec3 * other) {
	*vec += *other;
}

b2Vec3 * bmx_b2vec3_addnew(b2Vec3 * vec, b2Vec3 * other) {
	return bmx_b2vec3_new(*vec + *other);
}

void bmx_b2vec3_subtract(b2Vec3 * vec, b2Vec3 * other) {
	*vec -= *other;
}

b2Vec3 * bmx_b2vec3_subtractnew(b2Vec3 * vec, b2Vec3 * other) {
	return bmx_b2vec3_new(*vec - *other);
}

void bmx_b2vec3_multiply(b2Vec3 * vec, float32 value) {
	*vec *= value;
}

b2Vec3 * bmx_b2vec3_multiplynew(b2Vec3 * vec, float32 value) {
	b2Vec3 *v = vec;
	*v *= value;
	return v;
}

BBArray * bmx_b2vec3_getvertexarray(const b2Vec3* vertices, int32 vertexCount) {
	BBArray * array = _arm_box2d_b2Vec3__newb2Vec3Array(vertexCount);
	for (int i = 0; i < vertexCount; i++) {
		_arm_box2d_b2Vec3__setb2Vec3Array(array, i, bmx_b2vec3_new(vertices[i]));
	}
	
	return array;
}



//***********************************************************************************************************
// Class : b2Rot
//***********************************************************************************************************

b2Rot * bmx_b2rot_new(b2Rot r) {
	b2Rot *rot = new b2Rot(r.GetAngle());
	return rot;
}

b2Rot * bmx_b2rot_create() {
	return new b2Rot();
}

b2Rot * bmx_b2rot_createrotation(float32 angle) {
	return new b2Rot(angle * 0.0174533f);
}

b2Rot * bmx_b2rot_createrotationrad(float32 angle) {
	return new b2Rot(angle);
}

void bmx_b2rot_delete(b2Rot * rot) {
	delete rot;
}

void bmx_b2rot_setidentity(b2Rot * rot) {
	rot->SetIdentity();
}

void bmx_b2rot_set(b2Rot * rot, float32 angle) {
	rot->Set(angle * 0.0174533f);
}

void bmx_b2rot_setrad(b2Rot * rot, float32 angle) {
	rot->Set(angle);
}

float32 bmx_b2rot_getangle(b2Rot * rot) {
	return rot->GetAngle() * 57.2957795f;
}

float32 bmx_b2rot_getanglerad(b2Rot * rot) {
	return rot->GetAngle();
}

b2Vec2 * bmx_b2rot_getxaxis(b2Rot * rot) {
	return bmx_b2vec2_new(rot->GetXAxis());
}

b2Vec2 * bmx_b2rot_getyaxis(b2Rot * rot) {
	return bmx_b2vec2_new(rot->GetYAxis());
}

float32 bmx_b2rot_getsinus(b2Rot * rot) {
	return rot->s;
}

void bmx_b2rot_setsinus(b2Rot * rot, float32 sinus) {
	rot->s = sinus;
}

float32 bmx_b2rot_getcosinus(b2Rot * rot) {
	return rot->c;
}

void bmx_b2rot_setcosinus(b2Rot * rot, float32 cosinus) {
	rot->c = cosinus;
}


//***********************************************************************************************************
// Class : b2Transform
//***********************************************************************************************************

b2Transform * bmx_b2transform_new(b2Transform t) {
	b2Transform *trans = new b2Transform(t.p, t.q);
	return trans;
}

b2Transform * bmx_b2transform_create() {
	return new b2Transform();
}

b2Transform * bmx_b2transform_createtransform(b2Vec2 * position, b2Rot * rotation) {
	return new b2Transform(*position, *rotation);
}

void bmx_b2transform_delete(b2Transform * trans) {
	delete trans;
}

void bmx_b2transform_setidentity(b2Transform * trans) {
	trans->SetIdentity();
}

void bmx_b2transform_set(b2Transform * trans, b2Vec2 * position, float32 angle) {
	trans->Set(*position, angle * 0.0174533f);
}

void bmx_b2transform_setrad(b2Transform * trans, b2Vec2 * position, float32 angle) {
	trans->Set(*position, angle);
}

b2Vec2 * bmx_b2transform_getposition(b2Transform * trans) {
	return bmx_b2vec2_new(trans->p);
}

void bmx_b2transform_setposition(b2Transform * trans, b2Vec2 * position) {
	trans->p = *position;
}

b2Rot * bmx_b2transform_getrotation(b2Transform * trans) {
	return bmx_b2rot_new(trans->q);
}

void bmx_b2transform_setrotation(b2Transform * trans, b2Rot * rotation) {
	trans->q = *rotation;
}

//***********************************************************************************************************
// Class : b2RayCastInput
//***********************************************************************************************************


b2RayCastInput * bmx_b2raycastinput_create(b2Vec2 * p1, b2Vec2 * p2, float32 maxFraction) {

	b2RayCastInput * rayCastInput = new b2RayCastInput;
	
	rayCastInput->p1 = *p1;
	rayCastInput->p2 = *p2;
	rayCastInput->maxFraction = maxFraction;

	return rayCastInput;
}

void bmx_b2raycastinput_delete(b2RayCastInput * rayCastInput) {
	delete rayCastInput;
}

void bmx_b2raycastinput_copy(b2RayCastInput * rayCastInput, b2RayCastInput * other) {
	*rayCastInput = *other;
}

void bmx_b2raycastinput_get(b2RayCastInput * rayCastInput, b2Vec2 * p1, b2Vec2 * p2, float32 * maxFraction) {
	*p1 = *bmx_b2vec2_new(rayCastInput->p1);
	*p2 = *bmx_b2vec2_new(rayCastInput->p2);
	*maxFraction = rayCastInput->maxFraction;
}

void bmx_b2raycastinput_set(b2RayCastInput * rayCastInput, b2Vec2 * p1, b2Vec2 * p2, float32 maxFraction) {
	rayCastInput->p1 = *p1;
	rayCastInput->p2 = *p2;
	rayCastInput->maxFraction = maxFraction;
}

b2Vec2 * bmx_b2raycastinput_getp1(b2RayCastInput * rayCastInput) {
	return bmx_b2vec2_new(rayCastInput->p1);
}

void bmx_b2raycastinput_setp1(b2RayCastInput * rayCastInput, b2Vec2 * p1) {
	rayCastInput->p1 = *p1;
}

b2Vec2 * bmx_b2raycastinput_getp2(b2RayCastInput * rayCastInput) {
	return bmx_b2vec2_new(rayCastInput->p2);
}

void bmx_b2raycastinput_setp2(b2RayCastInput * rayCastInput, b2Vec2 * p2) {
	rayCastInput->p2 = *p2;
}

float32 bmx_b2raycastinput_getmaxfraction(b2RayCastInput * rayCastInput) {
	return rayCastInput->maxFraction;
}

void bmx_b2raycastinput_setmaxfraction(b2RayCastInput * rayCastInput, float32 maxFraction) {
	rayCastInput->maxFraction = maxFraction;
}


//***********************************************************************************************************
// Class : b2RayCastOutput
//***********************************************************************************************************


b2RayCastOutput * bmx_b2raycastoutput_create(b2Vec2 * normal,  float32 fraction) {

	b2RayCastOutput * rayCastOutput = new b2RayCastOutput;
	
	rayCastOutput->normal = *normal;
	rayCastOutput->fraction = fraction;

	return rayCastOutput;
}

void bmx_b2raycastoutput_delete(b2RayCastOutput * rayCastOutput) {
	delete rayCastOutput;
}

void bmx_b2raycastoutput_copy(b2RayCastOutput * rayCastOutput, b2RayCastOutput * other) {
	*rayCastOutput = *other;
}

void bmx_b2raycastoutput_get(b2RayCastOutput * rayCastOutput, b2Vec2 * normal, float32 * fraction) {
	*normal = *bmx_b2vec2_new(rayCastOutput->normal);
	*fraction = rayCastOutput->fraction;
}

void bmx_b2raycastoutput_set(b2RayCastOutput * rayCastOutput, b2Vec2 * normal, float32 fraction) {
	rayCastOutput->normal = *normal;
	rayCastOutput->fraction = fraction;
}

b2Vec2 * bmx_b2raycastoutput_getnormal(b2RayCastOutput * rayCastOutput) {
	return bmx_b2vec2_new(rayCastOutput->normal);
}

void bmx_b2raycastoutput_setnormal(b2RayCastOutput * rayCastOutput, b2Vec2 * normal) {
	rayCastOutput->normal = *normal;
}

float32 bmx_b2raycastoutput_getfraction(b2RayCastOutput * rayCastOutput) {
	return rayCastOutput->fraction;
}

void bmx_b2raycastoutput_setfraction(b2RayCastOutput * rayCastOutput, float32 fraction) {
	rayCastOutput->fraction = fraction;
}


//***********************************************************************************************************
// Class : b2AABB
//***********************************************************************************************************


b2AABB * bmx_b2aabb_create(b2Vec2 * lowerBound, b2Vec2 * upperBound) {
	b2AABB * aabb = new b2AABB;
	if (lowerBound) {
		aabb->lowerBound = *lowerBound;
	}
	if (upperBound) {
		aabb->upperBound = *upperBound;
	}
	return aabb; 
}

void bmx_b2aabb_delete(b2AABB * aabb) {
	delete aabb;
}

void bmx_b2aabb_get(b2AABB * aabb, b2Vec2 * lowerBound, b2Vec2 * upperBound) {
	*lowerBound = *bmx_b2vec2_new(aabb->lowerBound);
	*upperBound = *bmx_b2vec2_new(aabb->upperBound);
}

void bmx_b2aabb_set(b2AABB * aabb, b2Vec2 * lowerBound, b2Vec2 * upperBound) {
	aabb->lowerBound = *lowerBound;
	aabb->upperBound = *upperBound;
}

b2Vec2 * bmx_b2aabb_getlowerbound(b2AABB * aabb) {
	return bmx_b2vec2_new(aabb->lowerBound);
}

void bmx_b2aabb_setlowerbound(b2AABB * aabb, b2Vec2 * lowerBound) {
	aabb->lowerBound = *lowerBound;
}

b2Vec2 * bmx_b2aabb_getupperbound(b2AABB * aabb) {
	return bmx_b2vec2_new(aabb->upperBound);
}

void bmx_b2aabb_setupperbound(b2AABB * aabb, b2Vec2 * upperBound) {
	aabb->upperBound = *upperBound;
}

int bmx_b2aabb_isvalid(b2AABB * aabb) {
	return aabb->IsValid();
}

b2Vec2 * bmx_b2aabb_getcenter(b2AABB * aabb) {
	return bmx_b2vec2_new(aabb->GetCenter());
}

b2Vec2 * bmx_b2aabb_getextents(b2AABB * aabb) {
	return bmx_b2vec2_new(aabb->GetExtents());
}

float32 bmx_b2aabb_getperimeter(b2AABB * aabb) {
	return aabb->GetPerimeter();
}

void bmx_b2aabb_combine(b2AABB * aabb, b2AABB * other) {
	aabb->Combine(*other);
}

void bmx_b2aabb_combine2(b2AABB * aabb, b2AABB * other1, b2AABB * other2) {
	aabb->Combine(*other1, *other2);
}

int bmx_b2aabb_raycast(b2AABB * aabb, b2RayCastOutput * rayCastOutput, b2RayCastInput * rayCastInput) {
	return aabb->RayCast(rayCastOutput,*rayCastInput);
}

int bmx_b2aabb_contains(b2AABB * aabb, b2AABB * other) {
	return aabb->Contains(*other);
}


//***********************************************************************************************************
// Class : b2Fixture
//***********************************************************************************************************
BBObject * bmx_b2fixture_getmaxfixture(b2Fixture * fixture) {
	void * obj = fixture->GetUserData();
	if (obj) {
		return (BBObject *)obj;
	}
	return &bbNullObject;
}

int bmx_b2fixture_gettype(b2Fixture * fixture) {
	return fixture->GetType();
}

b2Body * bmx_b2fixture_getbody(b2Fixture * fixture) {
	return fixture->GetBody();
}

int bmx_b2fixture_issensor(b2Fixture * fixture) {
	return fixture->IsSensor();
}

int bmx_b2fixture_testpoint(b2Fixture * fixture, b2Vec2 * point) {
	return fixture->TestPoint(*point);
}

/*
b2Body * bmx_b2fixture_getbody(b2Fixture * fixture) {
	return fixture->GetBody();
}

b2Shape * bmx_b2fixture_getnext(b2Fixture * fixture) {
	return fixture->GetNext();
}

int bmx_b2fixture_testpoint(b2Fixture * fixture, b2XForm * xf, b2Vec2 * p) {
	return fixture->TestPoint(*xf, *p);
}

float32 bmx_b2fixture_getsweepradius(b2Fixture * fixture) {
	return fixture->GetSweepRadius();
}

float32 bmx_b2fixture_getfriction(b2Fixture * fixture) {
	return fixture->GetFriction();
}

float32 bmx_b2fixture_getrestitution(b2Fixture * fixture) {
	return fixture->GetRestitution();
}

void bmx_b2fixture_computeaabb(b2Fixture * fixture, b2AABB * aabb, b2XForm * xf) {
	fixture->ComputeAABB(aabb, *xf);
}

void bmx_b2fixture_computesweptaabb(b2Fixture * fixture, b2AABB * aabb, b2XForm * xf1, b2XForm * xf2) {
	fixture->ComputeSweptAABB(aabb, *xf1, *xf2);
}

void bmx_b2fixture_computemass(b2Fixture * fixture, b2MassData * data) {
	fixture->ComputeMass(data);
}

MaxFilterData * bmx_b2fixture_getfilterdata(b2Fixture * fixture) {
	return new MaxFilterData(fixture->GetFilterData());
}

void bmx_b2fixture_setfilterdata(b2Fixture * fixture, MaxFilterData * data) {
	fixture->SetFilterData(data->getData());
}

void bmx_b2fixture_setfriction(b2Fixture * fixture, float32 friction) {
	fixture->SetFriction(friction);
}

void bmx_b2fixture_setrestitution(b2Fixture * fixture, float32 restitution) {
	fixture->SetRestitution(restitution);
}

float32 bmx_b2fixture_getdensity(b2Fixture * fixture) {
	return fixture->GetDensity();
}

void bmx_b2fixture_setdensity(b2Fixture * fixture, float32 density) {
	fixture->SetDensity(density);
}
*/


//***********************************************************************************************************
// Class : b2Filter
//***********************************************************************************************************

b2Filter * bmx_b2filter_create(uint16 categoryBits, uint16 maskBits, int16 	groupIndex) {
	b2Filter * filter = new b2Filter;
	if (categoryBits) {
		filter->categoryBits = categoryBits;
	}
	if (maskBits) {
		filter->maskBits = maskBits;
	}
	if (groupIndex) {
		filter->groupIndex = groupIndex;
	}
	return filter; 
}

void bmx_b2filter_delete(b2Filter * filter) {
	delete filter;
}

uint16 bmx_b2filter_getcategorybits(b2Filter * filter) {
	return filter->categoryBits;
}

void bmx_b2filter_setcategorybits(b2Filter * filter, uint16 categoryBits) {
	filter->categoryBits = categoryBits;
}

uint16 bmx_b2filter_getmaskbits(b2Filter * filter) {
	return filter->maskBits;
}

void bmx_b2filter_setmaskbits(b2Filter * filter, uint16 maskBits) {
	filter->maskBits = maskBits;
}

int16 bmx_b2filter_getgroupindex(b2Filter * filter) {
	return filter->groupIndex;
}

void bmx_b2filter_setgroupindex(b2Filter * filter, int16 groupIndex) {
	filter->groupIndex = groupIndex;
}
//***********************************************************************************************************
// Class : b2FixtureDef
//***********************************************************************************************************

b2FixtureDef * bmx_b2fixturedef_create() {
	return new b2FixtureDef;
}

const b2Shape * bmx_b2fixturedef_getshape(b2FixtureDef * def) {
	return def->shape;
}

void bmx_b2fixturedef_setshape(b2FixtureDef * def, b2Shape * shape) {
	def->shape = shape;
}

float32 bmx_b2fixturedef_getfriction(b2FixtureDef * def) {
	return def->friction;
}

void bmx_b2fixturedef_setfriction(b2FixtureDef * def, float32 friction) {
	def->friction = friction;
}

float32 bmx_b2fixturedef_getrestitution(b2FixtureDef * def) {
	return def->restitution;
}

void bmx_b2fixturedef_setrestitution(b2FixtureDef * def, float32 restitution) {
	def->restitution = restitution;
}

float32 bmx_b2fixturedef_getdensity(b2FixtureDef * def) {
	return def->density;
}

void bmx_b2fixturedef_setdensity(b2FixtureDef * def, float32 density) {
	def->density = density;
}

int bmx_b2fixturedef_issensor(b2FixtureDef * def) {
	return def->isSensor;
}

void bmx_b2fixturedef_setissensor(b2FixtureDef * def, int sensor) {
	def->isSensor = sensor;
}

void bmx_b2fixturedef_setfilter(b2FixtureDef * def, b2Filter * filter) {
	def->filter = * filter;
}

b2Filter * bmx_b2fixturedef_getfilter(b2FixtureDef * def) {
	return &def->filter;
}

//***********************************************************************************************************
// Class : b2Shape
//***********************************************************************************************************
/*
int bmx_b2shape_issensor(b2Shape * shape) {
	return shape->IsSensor();
}

b2Body * bmx_b2shape_getbody(b2Shape * shape) {
	return shape->GetBody();
}
*/
/*
b2Shape * bmx_b2shape_getnext(b2Shape * shape) {
	return shape->GetNext();
}

int bmx_b2shape_testpoint(b2Shape * shape, b2XForm * xf, b2Vec2 * p) {
	return shape->TestPoint(*xf, *p);
}

float32 bmx_b2shape_getsweepradius(b2Shape * shape) {
	return shape->GetSweepRadius();
}

float32 bmx_b2shape_getfriction(b2Shape * shape) {
	return shape->GetFriction();
}

float32 bmx_b2shape_getrestitution(b2Shape * shape) {
	return shape->GetRestitution();
}

void bmx_b2shape_computeaabb(b2Shape * shape, b2AABB * aabb, b2XForm * xf) {
	shape->ComputeAABB(aabb, *xf);
}

void bmx_b2shape_computesweptaabb(b2Shape * shape, b2AABB * aabb, b2XForm * xf1, b2XForm * xf2) {
	shape->ComputeSweptAABB(aabb, *xf1, *xf2);
}

void bmx_b2shape_computemass(b2Shape * shape, b2MassData * data) {
	shape->ComputeMass(data);
}

MaxFilterData * bmx_b2shape_getfilterdata(b2Shape * shape) {
	return new MaxFilterData(shape->GetFilterData());
}

void bmx_b2shape_setfilterdata(b2Shape * shape, MaxFilterData * data) {
	shape->SetFilterData(data->getData());
}

void bmx_b2shape_setfriction(b2Shape * shape, float32 friction) {
	shape->SetFriction(friction);
}

void bmx_b2shape_setrestitution(b2Shape * shape, float32 restitution) {
	shape->SetRestitution(restitution);
}

float32 bmx_b2shape_getdensity(b2Shape * shape) {
	return shape->GetDensity();
}

void bmx_b2shape_setdensity(b2Shape * shape, float32 density) {
	shape->SetDensity(density);
}

*/

//***********************************************************************************************************
// Class : b2CircleShape
//***********************************************************************************************************

b2CircleShape * bmx_b2circleshape_create() {
	return new b2CircleShape;
}


//***********************************************************************************************************
// Class : b2PolygonShape
//***********************************************************************************************************

b2PolygonShape * bmx_b2polygonshape_create() {
	return new b2PolygonShape;
}

void bmx_b2polygonshape_setasbox(b2PolygonShape * shape, float32 hx, float32 hy) {
	shape->SetAsBox(hx, hy);
}

void bmx_b2polygondef_setasorientedbox(b2PolygonShape * shape, float32 hx, float32 hy, b2Vec2 * center, float32 angle) {
	shape->SetAsBox(hx, hy, *center, angle * 0.0174533f);
}

void bmx_b2polygondef_setasorientedboxrad(b2PolygonShape * shape, float32 hx, float32 hy, b2Vec2 * center, float32 angle) {
	shape->SetAsBox(hx, hy, *center, angle);
}

/*
BBArray * bmx_b2polygonshape_getvertices(b2PolygonShape * shape) {
	return bmx_b2vec2_getvertexarray(shape->GetVertices(), shape->GetVertexCount());
}

BBArray * bmx_b2polygonshape_getcorevertices(b2PolygonShape * shape) {
	return bmx_b2vec2_getvertexarray(shape->GetCoreVertices(), shape->GetVertexCount());
}

BBArray * bmx_b2polygonshape_getnormals(b2PolygonShape * shape) {
	return bmx_b2vec2_getvertexarray(shape->GetNormals(), shape->GetVertexCount());
}

const b2OBB * bmx_b2polygonshape_getobb(b2PolygonShape * shape) {
	return &shape->GetOBB();
}

b2Vec2 * bmx_b2polygonshape_getcentroid(b2PolygonShape * shape) {
	return bmx_b2vec2_new(shape->GetCentroid());
}

int bmx_b2polygonshape_getvertexcount(b2PolygonShape * shape) {
	return shape->GetVertexCount();
}

b2Vec2 * bmx_b2polygonshape_getfirstvertex(b2PolygonShape * shape, b2XForm * xf) {
	return bmx_b2vec2_new(shape->GetFirstVertex(*xf));
}

b2Vec2 * bmx_b2polygonshape_centroid(b2PolygonShape * shape, b2XForm * xf) {
	return bmx_b2vec2_new(shape->Centroid(*xf));
}

b2Vec2 * bmx_b2polygonshape_support(b2PolygonShape * shape, b2XForm * xf, b2Vec2 * d) {
	return bmx_b2vec2_new(shape->Support(*xf, *d));
}

*/

//***********************************************************************************************************
// Class : b2Body
//***********************************************************************************************************
BBObject * bmx_b2body_getmaxbody(b2Body * body) {
	void * obj = body->GetUserData();
	if (obj) {
		return (BBObject *)obj;
	}
	return &bbNullObject;
}

b2Fixture * bmx_b2body_createfixture(b2Body * body, b2FixtureDef * def) {
//  [WRONG]
//	BBObject * fixture  = _arm_box2d_b2Body_MaxCreateFixture(*def);
//	def->userData = fixture;
//	BBRETAIN(fixture);
	return body->CreateFixture(def);
}

b2Fixture * bmx_b2body__createfixture(b2Body * body, b2Shape * shape, float32 density) {
	return body->CreateFixture(shape, density);
}

void bmx_b2body_destroyFixture(b2Body * body, b2Fixture * fixture) {

	void * data = fixture->GetUserData();
	if (data && data != &bbNullObject) {
		BBRELEASE((BBObject*)data);
	}
	body->DestroyFixture(fixture);
}

b2Vec2 * bmx_b2body_getposition(b2Body * body) {
	return bmx_b2vec2_new(body->GetPosition());
}

float32 bmx_b2body_getangle(b2Body * body) {
	return body->GetAngle() * 57.2957795f;
}

float32 bmx_b2body_getanglerad(b2Body * body) {
	return body->GetAngle();
}

b2Body * bmx_b2body_getnext(b2Body * body) {
	return body->GetNext();
}

b2Fixture * bmx_b2body_getfixturelist(b2Body * body) {
	return body->GetFixtureList();
}

int bmx_b2body_isawake(b2Body * body) {
	return body->IsAwake();
}

void bmx_b2body_setawake(b2Body * body, int flag) {
	body->SetAwake(flag);
}

int bmx_b2body_isbullet(b2Body * body) {
	return body->IsBullet();
}

void bmx_b2body_setbullet(b2Body * body, int flag) {
	body->SetBullet(flag);
}

b2Vec2 * bmx_b2body_getworldcenter(b2Body * body) {
	return bmx_b2vec2_new(body->GetWorldCenter());
}

b2Vec2 * bmx_b2body_getlocalcenter(b2Body * body) {
	return bmx_b2vec2_new(body->GetLocalCenter());
}

void bmx_b2body_setlinearvelocity(b2Body * body, b2Vec2 * v) {
	body->SetLinearVelocity(*v);
}

b2Vec2 * bmx_b2body_getlinearvelocity(b2Body * body) {
	return bmx_b2vec2_new(body->GetLinearVelocity());
}

void bmx_b2body_setangularvelocity(b2Body * body, float32 omega) {
	body->SetAngularVelocity(omega * 0.0174533f);
}

float32 bmx_b2body_getangularvelocity(b2Body * body) {
	return body->GetAngularVelocity() * 57.2957795f;
}

void bmx_b2body_applyforce(b2Body * body, b2Vec2 * force, b2Vec2 * point) {
	body->ApplyForce(*force, *point);
}

void bmx_b2body_applytorque(b2Body * body, float32 torque) {
	body->ApplyTorque(torque);
}

void bmx_b2body_applylinearimpulse(b2Body * body, b2Vec2 * impulse, b2Vec2 * point) {
	body->ApplyLinearImpulse(*impulse, *point);
}

float32 bmx_b2body_getmass(b2Body * body) {
	return body->GetMass();
}

float32 bmx_b2body_getinertia(b2Body * body) {
	return body->GetInertia();
}

b2Vec2 * bmx_b2body_getworldpoint(b2Body * body, b2Vec2 * localPoint) {
	return bmx_b2vec2_new(body->GetWorldPoint(*localPoint));
}

b2Vec2 * bmx_b2body_getworldvector(b2Body * body, b2Vec2 * localVector) {
	return bmx_b2vec2_new(body->GetWorldVector(*localVector));
}

b2Vec2 * bmx_b2body_getlocalpoint(b2Body * body, b2Vec2 * worldPoint) {
	return bmx_b2vec2_new(body->GetLocalPoint(*worldPoint));
}

b2Vec2 * bmx_b2body_getlocalvector(b2Body * body, b2Vec2 * worldVector) {
	return bmx_b2vec2_new(body->GetLocalVector(*worldVector));
}

b2JointEdge * bmx_b2body_getjointlist(b2Body * body) {
	return body->GetJointList();
}

b2World * bmx_b2body_getworld(b2Body * body) {
	return body->GetWorld();
}

void bmx_b2body_setmassdata(b2Body * body, b2MassData * massData) {
	body->SetMassData(massData);
}

int bmx_b2body_gettype(b2Body * def) {
	return def->GetType();
}

void bmx_b2body_settype(b2Body * def, int type) {
	def->SetType((b2BodyType)type);
}


//***********************************************************************************************************
// Class : b2BodyDef
//***********************************************************************************************************


b2BodyDef * bmx_b2bodydef_create() {
	return new b2BodyDef;
}

void bmx_b2bodydef_delete(b2BodyDef * def) {
	delete def;
}

b2Vec2 * bmx_b2bodydef_getposition(b2BodyDef * def) {
	return bmx_b2vec2_new(def->position);
}

void bmx_b2bodydef_setposition(b2BodyDef * def, b2Vec2 * position) {
	def->position = *position;
}

void bmx_b2bodydef_setpositionxy(b2BodyDef * def, float32 x, float32 y) {
	def->position = b2Vec2(x, y);
}

float32 bmx_b2bodydef_getangle(b2BodyDef * def) {
	return def->angle * 57.2957795f;
}

void bmx_b2bodydef_setangle(b2BodyDef * def, float32 angle) {
	def->angle = angle * 0.0174533f;
}

float32 bmx_b2bodydef_getanglerad(b2BodyDef * def) {
	return def->angle;
}

void bmx_b2bodydef_setanglerad(b2BodyDef * def, float32 angle) {
	def->angle = angle;
}

b2Vec2 * bmx_b2bodydef_getlinearvelocity(b2BodyDef * def) {
	return bmx_b2vec2_new(def->linearVelocity);
}

void bmx_b2bodydef_setlinearvelocity(b2BodyDef * def, b2Vec2 * velocity) {
	def->linearVelocity = *velocity;
}

float32 bmx_b2bodydef_getangularvelocity(b2BodyDef * def) {
	return def->angularVelocity;
}

void bmx_b2bodydef_setangularvelocity(b2BodyDef * def, float32 velocity) {
	def->angularVelocity = velocity;
}

float32 bmx_b2bodydef_getlineardamping(b2BodyDef * def) {
	return def->linearDamping;
}

void bmx_b2bodydef_setlineardamping(b2BodyDef * def, float32 damping) {
	def->linearDamping = damping;
}

float32 bmx_b2bodydef_getangulardamping(b2BodyDef * def) {
	return def->angularDamping;
}

void bmx_b2bodydef_setangulardamping(b2BodyDef * def, float32 damping) {
	def->angularDamping = damping;
}

int bmx_b2bodydef_getallowsleep(b2BodyDef * def) {
	return def->allowSleep;
}

void bmx_b2bodydef_setallowsleep(b2BodyDef * def, int allow) {
	def->allowSleep = allow;
}

int bmx_b2bodydef_getawake(b2BodyDef * def) {
	return def->awake;
}

void bmx_b2bodydef_setawake(b2BodyDef * def, int awake) {
	def->awake = awake;
}

int bmx_b2bodydef_getfixedrotation(b2BodyDef * def) {
	return def->fixedRotation;
}

void bmx_b2bodydef_setfixedrotation(b2BodyDef * def, int fixed) {
	def->fixedRotation = fixed;
}

int bmx_b2bodydef_getbullet(b2BodyDef * def) {
	return def->bullet;
}

void bmx_b2bodydef_setbullet(b2BodyDef * def, int bullet) {
	def->bullet = bullet;
}

int bmx_b2bodydef_getactive(b2BodyDef * def) {
	return def->active;
}

void bmx_b2bodydef_setactive(b2BodyDef * def, int active) {
	def->active = active;
}

int bmx_b2bodydef_gettype(b2BodyDef * def) {
	return def->type;
}

void bmx_b2bodydef_settype(b2BodyDef * def, int type) {
	def->type = (b2BodyType)type;
}

float32 bmx_b2bodydef_getgravityscale(b2BodyDef * def) {
	return def->gravityScale;
}

void bmx_b2bodydef_setgravityscale(b2BodyDef * def, float32 gravityScale) {
	def->gravityScale = gravityScale;
}

//***********************************************************************************************************
// Class : MaxQueryCallback
//***********************************************************************************************************

class MaxQueryCallback : public b2QueryCallback
{
public:
	MaxQueryCallback(BBObject * handle)
		: maxHandle(handle)
	{
	}
	
	~MaxQueryCallback() {}
	
	bool ReportFixture(b2Fixture *fixture) {
		return _arm_box2d_b2QueryCallback__ReportFixture(maxHandle, fixture);
	}
	
private:
	BBObject * maxHandle;
};

MaxQueryCallback * bmx_b2querycallback_create(BBObject * handle) {
	return new MaxQueryCallback(handle);
}

bool bmx_b2querycallback_reportfixture(MaxQueryCallback * callback, b2Fixture *fixture) {
	return callback->ReportFixture(fixture);
}

//***********************************************************************************************************
// Class : MaxDestructionListener
//***********************************************************************************************************

class MaxDestructionListener : public b2DestructionListener
{
public:
	MaxDestructionListener(BBObject * handle)
		: maxHandle(handle)
	{
	}
	
	void SayGoodbye(b2Joint * joint) {
		_arm_box2d_b2DestructionListener__SayGoodbyeJoint(maxHandle, joint);
		void * data = joint->GetUserData();
		if (data && data != &bbNullObject) {
			BBRELEASE((BBObject*)data);
			joint->SetUserData(0);
		}
	}

	void SayGoodbye(b2Fixture * fixture) {
		_arm_box2d_b2DestructionListener__SayGoodbyeFixture(maxHandle, fixture);
		void * data = fixture->GetUserData();
		if (data && data != &bbNullObject) {
			BBRELEASE((BBObject*)data);
			fixture->SetUserData(0);
		}
	}
	
private:
	BBObject * maxHandle;
};

MaxDestructionListener * bmx_b2destructionlistener_create(BBObject * handle) {
	return new MaxDestructionListener(handle);
}

void bmx_b2destructionlistener_delete(MaxDestructionListener * listener) {
	delete listener;
}

//***********************************************************************************************************
// Class : MaxDraw
//***********************************************************************************************************

class MaxDraw : public b2Draw
{
public:

	MaxDraw(BBObject * handle)
		: maxHandle(handle)
	{
	}

	~MaxDraw() {}

	void DrawPolygon(const b2Vec2* vertices, int32 vertexCount, const b2Color& color) {
		BBArray * array = bmx_b2vec2_getvertexarray(vertices, vertexCount);
		_arm_box2d_b2Draw__DrawPolygon(maxHandle, array, 
			static_cast<int>(color.r * 255.0f),
			static_cast<int>(color.g * 255.0f),
			static_cast<int>(color.b * 255.0f));
	}

	void DrawSolidPolygon(const b2Vec2* vertices, int32 vertexCount, const b2Color& color) {
		BBArray * array = bmx_b2vec2_getvertexarray(vertices, vertexCount);
		_arm_box2d_b2Draw__DrawSolidPolygon(maxHandle, array, 
			static_cast<int>(color.r * 255.0f),
			static_cast<int>(color.g * 255.0f),
			static_cast<int>(color.b * 255.0f));
	}

	void DrawCircle(const b2Vec2& center, float32 radius, const b2Color& color) {
	}

	void DrawSolidCircle(const b2Vec2& center, float32 radius, const b2Vec2& axis, const b2Color& color) {
		_arm_box2d_b2Draw__DrawSolidCircle(maxHandle, bmx_b2vec2_new(center), radius, 
			bmx_b2vec2_new(axis), 
			static_cast<int>(color.r * 255.0f),
			static_cast<int>(color.g * 255.0f),
			static_cast<int>(color.b * 255.0f));
	}

	void DrawSegment(const b2Vec2& p1, const b2Vec2& p2, const b2Color& color) {
		_arm_box2d_b2Draw__DrawSegment(maxHandle, bmx_b2vec2_new(p1), bmx_b2vec2_new(p2), 
			static_cast<int>(color.r * 255.0f),
			static_cast<int>(color.g * 255.0f),
			static_cast<int>(color.b * 255.0f));
	}

	void DrawTransform(const b2Transform& xf) {
		_arm_box2d_b2Draw__DrawTransform(maxHandle, bmx_b2transform_new(xf));
	}
	
	void SetFlags(uint32 flags) {
		b2Draw::m_drawFlags = flags;
	}
	
private:
	BBObject * maxHandle;
};


MaxDraw * bmx_b2draw_create(BBObject * handle) {
	return new MaxDraw(handle);
}

void bmx_b2draw_setflags(MaxDraw * dbg, uint32 flags) {
	dbg->SetFlags(flags);
}

uint32 bmx_b2draw_getflags(MaxDraw * dbg) {
	return dbg->GetFlags();
}

void bmx_b2draw_appendflags(MaxDraw * dbg, uint32 flags) {
	dbg->AppendFlags(flags);
}

void bmx_b2draw_clearflags(MaxDraw * dbg, uint32 flags) {
	dbg->ClearFlags(flags);
}


//***********************************************************************************************************
// Class : b2Joint
//***********************************************************************************************************
BBObject * bmx_b2joint_getmaxjoint(b2Joint * joint) {
	void * obj = joint->GetUserData();
	if (obj) {
		return (BBObject *)obj;
	}
	return &bbNullObject;
}

int bmx_b2joint_gettype(b2Joint * joint) {
	return joint->GetType();
}

b2Body * bmx_b2joint_getbodya(b2Joint * joint) {
	return joint->GetBodyA();
}

b2Body * bmx_b2joint_getbodyb(b2Joint * joint) {
	return joint->GetBodyB();
}

int bmx_b2joint_isactive(b2Joint * joint) {
	return joint->IsActive();
}

//***********************************************************************************************************
// Class : b2MouseJoint
//***********************************************************************************************************

b2Vec2 * bmx_b2mousejoint_getanchora(b2MouseJoint * mouseJoint) {
	return bmx_b2vec2_new(mouseJoint->GetAnchorA());
}

b2Vec2 * bmx_b2mousejoint_getanchorb(b2MouseJoint * mouseJoint) {
	return bmx_b2vec2_new(mouseJoint->GetAnchorB());
}

b2Vec2 * bmx_b2mousejoint_getreactionforce(b2MouseJoint * mouseJoint, float32 inv_dt) {
	return bmx_b2vec2_new(mouseJoint->GetReactionForce(inv_dt));
}

float32 bmx_b2mousejoint_getreactiontorque(b2MouseJoint * mouseJoint, float32 inv_dt) {
	return mouseJoint->GetReactionTorque(inv_dt);
}

b2Vec2 * bmx_b2mousejoint_gettarget(b2MouseJoint * mouseJoint) {
	return bmx_b2vec2_new(mouseJoint->GetTarget());
}

void bmx_b2mousejoint_settarget(b2MouseJoint * mouseJoint, b2Vec2 * target) {
	mouseJoint->SetTarget(*target);
}

float32 bmx_b2mousejoint_getmaxforce(b2MouseJoint * mouseJoint) {
	return mouseJoint->GetMaxForce();
}

void bmx_b2mousejoint_setmaxforce(b2MouseJoint * mouseJoint, float32 force) {
	mouseJoint->SetMaxForce(force);
}

float32 bmx_b2mousejoint_getfrequency(b2MouseJoint * mouseJoint) {
	return mouseJoint->GetFrequency();
}

void bmx_b2mousejoint_setfrequency(b2MouseJoint * mouseJoint, float32 frequency) {
	mouseJoint->SetFrequency(frequency);
}

float32 bmx_b2mousejoint_getdampingratio(b2MouseJoint * mouseJoint) {
	return mouseJoint->GetDampingRatio();
}

void bmx_b2mousejoint_setdampingratio(b2MouseJoint * mouseJoint, float32 damping) {
	mouseJoint->SetDampingRatio(damping);
}

void bmx_b2mousejoint_shiftorigin(b2MouseJoint * mouseJoint, b2Vec2 * newOrigin) {
	mouseJoint->ShiftOrigin(*newOrigin);
}

void bmx_b2mousejoint_dump(b2MouseJoint * mouseJoint) {
	mouseJoint->Dump();
}

//***********************************************************************************************************
// Class : b2JointDef
//***********************************************************************************************************
//b2JointDef * bmx_b2jointdef_create() {
//	return new b2JointDef;
//}

int bmx_b2jointdef_gettype(b2JointDef * jointDef) {
	return jointDef->type;
}

void bmx_b2jointdef_settype(b2JointDef * jointDef, int jointType) {
	jointDef->type = (b2JointType)jointType;
}

b2Body * bmx_b2jointdef_getbodya(b2JointDef * jointDef) {
	return jointDef->bodyA;
}

void bmx_b2jointdef_setbodya(b2JointDef * jointDef, b2Body * bodyA) {
	jointDef->bodyA = bodyA;
}

b2Body * bmx_b2jointdef_getbodyb(b2JointDef * jointDef) {
	return jointDef->bodyB;
}

void bmx_b2jointdef_setbodyb(b2JointDef * jointDef, b2Body * bodyB) {
	jointDef->bodyB = bodyB;
}

void bmx_b2jointdef_setcollideconnected(b2JointDef * jointDef, int flag) {
	jointDef->collideConnected = flag;
}

int bmx_b2jointdef_getcollideconnected(b2JointDef * jointDef) {
	return jointDef->collideConnected;
}

//***********************************************************************************************************
// Class : b2MouseJointDef
//***********************************************************************************************************

//b2MouseJointDef * bmx_b2mousejointdef_create() {
//	return new b2MouseJointDef;
//}

b2Vec2 * bmx_b2mousejointdef_gettarget(b2MouseJointDef * mouseJointDef) {
	return bmx_b2vec2_new(mouseJointDef->target);
}

void bmx_b2mousejointdef_settarget(b2MouseJointDef * mouseJointDef, b2Vec2 * target) {
	mouseJointDef->target = * target;
}

float32 bmx_b2mousejointdef_getmaxforce(b2MouseJointDef * mouseJointDef) {
	return mouseJointDef->maxForce;
}

void bmx_b2mousejointdef_setmaxforce(b2MouseJointDef * mouseJointDef, float32 force) {
	mouseJointDef->maxForce = force;
}

float32 bmx_b2mousejointdef_getfrequencyhz(b2MouseJointDef * mouseJointDef) {
	return mouseJointDef->frequencyHz;
}

void bmx_b2mousejointdef_setfrequencyhz(b2MouseJointDef * mouseJointDef, float32 frequency) {
	mouseJointDef->frequencyHz = frequency;
}

float32 bmx_b2mousejointdef_getdampingratio(b2MouseJointDef * mouseJointDef) {
	return mouseJointDef->dampingRatio;
}

void bmx_b2mousejointdef_setdampingratio(b2MouseJointDef * mouseJointDef, float32 damping) {
	mouseJointDef->dampingRatio = damping;
}

//***********************************************************************************************************
// Class : b2Shape
//***********************************************************************************************************
float32 bmx_b2shape_getradius(b2Shape * shape) {
	return shape->m_radius;
}

void bmx_b2shape_setradius(b2Shape * shape, float32 radius) {
	shape->m_radius = radius;
}

//***********************************************************************************************************
// Class : b2World
//***********************************************************************************************************

b2World * bmx_b2world_create(b2Vec2 * gravity) {
	return new b2World(*gravity);
}

void bmx_b2world_dostep(b2World * world, float32 timeStep, int velocityIterations, int positionIterations) {
	world->Step(timeStep, velocityIterations, positionIterations);
}

b2Body * bmx_b2world_createbody(b2World * world, b2BodyDef * def, BBObject * body) {
	def->userData = body;
	BBRETAIN(body);
	return world->CreateBody(def);
}

void bmx_b2world_destroybody(b2World * world, b2Body * body) {
	void * data = body->GetUserData();
	if (data && data != &bbNullObject) {
		BBRELEASE((BBObject*)data);
	}
	world->DestroyBody(body);
}

int bmx_b2world_getallowsleeping(b2World * world) {
	return world->GetAllowSleeping();
}

void bmx_b2world_setallowsleeping(b2World * world, int flag) {
	world->SetAllowSleeping(flag);
}

int bmx_b2world_getwarmstarting(b2World * world) {
	return world->GetWarmStarting();
}

void bmx_b2world_setwarmstarting(b2World * world, int flag) {
	world->SetWarmStarting(flag);
}

int bmx_b2world_getcontinuousphysics(b2World * world) {
	return world->GetContinuousPhysics();
}

void bmx_b2world_setcontinuousphysics(b2World * world, int flag) {
	world->SetContinuousPhysics(flag);
}

int bmx_b2world_getsubstepping(b2World * world) {
	return world->GetSubStepping();
}

void bmx_b2world_setsubstepping(b2World * world, int flag) {
	world->SetSubStepping(flag);
}

void bmx_b2world_DrawDebugData(b2World * world) {
	world->DrawDebugData();
}

void bmx_b2world_setdebugDraw(b2World * world, b2Draw * debugDraw) {
	world->SetDebugDraw(debugDraw);
}

b2Joint * bmx_b2world_createjoint(b2World * world, b2JointDef * def) {
	BBObject * joint = _arm_box2d_b2World__createJoint(def->type);
	def->userData = joint;
	BBRETAIN(joint);
	return world->CreateJoint(def);
}

void bmx_b2world_destroyjoint(b2World * world, b2Joint * joint) {
	void * data = joint->GetUserData();
	if (data && data != &bbNullObject) {
		BBRELEASE((BBObject*)data);
	}
	world->DestroyJoint(joint);
}
/*
b2Body * bmx_b2world_getbodylist(b2World * world) {
	return world->GetBodyList();
}

b2Joint * bmx_b2world_getjointlist(b2World * world) {
	return world->GetJointList();
}

void bmx_b2world_setfilter(b2World * world, b2ContactFilter * filter) {
	world->SetContactFilter(filter);
}

void bmx_b2world_setcontactlistener(b2World * world, b2ContactListener * listener) {
	world->SetContactListener(listener);
}

void bmx_b2world_setboundarylistener(b2World * world, b2BoundaryListener * listener) {
	world->SetBoundaryListener(listener);
}
*/
b2Vec2 * bmx_b2world_getgravity(b2World * world) {
	return bmx_b2vec2_new(world->GetGravity());
}

void bmx_b2world_setgravity(b2World * world, b2Vec2 * gravity) {
	world->SetGravity(*gravity);
}

int32 bmx_b2world_getproxycount(b2World * world) {
	return world->GetProxyCount();
}

int32 bmx_b2world_getcontactcount(b2World * world) {
	return world->GetContactCount();
}

int32 bmx_b2world_getbodycount(b2World * world) {
	return world->GetBodyCount();
}

int32 bmx_b2world_getjointcount(b2World * world) {
	return world->GetJointCount();
}

int32 bmx_b2world_gettreeheight(b2World * world) {
	return world->GetTreeHeight();
}

int32 bmx_b2world_gettreebalance(b2World * world) {
	return world->GetTreeBalance();
}


void bmx_b2world_queryaabb(b2World * world, b2QueryCallback * callback, b2AABB * aabb) {
	world->QueryAABB(callback, *aabb);
}

void bmx_b2world_free(b2World * world) {
	delete world;
}

void bmx_b2world_setdestructionlistener(b2World * world, b2DestructionListener * listener) {
	world->SetDestructionListener(listener);
}

/*
int32 bmx_b2world_raycast(b2World * world, b2Segment * segment, BBArray * shapes, int solidShapes) {
	int32 n = shapes->scales[0];
	b2Shape* _shapes[n];
	
	int32 ret = world->Raycast(*segment, _shapes, n, solidShapes, NULL);

	int32 count = (ret < n) ? ret : n;

	for (int i = 0; i < count; i++) {
		_bah_box2d_b2World__setShape(shapes, i, _shapes[i]);
	}

	return ret;
}

b2Controller * bmx_b2world_createcontroller(b2World * world, b2ControllerDef * def, b2ControllerType type) {
	BBObject * bbController = _bah_box2d_b2World___createController(type);
	BBRETAIN(bbController);

	b2Controller * controller =  world->CreateController(def);
	controller->SetUserData((void*)bbController);
	return controller;
}

void bmx_b2world_destroycontroller(b2World * world, b2Controller * controller) {
	void * data = controller->GetUserData();
	if (data && data != &bbNullObject) {
		BBRELEASE((BBObject*)data);
	}
	world->DestroyController(controller);
}
*/