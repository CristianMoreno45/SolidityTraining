// SPDX-License-Identifier: MIT

/// Comentario estándar natspec
/// @title      Contrato ABC
/// @author     Cristiaan Moreno
/// @notice     El contrato airve para ABC
/// @dev        Detalles adicionales
/// @param      nombre_parametro que funcion tiene en el contrato
/// @return     valor_retornado para que sirve el valor devuelto


pragma solidity >=0.8.0;

contract PrimerContrato {
    address owner;

    constructor() public {
        owner = msg.sender;
    }
}
