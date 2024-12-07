const ConvertLib = artifacts.require("ConvertLib");
const Enrollment = artifacts.require("Enrollment");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, Enrollment);
  deployer.deploy(Enrollment);
};
