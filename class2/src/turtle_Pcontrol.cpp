// include ros library
#include "ros/ros.h"

// include msg library
#include <turtlesim/Pose.h>
#include <geometry_msgs/Twist.h>
#include <geometry_msgs/Point.h>

// include math 
#include <math.h>

using namespace std;

float theta_error;

// turtle pose
turtlesim::Pose turtle;

// goal points
geometry_msgs::Point turtle_goal;

// turtle twist
geometry_msgs::Twist turtle_twist;

// turtle publisher
ros::Publisher turtle_pub;


bool reset;

struct XY{
    float x;
	float y;
};

struct XY pos_err_I;



// declare call back function
void turtle_cb(const turtlesim::Pose::ConstPtr& msg)
{
	turtle = *msg;
}


// rotate the world frame coordinate to body frame 
void worldtobody2D(float &x, float &y, float theta)
{
	/* --------------------
	Finish your code here


	----------------------*/
} 


// P control for goal position in world frame 
void Positioncontrol(geometry_msgs::Point &goal, turtlesim::Pose &turtle_pose, geometry_msgs::Twist &turtle_vel_msg) {

	// error in inertia frame
	pos_err_I.x = goal.x - turtle_pose.x;
	pos_err_I.y = goal.y - turtle_pose.y;

	// Find the goal_point position in Body(turtlesim) frame
	worldtobody2D(pos_err_I.x, pos_err_I.y, turtle_pose.theta);

	// Find the error postion 
	float error_norm = sqrt(pow(pos_err_I.x, 2) + pow(pos_err_I.y, 2));

	// Find the error theta 
	float error_theta = atan2(pos_err_I.y,pos_err_I.x);

	// Output boundary
	if (error_norm > 2) error_norm = 2;

	// Design your controller here, you may use a simple P controller
	
	/*--------------------------


		ex: turtle_vel_msg.x = ....
			turtle_vel_msg.theta = ....



	-----------------------------*/
}



int main(int argc, char **argv)
{
	ros::init(argc, argv, "turtle_Pcontrol");
  	ros::NodeHandle n;

  	// declare publisher & subscriber

	// turtle subscriber
  	ros::Subscriber turtle_sub = n.subscribe<turtlesim::Pose>("/turtlesim/turtle/pose", 1, turtle_cb); 

	turtle_pub = n.advertise<geometry_msgs::Twist>("/turtlesim/turtle/cmd_vel",1);
		
	// define turtle goal point

	ROS_INFO("Please input (x,y). x>0,y>0");
	cout<<"desired_X:";
	cin>>turtle_goal.x;
	cout<<"desired_Y:";
	cin>>turtle_goal.y;	


	// setting frequency as 10 Hz
  	ros::Rate loop_rate(10);
	
  	while (ros::ok()){
		
		ROS_INFO("goal x : %f \t y : %f\n",turtle_goal.x,turtle_goal.y);
    	ROS_INFO("pose x : %f \t y : %f\n",turtle.x,turtle.y);
    	ROS_INFO("pose theta: %f \n",turtle.theta);

		//Input your goal_point to your controller
		Positioncontrol(turtle_goal, turtle, turtle_twist);

		turtle_pub.publish(turtle_twist);

    	ros::spinOnce();
		loop_rate.sleep();
	}
	return 0;
}


