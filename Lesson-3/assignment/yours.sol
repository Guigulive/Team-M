pragma solidity ^0.4.14;

contract Payroll {
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }


    address owner;             //record contract creater as the boss, who can set salary standard.
    uint constant payDuration = 5 seconds;
    uint totalsalary = 0;
    mapping (address => Employee) public employees;

    function Payroll(){             //construction function
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender == owner);   //add this secments to the top
        _;
    }

    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }


    function changePaymentAddress (address paymentAddress) employeeExist(msg.sender) {
        //employees[msg.sender].id = paymentAddress;
        employees[paymentAddress] = (Employee(paymentAddress, employees[msg.sender].salary, employees[msg.sender].lastPayday));
        delete employees[msg.sender];
    }

    function _partialPaid (Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner {
        //require(msg.sender == owner);
        var employee = employees[employeeId];
        assert(employee.id == 0x0);

        employees [employeeId] = (Employee(employeeId, salary * 1 ether, now));
        totalsalary += employees[employeeId].salary;
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        _partialPaid(employees[employeeId]);

        delete employees[employeeId];
        totalsalary -= employees[employeeId].salary;
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId){
        totalsalary -= employees[employeeId].salary;

        _partialPaid(employees[employeeId]);
        employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].lastPayday = now;
        totalsalary += employees[employeeId].salary;
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

    function checkEmployee(address employeeId) returns(uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        //returns(employees[employeeId].salary, employees[employeeId].lastPayday);
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }


    function getPaid() employeeExist(msg.sender) {
        //var employee = employees[msg.sender];
        //assert(employee.id != 0x0);

        uint nextPayDay = employees[msg.sender].lastPayday + payDuration;
        assert(nextPayDay < now);

        employees[msg.sender].lastPayday = nextPayDay;
        employees[msg.sender].id.transfer(employees[msg.sender].salary);
    }
}

