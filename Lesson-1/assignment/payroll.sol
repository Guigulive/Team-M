pragma solidity ^0.4.14;

contract Payroll {
    uint constant paymentDuration = 10 seconds;
    
    address employee;
    uint salary;
    uint lastPayday = now;
    
    function addFund() payable returns(uint) {
        return this.balance;
    }
    
    function setEmployee(address e) {
        employee = e;
    }
    
    function setSalary(uint s) {
        salary = s * 1 ether;
    }
    
    function calculateRunway() returns(uint) {
        return this.balance / salary;
    }
    
    function hasEnoughtFund() returns(bool) {
        return calculateRunway() > 0;
    }
    
    function employeeValidation() constant returns(bool) {
        return !(employee == address(0));
    }
    
    function salaryValidation() constant returns(bool) {
        return salary > 0;
    }
    
    function getPaid() {
        if (!employeeValidation() || !salaryValidation() || !hasEnoughtFund()) {
            revert();
        }
        
        uint nextPayday = lastPayday + paymentDuration;
        
        if (nextPayday > now) {
            revert();
        }
        
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}