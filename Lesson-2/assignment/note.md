# gas 变化及分析

## gas 变化

1. 1669
2. 2457
3. 3245 
4. 4033
5. 4821
6. 5609
7. 6397
8. 7185
9. 7973
10. 8761

## 分析

随着员工数的增加，for 循环内部语句被执行的次数同步增加，导致计算消耗的 gas 增加

## 优化

将员工工资总额的更新放在 addEmployee/updateEmployee/deleteEmployee 中，totalSalary 存为全局变量。