pragma solidity ^0.4.14;

contract Payroll{
    
    address boss = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    
    address employee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    
    uint salary = 1;
    
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function addFund() payable returns (uint) {
        if(msg.sender != boss){
            revert();
        }
        return this.balance;
    }
    
    function setEmployAddress(address newAddress){
        if(msg.sender != boss){
            revert();
        }
        employee = newAddress;
    }
    
    function setEmploySalary(uint newSalary){
        if(msg.sender != boss){
            revert();
        }
        salary = newSalary * 1 ether;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid(){
        if(msg.sender != employee){
            revert();
        }
        uint nextPayday = lastPayday + payDuration;
        if (nextPayday > now){
            revert();    
        } 
        
        lastPayday = nextPayday;
        employee.transfer(salary);
    } 
    
    
}
