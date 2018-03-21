pragma solidity ^0.4.14;
import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 10 seconds;

    uint totalSalary;
    mapping(address => Employee) public employees;
    
    modifier employeeOwner(){
        assert(msg.sender == employees[msg.sender].id);
        _;
    }
    
    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    
    function _partialPay(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary) onlyOwner{
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        totalSalary += salary * 1 ether;
        employees[employeeId] = Employee(employeeId, salary, now);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        _partialPay(employee);
        totalSalary -= employees[employeeId].salary * 1 ether;
        delete employees[employeeId];
    }


    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
 
        _partialPay(employee);
        totalSalary -= employee.salary * 1 ether;
        employees[employeeId].salary = salary;
        employees[employeeId].lastPayday = now;
        totalSalary += salary * 1 ether;
    }
    
    function changePaymentAddress(address oldEmployeeId, address newEmployeeId) employeeOwner employeeExist(oldEmployeeId){
        var employee = employees[oldEmployeeId];
        employees[oldEmployeeId].id = newEmployeeId;
        employees[newEmployeeId] = employees[oldEmployeeId];
        delete employees[oldEmployeeId];
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        assert(totalSalary !=0);
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExist(msg.sender){
       var employee = employees[msg.sender];
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}