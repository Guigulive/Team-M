<<<<<<< HEAD
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
=======
/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
>>>>>>> 8cf877f6bdced1ffaed6b70e2bd14a32eb727c06
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
<<<<<<< HEAD
    function calculateRunaway() returns (uint) {
=======
    function calculateRunway() returns (uint) {
>>>>>>> 8cf877f6bdced1ffaed6b70e2bd14a32eb727c06
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
<<<<<<< HEAD
        return calculateRunaway() > 0;
    }
    
    function getPaid() {
        require (msg.sender == employee);
        uint nextPayDay = lastPayday + payDuration;
        if (nextPayDay > now) {
            revert();
        }
        
        lastPayday = nextPayDay;
=======
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
>>>>>>> 8cf877f6bdced1ffaed6b70e2bd14a32eb727c06
        employee.transfer(salary);
    }
}
