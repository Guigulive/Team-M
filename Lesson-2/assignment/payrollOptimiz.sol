pragma solidity ^0.4.14;
contract Payroll {
    
    struct Employee {
        address employeeAddress;
        uint lastPayday;
        uint salary;   
    }
    address boss;
    uint constant payDuration = 10 seconds;
    uint totalSalary;
    Employee[] employees;
     
    function Payroll() payable public {
        boss = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.employeeAddress.transfer(payment);
    }
    
    function _findEmployee(address employeeAddress) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].employeeAddress == employeeAddress) {
                return (employees[i], i);
            }
        }
    }
    
    function addEmployee(address employeeAddress, uint salary) {
        require(msg.sender == boss);
        
        var (employee, index) = _findEmployee(employeeAddress);
        assert(employee.employeeAddress == 0x0);
        
        employees.push(Employee(employeeAddress, salary * 1 ether, now));
        totalSalary += salary;
    }
    
    function removeEmployee(address employeeAddress) {
        require(msg.sender == boss);
        
        var (employee, index) = _findEmployee(employeeAddress);
        assert(employee.employeeAddress != 0x0);
        
        _partialPaid(employee);
        totalSalary -= employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
   }

    function updateEmployee(address newAddress, uint newSalary) public{
        require(msg.sender == boss);
        
        var (employee, index) = _findEmployee(newAddress);
        assert(employee.employeeAddress != 0x0);
        _partialPaid(employee);
        
        totalSalary += newSalary - employee.salary;
        employee.salary = newSalary * 1 ether;
        employee.lastPayday = now;
    }
    
    function addFund() payable public returns(uint) {
        return this.balance;
    }
    
    function calculateRunway() public view returns(uint) {
        return this.balance / totalSalary;
    }
    
    function getSalary(address employeeAddress) public view returns(uint) {
        var (employee, index) = _findEmployee(employeeAddress);
        return employee.salary;
    }
    
     function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
     }
        
    function getPayment() public {
        var(employee, index) = _findEmployee(msg.sender);
        assert(employee.employeeAddress != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employee.lastPayday = nextPayday;
        employee.employeeAddress.transfer(employee.salary);
    }
 }
