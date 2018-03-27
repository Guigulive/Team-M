var Payroll = artifacts.require("./Payroll"); 

contract('Payroll', function(accounts) {

  owner = accounts[0];

  //======================================================================================================
  /// add employee 
  it("add employee by owner test", function() {
    return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;
        return payrollInstance.addEmployee(accounts[2], 2, {from: owner});
    }).then(function() {
        return payrollInstance.employees(accounts[2]);
    }).then(function(employee) {
        assert.equal(employee[0], accounts[2], "Error!!: addEmployee() error!");
    });
  });

  it("add employee duplicate test", function() {
    return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;
        payrollInstance.addEmployee(accounts[2], 2, {from: owner});
        return payrollInstance.addEmployee(accounts[2], 2, {from: owner});
    }).then(function() {
        assert(false, "should be fail");
    }).catch(function(error) {
        assert.ok(!error, "can not add employee duplicate");
        // assert.ifError(error);
        // assert.fail(error);
    });
  });

  it("add employee by other test", function() {
    return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;
        return payrollInstance.addEmployee(accounts[2], 2, {from: accounts[8]});
    }).then(function() {
        assert(false, "should be fail");
    }).catch(function(error) {
        assert.ok(!error, "access error");
    });
  });

  it("salary test", function() {
    return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;
        return payrollInstance.addEmployee(accounts[3], 2, {from: owner});
    }).then(function() {
        return payrollInstance.employees(accounts[3]);
    }).then(function(employee) {
        assert.equal(employee[1].toNumber(), web3.toWei(2, 'ether'), "Error!!: wrong salary!");
    });
  });

  //======================================================================================================
  /// remove employee 
  it("remove employee by owner test", function() {
    return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;
        return payrollInstance.addEmployee(accounts[4], 2, {from: owner});
    }).then(function() {
        return payrollInstance.employees(accounts[4]);
    }).then(function(employee) {
        assert.equal(employee[0], accounts[4], "Error!!: addEmployee() error!");
    }).then(function() {
        payrollInstance.removeEmployee(accounts[4], {from: owner});
        return payrollInstance.employees(accounts[4]);
    }).then(function(employee) {
        assert.notEqual(employee[0], accounts[4], "Error!!: remove error!");
    });
  });

  it("remove non-exist employee test", function() {
    return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;
        return payrollInstance.addEmployee(accounts[4], 2, {from: owner});
    }).then(function() {
        return payrollInstance.removeEmployee(accounts[8], {from: owner});
    }).then(function() {
        assert(false, "should be fail");
    }).catch(function(error) {
        assert.ok(!error, "should not remove non-exist employee!");
    });
  });

  it("remove employee by other test", function() {
    return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;
        payrollInstance.removeEmployee(accounts[4], {from: owner});
        return payrollInstance.addEmployee(accounts[4], 2, {from: owner});
    }).then(function() {
        return payrollInstance.employees(accounts[4]);
    }).then(function(employee) {
        assert.equal(employee[0], accounts[4], "Error!!: addEmployee() error!");
    })  .then(function() {
        return payrollInstance.removeEmployee(accounts[4], {from: accounts[8]});
    }).then(function() {
        assert(false, "access error");
    });
  });

  //======================================================================================================
  /// getPaid 

  var payDuration = 5;
  var fund = 2;
  var salary = 1;
  it("employee getPaid test", function() {
    return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;

        payrollInstance.addEmployee(accounts[5], salary, {from: owner});
        //payduration
        web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [payDuration], id: 0});
        return payrollInstance.addFund({from: owner, value : web3.toWei(fund, 'ether')});
    }).then(function() {
        return payrollInstance.calculateRunway();
    }).then(function(totalFund) {
        assert.equal(totalFund, fund, "Error!!: addFund error!");
        return payrollInstance.getPaid({from: accounts[5]});
    }).then(function() {
        return payrollInstance.calculateRunway();
    }).then(function(totalFund) {
        assert.equal(totalFund, fund - salary, "Error!!: addFund error!");
        return payrollInstance.getPaid({from: accounts[8]}); // 非雇员
    }).then(function() {
        assert(false, "should not success!");
    }).catch(function(error) {
        assert.ok(!error, "can not get paid besides employee");
    });
  });

  it("employee getPaid before payDay", function() {
    return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;

        payrollInstance.addEmployee(accounts[6], salary, {from: owner});
        //payduration
        return payrollInstance.addFund({from: owner, value : web3.toWei(fund, 'ether')});
    }).then(function() {
        return payrollInstance.calculateRunway();
    }).then(function(totalFund) {
        assert.equal(totalFund, fund, "Error!!: addFund error!");
        return payrollInstance.getPaid({from: accounts[6]});
    }).then(function() {
        assert(false, "should not success!");
    }).catch(function(error) {
        assert.ok(!error, "can not get paid before payday");
    });
  });

});
