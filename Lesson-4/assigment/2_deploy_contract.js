const Ownable = artifacts.require("./Ownable.sol")
const SafeMath = artifacts.require("./SafeMath.sol")
const Payroll = artifacts.require("./Payroll.sol")

module.exports = function(deployer) {
    deployer.deploy(Ownable);
    deployer.deploy(SafeMath);
    deployer.link(Ownable, Payroll);
    deployer.link(SafeMath, Payroll);
    deployer.deploy(Payroll);
};
