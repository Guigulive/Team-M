pragma solidity ^0.4.14;
contract Payroll {
    
    struct Employee {
        address employeeAddress;
        uint lastPayday;
        uint salary;   
    }
    address boss;
    Employee employee;
    uint constant payDuration = 10 seconds;
     
    function Payroll() payable public {
        boss = msg.sender;
        employee.lastPayday = now;
        employee.salary = 2 ether;
    }

    function updateEmployee(address newAddress, uint newSalary) public{
        require(msg.sender == boss);
        require(newSalary > 0);
        if(employee.employeeAddress != 0x0) {
            uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
            employee.employeeAddress.transfer(payment);
        }
        employee.employeeAddress = newAddress;
        employee.salary = newSalary;
        employee.lastPayday = now;
    }

    function getEmployee() public view returns(address) {
        return employee.employeeAddress;
    }
    
    function addFund() payable public returns(uint) {
        return this.balance;
    }
    
    function calculateRunway() public view returns(uint) {
        return this.balance / employee.salary;
    }
    
    function getSalary() public view returns(uint) {
        return employee.salary;
    }
    
     function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
     }
        
    function getPayment() public {
        require(msg.sender == employee.employeeAddress);
        require(employee.employeeAddress != 0x0);
        uint nextPayday = employee.lastPayday + payDuration;
        require(nextPayday < now);
        
        employee.lastPayday = nextPayday;
        employee.employeeAddress.transfer(employee.salary);
    }
 }
