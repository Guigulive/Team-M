pragma solidity ^0.4.14;

// author: @haoruiwu
contract Payroll {
    uint salary = 1 ether;
    address employee;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function setSalary(uint s) {
        salary = s * 1 ether;
    }
    
    function setEmployee(address e) {
        employee = e;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunaway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunaway() > 0;
    }
    
    function getPaid() {
        require (msg.sender == employee);
        uint nextPayDay = lastPayday + payDuration;
        if (nextPayDay > now) {
            revert();
        }
        
        lastPayday = nextPayDay;
        employee.transfer(salary);
    }
}
