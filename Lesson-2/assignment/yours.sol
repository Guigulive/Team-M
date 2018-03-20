<<<<<<< HEAD
=======
/*作业请提交在这个目录下*/
>>>>>>> 8cf877f6bdced1ffaed6b70e2bd14a32eb727c06
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
<<<<<<< HEAD
    // keep track of total salary for all Employees.
    uint totalSalary = 0;
    uint constant payDuration = 10 seconds;
    address owner;
    Employee[] employees;
    
=======
    
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;

>>>>>>> 8cf877f6bdced1ffaed6b70e2bd14a32eb727c06
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
<<<<<<< HEAD
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
=======
        for(uint i = 0; i < employees.length; i++){
            if (employees[i].id == employeeId){
>>>>>>> 8cf877f6bdced1ffaed6b70e2bd14a32eb727c06
                return (employees[i], i);
            }
        }
    }
<<<<<<< HEAD
    
    function addEmployee(address employeeId, uint salary) returns (address) {
        require(msg.sender == owner);
        var(employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, salary * 1 ether, now));
        totalSalary += employees[index].salary;
        return employeeId;
    }
    
    function removeEmployee(address employeeId) {
        var(employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        delete employee;
=======

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (emloyee, index) = _findEmployee(employeeId);
        assert(emloyee.id == 0x0);
        employees.push(Employee(employeeId, salary * 1 ether, now));
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        delete employees[index];
>>>>>>> 8cf877f6bdced1ffaed6b70e2bd14a32eb727c06
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
<<<<<<< HEAD
    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        var(employee, index) = _findEmployee(e);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        
        employee.id = e;
        employees[index].salary = s * 1 ether;
        employee.lastPayday = now;
        totalSalary = totalSalary - employee.salary + employees[index].salary;
=======
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        employee.salary = salary;
        employee.lastPayday = now;
>>>>>>> 8cf877f6bdced1ffaed6b70e2bd14a32eb727c06
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
<<<<<<< HEAD
    function calculateRunaway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function getBalance() returns (uint) {
        return this.balance;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunaway() > 0;
    }
    
    function getPaid() {
        var(employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        uint nextPayDay = employee.lastPayday + payDuration;
        assert(nextPayDay < now);
        employee.lastPayday = nextPayDay;
=======
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
       for (uint i = 0; i < employees.length; i++) {
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
        assert (nextPayday < now);
        
        employee.lastPayday = nextPayday;
>>>>>>> 8cf877f6bdced1ffaed6b70e2bd14a32eb727c06
        employee.id.transfer(employee.salary);
    }
}
