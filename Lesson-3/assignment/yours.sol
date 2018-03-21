/*作业请提交在这个目录下*/
第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能

function changePaymentAddress(address employeeId,address newId) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];        
        employee.id = newId;
}
