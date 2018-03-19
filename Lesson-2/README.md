## 硅谷live以太坊智能合约频道官方地址

### 第二课《智能合约设计进阶-多员工薪酬系统》

目录结构
  <br/>|
  <br/>|--orgin 课程初始代码
  <br/>|
  <br/>|--assignment 课程作业提交代码
<br/> 
### 本节知识点
第2课：智能合约设计进阶-多员工薪酬系统
- 动态静态数组的不同
- 函数输入参数检查 revert
- 循环与遍历的安全性
- 程序运行错误检查和容错：assert与require


Homework02 Week01

Gas changes when number of employees increasing.
number of Employee/  Gas used in calculateRunaway();
1 / 1672
2 / 2453
3 / 3234
4 / 4015
5 / 4796
...

we can see that the gas consumed is increasing. This is because more iterations to calculate total salary will be needed as the number of employees incerease.
Since we only need to update the total salary when new employee is added, there's no need to re-calculate it each time we call the calculateRunaway().
We can simply move totalsalary out of this function and save it as a global variable.

function addFund() payable returns (uint){
      return this.balance;
    }


Please see Hw02_taurus.sol file for modified function and variable declaration.
In this way, the gas consumed by each calculateRunaway() call is reduced to 830.


Thank you.
Tao
