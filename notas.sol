pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract Notas{
    address public profesor;

    constructor (){
        profesor = msg.sender;
    }
}