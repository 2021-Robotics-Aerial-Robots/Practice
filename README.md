# Practice


### ROS 連線
- 虛擬機注意事項
    - 虛擬機需將網路設定調整成 **橋接介面卡**
    - [Reference](https://www.twblogs.net/a/5c1fe0edbd9eee16b3dacb8c)


1. install net-tools
```
$ sudo apt-get install net-tools
$ ifconfig 
```
2. open bashrc
```
$ gedit ~/.bashrc
```
3. Setup ROS_IP and ROS_MASTER_URI **at the bottom**
    - 假設我的IP： 192.168.0.185 ， 啟動 roscore 裝置 IP: 192.168.0.180
    - 裝置和roscore位置一樣，則填寫一樣的address
```bash=
$ export ROS_IP=192.168.0.185
$ export ROS_MASTER_URI=http://192.168.0.180:11311
```

### 可安裝工具
- VScode
    - 文字編輯器，支援多種語言，色調和提示可以讓開發更快速
    - [Reference](https://learningsky.io/tools-ubuntu-install-visual-studio-code/)
- Terminator
    - 可分切多個螢幕，特別適用於ROS要開多個terminal的時候
    ```
    $ sudo apt install terminator
    ```

