# skynet-calc-mmorpg
skynet-calculator mmorpg server


## Build
```
	1. cd skynet & git checkout calc & build
	2. ./start.sh
```

## 框架结构
1. skynet 基于该分支 [skynet](https://github.com/HYbutterfly/skynet/tree/calc) 
2. 网关: 第一阶段基于websocket, 后期扩展到多网关(tcp)
3. 数据库: mongodb 一个数据库够用了


## 游戏设计
职业: 
	战士 剑客 刺客 术士 药师

基本属性:
	力量 智慧 体质 敏捷 精神 灵巧

最大等级: 100级


## 位置同步
1. 对时
	客户端连接成功后发送一个 ping, 计算出rtt (Round-Trip Time) 然后带上 rtt 登陆
2. 猜测
	Client A -> S -> Client B,   S收到A的包（位置，速度，方向）后根据上行延时猜测A的当前位置，然后广播给其它玩家B, B再根据自己的下行延时猜测 A一秒后的位置, 然后计算好速度，方向，让A' 1秒后到那个预测到位置就行了。
3. 简单起见, 暂时假设 上行延迟 == 下行延迟 == rtt/2



## 游戏系统 
1. 战斗系统
2. 任务系统
3. 好友系统
4. 邮件系统
5. 交易系统
6. 聊天系统
7. 装备系统 (强化 宝石 附魔)
8. 宠物系统