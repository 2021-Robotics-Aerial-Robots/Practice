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
turtlesim::Pose leader;
turtlesim::Pose follower1;
turtlesim::Pose follower2;
turtlesim::Pose goal1;
turtlesim::Pose goal2;

geometry_msgs::Twist vel_msg_follower1;
geometry_msgs::Twist vel_msg_follower2;

ros::Publisher follower1_pub;
ros::Publisher follower2_pub;


bool reset;

struct XY{
    float x;
	float y;
};

struct XY pos_err_I;



// declare call back function
void leader_cb(const turtlesim::Pose::ConstPtr& msg)
{
	leader = *msg;
}

void follower_cb1(const turtlesim::Pose::ConstPtr& msg)
{
	follower1 = *msg;
}

void follower_cb2(const turtlesim::Pose::ConstPtr& msg)
{
	follower2 = *msg;
}

// translation matrix in 2D
void leadertoworld(float &x, float &y, turtlesim::Pose &leader)
{
	float x_temp = x;
	float y_temp = y;
	/* Write your code here


	*/
} 

// rotation matrix in 2D
void rotate2D(float &x, float &y, float theta)
{
	float x_temp = x;
	float y_temp = y;
	/* Write your code here


	*/
} 


void Positioncontrol(turtlesim::Pose &goal, turtlesim::Pose &follower, geometry_msgs::Twist &vel_msg) {
    
	ROS_INFO("Goal point");
	cout << "x: " << goal.x <<    "y: " << goal.y << endl;;
	ROS_INFO("current position");
    cout << "x: " << follower.x <<"y: " << follower.y << endl;;

	// error in inertia frame
	pos_err_I.x = goal.x - follower.x;
	pos_err_I.y = goal.y - follower.y;

	// Find the goal_point position in Body(turtlesim) frame
	rotate2D(pos_err_I.x, pos_err_I.y, follower.theta);


	// Find the error postion 
	float error_norm = sqrt(pow(pos_err_I.x, 2) + pow(pos_err_I.y, 2));

	// Find the error theta 
	float error_theta = atan2(pos_err_I.y,pos_err_I.x);

	// Output upper bound
	if (error_norm > 2) error_norm = 2;

	//Publish control input	
	vel_msg.linear.x = error_norm;
	vel_msg.angular.z = error_theta;

}



int main(int argc, char **argv)
{
	ros::init(argc, argv, "turtle_formation");
  	ros::NodeHandle n;

  	// declare publisher & subscriber
	// leader turtle
  	ros::Subscriber leader_sub = n.subscribe<turtlesim::Pose>("/turtlesim/leader/pose", 1, leader_cb);
	// follower turtle  
  	ros::Subscriber follower_sub1 = n.subscribe<turtlesim::Pose>("/turtlesim/follower1/pose", 1, follower_cb1);
	ros::Subscriber follower_sub2 = n.subscribe<turtlesim::Pose>("/turtlesim/follower2/pose", 1, follower_cb2);

	follower1_pub = n.advertise<geometry_msgs::Twist>("/turtlesim/follower1/cmd_vel", 1);
	follower2_pub = n.advertise<geometry_msgs::Twist>("/turtlesim/follower2/cmd_vel", 1);

	// setting frequency as 10 Hz
  	ros::Rate loop_rate(10);
	
  	while (ros::ok()){
		
		// Define the formation in leader turtle frame
        goal1.x = -1;
        goal1.y = -1;

		goal2.x = -1;
		goal2.y = 1;
		
        // rotate from leader turtle frame to world frame
        leadertoworld( goal1.x, goal1.y , leader);
		leadertoworld( goal2.x, goal2.y , leader);

		//Input your goal_point to your controller
    	Positioncontrol(goal1, follower1, vel_msg_follower1);
    	Positioncontrol(goal2, follower2, vel_msg_follower2);

		//Input your control input(from Pcontrol) to your plant
    	follower1_pub.publish(vel_msg_follower1);
		follower2_pub.publish(vel_msg_follower2);

    	ros::spinOnce();
		loop_rate.sleep();
	}
	return 0;
}


