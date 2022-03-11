"""
Simulate a quadrotor following a 3D trajectory, reference : PythonRobotics/ Daniel Ingram
"""

from cmath import pi
from math import cos, sin, acos, asin
from random import weibullvariate
import numpy as np
from Quadrotor import Quadrotor
from TrajectoryGenerator import TrajectoryGenerator
from mpl_toolkits.mplot3d import Axes3D

show_animation = True

# Simulation parameters
g = 9.81

Ixx = 1
Iyy = 1.2
Izz = 1
J = np.eye(3)
T = 5

# Proportional coefficients
# translation
Kp_z = 12

# rotation
Kp_roll = 10
Kp_pitch = 10
Kp_yaw = 10



# Derivative coefficients
# translation

Kd_z = 6

# rotation
Kd_yaw = 3
Kd_roll = 3
Kd_pitch = 3

def quad_sim(x_c, y_c, z_c):
    """
    Calculates the necessary total_thrust and torques for the quadrotor to
    follow the trajectory described by the sets of coefficients
    x_c, y_c, and z_c.
    """
    # initial condition
    x_pos = 0
    y_pos = 0
    z_pos = 2
    
    x_vel = 0
    y_vel = 0
    z_vel = 0
    
    x_acc = 0
    y_acc = 0
    z_acc = 0
    
    roll = 0
    pitch = 0
    yaw = 0
    
    eul_angle = np.array([[0],[0],[0]]); 
    angular_vel = np.array([[0], [0] , [0]]);
    
    # desire yaw angle
    des_yaw = 0

    # desire angular velocity, we want the quadcopter to avoid rotating
    des_yaw_rate = 0;
    des_roll_rate = 0;
    des_pitch_rate = 0;
    
    # time initialize
    dt = 0.1
    t = 0

    # initialize the quadcopter with ic above
    q = Quadrotor(x=x_pos, y=y_pos, z=z_pos, roll=roll,
                  pitch=pitch, yaw=yaw, size=1, show_animation=show_animation)

    # counts for trajectory
    i = 0
    n_run = 3
    irun = 0

    while True:
        
        while t <= T:

            des_z_pos = calculate_position(z_c[i], t)
            des_z_vel = calculate_velocity(z_c[i], t)
            des_x_acc = calculate_acceleration(x_c[i], t)
            des_y_acc = calculate_acceleration(y_c[i], t)
            des_z_acc = calculate_acceleration(z_c[i], t)

            
            des_roll =  0; 
            des_pitch = 0;
            
            
            # Checkpoint4:  Please define the error term here !
            
            '''
            # position error  (z)
            ex_z = 

            # angle error
            er_roll = 
            er_pitch = 
            er_yaw = 
                
            # velocity error (z)
            ev_z = ;
            
            # angular velocity error
            ew_roll = ;
            ew_pitch = ;
            ew_yaw = ;
            
            '''

            # Checkpoint5:  Please design your controller here !    
            
            '''
            # translation controller
            total_thrust = 
            
            # rotation controller
            roll_torque = 
            pitch_torque = 
            yaw_torque = 
            '''
            
            total_moment = np.array([ np.array([roll_torque]), np.array([pitch_torque]), yaw_torque], dtype=object)
            
            
            # motor force allocation
            control_input = np.concatenate([np.array([total_thrust]),total_moment])
            motor_force = q.invallocation_matrix @ control_input
            
            '''
            ---------------------Dynamics update -----------------------
            '''
            
            # Get total_thrust and total_moment from motor 
            control_input_real = q.allocation_matrix @ motor_force
            
            total_thrust_real = control_input_real[0]
            total_moment_real = control_input_real[1:]
            
            # -------------- Rotation dynamics update --------------------
            # equation (2) in week4
            
            angular_acc = (np.linalg.inv(J)) @ (total_moment_real - vec_cross(eul_angle, np.matmul(J,eul_angle)));
            angular_vel = angular_vel + angular_acc*dt;
            eul_angle = eul_angle + angular_vel*dt
            
            roll = eul_angle[0];
            pitch = eul_angle[1];
            yaw = eul_angle[2];
            
            # get the rotation matrix from roll, pitch, yaw angle
            R = rotation_matrix(roll, pitch, yaw)
            
            
            # ------------ Translation dynamics update ------------------
            # equation (1) in week4
            acc = (np.matmul(R, np.array([0, 0, total_thrust_real.item()]).T) ) / q.m - np.array([0, 0,  g]).T
            noise = np.random.normal(0, 0.05,acc.shape)
            acc += noise
            
            # acceleration update
            x_acc = acc[0]
            y_acc = acc[1]
            z_acc = acc[2]
            # velocity update, basic physics!
            x_vel += x_acc * dt
            y_vel += y_acc * dt
            z_vel += z_acc * dt
            # position update
            x_pos += x_vel * dt
            y_pos += y_vel * dt
            z_pos += z_vel * dt
            
            # update pose for quadcopter and update the animation
            q.update_pose(x_pos, y_pos, z_pos, roll, pitch, yaw)

            t += dt

        t = 0
        i = (i + 1) % 3
        irun += 1
        
        if irun >= n_run:
            break

    print("Simulation Complete")


def calculate_position(c, t):

    return c[0] * t**5 + c[1] * t**4 + c[2] * t**3 + c[3] * t**2 + c[4] * t + c[5]


def calculate_velocity(c, t):

    return 5 * c[0] * t**4 + 4 * c[1] * t**3 + 3 * c[2] * t**2 + 2 * c[3] * t + c[4]


def calculate_acceleration(c, t):

    return 20 * c[0] * t**3 + 12 * c[1] * t**2 + 6 * c[2] * t + 2 * c[3]


def rotation_matrix(roll, pitch, yaw):
    """
    Calculates the ZYX rotation matrix.

    Args
        Roll: Angular position about the x-axis in radians.
        Pitch: Angular position about the y-axis in radians.
        Yaw: Angular position about the z-axis in radians.

    Returns
        3x3 rotation matrix as NumPy array
    """
    return np.array(
        [[cos(yaw) * cos(pitch), -sin(yaw) * cos(roll) + cos(yaw) * sin(pitch) * sin(roll), sin(yaw) * sin(roll) + cos(yaw) * sin(pitch) * cos(roll)],
         [sin(yaw) * cos(pitch), cos(yaw) * cos(roll) + sin(yaw) * sin(pitch) *
          sin(roll), -cos(yaw) * sin(roll) + sin(yaw) * sin(pitch) * cos(roll)],
         [-sin(pitch), cos(pitch) * sin(roll), cos(pitch) * cos(yaw)]
         ])



def vec_cross(a,b):
    return np.array([[a[1]*b[2] - a[2]*b[2]], [-a[0]*b[2] + a[2]*b[0]], [a[0]*b[1] - a[1]*b[0]]]).reshape(3,1)

def main():
    """
    Calculates the x, y, z coefficients for the four segments 
    of the trajectory
    """
    x_coeffs = [[], [], [], []]
    y_coeffs = [[], [], [], []]
    z_coeffs = [[], [], [], []]
    waypoints = [[0, 0, 2], [0,0,2], [0,0,2]]

    for i in range(3):
        traj = TrajectoryGenerator(waypoints[i], waypoints[(i + 1) % 3], T)
        traj.solve()
        x_coeffs[i] = traj.x_c
        y_coeffs[i] = traj.y_c
        z_coeffs[i] = traj.z_c

        
    quad_sim(x_coeffs, y_coeffs, z_coeffs)


if __name__ == "__main__":
    main()
