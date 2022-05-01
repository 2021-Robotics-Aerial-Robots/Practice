# UKF estimate

In this practice, we are going to estimate the force of follower and leader quadcopters by measuring position and linear acceleration. 

You will need to complete the ukf algorithm. 
![](https://i.imgur.com/DjFd2NO.png)

## Rosbag
This bagfile contains position and acceleration of leader and follower quadcopter. 

- link : https://drive.google.com/file/d/1KWIDi6VNwPiwOLB5AGW6t-7zWqMQYqdp/view?usp=sharing

- usage:
```bash=
cd ~/where the bag is 
robag play -l exercise7.bag
```

## Nodes in this exercise
![](https://i.imgur.com/iq4UIkg.png)

1. leader quadcopter - firefly1
2. follower quadcopter - firefly2
3. leader_ukf / force_estimate
4. follower_ukf / force_estimate



## Citation
https://ieeexplore.ieee.org/abstract/document/9147355