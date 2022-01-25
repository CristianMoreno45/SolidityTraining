// SPDX-License-Identifier: MIT

/**

*/
pragma solidity >=0.8.0;

contract PrimerContrato {
    address owner;

    constructor() public {
        owner = msg.sender;
    }
}
