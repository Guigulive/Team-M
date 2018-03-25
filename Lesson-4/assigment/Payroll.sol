pragma solidity ^0.4.14;

import './Ownable.sol';
import './SafeMath.sol';


contract Payroll is Ownable{
    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    uint totalSalary = 0;
    mapping(address => Employee) public employees;

    modifier employeeExist(address employeeId) {
        Employee  employee = employees[employeeId];
        require(employee.id != 0x0);
        _;
    }

    modifier employeeNotExist(address employeeId) {
        Employee  employee = employees[employeeId];
        require(employee.id == 0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
        uint payments =  now.sub(employee.lastPayday)
        .div(payDuration)
        .mul(employee.salary);

        employee.id.transfer(payments);
    }

    function addEmployee(address employeeId, uint salaryEther) onlyOwner employeeNotExist(employeeId) {
        uint salary = salaryEther.mul(1 ether);

        employees[employeeId] = Employee(employeeId, salary, now);
        totalSalary = totalSalary.add(salary);
    }

    function removeEmployee(address employeeId) onlyOwner  employeeExist(employeeId) {
        Employee memory employee= employees[employeeId];

        delete employees[employeeId];
        totalSalary = totalSalary.sub(employee.salary);
        _partialPaid(employee);
    }

    function updateEmployee(address employeeId, uint salaryEther) onlyOwner employeeExist(employeeId) {
        Employee memory employee= employees[employeeId];

        uint salary = salaryEther.mul(1 ether);
        totalSalary = totalSalary.add(salary).sub(employee.salary);
        employees[employeeId].salary = salary;
        employees[employeeId].lastPayday = now;

        _partialPaid(employee);
    }

    function addFund()  payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExist(msg.sender){
        Employee storage employee = employees[msg.sender];

        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);

        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }

    function changePaymentAddress(address employeeId,address newEmployeeId) 
            onlyOwner employeeExist(employeeId) employeeNotExist(newEmployeeId) {
                
        addEmployee(newEmployeeId, employees[employeeId].salary * 1 ether);
        removeEmployee(employeeId);
    }
}
