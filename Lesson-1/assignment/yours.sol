/*作业请提交在这个目录下*/
//第一课：课后作业
//实现课上所教的单员工智能合约系统，并且加入两个函数能够更改员工地址以及员工薪水。
pragma solidity ^0.4.14;

contract Payroll{
    uint salary;  
    address employee;
    address owner;
    uint constant payDuration = 5 seconds;         //constant
    uint lastPayday = now;
    
    function setAddress(address a){               //setAddress
        employee = a;
    }
    
    function setSalary(uint s){                 //setSalary
        salary = s*1 ether;
    }
    
    function addFund() payable returns(uint){
        return this.balance;
    }
    
    function calculateRunway() returns(uint){
        return this.balance/salary;
    }
    
    function hasEnoughFund() returns(bool){
        return this.balance>=salary;
    }
    
    function getPaid(){
        if(msg.sender != employee){
            revert();
        }
        
        uint nextPayDay = lastPayday + payDuration;
        if(nextPayDay > now){
            revert();
        }
        
        lastPayday = nextPayDay;
        employee.transfer(salary);    
    }
}
