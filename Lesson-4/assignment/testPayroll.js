var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
    var owner = accounts[0];
    var worker = accounts[1];

  it("test addEmployee method", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.addEmployee(worker, 1, {from: owner});
    }).then(function() {
      return payrollInstance.employees.call(worker);
    }).then(function(employee) {
      assert.equal(employee[0], worker, "incorrect employee address");
      assert.equal(employee[1], web3.toWei(1, 'ether'), "incorrect salary");
    });
  });

  it("test removeEmployee method", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.removeEmployee(worker, {from: owner});
    }).then(function() {
      return payrollInstance.employees.call(worker);
    }).then(function(employee) {
      assert.equal(employee[0], 0x0, "employee not removed");
    });
  });
});