pragma solidity ^0.4.14;
contract Payroll {
    
    struct Employee {
        address employeeAddress;
        uint lastPayday;
        uint salary;   
    }
    address boss;
    uint constant payDuration = 10 seconds;
    uint totalSalary;
    mapping(address => Employee) public employees;
     
    function Payroll() payable {
        boss = msg.sender;
    }
    
    modifier onlyBoss {
        require(msg.sender == boss);
        _;
    }
    
    modifier employeeExsit(address employeeAddress) {
        var employee = employees[employeeAddress];
        assert(employee.employeeAddress != 0x0);
        _;
    }
    
    modifier employeeNotExsit(address employeeAddress) {
        var employee = employees[employeeAddress];
        assert(employee.employeeAddress == 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.employeeAddress.transfer(payment);
    }
    
    function addEmployee(address employeeAddress, uint salary) onlyBoss {
        var employee = employees[employeeAddress];
        assert(employee.employeeAddress == 0x0);
        employees[employeeAddress] = Employee(employeeAddress, now ,salary * 1 ether);
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeAddress) onlyBoss employeeExsit(employeeAddress){
        var employee = employees[employeeAddress];
        _partialPaid(employee);
        totalSalary -= employee.salary;
        delete employees[employeeAddress];
   }

    function updateEmployeeSalary(address employeeAddress, uint newSalary) onlyBoss employeeExsit(employeeAddress){
        var employee = employees[employeeAddress];
        _partialPaid(employee);
        
        totalSalary -= employee.salary;
        employees[employeeAddress].salary = newSalary * 1 ether;
        employees[employeeAddress].lastPayday = now;
        totalSalary += newSalary;
    }
    
    function changePaymentAddress(address oldAddress, address newAddress) employeeExsit(oldAddress) employeeNotExsit(newAddress) {
        var employee = employees[oldAddress];
        assert(msg.sender == boss || msg.sender == employee.employeeAddress);
        employees[oldAddress].employeeAddress = newAddress;
    }
    
    function addFund() payable returns(uint) {
        return this.balance;
    }
    
    function calculateRunway() view returns(uint) {
        return this.balance / totalSalary;
    }
    
    function getSalary(address employeeAddress) employeeExsit(employeeAddress) returns(uint) {
        var employee = employees[employeeAddress];
        return employee.salary;
    }
    
     function hasEnoughFund() view returns (bool) {
        return calculateRunway() > 0;
     }
        
    function getPayment() employeeExsit(msg.sender){
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employee.employeeAddress.transfer(employee.salary);
    }
 }
