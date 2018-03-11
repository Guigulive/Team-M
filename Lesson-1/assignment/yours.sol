pragma solidity ^0.4.14;

contract Payroll {
    uint salary;
    address frank;
    address boss = msg.sender;           //record contract creater as the boss, who can set salary standard.

    uint constant payDuration = 5 seconds;
    uint lastPayday = now;

    function showBoss() returns (address){                  //display boss' address
        return boss;
    }

    function setSalary(uint inputSalary) returns (uint){        //let boss to set salary; unit in ether
        if (msg.sender != boss)
            revert();
        salary = inputSalary * 1 ether;
        return salary;
    }

    function setAddress() returns (address){                //let employee set account addr to receive payment
        frank = msg.sender;
        return frank;
    }

    function addFund() payable returns (uint){
      return this.balance;
    }

    function calculateRunaway () returns (uint){
      return this.balance / salary;
    }

    function hasEnoughFund() returns (bool){
      return calculateRunaway() > 0;
    }

    function getPaid() returns(uint){
      if (msg.sender != frank){         //exclude senders other than Frank;
        revert();
      }

      uint nextPayDay = lastPayday + payDuration;
      if (nextPayDay > now){
        revert();
      }
      lastPayday = nextPayDay;
      frank.transfer(salary);
      return frank.balance;
    }
}
