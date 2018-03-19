/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
//by taoluwork

contract Payroll {
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    Employee[] employees;
    address owner;             //record contract creater as the boss, who can set salary standard.
    uint constant payDuration = 5 seconds;
    uint totalsalary = 0;


    function Payroll(){             //construction function
        owner = msg.sender;
    }

    function _partialPaid (Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeId) private returns (Employee, uint){
        for (uint i = 0; i < employees.length; i++){
            if (employees[i].id == employeeId){
               return (employees[i],i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, salary, now));
        totalsalary += salary;
    }

    function removeEmployee(address employeeId){
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    function updateEmployee(address employeeId, uint salary) {
        //if(msg.sender != owner) revert();       //assert(bool), require(bool)
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);

        _partialPaid(employee);
        employees[index].salary = salary;
        employees[index].lastPayday = now;
    }

    function addFund() payable returns (uint){
      return this.balance;
    }

    function calculateRunaway () returns (uint){
        return this.balance / totalsalary;

    }

    function hasEnoughFund() returns (bool){
      return calculateRunaway() > 0;
    }

    //function getPaid() returns(uint){
    function getPaid() {
        //require (msg.sender == employee);
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);

        uint nextPayDay = employee.lastPayday + payDuration;
        assert(nextPayDay < now);

        employees[index].lastPayday = nextPayDay;
        employees[index].id.transfer(employee.salary);
        //return employee.balance;
    }
}
