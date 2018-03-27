/*作业请提交在这个目录下*/
写出对如下两个函数的单元测试：
function addEmployee(address employeeId, uint salary) onlyOwner
function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId)

var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("should add and remove employee correctly", function() {
    var payroll;
    var account_boss = accounts[0];
    var account_employee = accounts[1];

    return Payroll.deployed().then(function(instance) {
      payroll = instance;
      assert(true);
      return payroll.addEmployee(account_employee, 2);
    }).then(function() {
      return payroll.checkEmployee(account_employee);
    }).then(function(result) {
      assert.equal(result[0].toString(), web3.toWei(2, 'ether'), "salary wasn't correct");
    }).then(function() {
      return payroll.removeEmployee(account_employee);
    }).then(function() {
      return payroll.checkEmployee(account_employee);
    }).then(function(result) {
      assert.equal(result[0].toString(), '0', "salary wasn't empty");
      assert.equal(result[1].toString(), '0', "lastPayday wasn't empty");
    })
   });
});
