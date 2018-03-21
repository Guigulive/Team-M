pragma solidity ^0.4.0;

contract Base1{
    function func1() returns (uint) {
        return 3333;
    }
}

contract Base2{
    function func1() returns (uint) {
        return 9999;
    }
}

contract Final is Base1,Base2{}

contract test {
    
    uint public a;
    
    function test() {
        Final f = new Final();
        a = f.func1();        
    }
}