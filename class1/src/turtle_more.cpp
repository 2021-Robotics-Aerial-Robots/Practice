#include "ros/ros.h"
#include <turtlesim/Spawn.h>
#include <turtlesim/Kill.h>
#include <string>
#include <iostream>

using namespace std;


int main(int argc, char **argv)
{
    ros::init(argc, argv, "spawnturtles");
    ros::NodeHandle n;

    // Check if the service is on
    ros::service::waitForService("/turtlesim/spawn");

    // initialize kill turtle service
    ros::ServiceClient client_kill=n.serviceClient<turtlesim::Kill>("/turtlesim/kill");
    turtlesim::Kill kill_name;
    // define parameters in service
    kill_name.request.name = "turtle1";
    // call the service
    client_kill.call(kill_name); 


    // initialize spawn turtle service
    ros::ServiceClient client_spawn = n.serviceClient<turtlesim::Spawn>("???");
    turtlesim::Spawn turtle;

    // Finish your code, you will need to spawn turtles






    

}