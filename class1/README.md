
# Practice 1

```
$ mkdir -p catkin_ws/src
$ cd ~/catkin_ws/src
$ git clone https://github.com/2021-Robotics-Aerial-Robots/Practice.git
$ cd ..
$ catkin_make
```
## 題目


### 1. Number Summation
- 需要 publish 一個 Int32 的數字到Topic上（名稱自訂），再subscribe 組內所有人 publish 的數字，加總後印出來即可

```
$ rosrun practice1 number_pub1
$ rosrun practice1 number_pub2
...

$ rosrun practice1 number_sum
```

### 2. Turtles spawn and control
- 呼叫 turtle
```
$ roslaunch practice1 turtlesim.launch
```
- 將原本的烏龜刪掉，並且呼叫和組員數量相同的烏龜
```
$ rosrun practice1 turtle_spawn
```
- 每位組員控制自己名字的烏龜，在一位同學的電腦上操控
```
$ rosrun practice1 turtle_control
```

