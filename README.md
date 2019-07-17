github下载插件注意事项

点击绿色的 Clone or download 》 Download ZIP  下载

解压后得到的文件名是MostValuablePlayer-master
-master 是默认分支名
需要删掉
最后AddOns里的文件名是MostValuablePlayer就行了






20190621 更新 数据共享.发送数据-切换场景时,队伍更新时。接收数据-在队伍里时
20190618 更新 修改MVP3D模型按ESC关闭,3秒钟变一次模型的动画，简化了一些代码
20190615 更新 可移动MVP3D模型位置和大小，用鼠标滚轮调大小和左键拖动
20190610 更新 获取鼠标指向UNIT大秘境数据并保存到本地，并在鼠标提示中显示
20190608 更新 通报者权重，如果队里有两人开这插件，只有一个人会通报。更新版本提醒
20190606 更新 支持details伤害统计，数据更准确。聊天框通报染色。通关后出现3D模型。anranwa提供部分代码和想法。
20190604 更新 修复猎人假死计入死亡次数，在设置里添加通报MVP开关
20190525 更新 可查看大秘境次数
20190521 更新 添加秒伤数据
20190513 更新 大秘境层数和限时加分
20190513 更新 添加驱散数据
20190505 更新 自动记录通关大秘境后的数据评分，并且添加到鼠标提示信息中

https://bbs.nga.cn/read.php?&tid=17126188





















特征：

常见问题：
一般情况：
问：如何备份我的MVP-数据和设置
答：将文件WoW\WTF\Account\*YourAccountName*\SavedVariables\MostValuablePlayer.lua复制到您选择的安全位置。

问：我发现了一个错误/错误，我该怎么办？
答：来NGA帖子https://bbs.nga.cn/read.php?&tid=17126188描述你是怎么引起问题的(或者是什么时候发生的)，并发布了Lua错误消息。由于我们可能有额外的问题，请加入暴雪群组Nx9mbGlhDLo 
完整的链接https://blizzardgames.cn/invite/Nx9mbGlhDLo 以修复更新。

问：我对这插件有个好主意！想听吗？
答：来NGA链接https://bbs.nga.cn/read.php?&tid=17126188或QQ群674540635暴雪群组Nx9mbGlhDLo然后发布你的想法。

问：我喜欢测试新版本。哪里能第一时间获得版本？
答：来NGA链接https://bbs.nga.cn/read.php?&tid=17126188或QQ群674540635暴雪群组Nx9mbGlhDLo





帮助评注/作者：
问：我怎样才能帮助本地化呢？
答：链接https://github.com/janyroo/MostValuablePlayer本地化/开始吧！

问：我如何支持作者和发展这一插件？
答：你可以在https://github.com/janyroo/MostValuablePlayer点个STAR

问：我可以用Lua编写代码，并想开发MVP？
答：用你的想法和经验给我写一个PM-我会回顾这个想法，如果它完成了，就把它写进Vanaskos，或者如果你想开发更多的东西，请把你作为一个共同作者添加。

其他：

问：你用这句话赚了多少钱？
答：几乎什么都没有-我(Jany)花在MostValuablePlayer的每小时不到5毛钱，不过别担心-这是作者的爱好，所以收入不是发展的一个因素，但也意味着现实生活中的工作更重要，所以当修复/开发需要更长的时间时，请耐心等待我。





意见和见意：
√ 修改mvp模型的大小和位置
修改评分算法

已知BUG:
宠物驱散末计入数据
√ MVP3D模型只能在出现的第一次调大小，之后调不了，除非重新加载游戏。代码结合和逻辑的原因
