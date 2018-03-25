pragma solidity ^0.4.18;
import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    // keep track of total salary for all Employees.
    uint totalSalary = 0;
    uint constant payDuration = 10 seconds;
    address owner;
    mapping(address => Employee) public employees;
    
    modifier employeeExist(address employeeId) {
        Employee storage employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    
    function addEmployee(address employeeId, uint salary) onlyOwner public {
        Employee storage employee = employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
        totalSalary += employees[employeeId].salary;
    }
    
    function removeEmployee(address employeeId) public employeeExist(employeeId) {
        Employee storage employee = employees[employeeId];
        _partialPaid(employee);
        delete employees[employeeId];
        totalSalary -= employee.salary;
    }
    
    function updateEmployee(address e, uint s) public onlyOwner employeeExist(e) {
        Employee storage employee = employees[e];
        _partialPaid(employee);
        
        employee.id = e;
        employee.salary = s * 1 ether;
        employee.lastPayday = now;
        totalSalary = totalSalary - employee.salary + employee.salary;
    }
    
    function changePaymentAddress(address oldAddress, address newAddress) public onlyOwner employeeExist(oldAddress) {
        Employee storage employee = employees[oldAddress];
        employees[newAddress] = Employee(newAddress, employee.salary, employee.lastPayday);
        delete employees[oldAddress];
    }
    
    function addFund() payable public returns (uint) {
        return this.balance;
    }
    
    function calculateRunaway() public returns (uint) {
        return this.balance / totalSalary;
    }
    
    function getBalance() public returns (uint) {
        return this.balance;
    }
    
    function hasEnoughFund() public returns (bool) {
        return calculateRunaway() > 0;
    }
    
    function getPaid() public employeeExist(msg.sender) {
        Employee storage employee = employees[msg.sender];
        uint nextPayDay = employee.lastPayday + payDuration;
        assert(nextPayDay < now);
        employee.lastPayday = nextPayDay;
        employee.id.transfer(employee.salary);
    }
}