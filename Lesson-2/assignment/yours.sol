pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    // keep track of total salary for all Employees.
    uint totalSalary = 0;
    uint constant payDuration = 10 seconds;
    address owner;
    Employee[] employees;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }
    
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
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        var(employee, index) = _findEmployee(e);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        
        employee.id = e;
        employees[index].salary = s * 1 ether;
        employee.lastPayday = now;
        totalSalary = totalSalary - employee.salary + employees[index].salary;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
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
        employee.id.transfer(employee.salary);
    }
}
