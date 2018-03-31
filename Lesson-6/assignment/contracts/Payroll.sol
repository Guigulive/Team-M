pragma solidity ^0.4.18;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
    uint constant paymentDuration = 10 seconds;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    address owner;
    uint totalSalary;
    uint totalEmployee;
    address[] employeeList;
    mapping(address => Employee) public employees;

    event NewEmployee(
        address employee
    );
    event UpdateEmployee(
        address employee
    );
    event RemoveEmployee(
        address employee
    );
    event NewFund(
        uint balance
    );
    event GetPaid(
        address employee
    );
    
    modifier employeeExists(address employeeId) {
        Employee storage employee = employees[employeeId];
        assert(employee.id != address(0));
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary
            .mul(now.sub(employee.lastPayday))
            .div(paymentDuration);
        employee.id.transfer(payment);
    }
    
    function addFund() public payable returns(uint) {
        NewFund(this.balance);
        return this.balance;
    }

    function checkEmployee(uint index) public view returns (address employeeId, uint salary, uint lastPayday) {
        employeeId = employeeList[index];
        Employee storage employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function addEmployee(address employeeId, uint salary) public onlyOwner {
        Employee storage employee = employees[employeeId];
        assert(employee.id == address(0));
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        
        totalSalary = totalSalary.add(salary.mul(1 ether));
        totalEmployee = totalEmployee.add(1);
        employeeList.push(employeeId);
        NewEmployee(employeeId);
    }
    
    function updateEmployee(address employeeId, uint salary) public onlyOwner employeeExists(employeeId) {
        Employee storage employee = employees[employeeId];
        
        _partialPaid(employee);
        
        totalSalary -= employees[employeeId].salary;
        employees[employeeId].salary = salary.mul(1 ether);
        employees[employeeId].lastPayday = now;
        totalSalary = totalSalary.add(employees[employeeId].salary);
        UpdateEmployee(employeeId);
    }
    
    function removeEmployee(address employeeId) public onlyOwner employeeExists(employeeId) {
        Employee storage employee = employees[employeeId];
        
        _partialPaid(employee);
        delete employees[employeeId];
        totalSalary = totalSalary.sub(employee.salary);
        totalEmployee = totalEmployee.sub(1);
        RemoveEmployee(employeeId);
    }
    
    function calculateRunway() public view returns(uint) {
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() public view returns(bool) {
        return calculateRunway() > 0;
    }
    
    function changePaymentAddress(address employeeId, address newAddress) public onlyOwner employeeExists(employeeId) {
        Employee storage employee = employees[employeeId];
        employees[newAddress] = Employee(newAddress, employee.salary, employee.lastPayday);
        delete employees[employeeId];
    }
    
    function checkEmployee(address employeeId) public view returns (uint salary, uint lastPayday) {
        Employee storage employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function getPaid() public employeeExists(msg.sender) {
        Employee storage employee = employees[msg.sender];

        uint nextPayday = employee.lastPayday.add(paymentDuration);
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
        GetPaid(employee.id);
    }

    function getInfo() public view returns(uint balance, uint runway, uint employeeCount) {
        balance = this.balance;
        employeeCount = totalEmployee;

        if (totalSalary > 0) {
            runway = calculateRunway();
        }
    }
}