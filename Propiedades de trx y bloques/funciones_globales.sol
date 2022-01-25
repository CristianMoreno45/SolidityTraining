//
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract hash{

    // computo de un hash de un string
    function calcularHash(string memory _cadena) public view returns (bytes32){
        return keccak256(abi.encodePacked(_cadena));
    }
    // computo de un hash de varios string
    function calcularHash2(string memory _cadena, uint _k, address _direccion) public view returns (bytes32){
        return keccak256(abi.encodePacked(_cadena, _k, _direccion));
    }

    // computo de un hash de varios string con valores a fuego
    function calcularHash3(string memory _cadena, uint _k, address _direccion) public view returns (bytes32){
        return keccak256(abi.encodePacked(_cadena, _k, _direccion, "Foo", uint(34)));    
    }

}