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


## 游戏系统 
1. 战斗系统
2. 任务系统
3. 好友系统
4. 邮件系统
5. 交易系统
6. 聊天系统
7. 装备系统 (强化 宝石 附魔)
8. 宠物系统