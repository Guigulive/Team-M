pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        address id ;
        uint salary ;
        uint lastPayDay ;
    }

    Employee [] employees;

    uint salary = 1 ether;

    //雇主 地址
    address employerAddress = 0x0 ;
    //员工地址
    address employeeAddress = 0x0 ;
    // 支付周期
    uint constant payDuration = 10 seconds ;
   //上次支付时间
    uint lastPayDay = now;


    // init method
    function Payroll(){
        employerAddress = msg.sender;
    }

    // 支付 部分工资
    function _partialPay(Employee e) {
        assert(employee.id != 0x0)
        uint payment = e.salary*(now - e.lastPayDay) / payDuration ;
        e.id.transfer(payment);

    }

    function _findEmployee(address employeeId){
          for ( uint i= 0; i< employees.length ; i++){
            if (employees[i].id == employeeId){
                return ( employees[i] ,i);
            }
        }
    }

    function addEmployee( address employeeId, uint salary  ){
        require(msg.sender == employerAddress);
        //Employee e =_findEmployee(employeeId);
        var (employee , index ) = _findEmployee(employeeId);
        // 异常
        assert(employee.id != 0x0)
        /**for(uint i= 0; i< employees.length ; i++){
            if (employees[i].id == employee){
                revert();
            }
        }*/
        employees.push(Employee(employeeId,salary,now));
    }

    function removeEmployee(address employee){
        require(msg.sender == employerAddress);

        var (employee , index ) = _findEmployee(employeeId);
        assert(employee.id != 0x0)
        _partialPay(employee.id);
        delete  employees[index];

        employees[index] = employees[employees.length - 1];
        employees.length -= 1;


    }

    function updateEmployee(address employee,uint  salary ) payable {
        require(msg.sender == employerAddress);
        var (employee , index ) = _findEmployee(employeeId);
        assert(employee.id != 0x0)

        employee.id = employee;
        employee.salary = salary;
        employee.lastPayDay = now;

    }

    function addFund()  payable returns (uint) {
      // add money to contract
      return this.balance ;
    }

    function  getFund () returns (uint) {
        return this.balance ;
    }

    function caculateRunaway() returns (uint){
        uint totalSalary = 0;
        for ( uint i= 0; i< employees.length ; i++){
            totalSalary += employees[i].salary ;

        }

         return this.balance / totalSalary ;
    }

    function hasEnoughFund() returns (bool) {
        // return this.balance >= salary ;
        // this 方法 gas 高
       return  caculateRunaway()>0 ;
    }

    function getPaid() {

        var ( employee ,index) = _findEmployee(msg.sender);

        assert( employee.id != 0x0 );

        uint nexPayDay = lastPayDay + payDuration;
        // 确保 支付时间 正确
        assert(nexPayDay < now);
        /**
         * if (nexPayDay > now ) {
            revert() ;
             exception no gas
        }
        */

        lastPayDay = nexPayDay ;
        // 发钱
        employee.id.transfer(employee.salary);

    }

}