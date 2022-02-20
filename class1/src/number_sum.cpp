// include ros library
#include "ros/ros.h"
// include msg library
#include "std_msgs/Int32.h"
// include c++ library
#include "cstdio"

using namespace std;

class NumberSummation {
private:

    int number1;
    int number2;
    int number3;
    ros::Publisher pub;
    ros::Subscriber number_subscriber1;
    ros::Subscriber number_subscriber2;
    ros::Subscriber number_subscriber3;

public:

    NumberSummation(ros::NodeHandle *nh) {
        // subscribe numbers
        number_subscriber1 = nh->subscribe("/number_1", 1000, 
            &NumberSummation::callback_number1, this);
        number_subscriber2 = nh->subscribe("/number_2", 1000, 
            &NumberSummation::callback_number2, this);
        number_subscriber3 = nh->subscribe("/number_3", 1000, 
            &NumberSummation::callback_number3, this);     
    }

    // get number from nodes
    void callback_number1(const std_msgs::Int32& msg) {
        number1 = msg.data;
    }

    void callback_number2(const std_msgs::Int32& msg) {
        number2 = msg.data;
    }

    void callback_number3(const std_msgs::Int32& msg) {
        number3 = msg.data;
        summation();
    } 

    // sum the numbers and publish
    void summation(){
        
        // Implement your code here


    }
};



int main (int argc, char **argv)
{  
    ros::init(argc, argv, "number_sum");
    ros::NodeHandle nh;
    NumberSummation nc = NumberSummation(&nh);
    ros::spin();
}