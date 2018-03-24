var Payroll = artifacts.require("./Payroll.sol");

contract('addEmployee',function(accounts){

    it("add employee by owner", function(done){
        var payroll;
        Payroll.deployed().then(instance => {
            payroll = instance;
            payroll.addEmployee(accounts[0],100, {from: accounts[0]});
        }).then( res => {
            return payroll.totalSalary.call();
        }).then( res => {
            assert.equal(res.toString(),web3.toWei(100),'totalSalary  is 100');
            return payroll.employees.call(accounts[0]);
        }) ;
    });

    it("employee can not add ", function(done){
        Payroll.deployed().then(instance => {
            instance.addEmployee(accounts[1],1,{from:accounts[1]}).catch(error =>{
                assert.include(error.toString(), "invalid opcode", "owner not correct");
                done();
            });
        });
    });

    it("already exit employee",function(done){
        Payroll.deployed().then(instance => {
            instance.addEmployee(accounts[0],1,{from:accounts[0]}).catch(error =>{
                assert.include(error.toString(), "invalid opcode", "owner not correct");
                done();
            });
        });
    });
});

contract('removeEmployee',function(accounts){
    it("remove by owner", function(done){
        var payroll;
        Payroll.deployed().then(instance => {
            payroll = instance;
            return payroll.addEmployee(accounts[3],100,{from:accounts[0]});
        }).then(res =>{
            return payroll.removeEmployee(accounts[3],{from:accounts[0]});
        }).then( res => {
            return payroll.totalSalary.call();
        }).then( res => {
            assert.equal(res.toString(),web3.toWei(0),'totalSalary not correct');
            return payroll.employees.call(accounts[3]);
        }).then( res =>{
            assert.equal(res[0].toString(),'0x0000000000000000000000000000000000000000','address not correct');
            done();
        });
    });

    it("cant remove by employee", function(done){
        var payroll;
        Payroll.deployed().then(instance => {
            payroll = instance;
            return payroll.addEmployee(accounts[4],1,{from:accounts[0]});
        }).then(res => {
            payroll.removeEmployee(accounts[4],{from:accounts[1]}).catch(error =>{
                assert.include(error.toString(), "invalid opcode", "owner not correct");
                done();
            });
        });
    });


});
