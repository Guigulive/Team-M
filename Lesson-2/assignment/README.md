作业
1. 完成今天的智能合约添加100ETH到合约中加入的10个员工，每个员工的薪水都是1ETH。

"0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", 1
"0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", 1
"0x583031d1113ad414f02576bd6afabfb302140225", 1
"0xdd870fa1b7c4700f2bd7f44238821c26f7392148", 1
"0x51b7fd73e860aa99326bdc7479249e8d2373e951", 1
"0x780af20bcd349102ba61b682896c099026eebc2e", 1
"0x6a5290c2cd2805f9e9f11bfd1eddeafc5245f49d", 1
"0xfa81525dad1d44bb4d1938573c7ab1dc9b923661", 1
"0x3d400952792cb363da37e884833d2b56a0b5a14b", 1
"0xd962b0fffa780b0c20f02079c09bc04f33bf8f48", 1



2. 每次加入一个员工后调用 calculateRunway函数并且记录消耗gas是多少?
gas cost
transaction     execution
23506  2234
24294  3022
25082  3810
25870  4598
26658  5386
27446 6174
28234 6962
29022 7750
29810 8538
30598 9326

3. 为什么消耗的gas有变化？
caculateRunaway 计算随着employees数组长度增加需要执行更多的opcodes。

4. 如何对calculateRunway函数进行优化 减少gas 消耗？

减少gas方法，需要减少evm上执行opcodes的数量。
方法一： 增加本地变量 totalSalaryCache 每次添加员工就把薪水值加到 totalSalaryCache。

方法二: 优化 for 循环，减少读取 employees 长度数组读取次数
```
 function caculateRunaway() returns (uint){
        uint totalSalary = 0;
        uint len = employees.length;
        for ( uint i= 0; i< len ; i++){
            totalSalary += employees[i].salary ;

        }
        assert(totalSalary !=0 );
        assert( this.balance !=0 );
        return this.balance / totalSalary ;
    }
```
优化后
```
gas cost
transaction     execution

23223 1951
23803 2531
24383 3111
24963 3691
25543 4271
26123 4851
26703 5431
27283 6011
27863 6591
28443 7171
```

可以看到优化后，transaction execution gas消耗明显减少。
