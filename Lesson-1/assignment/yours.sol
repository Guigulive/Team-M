/*作业请提交在这个目录下
url: https://remix.ethereum.org/#optimize=false&version=soljson-v0.4.21+commit.dfe3193c.js
author: hqman
date: 2018-03-13
*/
pragma solidity ^0.4.14;

contract Payroll {

    uint salary = 1 ether;

    //雇主 地址
    address employerAddress = 0x0 ;
    //员工地址
    address employeeAddress = 0x0 ;
    // 支付周期
    uint constant payDuration = 10 seconds ;
   //上次支付时间
    uint lastPayDay = now;



    function Payroll(){
        employerAddress = msg.sender;
    }

    function updateEmployeeAdress(address employeeAddress,uint  employeeSalary ){
        require(msg.sender == employerAddress);
        employeeAddress  = employeeAddress;
    }


    function  updateEmployeeSalary(uint  salary_ether){
        require(msg.sender == employerAddress);
        salary = salary_ether * 1 ether;
    }

    function addFund()  payable returns (uint) {
      // add money to contract
      return this.balance ;
    }

    function  getFund () returns (uint) {
        return this.balance ;
    }

    function caculateRunaway() returns (uint){
         return this.balance / salary ;
    }

    function hasEnoughFund() returns (bool) {
        // return this.balance >= salary ;
        // this 方法 gas 高
       return  caculateRunaway()>0 ;
    }

    function getPaid() {
        require(msg.sender == employeeAddress);

        uint nexPayDay = lastPayDay + payDuration;
        if (nexPayDay > now ) {
            revert() ;
            // exception no gas
        }

        lastPayDay = nexPayDay ;
        // 发钱
        employeeAddress.transfer(salary);

    }

}

