# Practice2

- 只要編譯指定的package
```bash=
$ catkin_make -DCATKIN_WHITELIST_PACKAGES="practice2"
```

## 題目
1. 請實踐出一個使turtlesim走到你指定位置的功能，注意frame之間的轉換，turtlesim的座標定義在world frame ，但是他的twist定義在 body frame。
- 須更改 code : turtle_Pcontrol.cpp

![](https://i.imgur.com/uEb3wAr.png)


``` bash=
$ roslaunch practice2 turtle_single.launch
$ rosrun practice2 turtle_Pcontrol
```
----
2. 請實現一個烏龜編隊的功能。共有三隻烏龜，一隻為 leader，其餘為 follower。
- 編隊隊形須定義再leader 的 body frame 底下，ex: leader頭轉，隊伍就要轉動
- leader turtle 由 keyboard control 來移動
- 須更改 code : turtle_formation.cpp

![](https://i.imgur.com/USt9MmZ.png)

```bash=
$ roslaunch practice2 turtle_team.launch
$ rosrun practice2 turtle_formation
$ rosrun practice2 turtle_keyboard
```
