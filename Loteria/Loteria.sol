// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 < 0.7.0;
pragma experimental ABIEncoderV2;
import "./ERC20.sol";

contract Loteria {
    // Token
    ERC20Basic private contractObj;
    address public ownerContract;
    address public addressContract;
    uint public createdTokens = 1000;

    event buyTokenEvent(uint, address);
    event returnTokenEvent(uint, address);
    // Loteria
    uint public ticketPrice = 5;
    mapping(address => uint[]) ticketsByUser;
    mapping(uint => address) UserByTicket; // inverse relationship ^^
    uint nonceNumber;
    uint [] ticketsSold;

    event buyTicketEvent(address, uint);
    event winningTicketEvent(uint);


    constructor () public {
        contractObj = new ERC20Basic(createdTokens);
        ownerContract = msg.sender;
        addressContract =address(this);
    }

    modifier onlyOwnerContract(address _ownerContract)
    {
        require(_ownerContract == ownerContract, "You do not have permissions to perform this operation");
        _;
    }

    function getCostToken(uint _tokenQuantity) internal pure returns(uint){
        return _tokenQuantity*(1 ether);
    }
    
    function increaseTokens(uint _tokenQuantity) public onlyOwnerContract(msg.sender) returns(uint){
        contractObj.increaseTotalSupply(_tokenQuantity);
        return contractObj.balanceOf(addressContract);
    }
   
    function buyToken(uint _tokenQuantity) public payable {
        // concer el valor en ethers de los tokens comprados
        uint costToken = getCostToken(_tokenQuantity);
        // msg.value = ethers pagados en la transacción
        require(msg.value >= costToken,"The amount of tokens is insufficient for this operation");
        uint Balance = getContractBalance();
        require(_tokenQuantity <= Balance,"This number of tokens does not exist at this time, change the number to a smaller number");
        // Si el valor de la operacion es mayor al coste, es necesario trasnferir la diferencia (las vueltas)
        uint change = msg.value - costToken;
        msg.sender.transfer(change);
        // transfiera los tokens al comprador
        contractObj.transfer(msg.sender, _tokenQuantity);
        // emitir evento de compra de tokens
        buyTokenEvent(_tokenQuantity, msg.sender);
    }

    function getContractBalance() public view returns (uint){
        return contractObj.balanceOf(addressContract);
    }

    function getRewardValue() public view returns(uint){
        return contractObj.balanceOf(ownerContract);
    }

     function getMyBalance() public view returns (uint){
        return contractObj.balanceOf(msg.sender);
    }

    // Loteria
    function buyTicket(uint _amountTickets) public {
        uint totalPrice = _amountTickets * ticketPrice;
        require(totalPrice <= getMyBalance(),"You need to buy more tokens, your balance is insufficient");
        //crear una transferencia originada en el contrato, desde el dueño de la oepración hacia el dueño del contrato
        contractObj.transferBase(msg.sender, ownerContract, totalPrice);

        for (uint i = 0; i< _amountTickets ; i++) {
            uint ticketNumber = uint(keccak256(abi.encodePacked(now, msg.sender, nonceNumber))) % 10000;
            nonceNumber++;
            ticketsByUser[msg.sender].push(ticketNumber);
            ticketsSold.push(ticketNumber);
            UserByTicket[ticketNumber] = msg.sender;
            buyTicketEvent(msg.sender, ticketNumber);
            
        }
    }

    function getMyTickets() public view returns (uint[] memory){
        return ticketsByUser[msg.sender];
    }

    function resolveWinner() public  onlyOwnerContract (msg.sender){
        require(ticketsSold.length > 0, "Tickets have not been sold");
        uint amountTickets = ticketsSold.length;
        uint indexArray = uint(keccak256(abi.encodePacked(now))) % amountTickets;
        uint winningTicket = ticketsSold[indexArray];
        address winner = UserByTicket[winningTicket];
        emit winningTicketEvent(winningTicket);
        contractObj.transferBase(msg.sender, winner, getRewardValue());
        
    }

    function returnTokens(uint _tokenQuantity) public payable{
        require(_tokenQuantity > 0, "To return the tokens, the amount needs to be greater than zero");
        require(_tokenQuantity <= getMyBalance(), "You cannot return more tokens than the amount of your balance");
        contractObj.transferBase(msg.sender, address(this),_tokenQuantity);
        msg.sender.transfer(getCostToken(_tokenQuantity));
        emit returnTokenEvent(_tokenQuantity, msg.sender);
    }

}