## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
答案：每次添加新员工后，calculateRunaway消耗的gas都会增加，因为每次计算totalSalary都是遍历一次employees数组，需要重复计算。
十次的gas消耗为
Transaction cost
22944
23725
24506
25287
26068
26849
27630
28411
29192
29973


Execution cost
1672
2453
3234
4015
4796
5577
6358
7139
7920
8701


- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化
优化后每次gas消耗
transaction cost 	22102 gas 
execution cost 	830 gas
