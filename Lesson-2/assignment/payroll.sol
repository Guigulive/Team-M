/*作业请提交在这个目录下
author: hqman
date: 2018-03-15
*/
contract Payroll {

    struct Employee {
        address id ;
        uint salary ;
        uint lastPayDay ;
    }

    Employee [] employees;

    uint salary = 0 ether;

    //雇主 地址
    address owner = 0x0 ;
    //员工地址
   // address employeeAddress = 0x0 ;
    // 支付周期
    uint constant payDuration = 10 seconds ;
   //上次支付时间
    uint lastPayDay = now;

    // init method
    function Payroll(){
        owner = msg.sender;
    }

    // 支付 部分工资
    function _partialPay(Employee employee) private {
        //assert(employee.id != 0x0);
        uint payment = employee.salary * ( now - employee.lastPayDay ) / payDuration ;
        employee.id.transfer(payment);

    }

    function _findEmployee(address employeeId) private returns (Employee ,uint) {
          for ( uint i= 0; i< employees.length ; i++ ){
            if ( employees[i].id == employeeId ) {
                return ( employees[i] ,i);
            }
        }
    }


    function addEmployee( address employeeId, uint salary  ){
        require(msg.sender == owner);
        //Employee e =_findEmployee(employeeId);
        var (employee , index ) = _findEmployee(employeeId);
        // 异常
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId,salary * 1 ether,now));
    }

    function removeEmployee(address employeeId){
        require(msg.sender == owner);

        var (employee , index ) = _findEmployee(employeeId);

        assert(employee.id != 0x0);
        _partialPay(employee);
        delete  employees[index];

        employees[index] = employees[employees.length - 1];
        employees.length -= 1;


    }

    function updateEmployee(address employeeId,uint  salary ) payable {
        require(msg.sender == owner);

        var (employee , index ) = _findEmployee(employeeId);
        assert(employee.id != 0x0);

        employees[index].id = employeeId;
        employees[index].salary = salary* 1 ether;
        employees[index].lastPayDay = now;

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

        assert(totalSalary !=0 );
        assert( this.balance !=0 );
        return this.balance / totalSalary ;
    }

    function caculateRunaway_Op() returns (uint){
        uint totalSalary = 0;

        uint len = employees.length;
        for ( uint i= 0; i< len ; i++){
            totalSalary += employees[i].salary ;

        }

        assert(totalSalary !=0 );
        assert( this.balance !=0 );
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