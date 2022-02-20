
#include "ros/ros.h"
#include "std_msgs/Int32.h"

using namespace std;
std_msgs::Int32 msg;


int main(int argc, char **argv)
{
  cout << "initialize publish number" << endl;

  // you should rename your node and topic to avoid confliction
  ros::init(argc, argv, "number_pub");
  ros::NodeHandle n;
  ros::Publisher chatter_pub1 = n.advertise<std_msgs::Int32>("/number_1", 1000);
  ros::Rate loop_rate(10);


  while (ros::ok())
  {

    // Publish number data here






  }


  return 0;
}
