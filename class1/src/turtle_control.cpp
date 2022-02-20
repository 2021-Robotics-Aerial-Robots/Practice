/*
  Author : Chad Lin
  Target : Keyboard Control
  Date : 11/07 2018
*/

// include ros library
#include "ros/ros.h"

// include msg library
#include <geometry_msgs/Twist.h>

// include cpp library 
#include <cstdio>
#include <unistd.h>
#include <termios.h>
#include <fcntl.h>

geometry_msgs::Twist vel_msg;

char getch()
{
  int flags = fcntl(0, F_GETFL, 0);
  fcntl(0, F_SETFL, flags | O_NONBLOCK);

  char buf = 0;
  struct termios old = {0};
  if (tcgetattr(0, &old) < 0) {
      perror("tcsetattr()");
  }
  old.c_lflag &= ~ICANON;
  old.c_lflag &= ~ECHO;
  old.c_cc[VMIN] = 1;
  old.c_cc[VTIME] = 0;
  if (tcsetattr(0, TCSANOW, &old) < 0) {
      perror("tcsetattr ICANON");
  }
  if (read(0, &buf, 1) < 0) {
      //perror ("read()");
  }
  old.c_lflag |= ICANON;
  old.c_lflag |= ECHO;
  if (tcsetattr(0, TCSADRAIN, &old) < 0) {
      perror ("tcsetattr ~ICANON");
  }
  return (buf);
}

void KeyboardControl()
{
  int c = getch();
  if (c != EOF)
  {
    switch (c)
    {
      // finish your code here

      case 119:    // key w
        
        break;
      case 115:    // key s
        
        break;
      case 100:    // key d
        
        break;
      case 97:    // key a
        
        break;
      case 114:    // key r, stop the turtle 
        
        break;
    }
  }
}

int main(int argc, char **argv)
{
  ros::init(argc, argv, "turtle_control");
  ros::NodeHandle n;

  // declare publisher, which turtle are you?
  ros::Publisher turtlesim_pub = n.advertise<geometry_msgs::Twist>("???", 100);

  // setting frequency as 100 Hz
  ros::Rate loop_rate(100);

  printf("KeyboardControl start\n");

  int count = 0;

  while (ros::ok()){
    
    // control turtle twist 
    KeyboardControl();
    turtlesim_pub.publish(vel_msg);
    // print on screen
    printf("\ncount : %d\n",count);
    printf("linear\t %f \n",vel_msg.linear.x);
    printf("angular\t %f \n",vel_msg.angular.z);
    count ++;
    ros::spinOnce();
    loop_rate.sleep();
  }
  return 0;
}


