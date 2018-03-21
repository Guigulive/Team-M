pragma solidity ^0.4.14;

contract VisibilityTest {
    
    uint public v;
    
    function VisibilityTest() {
        func2();
    }
    
    function func1() {
        func3();
    }
    
    function func2() private {
        v = 999;
    }
    
    function func3() internal {
        v = 888;
    }
    
    function func4() external {
        v = 1000;
    }
}