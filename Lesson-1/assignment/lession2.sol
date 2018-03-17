/***********
优化钱 gas 记录
操作  transaction cost   execution cost
1       22966               1694
2       23747               2475
3       24528               3256
4       25309               4037
5       26090               4818
6       26871               5599
7       27652               6380
8       28433               7161
9       29214               7942
10      29995               8723

优化后
操作  transaction cost   execution cost
1       22356               1084
2       22356               1084
3       22356               1084
4       22356               1084
--
--
*********/

pragma solidity ^0.4.14;

contract Payroll {
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 10 seconds;

    address owner;
    
    Employee[] employees;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    
    function _partialPay(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++){
            if(employees[i].id == employeeId){
                return (employees[i], i);
            }
        }
    }
    
    function addEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, salary, now));
    }
    
    function deleteEmployee(address employeeId){
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPay(employee);
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }


    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPay(employee);
        employees[index].salary = salary;
        employees[index].lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++){
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
