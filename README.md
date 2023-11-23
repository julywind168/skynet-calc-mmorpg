# skynet-calc-mmorpg
这个一个简单 mmo 开源游戏, 目的是简单演示 [skynet-calc](https://github.com/HYbutterfly/skynet/tree/calc) 的用法

对应的 [client](https://github.com/HYbutterfly/skynet-calc-mmorpg-client) 基于 cocos creator v3.8.1 开发



## Build
```
	1. git submodule update --init
	2. cd skynet & build
	3. ./start.sh
```

## 框架结构
1. skynet 基于该分支 [skynet-calc](https://github.com/HYbutterfly/skynet/tree/calc) 
2. 网关: 基于websocket
3. 数据库: mongodb


## 游戏玩法
玩家登陆后会进入一张地图, 可以攻击其它玩家

<img src="https://raw.githubusercontent.com/wiki/HYbutterfly/skynet-calc-mmorpg/mmo-demo.png" width="844" height="413">


## 在线试玩 (手机端)

1. 关注微信公众号 "纸鸢在线" 并发送 "mmo"
2. 手机浏览器打开 [mmorpg-demo](http://website-9gh9arvn0ad71845-1251951859.tcloudbaseapp.com/mmorpg-demo/index.html) 