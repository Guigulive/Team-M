## 第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图


## 第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能

   使用 modifier 整合 添加 修改员工地址

```
modifier employeeNotExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
```


## 第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
    - contract O
    - contract A is O
    - contract B is O
    - contract C is O
    - contract K1 is A, B
    - contract K2 is A, C
    - contract Z is K1, K2

    Z=>  [K2, C, K1, B, A, 0]