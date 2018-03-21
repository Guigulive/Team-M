/*作业请提交在这个目录下*/

/*完成今天的智能合约添加100ETH到合约中
加入十个员工，每个员工的薪水都是1ETH 每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
如何优化calculateRunway这个函数来减少gas的消耗？ 提交：智能合约代码，gas变化的记录，calculateRunway函数的优化*/

消耗的gas：
employee	            1	2	3	4	5	6	7	8	9	10
transaction cost(gas)	22966	23747	24528	25309	26090	26871	27652	28433	29214	29995
execution cost(gas)	1694	2475	3256	4037	4818	5599	6380	7161	7942	8723

答：gas消耗随着employee数量增加而增加。因为calculateRunway方法中要用for循环遍历所有员工的salary以求和，复杂度是O（n）的，n为employee数量。

答：优化方法，可以使用一个变量存放当前所有员工的totalSalary，每次addEmployee时，只需要将totalSalary加上新员工的salary即可，复杂度为O（1）。

优化完消耗的gas：
employee	1	2	3	4	5	6	7	8	9	10
transaction cost(gas)	22356	22356	22356	22356	22356	22356	22356	22356	22356	22356
execution cost(gas)	1084	1084	1084	1084	1084	1084	1084	1084	1084	1084

修改过的代码：有注释的地方是修改的地方

pragma solidity ^0.4.14;

contract Payroll{
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 60 seconds; //constant
    
    Employee[] employees;
    
    uint totalSalary;               //
    
    uint lastPayday = now;
    
    address owner;
    
    function Payroll() {
        owner  = msg.sender;
        totalSalary = 0 ether;      //initialize totalSalary
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday)/payDuration;
        employee.id.transfer(payment); 
    }
    
    function _findEmployee(address employeeId) private returns (Employee ,uint){
        for(uint i = 0;i < employees.length; i++){
            if(employees[i].id == employeeId) {
                return (employees[i],i);
            }
        }
    }
    
    function addEmployee(address employeeId,uint salary) {
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId,salary,now));
        
        totalSalary += (salary * 1 ether); // add totalSalary while add employee
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        
        totalSalary -= (employees[index].salary * 1 ether); // decrease totalSalary while removeEmployee
        delete employees[index];
        employees[index] = employees[employees.length -1];
        employees.length -= 1;
        
        
    }
    
    function updateEmployee(address employeeId,uint salary){
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0); 
        
        _partialPaid(employee);
        
        totalSalary = totalSalary - (employees[index].salary)* 1 ether + salary*1 ether;     //update totalSalary 
        
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;      
        
        
    }
    
    function addFund() payable returns(uint){
        return this.balance;
    }
    
    function calculateRunway() returns(uint){
        
        require(totalSalary != 0);
        return this.balance/totalSalary;
    }
    
    function hasEnoughFund() returns(bool){
        return calculateRunway() > 0;
    }
    
    function getPaid(){
        var (employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);        
        
        uint nextPayDay = lastPayday + payDuration;
        
        assert(nextPayDay < now);
        
        employees[index].lastPayday = nextPayDay;
        employees[index].id.transfer(employee.salary);    
    }
}

